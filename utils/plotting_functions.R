#Nicky Agius
#18/01/2021

#Load functions for breaking the data into tables

# ---- Source: Epidemia github -----

# transform into cumulatives
# @param object Result of posterior_ function
cumul <- function(object) {
  dfs <- split(
    as.data.frame(t(object$draws)),
    object$group
  )
  dfs <- lapply(
    dfs,
    function(x) t(apply(x, 2, cumsum))
  )
  object$draws <- do.call(cbind, dfs)
  return(object)
}


# Compute quantiles for all levels
#
# @param object Result of a posterior_ function
# @param levels A numeric vector defining levels
get_quantiles <- function(object, levels, dates=NULL, date_format=NULL) {
  levels <- levels[order(levels)]
  f <- function(level) {
    res <- apply(
      object$draws,
      2,
      function(x) quantile(x, 0.5 + level * c(-1, 1) / 200)
    )
    return(
      data.frame(
        date = object$time,
        lower = res[1, ],
        upper = res[2, ],
        group = object$group,
        tag = paste0(level, "% CI"),
        level = level
      )
    )
  }
  out <- lapply(levels, f)
  out <- do.call(rbind, out)
  out$tag <- factor(out$tag, ordered = T, levels = rev(levels(factor(out$tag))))
  if (!is.null(dates)){
    out <- subset_for_dates(
      out,
      dates,
      date_format
    )
  }
  return(out)
}

subset_for_dates <- function(qtl, dates, date_format) {
  dates <- check_dates(
    dates,
    date_format,
    min(qtl$date),
    max(qtl$date)
  )
  if (!is.null(dates)) {
    date_range <- seq(dates[1], dates[2], by = "day")
    qtl <- qtl[qtl$date %in% date_range, ]
    if (nrow(qtl) == 0) {
      stop("date subsetting removed all data")
    }
  }
  return(qtl)
}

# smooths observations across dates
#
# @param object Result of a posterior_ function
# @param smooth Periods to smooth for
smooth_obs <- function(object, smooth) {
  smooth <- check_smooth(object, smooth)
  if (smooth == 1) {
    return(object)
  }
  
  df <- as.data.frame(t(object$draws))
  dfs <- split(df, object$group)
  dfs <- lapply(
    dfs,
    function(x) {
      apply(
        x,
        2,
        function(x) {
          zoo::rollmean(
            x,
            smooth,
            fill = NA
          )
        }
      )
    }
  )
  df <- do.call(rbind, dfs)
  w <- complete.cases(df)
  object$draws <- t(df)
  return(sub_(object, w))
}

# subsets observations for a given
# a logical vector
#
# @param object Result of posterior_ function
# @param w A logical vector
sub_ <- function(object, w) {
  if (!is.logical(w)) {
    stop("bug found. 'w' should be logical")
  }
  object$draws <- object$draws[, w]
  object$time <- object$time[w]
  object$group <- droplevels(object$group[w])
  return(object)
}

# subsets posterior data for a given
# set of groups
#
# @param object output from posterior_rt or
# posterior_predict
# @param groups A character vector specifying
# groups to plot
gr_subset <- function(object, groups) {
  if (is.null(groups)) {
    return(object)
  }
  w <- !(groups %in% object$group)
  if (any(w)) {
    stop(paste0(
      "group(s) ", groups[w],
      " not found."
    ), call. = FALSE)
  }
  w <- object$group %in% groups
  return(sub_(object, w))
}

# makes sure all levels are between 0 and 100 (inclusive)
check_levels <- function(levels) {
  if (length(levels) == 0) {
    warning("no levels provided, will use 
            default credible intervals (50% and 95%)", call. = FALSE)
    return(c(50, 95))
  }
  if (any(!dplyr::between(levels, 0, 100))) {
    stop("all levels must be between 0
         and 100 (inclusive)", call. = FALSE)
  }
  return(sort(levels))
  }

# Checks viability of smoothing parameter
#
# @param object output from posterior_rt or
# posterior_predict 
# @param smooth 'smooth' argument to plotting 
# function
check_smooth <- function(object, smooth) {
  min_date <- min(table(object$group))
  if (smooth >= min_date) {
    warning(paste0("smooth=", smooth, " is too large 
                   (one group has ", min_date, " unique dates)
                   - no smoothing will be performed"),
            call. = FALSE
    )
    smooth <- 1
  } else if (smooth <= 0 | smooth %% 1 != 0) {
    warning("smooth must be a positive integer -
            no smoothing will be performed", call. = FALSE)
    smooth <- 1
  }
  return(smooth)
}


check_dates <- function(dates, date_format, min_date, max_date) {
  if (is.null(dates)) {
    return(NULL)
  }
  if (length(dates) != 2) {
    stop("'dates' must be a vector of length 2.", call. = FALSE)
  }
  
  # replace NAs
  if (is.na(dates[1])) {
    dates[1] <- as.character(min_date)
  }
  if (is.na(dates[2])) {
    dates[2] <- as.character(max_date)
  }
  
  # convert to date
  dates <- as.Date(dates, format = date_format)
  
  if (anyNA(dates)) {
    stop("conversion of 'dates' to 'Date' introduced NAs. 
         Please check date format specified.")
  }
  
  if (dates[1] >= dates[2]) {
    stop("end date must be after start date")
  }
  
  return(dates)
  }

# Basic ggplot. Plotting functions add to this
#
# @param qtl dataframe giving quantiles
# @param date_breaks Determines breaks uses on x-axis
base_plot <- function(qtl, log, date_breaks, step=FALSE) {
  
  
  aes_str <- ggplot2::aes_string(
    x = "date",
    ymin = "lower",
    ymax = "upper",
    group = "tag",
    fill = "tag")
  
  p <- ggplot2::ggplot(qtl)
  if (step) {
    p <- p + geom_stepribbon(aes_str)
  } else {
    p <- p + ggplot2::geom_ribbon(aes_str)
  }
  
  p <- p + ggpubr::theme_pubr() +
    ggplot2::xlab("") +
    ggplot2::scale_x_date(
      date_breaks = date_breaks,
      labels = scales::date_format("%e %b"),
      expand = ggplot2::expansion(mult=0.02)
    ) +
    ggplot2::scale_y_continuous(
      labels = fancy_scientific,
      expand = ggplot2::expansion(mult = c(0,0.02)),
      trans = ifelse(log, "pseudo_log", "identity"),
      limits = c(ifelse(log, NA, 0), NA)
    ) +
    ggplot2::theme(
      axis.text.x = ggplot2::element_text(
        angle = 45,
        hjust = 1
      ),
      axis.text = ggplot2::element_text(size = 12),
      axis.title = ggplot2::element_text(size = 12)
    ) 
  
  
  
  if (length(unique(qtl$group)) > 1) {
    p <- p + ggplot2::facet_wrap(~group, scale = "free_y") + 
      ggplot2::theme(
        strip.background = ggplot2::element_blank(), 
        strip.text = ggplot2::element_text(face = "bold"),
        axis.text.x = ggplot2::element_text(angle=45, hjust=1, size=8),
        axis.text.y = ggplot2::element_text(size=8),
        panel.spacing = ggplot2::unit(0.1, "lines")
      ) +
      ggplot2::geom_hline(yintercept=0, size=1)
  }
  return(p)
}

#' @importFrom magrittr %>%
#' @export
magrittr::`%>%`


# function to format y axis labels
# bigger numbers are shown as scientific
fancy_scientific <- function(l) {
  if (all(l[!is.na(l)] <= 1e4)) {
    l <- format(l)
  } else {
    # turn in to character string in scientific notation
    l <- format(l, scientific = TRUE)
    # quote the part before the exponent to keep all the digits
    l <- gsub("^(.*)e", "'\\1'e", l)
    # turn the 'e+' into plotmath format
    l <- gsub("e", "%*%10^", l)
  }
  # return this as an expression
  parse(text=l)
}

#' Plotting the posterior linear predictor for R or ascertainments
#'
#' Plots credible intervals for the observed data under the posterior
#' predictive distribution, and for a specific observation type. 
#' The user can control the levels of the intervals and the plotted group(s).
#' This is a generic function.
#' 
#' @inherit plot_rt params return
#' @param type the name of the observations to plot. This should match one
#'  of the names of the \code{obs} argument to \code{epim}.
#' @param ... Additional arguments for
#'  \code{\link[epidemia]{posterior_predict.epimodel}}. Examples include
#'  \code{newdata}, which allows 
#'  predictions or counterfactuals.
#' @export
plot_linpred <- function(object, ...) UseMethod("plot_linpred", object)


#' @rdname plot_linpred
#' @export
plot_linpred.epimodel <-
  function(object,
           type = NULL,
           groups = NULL,
           dates = NULL,
           date_breaks = "2 weeks",
           date_format = "%Y-%m-%d",
           levels = c(30, 60, 90),
           plotly = FALSE,
           ...) {
    levels <- check_levels(levels)
    
    groups <- groups %ORifNULL% object$groups
    
    pred <- posterior_linpred(
      object = object,
      type = type,
      ...
    )
    
    # transform data
    pred <- gr_subset(pred, groups)
    
    qtl <- get_quantiles(
      pred,
      levels,
      dates,
      date_format
    )
    
    p <- ggplot2::ggplot(qtl) +
      ggplot2::geom_ribbon(
        ggplot2::aes_string(
          x = "date",
          ymin = "lower",
          ymax = "upper",
          group = "tag",
          fill = "tag"
        )) +
      ggplot2::xlab("") +
      ggplot2::scale_x_date(
        date_breaks = date_breaks,
        labels = scales::date_format("%e %b")
      ) +
      ggpubr::theme_pubr +
      ggplot2::theme(
        axis.text.x = ggplot2::element_text(
          angle = 45,
          hjust = 1
        ),
        axis.text = ggplot2::element_text(size = 12),
        axis.title = ggplot2::element_text(size = 12)
      ) +
      ggplot2::theme(legend.position = "right") + 
      ggplot2::facet_wrap(~group, scale="free_y")
    
    df1 <- data.frame(
      date = pred$time, 
      median = apply(pred$draws, 2, function(x) quantile(x, 0.5)),
      group = pred$group
    )
    # only want to plot dates/groups that appear in qtl as it has been
    # subsetted
    df1 <- df1 %>%
      dplyr::right_join(qtl %>%
                          dplyr::select(.data$date, .data$group) %>%
                          dplyr::distinct(),
                        by=c("date", "group"))
    
    p <- p + ggplot2::geom_line(
      mapping = ggplot2::aes(x = date, y = median), 
      data = df1, 
      color = "deepskyblue4"
    )
    
    cols <- c(
      ggplot2::alpha("deepskyblue4", levels * 0.7 / 100),
      "darkslategray3"
    )
    
    nme <- type %ORifNULL% "R_t"
    cols <- ggplot2::scale_fill_manual(name = nme, values = cols)
    
    p <- p + cols
    
    if (plotly) {
      p <- plotly::ggplotly(p)
    }
    return(p)
  }