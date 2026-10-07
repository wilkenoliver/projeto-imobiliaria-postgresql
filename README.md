# 🏠 Sistema de Imobiliária — PostgreSQL

Projeto acadêmico desenvolvido para a faculdade com foco em **banco de dados e integridade de dados**, utilizando PostgreSQL.

O projeto simula um sistema simples de uma imobiliária, contendo proprietários, imóveis, inquilinos, corretores e aluguéis.

## 📚 Objetivos

- Criar e estruturar um banco de dados relacional.
- Aplicar **chaves primárias (PRIMARY KEY)**.
- Aplicar **chaves estrangeiras (FOREIGN KEY)**.
- Utilizar **NOT NULL**, **UNIQUE** e **CHECK**.
- Trabalhar com regras de integridade referencial.
- Demonstrar `ON DELETE CASCADE`.
- Demonstrar `ON DELETE SET NULL`.
- Demonstrar `ON DELETE RESTRICT`.
- Demonstrar `ON UPDATE CASCADE`.
- Alterar constraints utilizando `ALTER TABLE`.
- Registrar e explicar testes de integridade.

## 🗂️ Estrutura do projeto

```text
projeto-imobiliaria-postgresql/
├── README.md
├── sql/
│   └── imobiliaria_integridade.sql
└── docs/
    └── modelo-dados.md
```

## 🛠️ Tecnologias

- PostgreSQL
- SQL
- Git / GitHub

## 🏗️ Entidades

O banco possui cinco tabelas principais:

| Tabela | Descrição |
|---|---|
| `proprietario` | Dados dos proprietários dos imóveis |
| `imovel` | Dados dos imóveis cadastrados |
| `inquilino` | Dados dos inquilinos |
| `corretor` | Dados dos corretores |
| `aluguel` | Relação entre imóveis, inquilinos e corretores |

## 🔐 Integridade de dados

O projeto demonstra diferentes mecanismos de integridade:

### PRIMARY KEY
Identifica unicamente os registros de cada tabela.

### UNIQUE
Utilizado, por exemplo, para impedir CPFs e CRECIs duplicados.

### NOT NULL
Garante que campos obrigatórios não sejam deixados vazios.

### CHECK
Restringe valores que não atendem às regras definidas. Exemplos:

- Sexo: `M` ou `F`
- Idade dos proprietários: entre 21 e 80 anos
- Idade dos inquilinos: entre 18 e 90 anos
- Valor do aluguel do imóvel: maior que R$ 500,00
- Tipo do imóvel: residencial ou comercial
- Status: alugado, livre ou em reforma

### FOREIGN KEY
Mantém os relacionamentos entre as tabelas e evita referências a registros inexistentes.

## 🔄 Regras de relacionamento

O projeto também demonstra três comportamentos importantes:

| Regra | Comportamento |
|---|---|
| `ON DELETE CASCADE` | Ao excluir o registro pai, os registros dependentes também são excluídos |
| `ON DELETE SET NULL` | O registro dependente permanece, mas sua chave estrangeira recebe `NULL` |
| `ON DELETE RESTRICT` | Impede a exclusão do registro pai enquanto houver registros dependentes |
| `ON UPDATE CASCADE` | Atualiza automaticamente as chaves estrangeiras quando a chave do registro pai muda |

## ▶️ Como executar

### 1. Instale o PostgreSQL

Tenha o PostgreSQL instalado e disponível através do **pgAdmin**, **psql** ou outra ferramenta compatível.

### 2. Crie o banco

No PostgreSQL, execute:

```sql
CREATE DATABASE Imobiliaria;
```

Depois, conecte-se ao banco `Imobiliaria`.

### 3. Execute o arquivo SQL

Abra:

```text
sql/imobiliaria_integridade.sql
```

e execute o script.

> Alguns testes que propositalmente geram erros estão comentados no arquivo SQL. Eles podem ser descomentados individualmente para testar cada regra de integridade.

## 🧪 Testes realizados

O trabalho contém testes para:

1. `CHECK` com sexo inválido.
2. `CHECK` com idade inválida.
3. `CHECK` no valor do aluguel.
4. `NOT NULL`.
5. `UNIQUE`.
6. `FOREIGN KEY`.
7. `ON DELETE CASCADE`.
8. `ON DELETE SET NULL`.
9. `ON DELETE RESTRICT`.
10. `ON UPDATE CASCADE`.
11. Alteração de uma `FOREIGN KEY` utilizando `ALTER TABLE`.

As respostas e explicações dos testes estão registradas diretamente no arquivo SQL.

## 📐 Relacionamentos

```text
PROPRIETARIO 1 ─────── N IMOVEL
                         │
                         │
                         N
                       ALUGUEL
                         N
                         │
        ┌────────────────┴────────────────┐
        │                                 │
        1                                 1
   INQUILINO                           CORRETOR
```

Mais especificamente:

- Um proprietário pode ter vários imóveis.
- Um imóvel pode possuir vários aluguéis.
- Um inquilino pode possuir vários aluguéis.
- Um corretor pode cuidar de vários aluguéis.

## 🎓 Contexto acadêmico

Este projeto foi desenvolvido como atividade prática de faculdade para demonstrar conhecimentos de **SQL, PostgreSQL, modelagem relacional e integridade de dados**.

## 👨‍💻 Autor

**Eduardo Elioterio de Oliveira**

Projeto acadêmico — Ciências da Computação.
