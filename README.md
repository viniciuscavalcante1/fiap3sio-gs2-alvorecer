# fiap3sio-gs2-alvorecer
Alvorecer: a energia que renova. 

Alvorecer é um aplicativo desenvolvido em Flutter para a segunda edição do Global Solution de 2024, organizado pela FIAP. 

## Como executar

### Requisitos
É necessário ter vários aplicativos instalados no computador para executar o Alvorecer de forma local.
- PostgreSQL e pgAdmin 
- Flutter, Dart SDK, Android SDK, Visual Studio Code e Android Studio

## Configuração do Banco de Dados
1. Instale o PostgreSQL: https://www.postgresql.org/download/
2. Use o terminal para se conectar ao servidor do PostgreSQL instalado
- ```bash
  psql -U posgres
  ```
3. Crie o banco de dados
- ```sql
  CREATE DATABASE alvorecer;
  ```
4. Conecte-se ao banco de dados
- ```bash
  \c alvorecer
  ```

