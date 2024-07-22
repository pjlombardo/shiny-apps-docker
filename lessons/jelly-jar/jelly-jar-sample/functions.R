
# Tab 1
# Set up stuff
get_sample<-function(n){
    record<-rbinom(n,1,0.2123)
    return(data.frame(record = record,
                      color = ifelse(record==1,"green","other")))
}


df <-get_sample(25)
history<-c(mean(df$record))


get_sample_summ<-function(df){
    total <- nrow(df)
    summ_df<-df %>% group_by(color) %>% count() %>%
        mutate(count = n,percent = round(count/total,3)) %>%
        select(color,count, percent) %>%
        as.data.frame()
    return(summ_df)
}

summ<-get_sample_summ(df)

get_sample_summ(get_sample(30))

get_sample_tbl<-function(df){
    t1<- df$color %>% kable("html",col.names="Jelly Color",
                            row.names =FALSE,
                            align = "c")
    for (i in which(df$record==1)){
        t1<- t1 %>% row_spec(i,background="green",color = "white")
    }
    return(t1)
}

get_sim_summ<-function(history){
    df<-data.frame(percents = history)
    df %>% summarize(
        "Average Percent Green" = mean(percents),
        "Median Percent Green" = median(percents),
        "Std. Deviation of Percent Green" = sd(percents)
    )
}

get_sim_summ(history)

# start_plot<-ggplot()+theme_bw()


generate_plot<-function(history, counter, binsize){
    if (counter < 10){
        ggplot(data = data.frame(percents = history))+
            geom_histogram(aes(x = percents),
                           color='white',
                           fill='green3',
                           breaks = seq(0,.8,by=binsize))+
            scale_x_continuous(limits = c(0, 0.8))+
            scale_y_continuous(limits = c(0,10))+
            theme_bw()
    } else {
        ggplot(data = data.frame(percents = history))+
            geom_histogram(aes(x = percents),
                           color='white',
                           fill='green3',
                           breaks = seq(0,.8,by=binsize))+
            scale_x_continuous(limits = c(0, 0.8))+
            theme_bw()
    }
    
}



