# Dockerfile by Marcos Roberto
# Variaveis de ambiente iniciais
FROM centos:centos7
LABEL author="marcos.roberto@defensoria.ce.def.br"
ENV TZ=America/Fortaleza
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
ENV RUBY_VERSION=2.2.1

# Dependencias básicas do S.O
RUN yum -y update ; \ 
yum clean all ; \ 
yum -y install epel-release  ; \ 
yum -y install gcc unzip wget git which patch autoconf \
automake bison bzip2 gcc-c++ libffi-devel libtool readline-devel \
sqlite-devel zlib-devel libyaml-devel openssl-devel \
nodejs npm postgresql-devel openssl icu xorg-x11-fonts-Type1 xorg-x11-fonts-75dpi libXext libXrender libpng libjpeg ; \
rpm -i https://bitbucket.org/wkhtmltopdf/wkhtmltopdf/downloads/wkhtmltox-0.13.0-alpha-7b36694_linux-centos7-amd64.rpm ; \
curl --fail -sSLo /etc/yum.repos.d/passenger.repo https://oss-binaries.phusionpassenger.com/yum/definitions/el-passenger.repo ; \
yum -y install passenger passenger-devel 

# Dependencias RVM e RUBY
RUN /bin/bash -l -c "curl -sSL https://rvm.io/mpapis.asc | gpg2 --import - " ; \ 
/bin/bash -l -c "curl -ssL https://get.rvm.io | bash -s stable --without-gems="rvm rubygems-bundler" " ; \ 
/bin/bash -l -c "source ~/.bashrc" ; \ 
/bin/bash -l -c "rvm install ${RUBY_VERSION}" ; \ 
/bin/bash -l -c "gem uninstall -i /usr/local/rvm/gems/ruby-2.2.1@global bundler" ; \ 
/bin/bash -l -c "gem install bundler -v=1.8.4"

#### INICIO CONFIGURAÇÃO DA APLICAÇÃO ####

# Variáveis de ambiente 
ARG APPNAME
ARG AMBIENTE
# Base de dados SIC
ARG DB_NAME
ARG DB_USER
ARG DB_PASS
ARG DB_HOST
# Base de dados db_portal_digital
ARG PORTAL_DB_USER
ARG PORTAL_DB_PASS
ARG PORTAL_DB_HOST 
#RUN env
# Adicionar diretórios e arquivos de configuracao
RUN mkdir -p /home/AppData/logs ; \
mkdir -p /home/AppData/ruby_log ; \
mkdir -p /home/AppData/repositorios ; \
mkdir -p /home/AppData/template_central ; \
mkdir -p /home/AppConfig ; \
mkdir -p /home/AppCode/${APPNAME}
COPY . /home/AppCode/${APPNAME}/

# Arquivos de configuracao e template central
COPY ./docker_setup/. /home/AppConfig/

# Adicionar arquivos do projeto e executar bundle install
COPY . /home/AppCode/${APPNAME}/
#RUN /bin/bash -l -c "cd /home/AppCode/${APPNAME}/ && bundle install"

# Ajustes do arquivo database.yml
# Base db_portal_digital
RUN sed -i "s/PORTAL_DB_USER/${PORTAL_DB_USER}/g" /home/AppConfig/database.yml ; \
sed -i "s/PORTAL_DB_PASS/${PORTAL_DB_PASS}/g" /home/AppConfig/database.yml ; \
sed -i "s/PORTAL_DB_HOST/${PORTAL_DB_HOST}/g" /home/AppConfig/database.yml ; \
# Base sic
sed -i "s/DB_NAME/${DB_NAME}/g" /home/AppConfig/database.yml ; \
sed -i "s/DB_USER/${DB_USER}/g" /home/AppConfig/database.yml ; \
sed -i "s/DB_PASS/${DB_PASS}/g" /home/AppConfig/database.yml ; \
sed -i "s/DB_HOST/${DB_HOST}/g" /home/AppConfig/database.yml ; \
# Ajuste arquivo database.ylm
rm -f /home/AppCode/${APPNAME}/config/database.yml ; \
ln -s /home/AppConfig/database.yml /home/AppCode/${APPNAME}/config/database.yml ; \
# Log do ruby teste
rm -rf /home/AppCode/${APPNAME}/log ; \
ln -s /home/AppData/ruby_log /home/AppCode/${APPNAME}/log ; \
# Template Central
rm -f /home/AppCode/${APPNAME}/app/assets ; \
ln -s /home/AppData/template_central /home/AppCode/${APPNAME}/app/assets ; \
# Repositorio de arquivos
mkdir -p /home/defensoria/sistemas/ ; \
ln -s /home/AppData/repositorios /home/defensoria/sistemas/repositorios

# Copiando scripts principais e ajustes de permissoes
COPY /docker_setup/run.sh /run.sh
RUN chmod 775 /*.sh ; \
sed -i "s/AMBIENTE/${AMBIENTE}/g" /run.sh ; \
sed -i "s/APPNAME/${APPNAME}/g" /run.sh 
# Executar bundle install
RUN /bin/bash -l -c "cd /home/AppCode/${APPNAME}/ && bundle install"
## Iniciar Tudo
CMD ["/run.sh"]