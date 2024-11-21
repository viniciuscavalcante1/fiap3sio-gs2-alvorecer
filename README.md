# fiap3sio-gs2-alvorecer
Alvorecer: a energia que renova. 

Alvorecer é um aplicativo desenvolvido em Flutter para a segunda edição do Global Solution de 2024, organizado pela FIAP. 
O aplicativo busca facilitar a migração para energia solar, disponibilizando funções para simular economias com energia solar, encontrar empresas próximas que oferecem soluções fotovoltaicas, monitorar o uso de energia solar, descobrir mais sobre dispositivos e explorar soluções sustentáveis, com dicas úteis.

## Funcionalidades
- **Autenticação de usuários**: registro e login de usuários com senhas criptografadas.
- **Simulador de custos**: estimação de economias ao migrar para energia solar, com base na conta de luz.
- **Monitoramento de energia**: gráficos e insights sobre dados de consumo, geração e custos de energia solar.
- **Hub de empresas**: lista de empresas especializadas em soluções fotovoltaicas.
- **Dicas de economia**: insights para reduzir o consumo de energia.


## Como executar

### Requisitos
É necessário os seguintes softwares instalados no computador para executar o Alvorecer de forma local.
- PostgreSQL e pgAdmin para gerenciar o banco de dados
- Flutter e Dart SDK para execução
- Android SDK, Android Studio e Visual Studio Code para emulação e execução

### Configuração do Banco de Dados
1. Instale o [PostgreSQL](https://www.postgresql.org/download/) 
2. Use o terminal para se conectar ao servidor do PostgreSQL instalado
- ```bash
  psql -U postgres
  ```
3. Crie o banco de dados
- ```sql
  CREATE DATABASE alvorecer;
  ```
4. Conecte-se ao banco de dados
- ```bash
  \c alvorecer
  ```
5. Garanta que está na pasta alvorecer/sql e execute as rotinas PLSQL para criar as tabelas, inserir dados iniciais e criar autoomações. 
- ```bash
  psql -U postgres -d alvorecer -f create_tables.sql
  psql -U postgres -d alvorecer -f initial_data.sql
  psql -U postgres -d alvorecer -f automation_routines.sql
  ```

### Configuração do Flutter e do projeto
1. Instale o [Fluter SDK](https://docs.flutter.dev/get-started/install)
2. Verifique a instalação do Flutter e garanta que todos os pontos estão corretos:
- ```bash
  flutter doctor
  ```
3. Clone o repositório:
- ```bash
  git clone https://github.com/viniciuscavalcante1/fiap3sio-gs2-alvorecer.git
  cd fiap3sio-gs2-alvorecer
  cd alvorecer
  ```
4. Instale as dependências do projeto
- ```bash
  flutter pub get
  ```
5. Configure um emulador no [Android Studio](https://developer.android.com/studio?hl=pt-br)
6. Execute o aplicativo:
- ```bash
  flutter run
  ```

 ## Justificativa das escolhas técnicas
 - **Flutter:** escolhi o ```Flutter``` por ser uma linguagem mobile multiplataforma e de rápido desenvolvimento. 
 - **PostgreSQL:** banco de dados relacional robusto, moderno e confiável. Amplamente usado no mercado.
 - **Syncfusion Flutter Charts:** biblioteca do Flutter para gerar gráficos modernos e amigáveis.

 ## Boas práticas
 ### Segurança
 As senhas são criptografadas! Hashes SHA-256. Isso protege e garante a segurança dos dados dos usuários.

 ### Gerenciamento de memória
 - **Liberação de recursos**: objetos e conexões com o banco são liberados usando o método dispose() para evitar vazamentos de memória.
 - **Listas eficientes**: componentes como ListView.builder foram usados para carregar apenas os itens visíveis na tela.
 - **Banco de dados**: dados são consultados apenas quando necessário, e índices deixam as consultas mais rápidas. 
 - **Imagens otimizadas**: imagens redimensionadas, evitando arquivos grandes.




