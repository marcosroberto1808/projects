# Dockerfile by Marcos Roberto
# Variaveis de ambiente iniciais
FROM postgres:9.4
RUN echo "LC_ALL=pt_BR.UTF-8" >> /etc/environment-8 ; \
echo "pt_BR.UTF-8 UTF-8" >> /etc/locale.gen ; \
echo "LANG=pt_BR.UTF-8" > /etc/locale.conf ; \
locale-gen pt_BR.UTF-8
# ENVs
ENV LANG="pt_BR.UTF-8"
ENV LC_ALL="pt_BR.UTF-8"
ENV LC_CTYPE="pt_BR.UTF-8"

ADD ./sql_scripts/. /docker-entrypoint-initdb.d