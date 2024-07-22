
# Tab 1
# Set up stuff
set.seed(1001)
coin_flip<-function(n=500){
    if (n>8000){
        print("Pick an n-value below 8000.")
        return(NA)
    } else {
        rel_freq <-numeric(n)
        flips<-numeric(0)
        for (i in 1:n){
            r<-ifelse(runif(1)<0.2123,1,0)
            flips<-c(flips,r)
            rel_freq[i]<-sum(flips)/length(flips)
        }
    }
    rel_freq
}


coin<-coin_flip(n=2000)

generate_plot<-function(data,n){
    ggplot()+
        geom_hline(yintercept = 0.2123, color='red',linewidth=.9)+
        geom_line(aes(x=1:n,y=data[1:n]),
                  color='blue',linewidth=1.5)+
        ggtitle("Coin Flip Simulation")+
        coord_cartesian(ylim=c(0,1))+
        labs(x="Number of Flips",y="Relative Frequency Green Jellies")+
        theme_bw()
}

