# Documentação do Data Warehouse (PostgreSQL)

## Estágio 1: Camada BRONZE (Landing Zone: Dados Brutos)

**Propósito:** Receber os dados brutos de origem. Os campos de data e valor são mantidos como `VARCHAR` para evitar erros de importação.

```sql
-- CRIAÇÃO DO SCHEMA BRONZE
CREATE SCHEMA IF NOT EXISTS bronze;

-- 1. Tabela BRONZE.contas_planejadas
-- Tabela para receber dados brutos de contas planejadas.
CREATE TABLE IF NOT EXISTS bronze.contas_planejadas (
    id_conta VARCHAR(50),
    data_vencimento VARCHAR(50), 
    valor_previsto VARCHAR(50), 
    parceiro VARCHAR(100),
    categoria_financeira VARCHAR(100),
    status_cobranca VARCHAR(50)
);

-- 2. Tabela BRONZE.transacoes_realizadas
-- Tabela para receber dados brutos de transações realizadas.
CREATE TABLE IF NOT EXISTS bronze.transacoes_realizadas (
    id_transacao VARCHAR(50),
    data_lancamento VARCHAR(50),
    valor_transacao VARCHAR(50), 
    parceiro VARCHAR(100),
    categoria_financeira VARCHAR(100)
);

-- NOTA: Os dados devem ser importados para estas tabelas antes de executar a próxima seção.
```

-----

## Estágio 2: Camada SILVER (Integração: Limpeza e Tipagem)

**Propósito:** Limpar caracteres especiais (R$, etc.), garantir a qualidade dos dados e aplicar a tipagem correta (DATE, NUMERIC, INTEGER).

```sql
-- CRIAÇÃO DO SCHEMA SILVER
CREATE SCHEMA IF NOT EXISTS silver;

-- 1. CRIAÇÃO DAS TABELAS SILVER (Com Tipos Corrigidos)

-- Tabela SILVER.contas_planejadas
CREATE TABLE IF NOT EXISTS silver.contas_planejadas (
    id_conta VARCHAR(50) PRIMARY KEY,
    data_vencimento DATE,
    valor_previsto NUMERIC(10, 2),
    parceiro VARCHAR(100),
    categoria_financeira VARCHAR(100),
    status_cobranca VARCHAR(50)
);

-- Tabela SILVER.transacoes_realizadas
CREATE TABLE IF NOT EXISTS silver.transacoes_realizadas (
    id_transacao INTEGER PRIMARY KEY,
    data_lancamento DATE,
    valor_realizado NUMERIC(10, 2),
    parceiro VARCHAR(100),
    categoria_financeira VARCHAR(100)
);

-- 2. ETL BRONZE PARA SILVER: POPULAÇÃO E LIMPEZA

-- a) Carga e Limpeza de Contas Planejadas:
INSERT INTO silver.contas_planejadas
SELECT
    id_conta,
    data_vencimento::DATE, -- Converte string para DATE
    -- Limpa e converte o valor monetário para NUMERIC
    REPLACE(REPLACE(REPLACE(valor_previsto, 'R$', ''), '.', ''), ',', '.')::NUMERIC(10, 2),
    parceiro,
    categoria_financeira,
    status_cobranca
FROM bronze.contas_planejadas
ON CONFLICT (id_conta) DO NOTHING;

-- b) Carga e Limpeza de Transações Realizadas:
INSERT INTO silver.transacoes_realizadas
SELECT
    id_transacao::INTEGER, -- Converte string para INTEGER
    data_lancamento::DATE,
    -- Limpa e converte o valor monetário para NUMERIC
    REPLACE(REPLACE(REPLACE(valor_transacao, 'R$', ''), '.', ''), ',', '.')::NUMERIC(10, 2),
    parceiro,
    categoria_financeira
FROM bronze.transacoes_realizadas
ON CONFLICT (id_transacao) DO NOTHING;
```

-----

## Estágio 3: Camada GOLD (Apresentação: Modelo Dimensional)

**Propósito:** Estruturar os dados limpos em um Modelo Dimensional (Esquema Estrela) otimizado para a análise de Fluxo de Caixa.

```sql
-- CRIAÇÃO DO SCHEMA GOLD
CREATE SCHEMA IF NOT EXISTS gold;
SET search_path TO gold, public; 

-- 1. CRIAÇÃO DAS DIMENSÕES

-- dim_tempo
CREATE TABLE IF NOT EXISTS dim_tempo (
    data DATE PRIMARY KEY,
    ano INTEGER NOT NULL,
    mes INTEGER NOT NULL,
    nome_mes VARCHAR(20) NOT NULL,
    dia_semana INTEGER NOT NULL,
    nome_dia_semana VARCHAR(20) NOT NULL
);

-- dim_conta
CREATE TABLE IF NOT EXISTS dim_conta (
    id_conta VARCHAR(50) PRIMARY KEY,
    descricao_detalhada VARCHAR(255),
    tipo_conta VARCHAR(50) 
);

-- 2. CRIAÇÃO DA TABELA FATO (ft_fluxo_caixa)
CREATE TABLE IF NOT EXISTS ft_fluxo_caixa (
    sk_fluxo_caixa SERIAL PRIMARY KEY,
    id_transacao INTEGER,
    id_conta VARCHAR(50) REFERENCES dim_conta(id_conta),
    data_ref DATE REFERENCES dim_tempo(data),
    
    valor_realizado NUMERIC(10, 2),
    valor_planejado NUMERIC(10, 2),
    valor_net NUMERIC(10, 2) NOT NULL, 
    
    tipo_movimento VARCHAR(10), 
    categoria VARCHAR(100),
    
    is_realizado BOOLEAN NOT NULL,
    is_planejado BOOLEAN NOT NULL,
    is_entrada BOOLEAN NOT NULL,
    is_saida BOOLEAN NOT NULL
);

-- 3. POPULAÇÃO DA dim_tempo (Gerador de Datas)
DO $$
DECLARE
    start_date DATE := '2024-01-01'; 
    end_date DATE := '2026-12-31';   
BEGIN
    TRUNCATE TABLE dim_tempo; 
    
    INSERT INTO dim_tempo (data, ano, mes, nome_mes, dia_semana, nome_dia_semana)
    SELECT
        dt::DATE,
        EXTRACT(YEAR FROM dt) AS ano,
        EXTRACT(MONTH FROM dt) AS mes,
        TO_CHAR(dt, 'Month') AS nome_mes,
        EXTRACT(ISODOW FROM dt) AS dia_semana,
        TO_CHAR(dt, 'Day') AS nome_dia_semana
    FROM generate_series(start_date, end_date, '1 day'::interval) AS t(dt)
    ON CONFLICT (data) DO NOTHING;
END $$;

-- 4. ETL SILVER PARA GOLD: CARGA DOS DADOS

-- a) POPULAR gold.dim_conta
INSERT INTO gold.dim_conta (id_conta, tipo_conta, descricao_detalhada)
SELECT DISTINCT id_conta, 
       CASE WHEN valor_previsto > 0 THEN 'Receber' ELSE 'Pagar' END AS tipo,
       categoria_financeira
FROM silver.contas_planejadas 
ON CONFLICT (id_conta) DO NOTHING;

-- b) POPULAR gold.ft_fluxo_caixa (Carga de Dados Planejados)
INSERT INTO gold.ft_fluxo_caixa (
    id_conta, data_ref, valor_planejado, valor_net, tipo_movimento, categoria,
    is_planejado, is_realizado, is_entrada, is_saida
)
SELECT 
    cp.id_conta,
    cp.data_vencimento,
    cp.valor_previsto,
    cp.valor_previsto, 
    'Planejado' AS tipo_movimento,
    cp.categoria_financeira,
    TRUE AS is_planejado, 
    FALSE AS is_realizado,
    CASE WHEN cp.valor_previsto > 0 THEN TRUE ELSE FALSE END AS is_entrada,
    CASE WHEN cp.valor_previsto < 0 THEN TRUE ELSE FALSE END AS is_saida
FROM silver.contas_planejadas cp;

-- c) POPULAR gold.ft_fluxo_caixa (Carga de Dados Realizados)
INSERT INTO gold.ft_fluxo_caixa (
    id_transacao, id_conta, data_ref, valor_realizado, valor_net, tipo_movimento, categoria,
    is_planejado, is_realizado, is_entrada, is_saida
)
SELECT 
    tr.id_transacao,
    tr.id_conta,
    tr.data_lancamento,
    tr.valor_realizado,
    tr.valor_realizado, 
    'Realizado' AS tipo_movimento,
    tr.categoria_financeira,
    FALSE AS is_planejado,
    TRUE AS is_realizado, 
    CASE WHEN tr.valor_realizado > 0 THEN TRUE ELSE FALSE END AS is_entrada,
    CASE WHEN tr.valor_realizado < 0 THEN TRUE ELSE FALSE END AS is_saida
FROM silver.transacoes_realizadas tr;
```
