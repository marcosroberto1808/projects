# coding= utf-8
from fabric.api import run, env, sudo
import os

# env.use_ssh_config = True
env.hosts = ["192.168.0.18"]
env.user = "defensoria"
env.password = "dpgece"
env.port = 22

def deploy():
   " => Atualizar sistema em: homologação"
   os.system("echo Atualizando sistema em: homologação")
   run("cd /var/www/sic/ && git pull origin develop && touch tmp/restart.txt")

def executa_bundle():
   " => Executa instalação das gems setadas no Gemfile"
   os.system("echo Instalar gems setadas no Gemfile")
   run("cd /var/www/sic/ && bundle install")

def checkout_projeto():
   " => Executa checkout em projeto para alterações locais"
   os.system("echo Executando checkout")
   run("cd /var/www/sic/ && git fetch origin && git reset --hard origin/develop && touch tmp/restart.txt")

def checkout_commit(commit):
   " => Executa checkout para commit informado. Ex: fab -f fab_homolog.py checkout_commit:commit='commit'"
   os.system("echo Executando checkout para commit informado")
   run("cd /var/www/sic/ && git checkout %s && touch tmp/restart.txt" % commit)

def executa_migrates(comandos):
   " => Executa migrates, argumento ou string vazia. Ex: fab -f fab_homolog.py executa_migrates:migrate='comandos' ou 'string_vazia' "
   os.system("echo Executando migrates")
   run("cd /var/www/sic/ && rake db:migrate %s" % comandos)

def reinicia_servidor():
   " => Reinicia o servidor nginx"
   sudo('cd /tmp/ && rm -rf unicorn.sic.sock && sudo /var/www/sic/config/unicorn.sh start  && sudo /var/www/sic/config/unicorn.sh restart', user='root')
   sudo('/etc/init.d/nginx restart', user='root')
