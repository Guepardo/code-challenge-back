  # Code Challenge Backend

  ## Instalação

  Navegue até o diretório do projeto e execute os seguintes comandos:

  Copie o arquivo `.env.example` para o `.env`:
  ```
  $ cp .env.example .env
  ```

  Crie o contêiner do projeto:

  ```
  $ docker-compose up
  ```

  Ou use o comando Make


  ```
  $ make start
  ```

  Não é necessário alterar as configurações do arquivo .env.example para que o projeto rode em modo de desenvolvimento. O contêiner vai ficar aberto em http://localhost:3000 e pode ser acessado pelo navegador. Para acompanhar o processamento dos jobs, acesse a URL http://localhost:3000/sidekiq.

  ## Executando Tests no Contêiner

  Para executar os testes no contêiner execute o seguinte comando: **É importante que o contêiner esteja em execução**

  ```
  $ docker exec -it github_profile_web bash -c "export RAILS_ENV=test && bundle install && bundle exec rake db:create db:schema:load && bundle exec rspec --format=documentation"
  ```

  Ou use o comando Make

  ```
  $ make run_test
  ```

  ## Ferramentas Utilizadas no Projeto

  ### Bibliotecas

  - [Sidekiq](https://github.com/mperham/sidekiq)
  - [Shoulda](https://github.com/thoughtbot/shoulda)
  - [Rspec](https://github.com/rspec/rspec)
  - [SI](https://github.com/junegunn/si)
  - [Nanoid](https://github.com/radeno/nanoid.rb)
  - [Dry-Monads](https://github.com/dry-rb/dry-monads)
  - [Puppeteer-Ruby](https://github.com/puppeteer-ruby/puppeteer-ruby)
  - [ActiveModelSerializers](https://github.com/rails-api/active_model_serializers)
  - [Nokogiri](https://github.com/sparklemotion/nokogiri)
  - [Kaminari](https://github.com/kaminari/kaminari)
  - [Faker](https://github.com/faker-ruby/faker)
  - [FactoryBot](https://github.com/thoughtbot/factory_bot)

  ### Bancos de Dados

  - Redis
  - Postgres

  ## Decisões de Arquitetura

  ### Processamento Assíncrono dos Perfis

  Os perfis são processados em segundo plano utilizando o Sidekiq. O modelo de Perfil inclui um campo de 'status de sincronização', que armazena uma pequena máquina de estados para manter o usuário informado sobre o andamento e para executar validações internas em momentos específicos.

  Existem três tipos de operações que acionam um job de sincronização:

  - Criar Perfil
  - Atualizar Perfil
  - Ação de Sincronização (Refresh)

  Os dados são extraídos por meio de uma instância do Chrome em modo headless. O uso de um navegador é necessário, pois alguns campos da página do perfil do GitHub são renderizados com JavaScript. Após a página ser completamente carregada no Chrome, o texto HTML resultante é utilizado para a extração dos dados.

  Separar essas duas partes é vantajoso para facilitar os testes. No entanto, vale ressaltar que o teste pode não refletir mudanças futuras na estrutura da página do GitHub.

  ### Encurtador de Links

  O projeto utiliza o [Nanoid](https://github.com/radeno/nanoid.rb)  para gerar identificadores únicos para cada link. Cada perfil recebe um ID de até 5 caracteres, gerado no momento da criação do perfil.

  O processo de redirecionamento começa consultando o Redis. Se o dado não estiver presente, o identificador é recuperado do banco de dados. Quando ocorre um cache miss, o dado é armazenado no Redis por uma hora.


  ## Limitações

  - Os testes não capturam o estado real da estrutura HTML do perfil do GitHub. Em um projeto real, seria interessante criar um teste End-to-End para garantir o funcionamento completo do sistema.
  - O processo de cache dos links funciona muito bem em cenários com poucos links muito acessados. No entanto, em cenários de larga escala, com centenas de milhares de links sendo acessados de forma intermitente, essa arquitetura pode não ser a mais adequada.
