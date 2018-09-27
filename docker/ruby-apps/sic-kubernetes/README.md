# SIC

### Pré-Requisitos

- Ruby Versão 2+
- Postgres 9.6

### Instalação

#### Banco
O SIC utiliza dois bancos de dados para seu funcionamento o banco sic e o banco db_portal_digital
- sic:
>> __esquema(s):__ public
- db_portal_digital:
>> __esquema(s):__ adm_pgeatv110127, adm_pgeatv100029 e adm_pgeatv100030 

#### Aplicação

Clone o repositorio
```
git clone https://github.com/dpgeceti/sic.git
```

Clone o repositorio
```
git clone https://github.com/dpgeceti/sic.git
```

Clone o assets
```
cd sic/app/
git clone https://github.com/dpgeceti/template_central.git assets
```

Instalação das gems
```
bundle install
```

Para iniciar o servidor rode
```
rails server
```

### Reiniciando a aplicação utilizando passenger:
```
$ cd <caminho-para-o-repositório-da-aplicação>
$ touch tmp/restart.txt
``` 

> Vá ao navegador e acesse a aplicação e o passenger vai reiniciar a aplicação

```
$ rm tmp/restart.txt
``` 

###Deploy  Stage 
Acessa o servidor do sic
```
ssh defensoria@stage.sic
```

Entra no projeto
```
cd sistemas/sic
```

Faz uma cópia do sic
```
cp -rf sic sic_dd_mm_aa
```

Atualiza o repositório
```
git pull origin develop
```

Ativa a versão do ruby
```rvm use 2.2.1
```

Atualiza os pacotes
```
bundle install
```

Atualiza as migrations 
```
rake db:migrate RAILS_ENV=stage
```

Restart da aplicação 
```
touch tmp/restart.txt
```

Acessa a aplicação e depois remove arquivo
```
rm tmp/restart.txt
```
