# rocker/shiny-verse with learnr, kableExtra, car, and sortable
# shiny-verse comes with shiny server pointed to 3838, as well
# as tidyverse installed, with many other important packages.
# We simply extend it to include some other packages I use for 
# learnr lessons and other visualizations.

# BUILD from gk-learnr parente directory
# docker build -t gk-learnr ~/gk-learnr/docker --no-cache

FROM rocker/shiny-verse:4.3

RUN R -e 'install.packages("learnr")'
RUN R -e 'install.packages("kableExtra")'
RUN R -e 'install.packages("car")'
RUN R -e 'install.packages("sortable")'
RUN R -e 'install.packages("patchwork")'
RUN R -e 'install.packages("latex2exp")'

# for copy and past buttons
# Run R -e 'install.packages("rclipboard")'

# scripts to for making learnr htmls
# Run mkdir /scripts
# ADD scripts/render_learnr.sh /scripts
# ADD scripts/render.R /scripts

# Copy leanr or shiny files
COPY lessons/anova /srv/shiny-server/anova
COPY lessons/confidence-intervals /srv/shiny-server/confidence-intervals
COPY lessons/descriptive-stats /srv/shiny-server/descriptive-stats
COPY lessons/hypothesis-testing /srv/shiny-server/hypothesis-testing
COPY lessons/power /srv/shiny-server/power
COPY lessons/probability-distributions /srv/shiny-server/probability-distributions
COPY lessons/regression /srv/shiny-server/regression
COPY lessons/sampling-demos /srv/shiny-server/sampling-demos
COPY lessons/sampling-distributions /srv/shiny-server/sampling-distributions
COPY lessons/simulations /srv/shiny-server/simulations

# Launchpage details
COPY web/css /srv/shiny-server/css
COPY web/index.html /srv/shiny-server/index.html
COPY web/images /srv/shiny-server/images

# Run indexing scripts
# RUN sh /scripts/render_learnr.sh

EXPOSE 3838

CMD ["/init"]
