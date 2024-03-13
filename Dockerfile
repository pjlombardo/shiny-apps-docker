# rocker/shiny-verse with learnr, kableExtra, car, and sortable
# shiny-verse comes with shiny server pointed to 3838, as well
# as tidyverse installed, with many other important packages.
# We simply extend it to include some other packages I use for 
# learnr lessons and other visualizations.

# BUILD from gk-learnr parente directory
# docker build -t gk-learnr ~/gk-learnr/docker --no-cache

From rocker/shiny-verse:4.3

RUN R -e 'install.packages("learnr")'
RUN R -e 'install.packages("kableExtra")'
RUN R -e 'install.packages("car")'
Run R -e 'install.packages("sortable")'

# scripts to for making learnr htmls
Run mkdir /scripts
ADD scripts/render_learnr.sh /scripts
ADD scripts/render.R /scripts

# Copy leanr or shiny files
COPY lessons/ggplot-basics /srv/shiny-server/ggplot-basics
COPY lessons/make-tidy /srv/shiny-server/make-tidy
COPY lessons/tidy-data /srv/shiny-server/tidy-data

# Launchpage details
COPY web/css /srv/shiny-server/css
COPY web/index.html /srv/shiny-server/index.html
COPY web/images /srv/shiny-server/images

# Run indexing scripts
RUN sh /scripts/render_learnr.sh



EXPOSE 3838

CMD ["/init"]
