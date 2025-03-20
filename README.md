# tech-challenge-infra-api-gateway

## Descrição
Este repositório contém o código Terraform responsável pela configuração do API Gateway para o Fast Food Tech Challenge. Integra com outros serviços (como NLB, Lambda e Cognito) e define rotas para diferentes endpoints da aplicação.

## Workflow
Todo o deploy CI/CD é automatizado utilizando o GitHub Actions, seguindo o Github Flow:
- As alterações são realizadas em branchs independentes e, quando validadas, são mergeadas na main via pull request.
- O workflow é definido em .github/workflows/terraform.yaml, onde credenciais são configuradas e o Terraform é executado (init, validate, plan, apply).

## Rotas e integrações

O arquivo OpenAPI (fast-food-tech-challenge-definition.json) define rotas que integram o API Gateway com vários serviços:

- **/products**: métodos POST para criação de produtos e GET para listagem, integrados via VPC Link à aplicação em execução no EKS.  
- **/products/{id}**: métodos PUT para atualizar e DELETE para remover produtos, também via VPC Link.  
- **/customers**: método POST para criação de clientes.  
- **/customers/authentication**: método POST que invoca a Lambda “tech-challenge-customer-token-generation” para gerar token JWT usando Secrets Manager.  
- **/orders**: métodos POST para criar pedidos e GET para listar, via VPC Link.  
- **/orders/{orderId}/payments**: método POST que simula processamento de pagamento via VPC Link.

A autenticação é baseada em:
1. **LambdaAuthorizer** (função Lambda “tech-challenge-authorizer”) para verificar permissões e liberar ou negar acesso dinamicamente.

Cada rota apresenta seu esquema de request/response no OpenAPI, descrevendo como a aplicação se conecta a diferentes serviços por meio do API Gateway. As rotas de produtos, clientes e pedidos seguem o padrão HTTP Proxy; já a rota /customers/authentication utiliza a integração “aws_proxy” diretamente com a função Lambda.
