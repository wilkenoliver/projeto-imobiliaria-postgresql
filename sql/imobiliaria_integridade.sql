-- =====================================================
-- Banco de Dados - Exercício de Integridade de Dados
-- Sistema de Imobiliária
-- Aluno: NOME COMPLETO DO ALUNO
-- Usei o PostgreSQL
-- =====================================================
-- Obs: os testes que dão erro estão comentados, porque se der erro
-- no meio o script para. Pra testar, é só tirar o "--" e rodar um
-- de cada vez. As respostas ficam logo abaixo de cada teste.


-- =====================================================
-- 1. Criando o banco
-- =====================================================
CREATE DATABASE Imobiliaria;
-- depois de criar, é preciso conectar nele (no psql: \c imobiliaria)


-- =====================================================
-- 2. Tabela PROPRIETARIO
-- =====================================================
CREATE TABLE proprietario (
    codigo    INTEGER      NOT NULL,
    nome      VARCHAR(100) NOT NULL,
    cpf       VARCHAR(14)  NOT NULL,
    sexo      CHAR(1),
    idade     INTEGER,
    telefone  VARCHAR(20)  NOT NULL,
    CONSTRAINT pk_proprietario       PRIMARY KEY (codigo),
    CONSTRAINT uq_proprietario_cpf   UNIQUE (cpf),
    CONSTRAINT ck_proprietario_sexo  CHECK (sexo IN ('M', 'F')),
    CONSTRAINT ck_proprietario_idade CHECK (idade BETWEEN 21 AND 80)
);

-- =====================================================
-- 3. Tabela IMOVEL
-- =====================================================
-- A coluna proprietario ficou sem NOT NULL de propósito, senão
-- não dá pra usar o SET NULL no item 13.
CREATE TABLE imovel (
    codigo         INTEGER        NOT NULL,
    endereco       VARCHAR(200)   NOT NULL,
    descricao      VARCHAR(300)   NOT NULL,
    valor_aluguel  NUMERIC(10,2),
    tipo           VARCHAR(15),
    status         VARCHAR(15),
    proprietario   INTEGER,
    CONSTRAINT pk_imovel              PRIMARY KEY (codigo),
    CONSTRAINT ck_imovel_valor        CHECK (valor_aluguel > 500),
    CONSTRAINT ck_imovel_tipo         CHECK (tipo IN ('residencial', 'comercial')),
    CONSTRAINT ck_imovel_status       CHECK (status IN ('alugado', 'livre', 'em reforma')),
    CONSTRAINT fk_imovel_proprietario FOREIGN KEY (proprietario)
        REFERENCES proprietario (codigo)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

-- =====================================================
-- 4. Tabela INQUILINO
-- =====================================================
CREATE TABLE inquilino (
    codigo    INTEGER      NOT NULL,
    nome      VARCHAR(100) NOT NULL,
    cpf       VARCHAR(14)  NOT NULL,
    sexo      CHAR(1),
    idade     INTEGER,
    telefone  VARCHAR(20)  NOT NULL,
    CONSTRAINT pk_inquilino       PRIMARY KEY (codigo),
    CONSTRAINT uq_inquilino_cpf   UNIQUE (cpf),
    CONSTRAINT ck_inquilino_sexo  CHECK (sexo IN ('M', 'F')),
    CONSTRAINT ck_inquilino_idade CHECK (idade BETWEEN 18 AND 90)
);

-- =====================================================
-- 5. Tabela CORRETOR
-- =====================================================
CREATE TABLE corretor (
    codigo           INTEGER      NOT NULL,
    nome             VARCHAR(100) NOT NULL,
    cpf              VARCHAR(14)  NOT NULL,
    sexo             CHAR(1),
    data_nascimento  DATE         NOT NULL,
    telefone         VARCHAR(20)  NOT NULL,
    creci            VARCHAR(20)  NOT NULL,
    CONSTRAINT pk_corretor       PRIMARY KEY (codigo),
    CONSTRAINT uq_corretor_cpf   UNIQUE (cpf),
    CONSTRAINT uq_corretor_creci UNIQUE (creci),
    CONSTRAINT ck_corretor_sexo  CHECK (sexo IN ('M', 'F'))
);

-- =====================================================
-- 6. Tabela ALUGUEL
-- =====================================================
-- Aqui também deixei inquilino sem NOT NULL, por causa do SET NULL.
CREATE TABLE aluguel (
    codigo               INTEGER       NOT NULL,
    imovel               INTEGER,
    inquilino            INTEGER,
    corretor             INTEGER,
    data_aluguel         DATE          NOT NULL,
    data_vencimento      DATE          NOT NULL,
    valor_final_aluguel  NUMERIC(10,2),
    CONSTRAINT pk_aluguel       PRIMARY KEY (codigo),
    CONSTRAINT ck_aluguel_valor CHECK (valor_final_aluguel > 600),

    -- 6.1 aluguel -> imovel (apagou o imóvel, apaga o aluguel)
    CONSTRAINT fk_aluguel_imovel FOREIGN KEY (imovel)
        REFERENCES imovel (codigo)
        ON DELETE CASCADE
        ON UPDATE CASCADE,

    -- 6.2 aluguel -> inquilino (apagou o inquilino, o aluguel fica com NULL)
    CONSTRAINT fk_aluguel_inquilino FOREIGN KEY (inquilino)
        REFERENCES inquilino (codigo)
        ON DELETE SET NULL
        ON UPDATE CASCADE,

    -- 6.3 aluguel -> corretor (se tem aluguel, não deixa apagar o corretor)
    CONSTRAINT fk_aluguel_corretor FOREIGN KEY (corretor)
        REFERENCES corretor (codigo)
        ON DELETE RESTRICT
        ON UPDATE CASCADE
);


-- =====================================================
-- 7. Inserindo os dados
-- =====================================================
INSERT INTO proprietario (codigo, nome, cpf, sexo, idade, telefone) VALUES
(1, 'Carlos Silva', '111.111.111-11', 'M', 45, '(11) 91111-1111'),
(2, 'Maria Souza',  '222.222.222-22', 'F', 52, '(11) 92222-2222'),
(3, 'João Pereira', '333.333.333-33', 'M', 60, '(11) 93333-3333');

INSERT INTO inquilino (codigo, nome, cpf, sexo, idade, telefone) VALUES
(1, 'Ana Lima',     '444.444.444-44', 'F', 28, '(11) 94444-4444'),
(2, 'Bruno Costa',  '555.555.555-55', 'M', 35, '(11) 95555-5555'),
(3, 'Carla Mendes', '666.666.666-66', 'F', 41, '(11) 96666-6666');

INSERT INTO corretor (codigo, nome, cpf, sexo, data_nascimento, telefone, creci) VALUES
(1, 'Roberto Alves',  '777.777.777-77', 'M', '1985-03-12', '(11) 97777-7777', 'CRECI-1001'),
(2, 'Fernanda Rocha', '888.888.888-88', 'F', '1990-07-25', '(11) 98888-8888', 'CRECI-1002');

INSERT INTO imovel (codigo, endereco, descricao, valor_aluguel, tipo, status, proprietario) VALUES
(1, 'Rua das Flores, 100',   'Apartamento 2 quartos',      1500.00, 'residencial', 'alugado', 1),
(2, 'Av. Brasil, 200',       'Sala comercial 40m²',        2500.00, 'comercial',   'alugado', 1),
(3, 'Rua das Palmeiras, 50', 'Casa 3 quartos com quintal', 2200.00, 'residencial', 'alugado', 2),
(4, 'Rua Central, 300',      'Loja térrea no centro',      3000.00, 'comercial',   'alugado', 3);

INSERT INTO aluguel (codigo, imovel, inquilino, corretor, data_aluguel, data_vencimento, valor_final_aluguel) VALUES
(1, 1, 1, 1, '2026-01-10', '2026-02-10', 1500.00),
(2, 2, 2, 1, '2026-02-01', '2026-03-01', 2500.00),
(3, 3, 3, 2, '2026-03-05', '2026-04-05', 2200.00),
(4, 4, 1, 2, '2026-04-01', '2026-05-01', 3000.00);

-- conferindo se entrou tudo certinho
SELECT * FROM proprietario;
SELECT * FROM inquilino;
SELECT * FROM corretor;
SELECT * FROM imovel;
SELECT * FROM aluguel;


-- =====================================================
-- 8. Testes de integridade
-- =====================================================

-- ----- TESTE 1: CHECK com sexo inválido -----
-- INSERT INTO proprietario (codigo, nome, cpf, sexo, idade, telefone)
-- VALUES (10, 'Teste Sexo', '000.000.000-01', 'X', 30, '(11) 90000-0001');
--
-- Erro que apareceu:
--   ERROR: new row for relation "proprietario" violates check constraint "ck_proprietario_sexo"
--
-- 1. Não, o registro não foi inserido. O banco recusou.
-- 2. Violou o CHECK ck_proprietario_sexo.
-- 3. Só aceita 'M' ou 'F' (ou NULL, já que a coluna não é NOT NULL).


-- ----- TESTE 2: CHECK com idade inválida -----
-- INSERT INTO proprietario (codigo, nome, cpf, sexo, idade, telefone)
-- VALUES (10, 'Teste Idade', '000.000.000-02', 'M', 15, '(11) 90000-0002');
--
-- Erro que apareceu:
--   ERROR: new row for relation "proprietario" violates check constraint "ck_proprietario_idade"
--
-- 1. Não aceitou, porque 15 está fora do intervalo de 21 a 80.
-- 2. Quem validou foi o CHECK ck_proprietario_idade. Isso é integridade
--    de domínio (o valor tem que estar dentro do que é permitido).


-- ----- TESTE 3: CHECK no valor do aluguel -----
-- INSERT INTO imovel (codigo, endereco, descricao, valor_aluguel, tipo, status, proprietario)
-- VALUES (10, 'Rua Teste, 1', 'Imóvel de teste', 300, 'residencial', 'livre', 1);
--
-- Erro que apareceu:
--   ERROR: new row for relation "imovel" violates check constraint "ck_imovel_valor"
--
-- Explicação: 300 não é maior que 500, então o CHECK ck_imovel_valor
-- barrou o insert. O banco só aceita aluguel acima de R$ 500,00.


-- ----- TESTE 4: NOT NULL -----
-- INSERT INTO proprietario (codigo, cpf, sexo, idade, telefone)
-- VALUES (10, '000.000.000-04', 'M', 30, '(11) 90000-0004');
--
-- Erro que apareceu:
--   ERROR: null value in column "nome" of relation "proprietario" violates not-null constraint
--
-- 1. Não foi inserido.
-- 2. Violou o NOT NULL da coluna nome.
-- 3. Porque o nome é obrigatório. Como eu não informei, ele ficaria vazio
--    (NULL) e o banco não permite. Isso é a integridade de vazio.


-- ----- TESTE 5: UNIQUE -----
-- Primeiro cadastrei um proprietário com um CPF (esse funciona):
INSERT INTO proprietario (codigo, nome, cpf, sexo, idade, telefone)
VALUES (4, 'Paulo Ribeiro', '999.999.999-99', 'M', 50, '(11) 99999-9999');

-- Agora tento cadastrar outro com o mesmo CPF (esse dá erro):
-- INSERT INTO proprietario (codigo, nome, cpf, sexo, idade, telefone)
-- VALUES (5, 'Outro Proprietario', '999.999.999-99', 'F', 40, '(11) 90000-0005');
--
-- Erro que apareceu:
--   ERROR: duplicate key value violates unique constraint "uq_proprietario_cpf"
--   DETAIL: Key (cpf)=(999.999.999-99) already exists.
--
-- 1. Não, o segundo não foi aceito.
-- 2. Quem impediu foi o UNIQUE uq_proprietario_cpf.
-- 3. O UNIQUE serve pra não deixar repetir um valor que tem que ser único,
--    como o CPF, que identifica uma pessoa só. É integridade de chave.


-- ----- TESTE 6: FOREIGN KEY -----
-- INSERT INTO imovel (codigo, endereco, descricao, valor_aluguel, tipo, status, proprietario)
-- VALUES (10, 'Rua Teste, 2', 'Imóvel sem dono', 1000, 'residencial', 'livre', 999);
--
-- Erro que apareceu:
--   ERROR: insert or update on table "imovel" violates foreign key constraint "fk_imovel_proprietario"
--   DETAIL: Key (proprietario)=(999) is not present in table "proprietario".
--
-- 1. Não foi inserido.
-- 2. Porque não existe proprietário com código 999, e a chave estrangeira
--    só aceita código que já exista na tabela proprietario.
-- 3. Integridade referencial. Ela evita imóvel "órfão", ligado a um
--    proprietário que não existe.


-- =====================================================
-- 9. Testando ON DELETE CASCADE
-- =====================================================
-- O proprietário 3 (João Pereira) tem o imóvel 4, que tem o aluguel 4.
SELECT * FROM proprietario;
SELECT * FROM imovel;
SELECT * FROM aluguel;

DELETE FROM proprietario
WHERE codigo = 3;

SELECT * FROM proprietario;
SELECT * FROM imovel;
SELECT * FROM aluguel;

-- 1. Sim, o proprietário 3 foi excluído.
-- 2. O imóvel 4 dele também sumiu. E o aluguel 4 também, porque ele
--    dependia desse imóvel (aluguel -> imovel também é CASCADE).
-- 3. A regra ON DELETE CASCADE da fk_imovel_proprietario (e depois a da
--    fk_aluguel_imovel).


-- =====================================================
-- 10. Testando ON DELETE SET NULL
-- =====================================================
-- A inquilina 3 (Carla Mendes) está no aluguel 3.
SELECT * FROM aluguel;

DELETE FROM inquilino
WHERE codigo = 3;

SELECT * FROM aluguel;

-- 1. Não, o aluguel 3 continua lá.
-- 2. O campo inquilino dele ficou NULL.
-- 3. Por causa do ON DELETE SET NULL: quando o pai é apagado, o banco
--    coloca NULL na chave estrangeira do filho. Só funciona porque a
--    coluna não é NOT NULL.
-- 4. No CASCADE o filho é apagado junto com o pai. No SET NULL o filho
--    fica, só perde a ligação com o pai.


-- =====================================================
-- 11. Testando ON DELETE RESTRICT
-- =====================================================
-- O corretor 1 (Roberto Alves) está nos aluguéis 1 e 2.
-- DELETE FROM corretor
-- WHERE codigo = 1;
--
-- Erro que apareceu:
--   ERROR: update or delete on table "corretor" violates foreign key constraint
--          "fk_aluguel_corretor" on table "aluguel"
--   DETAIL: Key (codigo)=(1) is still referenced from table "aluguel".
--
-- 1. Não, o corretor não foi excluído.
-- 2. Porque ainda tem aluguel ligado a ele, e o RESTRICT não deixa apagar
--    o pai enquanto existir filho.
-- 3. Antes é preciso apagar esses aluguéis ou passar eles pra outro
--    corretor. Por exemplo:
--      UPDATE aluguel SET corretor = 2 WHERE corretor = 1;
--      DELETE FROM corretor WHERE codigo = 1;


-- =====================================================
-- 12. Testando ON UPDATE CASCADE
-- =====================================================
-- O proprietário 1 (Carlos Silva) tem os imóveis 1 e 2.
SELECT * FROM proprietario;
SELECT * FROM imovel;

UPDATE proprietario
SET codigo = 100
WHERE codigo = 1;

SELECT * FROM proprietario;
SELECT * FROM imovel;

-- 1. Sim, o código mudou de 1 para 100.
-- 2. Sim, os imóveis 1 e 2 agora aparecem com proprietario = 100.
-- 3. Foi o ON UPDATE CASCADE da fk_imovel_proprietario, que repassa a
--    mudança da chave primária para as chaves estrangeiras.


-- =====================================================
-- 13. Mudando a constraint com ALTER TABLE
-- =====================================================

-- 1. Descobrindo o nome da FK (e a regra de delete atual)
SELECT conname AS nome_constraint, confdeltype AS regra_delete
FROM pg_constraint
WHERE conrelid = 'imovel'::regclass AND contype = 'f';
-- Resultado: fk_imovel_proprietario, com 'c' (CASCADE)

-- 2. Removendo a constraint
ALTER TABLE imovel
DROP CONSTRAINT fk_imovel_proprietario;

-- 3, 4 e 5. Criando de novo com SET NULL no delete e CASCADE no update
ALTER TABLE imovel
ADD CONSTRAINT fk_imovel_proprietario
    FOREIGN KEY (proprietario)
    REFERENCES proprietario (codigo)
    ON DELETE SET NULL
    ON UPDATE CASCADE;

-- conferindo se mudou (agora deve aparecer 'n', que é SET NULL)
SELECT conname AS nome_constraint, confdeltype AS regra_delete
FROM pg_constraint
WHERE conrelid = 'imovel'::regclass AND contype = 'f';

-- 6. Excluindo a proprietária 2 (Maria Souza), dona do imóvel 3
SELECT * FROM imovel;

DELETE FROM proprietario
WHERE codigo = 2;

SELECT * FROM proprietario;
SELECT * FROM imovel;

-- O que aconteceu: a Maria foi excluída, mas o imóvel 3 NÃO foi apagado.
-- Ele continua na tabela, só que com proprietario = NULL. Diferente do
-- item 9, em que o imóvel sumia junto com o dono.


-- =====================================================
-- 14. Comparando as regras
-- =====================================================
-- Regra               | Ao excluir o pai          | O que acontece com o filho
-- --------------------|---------------------------|-------------------------------
-- ON DELETE CASCADE   | Exclui normalmente        | Também é excluído
-- ON DELETE SET NULL  | Exclui normalmente        | Fica, com a FK = NULL
-- ON DELETE RESTRICT  | Bloqueia (se tiver filho) | Fica igual, e o pai não é excluído
--
-- Com as minhas palavras:
-- CASCADE: apagou o pai, apaga tudo que depende dele. Faz sentido quando
-- o filho não existe sem o pai (um aluguel de um imóvel que não existe mais).
-- SET NULL: o pai é apagado, mas os filhos ficam, só sem ligação (NULL).
-- Bom pra guardar histórico, tipo manter o aluguel mesmo sem o inquilino.
-- RESTRICT: protege o pai. Enquanto tiver filho ligado, o banco não deixa
-- apagar, e a gente tem que resolver os filhos antes.


-- =====================================================
-- 15. DER (resumo em texto, o desenho vai em arquivo separado)
-- =====================================================
-- PROPRIETARIO (PK codigo, nome, cpf, sexo, idade, telefone)
-- IMOVEL       (PK codigo, endereco, descricao, valor_aluguel, tipo, status,
--               FK proprietario -> PROPRIETARIO)
-- INQUILINO    (PK codigo, nome, cpf, sexo, idade, telefone)
-- CORRETOR     (PK codigo, nome, cpf, sexo, data_nascimento, telefone, creci)
-- ALUGUEL      (PK codigo, data_aluguel, data_vencimento, valor_final_aluguel,
--               FK imovel -> IMOVEL, FK inquilino -> INQUILINO,
--               FK corretor -> CORRETOR)
--
-- Cardinalidades:
--   um PROPRIETARIO tem vários IMOVEIS            (1:N)
--   um IMOVEL pode ter vários ALUGUEIS            (1:N)
--   um INQUILINO pode ter vários ALUGUEIS         (1:N)
--   um CORRETOR pode cuidar de vários ALUGUEIS    (1:N)
