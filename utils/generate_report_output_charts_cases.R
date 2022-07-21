
#plot the various RT graphs

source("utils/charts.R")

print("Creating R charts")



Scot_RT_plot <-plot_rt(fit,groups='Scotland',newdata=newdata,levels=c(5,50,95),date_breaks = "2 weeks")
#Eng_RT_plot <-plot_rt(fit,groups='England',newdata=newdata,levels=c(5,50,95),date_breaks = "2 weeks")
#Wales_RT_plot <-plot_rt(fit,groups='Wales',newdata=newdata,levels=c(5,50,95),date_breaks = "2 weeks")
#NI_RT_plot <-plot_rt(fit,groups='NI',newdata=newdata,levels=c(5,50,95),date_breaks = "2 weeks")
#plot the various linear graphs

print("Creating infection charts")

#plot the infections charts
Scot_inf_plot <-plot_infections_SG(fit,groups='Scotland') # ,newdata=newdata,levels=c(5,50,95),date_breaks = "2 weeks")
#Eng_inf_plot <-plot_infections_SG(fit,groups='England') #,newdata=newdata,levels=c(5,50,95),date_breaks = "2 weeks")
#Wales_inf_plot <-plot_infections_SG(fit,groups='Wales') # ,newdata=newdata,levels=c(5,50,95),date_breaks = "2 weeks")
#NI_inf_plot <-plot_infections_SG(fit,groups='NI') #,newdata=newdata,levels=c(5,50,95),date_breaks = "2 weeks")


print("Creating two panel charts")

#create three panel charts
Scot_2pan_plot <- plot_grid(Scot_inf_plot,Scot_RT_plot,nrow=1,ncol=2)
#Eng_2pan_plot <- plot_grid(Eng_inf_plot,Eng_RT_plot,nrow=1,ncol=2)
#Wales_2pan_plot <- plot_grid(Wales_inf_plot,Wales_RT_plot,nrow=1,ncol=2)
#NI_2pan_plot <- plot_grid(NI_inf_plot,NI_RT_plot,nrow=1,ncol=2)

# Comparison against other countries

# Get values of R for each country

R_summary <- total_output_table[total_output_table$date==dmy(MODEL_DATE),] %>%
  select("Country",min="5%_RT",lower="25%_RT",mid="50%_RT",upper="75%_RT",max="95%_RT") 

R_global <- ggplot(R_summary, aes(Country, group = Country)) +
  geom_boxplot(
    aes(ymin = min, lower = lower, middle = mid, upper = upper, ymax = max),
    stat = "identity"
  )

#global_comparison <- plot_grid(
#Eng_RT_plot + labs(title="England"),
#                               NI_RT_plot + labs(title="NI"),
#                               Wales_RT_plot + labs(title="Wales"),
#                               R_global,
#                               nrow=2,ncol=2)

#save various charts

print("Saving chart outputs")

ggsave(paste0(results_fp,JOBID,"_Scot_2pan_plot.png"),Scot_2pan_plot)
#ggsave(paste0(results_fp,JOBID,"_Eng_2pan_plot.png"), Eng_2pan_plot)
#ggsave(paste0(results_fp,JOBID,"_Wales_2pan_plot.png"), Wales_2pan_plot)
#ggsave(paste0(results_fp,JOBID,"_NI_2pan_plot.png"), NI_2pan_plot)
ggsave(paste0(results_fp,JOBID,"_Scot_inf.png"), Scot_inf_plot)
ggsave(paste0(results_fp,JOBID,"_Scot_R.png"), Scot_RT_plot)
#ggsave(paste0(results_fp,JOBID,"_R_comp.png"), R_global)
#ggsave(paste0(results_fp,JOBID,"_global.png"), global_comparison)
