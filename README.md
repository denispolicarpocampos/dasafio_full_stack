# Recomendações para rodar o projeto
1 - Ruby 2.5.1
2 - Rails 5.2.1
3 - Banco de dados Postgresql
5-  Execute bundle install na pasta do projeto.
6 - Para rodar o projeto utilize os seguintes comandos antes: rake db:create db:migrate db:seed
7 - db:seed criará um usuário administrador para a aplicação. O email e a senha desse administrador 
para login no sistema são:
email: denispolicarpocampos@gmail.com
senha: 12345678

8 - Pode executar o projeto no terminal utilizando rails s.

# Documentação da API

https://documenter.getpostman.com/view/4002613/RzfcLAu6

# RESPOSTA DA QUESTÃO  BONUS.

É necessário chegar a uma configuração ideal no postgresql.conf, um site que ajuda a dar um ponto de partida para a configuração é: https://pgtune.leopard.in.ua/#/ ele ajuda a configurar as opções como por exemplo o número máximo de conexões de acordo com o seu servidor.

Além disso é necessário verificar o pool de conexões no database.yml e aumentá-lo para o número de threads que o aplicativo usa. Também é interessante verificar como está sendo feito as consultas aos dos dados no aplicativo e evitar N+1 queries e carregar em lotes consultas que geram centenas/milhares de resultados.


