expected_value<-function(loss_ratio){
    X_vals<-c(1, 2, 3, 4, 5, 6, -1*loss_ratio,
              -2*loss_ratio, -3*loss_ratio,
              -4*loss_ratio, -5*loss_ratio, -6*loss_ratio)
    Prs<-c(rep(2/36,6),rep(4/36,6))
    
    sum(X_vals*Prs)
}


event<-function(loss_ratio = .5){
    die<-c(1, 2, 3, 4, 5, 6)
    rolls<-c(sample(die,1), sample(die,1))
    if (rolls[1]>=5){
        return(rolls[2])
    } else {
        return(-loss_ratio*rolls[2])
    }
}

iterate_event<-function(loss_ratio,n=1000){
    payments<-numeric(n)
    rel_freq<-numeric(n)
    total<-0
    for (i in 1:n){
        payments[i]<-event(loss_ratio)
        total<- total + payments[i]
        rel_freq[i]<- total/i
    }
    df<-data.frame(round = 1:n,
                   pmts = round(payments,2),
                   rel_freqs = round(rel_freq,3))
    
    df
}

simulations_st<-iterate_event(.5,5000)




generate_plot<-function(data,n,show,loss_ratio){
    if (show){
        ev<-expected_value(loss_ratio)
        ggplot()+geom_hline(yintercept=ev,col='red',linewidth=1.3)+
            geom_line(aes(x=data[1:n,"round"],y=data[1:n,"rel_freqs"]),
                      size = 1)+
            ggtitle("Carnival Game Repeated Experiments")+
            labs(x="Number of Games Played",y="Average Winnings Per Game\nFor the Player")
    }else{
        ggplot()+geom_line(aes(x=data[1:n,"round"],y=data[1:n,"rel_freqs"]),
                           size = 1)+
            ggtitle("Carnival Game Repeated Experiments")+
            labs(x="Number of Games Played",y="Average Winnings Per Game")
    }
}

