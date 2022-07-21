
    options(scipen=999)    
    
    base_plot_SG <- function(qtl, log, date_breaks, step=FALSE) {
      
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
          date_breaks  = date_breaks,
          labels = scales::date_format("%e %b"),
          expand = ggplot2::expansion(mult=0.02)
        ) +
        ggplot2::scale_y_continuous(
          labels = scales::comma,
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
    
plot_infections_SG <- function(fit, groups) {

    date_breaks="8 weeks" 
    date_format="%Y-%m-%d"
    dates=NULL
    
    levels <- c(5, 50, 95)
    log <- FALSE
    
#    levels <- check_levels(levels)
    
    inf <- posterior_infections(fit)

    # transform data
    inf <- gr_subset(inf, groups)
    
    qtl <- get_quantiles(
      inf,
      levels,
      dates,
      date_format
    )
    
    p <- base_plot_SG(qtl, log, date_breaks)
    
    p <- p + ggplot2::scale_fill_manual(
      name = "Infections",
      values = ggplot2::alpha("deepskyblue4", levels/100)
    )
    
    p <- p + ggplot2::ylab("Infections")
    
    return(p)
  
}


