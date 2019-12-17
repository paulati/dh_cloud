FROM rocker/rstudio

VOLUME /home/rstudio/plot2DO

RUN sudo apt-get update
RUN sudo apt-get --yes install libcurl4-openssl-dev libxml2-dev
RUN sudo apt-get --yes install r-bioc-xvector

# Contexto: Copia todo el contenido de este directerio adentro del container en la carpeta /app
COPY ./dh_plot2do/plot2DO_setup.R /home/rstudio/plot2DO/plot2DO_setup.R

WORKDIR /home/rstudio/plot2DO

# Correr un comando, en este caso para instalar las dependencias en requirements.txt
RUN sudo Rscript plot2DO_setup.R

# Cuando el container se lance va a ejecutar este comando
#CMD ["echo", "hola"]

