# Modelo de Dados

## Entidades

### PROPRIETARIO
- PK: `codigo`
- `nome`
- `cpf` — UNIQUE
- `sexo` — CHECK
- `idade` — CHECK
- `telefone`

### IMOVEL
- PK: `codigo`
- `endereco`
- `descricao`
- `valor_aluguel` — CHECK
- `tipo` — CHECK
- `status` — CHECK
- FK: `proprietario` → `PROPRIETARIO(codigo)`

### INQUILINO
- PK: `codigo`
- `nome`
- `cpf` — UNIQUE
- `sexo` — CHECK
- `idade` — CHECK
- `telefone`

### CORRETOR
- PK: `codigo`
- `nome`
- `cpf` — UNIQUE
- `sexo` — CHECK
- `data_nascimento`
- `telefone`
- `creci` — UNIQUE

### ALUGUEL
- PK: `codigo`
- FK: `imovel` → `IMOVEL(codigo)`
- FK: `inquilino` → `INQUILINO(codigo)`
- FK: `corretor` → `CORRETOR(codigo)`
- `data_aluguel`
- `data_vencimento`
- `valor_final_aluguel` — CHECK

## Cardinalidades

- PROPRIETARIO → IMOVEL: **1:N**
- IMOVEL → ALUGUEL: **1:N**
- INQUILINO → ALUGUEL: **1:N**
- CORRETOR → ALUGUEL: **1:N**

## Regras de integridade

O banco utiliza `CASCADE`, `SET NULL` e `RESTRICT` para controlar o comportamento das relações quando registros são atualizados ou excluídos.
