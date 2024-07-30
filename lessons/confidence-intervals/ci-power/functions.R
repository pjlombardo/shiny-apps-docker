set.seed(15234)
pop1<-round(rnorm(1000,12,3.7),2)
pop1<-sapply(pop1, function(x){max(x,.1)})
pop1<-sapply(pop1, function(x){min(x,24.3)})
pop1<-data.frame(plant_heights = pop1)
PS<-sd(pop1$plant_heights)
PM<-mean(pop1$plant_heights)

get_index_and_bars<-function(n,me,null_mu){
    index_list<-list()
    ms<-numeric(2000)
    ymins<-numeric(2000)
    ymaxes<-numeric(2000)
    flag<-character(2000)
    
    for (j in 1:2000){
        samp_index<-sample(1:1000,n)
        ms[j]<-mean(pop1[samp_index,1])
        ymins[j]<-ms[j]-me
        ymaxes[j]<-ms[j]+me
        
        if (ymins[j]>null_mu | ymaxes[j]<null_mu) {
            flag[j]<-"blue"
        } else {flag[j]<-"red"}
        index_list[[j]]<-samp_index
    }
    
    df_errorbars<-data.frame(m=ms,
                             x=1:2000,
                             ymin=ymins,
                             ymax=ymaxes,
                             flag=flag)
    
    return(list(index_list,df_errorbars))
}

in_ci<-function(low,high,null_mu){
    temp_log<-(low < null_mu)&(null_mu<high)
    ifelse(temp_log,"red","blue")
}

update_flags<-function(rlist,me,null_mu){
    temp_df<-rlist[[2]]
    temp_df$ymin<- temp_df$m-me
    temp_df$ymax<- temp_df$m+me
    temp_df$flag<-mapply(in_ci, 
                         temp_df$ymin, 
                         temp_df$ymax,
                         null_mu)
    
    return(list(rlist[[1]],temp_df))
}


update_margin_error<-function(rlist,me,null_mu){
    temp_df<-rlist[[2]]
    temp_df$ymin<- temp_df$m-me
    temp_df$ymax<- temp_df$m+me
    temp_df$flag<-mapply(in_ci, 
                         temp_df$ymin, 
                         temp_df$ymax,
                         null_mu)
    
    return(list(rlist[[1]],temp_df))
}


gen_truth<-function(null_mu){
        ggplot()+geom_point(aes(x=1:1000,
                            y=pop1$plant_heights),
                        col='green',
                        alpha=.4)+
        scale_y_continuous(limits=c(0,25))+
        geom_hline(yintercept=PM,col='green4',linewidth=.8)+
        geom_hline(yintercept= null_mu, col='red',linewidth = 1.2)+
        labs(x="Plant ID Number",
             y="Plant Height (inches)",
             title="Population of Plant Heights One Month After Germination")+
        theme_bw()
}

plot_with_sample<-function(plot,record_num,
                           index_list, 
                           df_errorbars,
                           null_mu){
    
    plot +
        geom_point(aes(x=index_list[[record_num]],
                       y=pop1[index_list[[record_num]],1]),
                   col='blue',alpha=.6)+
        geom_hline(yintercept=df_errorbars$m[record_num],
                   col='blue',size=1,lty=2)+
        geom_hline(yintercept=PM,col='green4',linewidth=.8)+
        geom_hline(yintercept= null_mu, col='red',linewidth = 1.2)+
        labs(x="Plant ID Number",
             y="Plant Height (inches)",
             title="Population of Plant Heights One Month After Germination")
}

#create CI tracker
ci_plot_gen<-function(null_mu){
        ggplot()+
        geom_segment(aes(x=0, y=0, xend=10,yend=0))+
        geom_hline(yintercept=PM,col='green4',linewidth=.8)+
        geom_hline(yintercept= null_mu, col='red',linewidth = 1.2)+
        labs(y="",
             title="Record of Confidence Intervals")+
        geom_vline(xintercept=0)+
        scale_y_continuous(limits=c(0,25))+theme_bw()
    # +
    #     scale_x_continuous(limits=c(0,10))

}


add_ci<-function(record_num,df_errorbars,show_eb,null_mu){
    if (show_eb){
        ci_plot_gen(null_mu)+ geom_errorbar(data=df_errorbars[1:record_num,],
                                 aes(x =x, 
                                     ymin = ymin,
                                     ymax = ymax,
                                     col=flag),
                                 size=1,
                                 width=.1+.2*(record_num/(record_num+10)))+
            geom_point(data=df_errorbars[1:record_num,],
                       aes(x = x,
                           y = m,
                           col=flag))+
            geom_hline(yintercept = 0)+
            scale_color_manual("",values=c("blue","red"),guide="none")+
            scale_x_continuous(limits=c(0,max(10,record_num+3)))
    } else {
        ci_plot_gen(null_mu)+
            geom_point(data=df_errorbars[1:record_num,],
                       aes(x = x,
                           y = m,
                           col=flag))+
            geom_hline(yintercept = 0)+
            scale_color_manual("",values=c("blue","red"),guide="none")+
            scale_x_continuous(limits=c(0,max(10,record_num+3)))
    }
    
}
