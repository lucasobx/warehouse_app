# Warehouse App

Aplicação Ruby on Rails feita com TDD para gerenciamento de galpões e estoque no contexto de um e-commerce.

## Funcionalidades
### Galpões
  - Detalhes (nome, cidade, área, endereço, cep, detalhes, itens em estoque e saída de itens) 
  - Listagem
  - Cadastro
  - Edição

### Fornecedores
  - Detalhes (nome da marca, nome corporativo, cidade, email, endereço, cep e cnpj)
  - Listagem
  - Cadastro
  - Edição

### Produtos (usuário deve estar autenticado para acessar essas funcionalidades)
  - Detalhes (nome, nome da marca do fornecedor, peso, largura, altura, profundidade e sku) 
  - Listagem
  - Cadastro

### Pedidos (usuário deve estar autenticado para acessar essas funcionalidades)
  - Busca de pedidos de acordo com os parâmetros informados
  - Detalhes (código do pedido, nome da marca do fornecedor, código do galpão, nome do galpão, nome do demandante, email do demandante, data prevista de entrega, status)
  - Listagem
  - Cadastro
  - Edição

### Autenticação
  - Autenticação com Devise
  - Usuário possui email e senha

## Dependências
### Sistema
- ruby "3.3.0"
- rails "~> 7.1.3"

### Testes
- rspec-rails
- capybara

### Autenticação
- devise

## Rodando localmente

clone o repositório
```
git clone git@github.com:lucasobx/warehouse_app.git
```
instale as demais dependências e prepare o banco de dados
```
bin/setup
```
inicialize o servidor
```
rails s
```

### Teste as funcionalidades
```
rspec
```
testes de sistema
```
rspec spec/system
```
testes de requisição
```
rspec spec/requests
```
testes de modelo
```
rspec spec/models
```

## Warehouse App API
### Endpoints
- GET `/api/v1/warehouses/:id` - Detalhes de um galpão

**Exemplo de Requisição**
```
http://localhost:3000/api/v1/warehouses/1/
```
**Exemplo de Resposta**
```json
{
  "id":1,
  "name":"Rio",
  "code":"SDU",
  "city":"Rio de Janeiro",
  "area":60000,
  "address":"Avenida Atlantica, 10",
  "cep":"20000-000",
  "description":"Galpão do Aeroporto do Rio"
}
```

- GET `/api/v1/warehouses` - Listagem de galpões

**Exemplo de Requisição**
```
http://localhost:3000/api/v1/warehouses/
```
**Exemplo de Resposta**
```json
[
  {
  "id":1,
  "name":"Rio",
  "code":"SDU",
  "city":"Rio de Janeiro",
  "area":60000,
  "address":"Avenida Atlantica, 10",
  "cep":"20000-000",
  "description":"Galpão do Aeroporto do Rio"
  },
  {
  "id":2,
  "name":"Aeroporto SP",
  "code":"GRU",
  "city":"Guarulhos",
  "area":100000,
  "address":"Avenida do Aeroporto, 1000",
  "cep":"15000-000",
  "description":"Galpão destinado para cargas internacionais"
  }
]
```

- POST `/api/v1/warehouses` - Cadastro de galpões

**Exemplo de Requisição (Linha de Comando)**
```
curl -X POST http://localhost:3000/api/v1/warehouses -H "Content-Type: application/json" -d '{
  "warehouse": {
    "name": "Aeroporto Internacional",
    "code": "GRU",
    "city": "Guarulhos",
    "area": 100000,
    "address": "Avenida do Aeroporto, 1000",
    "cep": "15000-000",
    "description": "Alguma descrição"
  }
}'
```
**Exemplo de Resposta**
```json
{
  "id": 3,
  "name": "Aeroporto Internacional",
  "code": "GRU",
  "city": "Guarulhos",
  "area": 100000,
  "address": "Avenida do Aeroporto, 1000",
  "cep": "15000-000",
  "description": "Alguma descrição",
}