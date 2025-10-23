--
-- PostgreSQL database dump
--

\restrict IwVuly9nm92rhNtX4LekIE2cel0SpK23R5qgOnJ1rAtu44Vu34NHAVFHdEnHRBy

-- Dumped from database version 18.0
-- Dumped by pg_dump version 18.0

-- Started on 2025-10-23 14:58:20

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 6 (class 2615 OID 49157)
-- Name: bronze; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA bronze;


ALTER SCHEMA bronze OWNER TO postgres;

--
-- TOC entry 8 (class 2615 OID 49192)
-- Name: gold; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA gold;


ALTER SCHEMA gold OWNER TO postgres;

--
-- TOC entry 7 (class 2615 OID 49168)
-- Name: silver; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA silver;


ALTER SCHEMA silver OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 225 (class 1259 OID 49163)
-- Name: contas_planejadas; Type: TABLE; Schema: bronze; Owner: postgres
--

CREATE TABLE bronze.contas_planejadas (
    "ID da Conta" text,
    "Tipo de Conta" text,
    "Descrição Detalhada" text,
    "Valor Previsto (R$)" text,
    "Data de Vencimento" text,
    "Categoria Financeira" text,
    "Status da Cobrança" text,
    "Parceiro" text,
    "Condição de Pgto" text
);


ALTER TABLE bronze.contas_planejadas OWNER TO postgres;

--
-- TOC entry 224 (class 1259 OID 49158)
-- Name: transacoes_realizadas; Type: TABLE; Schema: bronze; Owner: postgres
--

CREATE TABLE bronze.transacoes_realizadas (
    "ID Transação" text,
    "Data" text,
    "Hora" text,
    "Tipo" text,
    "Valor (R$)" text,
    "Descrição" text,
    "Categoria" text,
    "Conta" text,
    "Meio de Pgto" text,
    "Status" text,
    "Estabelecimento" text,
    "ID Conta" text
);


ALTER TABLE bronze.transacoes_realizadas OWNER TO postgres;

--
-- TOC entry 229 (class 1259 OID 49204)
-- Name: dim_conta; Type: TABLE; Schema: gold; Owner: postgres
--

CREATE TABLE gold.dim_conta (
    id_conta character varying(5) NOT NULL,
    tipo_conta character varying(7) NOT NULL,
    descricao_detalhada text
);


ALTER TABLE gold.dim_conta OWNER TO postgres;

--
-- TOC entry 228 (class 1259 OID 49193)
-- Name: dim_tempo; Type: TABLE; Schema: gold; Owner: postgres
--

CREATE TABLE gold.dim_tempo (
    data date NOT NULL,
    ano integer NOT NULL,
    mes integer NOT NULL,
    nome_mes character varying(20) NOT NULL,
    dia_semana character varying(20) NOT NULL,
    nome_dia_semana character varying(20) NOT NULL
);


ALTER TABLE gold.dim_tempo OWNER TO postgres;

--
-- TOC entry 231 (class 1259 OID 49214)
-- Name: ft_fluxo_caixa; Type: TABLE; Schema: gold; Owner: postgres
--

CREATE TABLE gold.ft_fluxo_caixa (
    sk_transacao_planejamento integer NOT NULL,
    id_transacao integer,
    id_conta character varying(5) NOT NULL,
    data_ref date NOT NULL,
    valor_realizado numeric(10,2),
    valor_planejado numeric(10,2),
    tipo_movimento character varying(10) NOT NULL,
    categoria character varying(50),
    status character varying(50),
    is_realizado boolean,
    is_planejado boolean,
    is_entrada boolean,
    is_saida boolean,
    valor_net numeric(10,2)
);


ALTER TABLE gold.ft_fluxo_caixa OWNER TO postgres;

--
-- TOC entry 230 (class 1259 OID 49213)
-- Name: ft_fluxo_caixa_sk_transacao_planejamento_seq; Type: SEQUENCE; Schema: gold; Owner: postgres
--

CREATE SEQUENCE gold.ft_fluxo_caixa_sk_transacao_planejamento_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE gold.ft_fluxo_caixa_sk_transacao_planejamento_seq OWNER TO postgres;

--
-- TOC entry 4969 (class 0 OID 0)
-- Dependencies: 230
-- Name: ft_fluxo_caixa_sk_transacao_planejamento_seq; Type: SEQUENCE OWNED BY; Schema: gold; Owner: postgres
--

ALTER SEQUENCE gold.ft_fluxo_caixa_sk_transacao_planejamento_seq OWNED BY gold.ft_fluxo_caixa.sk_transacao_planejamento;


--
-- TOC entry 223 (class 1259 OID 41018)
-- Name: contas_planejadas; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.contas_planejadas (
    id_conta character varying(50) NOT NULL,
    tipo_conta character varying(10) NOT NULL,
    descricao_detalhada text,
    valor_previsto numeric(15,2) NOT NULL,
    data_vencimento date NOT NULL,
    categoria_financeira character varying(100),
    status_cobranca character varying(50),
    parceiro character varying(100),
    condicao_pagamento character varying(100)
);


ALTER TABLE public.contas_planejadas OWNER TO postgres;

--
-- TOC entry 222 (class 1259 OID 41007)
-- Name: transacoes_realizadas; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.transacoes_realizadas (
    id_transacao character varying(50) NOT NULL,
    data_transacao date NOT NULL,
    hora_transacao time without time zone,
    data_hora timestamp without time zone,
    tipo character varying(10) NOT NULL,
    valor numeric(15,2) NOT NULL,
    descricao text,
    categoria character varying(100),
    conta character varying(100),
    meio_pagamento character varying(100),
    status character varying(50),
    estabelecimento character varying(100),
    id_conta character varying(10)
);


ALTER TABLE public.transacoes_realizadas OWNER TO postgres;

--
-- TOC entry 226 (class 1259 OID 49169)
-- Name: contas_planejadas; Type: TABLE; Schema: silver; Owner: postgres
--

CREATE TABLE silver.contas_planejadas (
    id_conta character varying(5) NOT NULL,
    tipo_conta character varying(7) NOT NULL,
    descricao_detalhada text,
    valor_previsto numeric(10,2) NOT NULL,
    data_vencimento date NOT NULL,
    categoria_financeira character varying(50),
    status_cobranca character varying(20),
    parceiro character varying(100),
    condicao_pgto character varying(50)
);


ALTER TABLE silver.contas_planejadas OWNER TO postgres;

--
-- TOC entry 227 (class 1259 OID 49180)
-- Name: transacoes_realizadas; Type: TABLE; Schema: silver; Owner: postgres
--

CREATE TABLE silver.transacoes_realizadas (
    id_transacao integer NOT NULL,
    id_conta character varying(5),
    data_transacao date NOT NULL,
    hora_transacao time without time zone NOT NULL,
    tipo_transacao character varying(10) NOT NULL,
    valor numeric(10,2) NOT NULL,
    descricao text,
    categoria character varying(50),
    conta_origem character varying(100),
    meio_pgto character varying(50),
    status_transacao character varying(20),
    estabelecimento character varying(100)
);


ALTER TABLE silver.transacoes_realizadas OWNER TO postgres;

--
-- TOC entry 4790 (class 2604 OID 49217)
-- Name: ft_fluxo_caixa sk_transacao_planejamento; Type: DEFAULT; Schema: gold; Owner: postgres
--

ALTER TABLE ONLY gold.ft_fluxo_caixa ALTER COLUMN sk_transacao_planejamento SET DEFAULT nextval('gold.ft_fluxo_caixa_sk_transacao_planejamento_seq'::regclass);


--
-- TOC entry 4957 (class 0 OID 49163)
-- Dependencies: 225
-- Data for Name: contas_planejadas; Type: TABLE DATA; Schema: bronze; Owner: postgres
--

COPY bronze.contas_planejadas ("ID da Conta", "Tipo de Conta", "Descrição Detalhada", "Valor Previsto (R$)", "Data de Vencimento", "Categoria Financeira", "Status da Cobrança", "Parceiro", "Condição de Pgto") FROM stdin;
CR001	Receber	Fatura de Venda Lote 25	9500.00	2025-11-15	Vendas Futuras	Pago	Cliente Tau	15 DDL
CP001	Pagar	Salários de Novembro (Provisão)	-23000.00	2025-11-20	Folha de Pagamento	Pago	RH - Funcionários	Mensal
CP002	Pagar	Campanha Black Friday (2ª parcela)	-4000.00	2025-11-30	Marketing	Pago	Agência Digital	2x
CR003	Receber	Venda de Produto Especial	1200.00	2025-12-05	Vendas Futuras	Aberto	Cliente Epsilon	À Vista
CP005	Pagar	Aluguel do Escritório (Dez)	-3500.00	2025-12-05	Contas Fixas	Aberto	Locadora Imóveis	Mensal
CP006	Pagar	Compra de Estoque (Natal)	-15000.00	2025-12-08	Fornecedores	Aberto	Fornecedor Beta	45 DDL
CP007	Pagar	13º Salário (Provisão)	-15000.00	2025-12-20	Folha de Pagamento	Aberto	RH - Funcionários	Único
CP008	Pagar	Salários de Dezembro	-23000.00	2025-12-20	Folha de Pagamento	Aberto	RH - Funcionários	Mensal
CR009	Receber	Pagamento de Serviço de Dezembro	3500.00	2025-12-25	Serviços Recorrentes	Aberto	Empresa Serviços Z	Mensal
CP010	Pagar	Impostos Mensais (Dez)	-6000.00	2025-12-30	Contas Fixas	Aberto	Receita Federal	Mensal
CR011	Receber	Venda Lote 27	7500.00	2026-01-05	Vendas Futuras	Aberto	Cliente Gama	30 DDL
CP012	Pagar	Aluguel do Escritório (Jan)	-3500.00	2026-01-05	Contas Fixas	Aberto	Locadora Imóveis	Mensal
CP013	Pagar	Mensalidade de Software ERP (Jan)	-850.00	2026-01-05	Despesas Operacionais	Aberto	Fornecedor de TI	Boleto
CP014	Pagar	Compra de Matéria-Prima (Pedido 56)	-21000.00	2026-01-10	Fornecedores	Aberto	Fornecedor Delta	30 DDL
CP015	Pagar	Salários de Janeiro (Provisão)	-24000.00	2026-01-20	Folha de Pagamento	Aberto	RH - Funcionários	Mensal
CP016	Pagar	Renovação de Contrato Anual TI	-15000.00	2026-01-28	Despesas Operacionais	Aberto	Fornecedor de TI	TED
CR017	Receber	Venda Lote 28	4800.00	2026-02-05	Vendas Futuras	Aberto	Cliente Omicron	45 DDL
CP018	Pagar	Aluguel do Escritório (Fev)	-3500.00	2026-02-05	Contas Fixas	Aberto	Locadora Imóveis	Mensal
CP019	Pagar	Marketing de Lançamento (Fev)	-7000.00	2026-02-15	Marketing	Aberto	Agência Digital	30 DDL
CR020	Receber	Fatura de Venda Lote 29	11000.00	2026-02-15	Vendas Futuras	Aberto	Cliente Tau	30 DDL
CP021	Pagar	Salários de Fevereiro (Provisão)	-24500.00	2026-02-20	Folha de Pagamento	Aberto	RH - Funcionários	Mensal
CP022	Pagar	Impostos Mensais (Fev)	-6500.00	2026-02-28	Contas Fixas	Aberto	Receita Federal	Mensal
CR023	Receber	Fatura de Venda Lote 31	8800.00	2026-03-05	Vendas Futuras	Aberto	Cliente Mu	30 DDL
CP024	Pagar	Aluguel do Escritório (Mar)	-3500.00	2026-03-05	Contas Fixas	Aberto	Locadora Imóveis	Mensal
CP025	Pagar	Compra de Estoque (Mar)	-19000.00	2026-03-10	Fornecedores	Aberto	Fornecedor Kappa	45 DDL
CP026	Pagar	Salários de Março (Provisão)	-24500.00	2026-03-20	Folha de Pagamento	Aberto	RH - Funcionários	Mensal
CR027	Receber	Pagamento de Serviços Recorrentes (Abr)	3600.00	2026-04-05	Serviços Recorrentes	Aberto	Empresa Serviços Z	Mensal
CP028	Pagar	Aluguel do Escritório (Abr)	-3500.00	2026-04-05	Contas Fixas	Aberto	Locadora Imóveis	Mensal
CP029	Pagar	Salários de Abril (Provisão)	-24500.00	2026-04-20	Folha de Pagamento	Aberto	RH - Funcionários	Mensal
CP030	Pagar	Impostos Trimestrais	-5500.00	2026-04-28	Contas Fixas	Aberto	Receita Federal	Trimestral
CR031	Receber	Venda Lote 38	5500.00	2026-05-15	Vendas Futuras	Aberto	Cliente Zeta	30 DDL
CP032	Pagar	Aluguel do Escritório (Mai)	-3500.00	2026-05-05	Contas Fixas	Aberto	Locadora Imóveis	Mensal
CP033	Pagar	Marketing (Meio do Ano)	-10000.00	2026-05-10	Marketing	Aberto	Agência Digital	TED
CP034	Pagar	Salários de Maio (Provisão)	-24500.00	2026-05-20	Folha de Pagamento	Aberto	RH - Funcionários	Mensal
CP035	Pagar	Impostos Mensais (Mai)	-6000.00	2026-05-30	Contas Fixas	Aberto	Receita Federal	Mensal
CR036	Receber	Fatura de Venda Lote 42	12500.00	2026-06-15	Vendas Futuras	Aberto	Cliente Lambda	30 DDL
CP037	Pagar	Aluguel do Escritório (Jun)	-3500.00	2026-06-05	Contas Fixas	Aberto	Locadora Imóveis	Mensal
CP038	Pagar	Compra de Estoque (Jun)	-25000.00	2026-06-18	Fornecedores	Aberto	Fornecedor Delta	30 DDL
CP039	Pagar	Salários de Junho (Provisão)	-24500.00	2026-06-20	Folha de Pagamento	Aberto	RH - Funcionários	Mensal
CR040	Receber	Renda de Aluguéis Imóvel 1 (Jul)	1800.00	2026-07-10	Renda Extra	Aberto	Inquilino A	Mensal
CP041	Pagar	Aluguel do Escritório (Jul)	-3500.00	2026-07-05	Contas Fixas	Aberto	Locadora Imóveis	Mensal
CP042	Pagar	Salários de Julho (Provisão)	-24500.00	2026-07-20	Folha de Pagamento	Aberto	RH - Funcionários	Mensal
CP043	Pagar	Impostos Mensais (Jul)	-6000.00	2026-07-30	Contas Fixas	Aberto	Receita Federal	Mensal
CR044	Receber	Venda Lote 48	9500.00	2026-08-15	Vendas Futuras	Aberto	Cliente Tau	30 DDL
CP045	Pagar	Aluguel do Escritório (Ago)	-3500.00	2026-08-05	Contas Fixas	Aberto	Locadora Imóveis	Mensal
CP046	Pagar	Salários de Agosto (Provisão)	-24500.00	2026-08-20	Folha de Pagamento	Aberto	RH - Funcionários	Mensal
CP047	Pagar	Marketing (Nova Campanha)	-7500.00	2026-08-25	Marketing	Aberto	Agência Digital	Boleto
CR048	Receber	Fatura de Venda Lote 52	7200.00	2026-09-15	Vendas Futuras	Aberto	Cliente Gamma	45 DDL
CP049	Pagar	Aluguel do Escritório (Set)	-3500.00	2026-09-05	Contas Fixas	Aberto	Locadora Imóveis	Mensal
CP050	Pagar	Salários de Setembro (Provisão)	-25000.00	2026-09-20	Folha de Pagamento	Aberto	RH - Funcionários	Mensal
CP051	Pagar	Compra de Estoque (Set)	-28000.00	2026-09-25	Fornecedores	Aberto	Fornecedor Kappa	45 DDL
CR052	Receber	Venda Lote 55	15000.00	2026-10-15	Vendas Futuras	Aberto	Cliente Alfa	60 DDL
CP053	Pagar	Aluguel do Escritório (Out)	-3500.00	2026-10-05	Contas Fixas	Aberto	Locadora Imóveis	Mensal
CP054	Pagar	Salários de Outubro (Provisão)	-25000.00	2026-10-20	Folha de Pagamento	Aberto	RH - Funcionários	Mensal
CP055	Pagar	Impostos Mensais (Out)	-6200.00	2026-10-30	Contas Fixas	Aberto	Receita Federal	Mensal
\.


--
-- TOC entry 4956 (class 0 OID 49158)
-- Dependencies: 224
-- Data for Name: transacoes_realizadas; Type: TABLE DATA; Schema: bronze; Owner: postgres
--

COPY bronze.transacoes_realizadas ("ID Transação", "Data", "Hora", "Tipo", "Valor (R$)", "Descrição", "Categoria", "Conta", "Meio de Pgto", "Status", "Estabelecimento", "ID Conta") FROM stdin;
2001	2025-09-01	09:15:00	Entrada	5200.00	Venda Lote 1	Vendas	Banco A (Corrente)	PIX	Compensado	Cliente Alfa	CR001
2002	2025-09-01	14:45:00	Saída	-450.00	Material de Escritório	Despesas Operacionais	Caixa	Dinheiro	Compensado	Papelaria Central	CP001
2003	2025-09-01	17:55:00	Entrada	1800.00	Prestação de Serviço (Mês Anterior)	Prestação de Serviços	Banco A (Corrente)	Boleto	Compensado	Empresa Serviços Z	CP002
2004	2025-09-02	11:30:00	Saída	-25000.00	Pagamento Fornecedor Principal	Fornecedores	Banco A (Corrente)	TED	Compensado	Fornecedor Delta	CR003
2005	2025-09-03	08:50:00	Saída	-30.00	Taxa Bancária Mensal	Contas Fixas	Banco A (Corrente)	Débito Automático	Compensado	Banco A	CP005
2006	2025-09-04	10:00:00	Saída	-8000.00	Campanha de Marketing Digital	Marketing	Banco A (Corrente)	Boleto	Compensado	Agência Digital	CP006
2007	2025-09-04	14:00:00	Entrada	600.00	Renda de Aluguéis Imóvel 1	Renda Extra	Banco B (Poupança)	TED	Compensado	Inquilino A	CP007
2008	2025-09-05	10:30:00	Saída	-3500.00	Aluguel do Escritório	Contas Fixas	Banco A (Corrente)	Boleto	Compensado	Locadora Imóveis	CP008
2009	2025-09-05	14:00:00	Entrada	3500.00	Venda Lote 2	Vendas	Banco A (Corrente)	PIX	Compensado	Cliente Gamma	CR009
2010	2025-09-06	15:20:00	Saída	-150.00	Manutenção de Computadores	Despesas Operacionais	Caixa	Dinheiro	Compensado	Técnico Info	CP010
2011	2025-09-08	09:00:00	Entrada	7500.00	Venda Lote 3 (Grande)	Vendas	Banco A (Corrente)	TED	Compensado	Cliente Delta	CR011
2012	2025-09-08	11:45:00	Saída	-200.00	Combustível para Entrega	Logística	Cartão Crédito	Cartão Crédito	Compensado	Posto Ipiranga	CP012
2013	2025-09-09	13:00:00	Entrada	4200.00	Venda Lote 4	Vendas	Banco A (Corrente)	PIX	Compensado	Cliente Alfa	CP013
2014	2025-09-10	16:50:00	Saída	-1200.00	Serviço de Limpeza	Despesas Operacionais	Banco A (Corrente)	TED	Compensado	Empresa Limpeza	CP014
2015	2025-09-11	10:00:00	Entrada	900.00	Venda de Acessórios	Vendas	Caixa	Dinheiro	Compensado	Cliente Eta	CP015
2016	2025-09-11	17:15:00	Saída	-40000.00	Compra de Matéria-Prima	Fornecedores	Banco A (Corrente)	TED	Compensado	Fornecedor Kappa	CP016
2017	2025-09-12	14:20:00	Entrada	500.00	Reembolso de Despesa de Viagem	Renda Extra	Banco B (Poupança)	PIX	Compensado	Sócio Alfa	CR017
2018	2025-09-13	09:30:00	Saída	-180.00	Mensalidade de Internet	Contas Fixas	Banco A (Corrente)	Débito Automático	Compensado	Provedor NET	CP018
2019	2025-09-15	16:00:00	Entrada	15000.00	Venda Lote 5 (Muito Grande)	Vendas	Banco A (Corrente)	TED	Compensado	Cliente Beta	CP019
2020	2025-09-16	12:00:00	Saída	-1500.00	Serviço de Contabilidade	Despesas Operacionais	Banco A (Corrente)	Boleto	Compensado	Contador XPTO	CR020
2021	2025-09-17	14:00:00	Entrada	2200.00	Venda Lote 6	Vendas	Banco A (Corrente)	PIX	Compensado	Cliente Zeta	CP021
2022	2025-09-17	18:00:00	Saída	-150.00	Material de Copa	Despesas Operacionais	Caixa	Dinheiro	Compensado	Supermercado Local	CP022
2023	2025-09-18	11:00:00	Entrada	800.00	Venda de Conserto	Prestação de Serviços	Banco A (Corrente)	PIX	Compensado	Cliente Theta	CR023
2024	2025-09-18	16:00:00	Saída	-500.00	Licença de Software Mensal	Contas Fixas	Cartão Crédito	Cartão Crédito	Compensado	Software Service	CP024
2025	2025-09-19	10:00:00	Saída	-3000.00	Pagamento Parcial Fornecedor Beta	Fornecedores	Banco A (Corrente)	TED	Compensado	Fornecedor Beta	CP025
2026	2025-09-20	14:00:00	Entrada	6500.00	Venda Lote 7 (Fechamento)	Vendas	Banco A (Corrente)	TED	Compensado	Cliente Iota	CP026
2027	2025-09-21	10:00:00	Saída	-250.00	Jantar de Negócios	Despesas Operacionais	Cartão Crédito	Cartão Crédito	Pendente	Restaurante A	CR027
2028	2025-09-22	12:00:00	Entrada	1200.00	Renda de Aluguéis Imóvel 2	Renda Extra	Banco B (Poupança)	TED	Compensado	Inquilino B	CP028
2029	2025-09-22	15:30:00	Saída	-18000.00	Salários (Final do Mês)	Folha de Pagamento	Banco A (Corrente)	TED	Compensado	RH - Funcionários	CP029
2030	2025-09-23	09:00:00	Saída	-1000.00	Seguro Mensal	Contas Fixas	Banco A (Corrente)	Débito Automático	Compensado	Seguradora X	CP030
2031	2025-09-24	14:00:00	Entrada	3800.00	Venda Lote 8	Vendas	Banco A (Corrente)	Boleto	Pendente	Cliente Kappa	CR031
2032	2025-09-25	11:00:00	Saída	-450.00	Manutenção de Equipamento	Despesas Operacionais	Caixa	Dinheiro	Compensado	Oficina Geral	CP032
2033	2025-09-26	16:00:00	Entrada	250.00	Venda Avulsa	Vendas	Caixa	PIX	Compensado	Cliente Lambda	CP033
2034	2025-09-29	09:20:00	Saída	-5000.00	Pagamento de Impostos	Contas Fixas	Banco A (Corrente)	Boleto	Compensado	Receita Federal	CP034
2407	2026-08-30	16:00:00	Entrada	400.00	Venda Avulsa	Vendas	Caixa	PIX	Compensado	Cliente Y	CP022
2035	2025-09-30	15:00:00	Entrada	8500.00	Venda Lote 9 (Fechamento)	Vendas	Banco A (Corrente)	TED	Compensado	Cliente Mu	CP035
2036	2025-10-01	11:30:00	Entrada	5800.00	Venda Lote 14	Vendas	Banco A (Corrente)	PIX	Compensado	Cliente Alfa	CR036
2037	2025-10-02	09:15:00	Saída	-350.00	Material de Higiene	Despesas Operacionais	Caixa	Dinheiro	Compensado	Supermercado Local	CP037
2038	2025-10-03	09:40:00	Saída	-1500.00	Material de Embalagem	Fornecedores	Banco A (Corrente)	Boleto	Compensado	Fornecedor Beta	CP038
2039	2025-10-04	16:55:00	Entrada	2100.00	Prestação de Serviço (Treinamento)	Prestação de Serviços	Banco B (Poupança)	TED	Compensado	Empresa Serviços Z	CP039
2040	2025-10-05	14:00:00	Saída	-3500.00	Aluguel do Escritório	Contas Fixas	Banco A (Corrente)	Boleto	Compensado	Locadora Imóveis	CR040
2041	2025-10-06	09:10:00	Entrada	4500.00	Venda Lote 15	Vendas	Banco A (Corrente)	PIX	Compensado	Cliente Gamma	CP041
2042	2025-10-07	17:30:00	Saída	-4000.00	Compra de Software	Despesas Operacionais	Banco A (Corrente)	Boleto	Compensado	Fornecedor de TI	CP042
2043	2025-10-08	10:00:00	Saída	-500.00	Doação Institucional	Despesas Operacionais	Banco A (Corrente)	TED	Compensado	Instituição ABC	CP043
2044	2025-10-09	12:00:00	Entrada	1500.00	Reembolso de Despesas	Renda Extra	Banco B (Poupança)	PIX	Compensado	Sócio João	CR044
2045	2025-10-10	14:30:00	Saída	-120.00	Compra de Café/Almoço	Despesas Operacionais	Caixa	Dinheiro	Compensado	Padaria Central	CP045
2046	2025-10-13	11:10:00	Entrada	1800.00	Venda Lote 16	Vendas	Banco A (Corrente)	PIX	Compensado	Cliente Epsilon	CP046
2047	2025-10-14	13:00:00	Saída	-7500.00	Pagamento Parcial Fornecedor Principal	Fornecedores	Banco A (Corrente)	TED	Compensado	Fornecedor Delta	CP047
2048	2025-10-15	17:00:00	Entrada	9000.00	Venda Lote 17 (Grande)	Vendas	Banco A (Corrente)	Boleto	Compensado	Cliente Alfa	CR048
2049	2025-10-16	09:00:00	Saída	-250.00	Reparo de Vazamento	Manutenção	Caixa	Dinheiro	Compensado	Encanador Z	CP049
2050	2025-10-17	14:00:00	Entrada	3000.00	Venda Lote 18	Vendas	Banco A (Corrente)	PIX	Compensado	Cliente Zeta	CP050
2051	2025-10-20	11:30:00	Saída	-50.00	Taxa de Saque	Contas Fixas	Banco B (Poupança)	Saque	Compensado	Banco B	CP051
2052	2025-10-21	18:05:00	Saída	-15000.00	Salários (Parte Final)	Folha de Pagamento	Banco A (Corrente)	TED	Compensado	RH - Funcionários	CR052
2053	2025-10-22	10:00:00	Entrada	600.00	Renda de Aluguéis Imóvel 2	Renda Extra	Banco B (Poupança)	TED	Compensado	Inquilino B	CP053
2054	2025-10-23	13:45:00	Saída	-4500.00	Pagamento de Impostos (Complemento)	Contas Fixas	Banco A (Corrente)	Boleto	Compensado	Receita Federal	CP054
2055	2025-10-24	16:00:00	Entrada	10000.00	Venda Lote 19 (Fechamento)	Vendas	Banco A (Corrente)	TED	Compensado	Cliente Alpha	CP055
2056	2025-10-25	10:00:00	Saída	-180.00	Telefonia Mensal	Contas Fixas	Banco A (Corrente)	Débito Automático	Compensado	VIVO	CR001
2057	2025-10-26	14:00:00	Entrada	2500.00	Venda Lote 14 - Parcela 1	Vendas	Banco A (Corrente)	Boleto	Compensado	Cliente F	CP001
2058	2025-10-27	10:00:00	Saída	-600.00	Assinatura Adobe	Despesas Operacionais	Cartão Crédito	Cartão Crédito	Compensado	Adobe	CP002
2059	2025-10-27	16:00:00	Entrada	350.00	Venda Avulsa (Caixa)	Vendas	Caixa	Dinheiro	Compensado	Cliente G	CR003
2060	2025-10-28	11:00:00	Saída	-50.00	Estacionamento	Despesas Operacionais	Caixa	Dinheiro	Compensado	Estacionamento H	CP005
2061	2025-10-28	15:00:00	Entrada	4200.00	Fatura de Serviço	Prestação de Serviços	Banco A (Corrente)	TED	Compensado	Empresa K	CP006
2062	2025-10-29	09:00:00	Saída	-800.00	Manutenção Predial	Manutenção	Banco A (Corrente)	PIX	Compensado	Serviço L	CP007
2063	2025-10-29	13:00:00	Entrada	750.00	Comissão Recebida	Renda Extra	Banco B (Poupança)	PIX	Compensado	Parceiro M	CP008
2064	2025-10-30	14:00:00	Saída	-2000.00	Consultoria Jurídica	Despesas Operacionais	Banco A (Corrente)	Boleto	Compensado	Advogados N	CR009
2065	2025-10-30	16:00:00	Entrada	300.00	Reembolso de Taxa	Renda Extra	Banco A (Corrente)	PIX	Compensado	Banco A	CP010
2066	2025-10-31	10:00:00	Saída	-50.00	Despesa Cartório	Despesas Operacionais	Caixa	Dinheiro	Compensado	Cartório O	CR011
2067	2025-10-31	12:00:00	Entrada	1500.00	Venda Avulsa de Produto	Vendas	Caixa	Dinheiro	Compensado	Cliente P	CP012
2068	2025-10-18	12:30:00	Entrada	500.00	Reembolso de Combustível	Renda Extra	Caixa	Dinheiro	Compensado	Funcionário X	CP013
2069	2025-10-19	14:30:00	Saída	-150.00	Almoço Executivo	Despesas Operacionais	Cartão Crédito	Cartão Crédito	Compensado	Restaurante C	CP014
2070	2025-10-25	12:00:00	Saída	-1200.00	Licença Anual de Antivírus	Despesas Operacionais	Banco A (Corrente)	Boleto	Compensado	Fornecedor de TI	CP015
2071	2025-11-03	10:00:00	Saída	-35000.00	Compra de Estoque (Grande)	Fornecedores	Banco A (Corrente)	TED	Compensado	Fornecedor Delta	CP016
2072	2025-11-04	14:00:00	Entrada	4500.00	Venda Lote 20	Vendas	Banco A (Corrente)	PIX	Compensado	Cliente Alfa	CR017
2073	2025-11-05	10:30:00	Saída	-3500.00	Aluguel do Escritório	Contas Fixas	Banco A (Corrente)	Boleto	Compensado	Locadora Imóveis	CP018
2074	2025-11-05	11:00:00	Saída	-850.00	Mensalidade de Software ERP	Despesas Operacionais	Banco A (Corrente)	Boleto	Compensado	Fornecedor de TI	CP019
2075	2025-11-06	15:00:00	Saída	-150.00	Material de Copa	Despesas Operacionais	Caixa	Dinheiro	Compensado	Supermercado Local	CR020
2076	2025-11-07	11:00:00	Entrada	2800.00	Venda Lote 21	Vendas	Banco A (Corrente)	TED	Compensado	Cliente P	CP021
2077	2025-11-10	13:00:00	Saída	-18000.00	Compra de Matéria-Prima (Pedido 55)	Fornecedores	Banco A (Corrente)	TED	Compensado	Fornecedor Delta	CP022
2078	2025-11-12	10:00:00	Entrada	1500.00	Venda Avulsa	Vendas	Caixa	PIX	Compensado	Cliente Q	CR023
2079	2025-11-14	16:00:00	Saída	-300.00	Taxa de Manutenção	Contas Fixas	Banco A (Corrente)	Débito Automático	Compensado	Banco A	CP024
2080	2025-11-15	14:00:00	Entrada	9500.00	Fatura de Venda Lote 25	Vendas	Banco A (Corrente)	TED	Compensado	Cliente Tau	CP025
2081	2025-11-17	11:00:00	Saída	-120.00	Combustível	Logística	Cartão Crédito	Cartão Crédito	Compensado	Posto R	CP026
2082	2025-11-18	10:00:00	Entrada	600.00	Renda de Aluguéis Imóvel 1	Renda Extra	Banco B (Poupança)	TED	Compensado	Inquilino A	CR027
2083	2025-11-19	11:15:00	Saída	-8000.00	Campanha de Marketing (Black Friday)	Marketing	Banco A (Corrente)	TED	Compensado	Agência Digital	CP028
2084	2025-11-20	15:30:00	Saída	-23000.00	Salários (Novembro)	Folha de Pagamento	Banco A (Corrente)	TED	Compensado	RH - Funcionários	CP029
2085	2025-11-21	14:00:00	Entrada	3200.00	Venda Lote 26	Vendas	Banco A (Corrente)	PIX	Compensado	Cliente S	CP030
2086	2025-11-22	10:00:00	Saída	-400.00	Material de Embalagem	Fornecedores	Caixa	Dinheiro	Compensado	Fornecedor U	CR031
2087	2025-11-24	16:00:00	Entrada	3500.00	Pagamento de Serviços Recorrentes	Serviços Recorrentes	Banco A (Corrente)	TED	Compensado	Empresa Serviços Z	CP032
2088	2025-11-25	11:00:00	Saída	-500.00	Licença de Software Mensal	Contas Fixas	Cartão Crédito	Cartão Crédito	Compensado	Software Service	CP033
2089	2025-11-26	09:00:00	Entrada	7000.00	Venda Lote 27	Vendas	Banco A (Corrente)	Boleto	Compensado	Cliente V	CP034
2090	2025-11-27	13:00:00	Saída	-2500.00	Consultoria Financeira	Despesas Operacionais	Banco A (Corrente)	TED	Compensado	Consultor W	CP035
2091	2025-11-28	15:00:00	Entrada	12000.00	Venda Black Friday (Alta)	Vendas	Banco A (Corrente)	PIX	Compensado	Cliente Sigma	CR036
2092	2025-11-29	09:20:00	Saída	-5200.00	Pagamento de Impostos (Novembro)	Contas Fixas	Banco A (Corrente)	Boleto	Compensado	Receita Federal	CP037
2093	2025-11-30	16:00:00	Entrada	450.00	Venda Avulsa (Caixa)	Vendas	Caixa	Dinheiro	Compensado	Cliente X	CP038
2094	2025-11-01	12:00:00	Entrada	1500.00	Renda de Aluguéis Imóvel 2	Renda Extra	Banco B (Poupança)	TED	Compensado	Inquilino B	CP039
2095	2025-11-02	14:30:00	Saída	-200.00	Passagens de Ônibus	Logística	Caixa	Dinheiro	Compensado	Viação Y	CR040
2096	2025-11-08	16:00:00	Entrada	900.00	Venda de Reparo	Prestação de Serviços	Banco A (Corrente)	PIX	Compensado	Cliente Z	CP041
2097	2025-11-10	09:00:00	Saída	-40.00	Tarifa de Extrato	Contas Fixas	Banco A (Corrente)	Débito Automático	Compensado	Banco A	CP042
2098	2025-11-11	15:00:00	Entrada	5000.00	Adiantamento de Cliente	Vendas	Banco A (Corrente)	TED	Compensado	Cliente Delta	CP043
2099	2025-11-16	12:30:00	Saída	-100.00	Almoço de Equipe	Despesas Operacionais	Cartão Crédito	Cartão Crédito	Compensado	Restaurante D	CR044
2100	2025-11-23	14:00:00	Entrada	800.00	Reembolso de Despesa	Renda Extra	Caixa	Dinheiro	Compensado	Sócio Alfa	CP045
2101	2025-11-24	10:00:00	Saída	-300.00	Compra de Equipamento Pequeno	Despesas Operacionais	Caixa	Dinheiro	Compensado	Loja Elétrica	CP046
2102	2025-11-26	18:00:00	Saída	-180.00	Telefonia (Adicional)	Contas Fixas	Banco A (Corrente)	Débito Automático	Compensado	VIVO	CP047
2103	2025-11-27	10:00:00	Entrada	4500.00	Venda Lote 28	Vendas	Banco A (Corrente)	Boleto	Compensado	Cliente Mu	CR048
2104	2025-11-28	12:00:00	Saída	-50.00	Despesa com Cartório	Despesas Operacionais	Caixa	Dinheiro	Compensado	Cartório O	CP049
2105	2025-11-29	14:00:00	Entrada	1500.00	Venda de Serviço (Fechamento)	Prestação de Serviços	Banco A (Corrente)	PIX	Compensado	Empresa K	CP050
2106	2025-12-02	10:00:00	Saída	-25000.00	Compra de Estoque (Natal)	Fornecedores	Banco A (Corrente)	TED	Compensado	Fornecedor Beta	CP051
2107	2025-12-03	14:00:00	Entrada	5000.00	Venda Lote 29	Vendas	Banco A (Corrente)	PIX	Compensado	Cliente Epsilon	CR052
2108	2025-12-04	15:00:00	Saída	-150.00	Material de Limpeza	Despesas Operacionais	Caixa	Dinheiro	Compensado	Supermercado Local	CP053
2109	2025-12-05	10:30:00	Saída	-3500.00	Aluguel do Escritório	Contas Fixas	Banco A (Corrente)	Boleto	Compensado	Locadora Imóveis	CP054
2110	2025-12-05	11:00:00	Saída	-850.00	Mensalidade de Software ERP	Despesas Operacionais	Banco A (Corrente)	Boleto	Compensado	Fornecedor de TI	CP055
2111	2025-12-06	12:00:00	Entrada	1200.00	Venda de Produto Especial	Vendas	Caixa	Dinheiro	Compensado	Cliente Epsilon	CR001
2112	2025-12-08	09:00:00	Saída	-40.00	Tarifa de Extrato	Contas Fixas	Banco A (Corrente)	Débito Automático	Compensado	Banco A	CP001
2113	2025-12-09	14:00:00	Entrada	6000.00	Venda Lote 30	Vendas	Banco A (Corrente)	TED	Compensado	Cliente Lambda	CP002
2114	2025-12-10	10:00:00	Entrada	1800.00	Renda de Aluguéis Imóvel 1	Renda Extra	Banco B (Poupança)	TED	Compensado	Inquilino A	CR003
2115	2025-12-11	13:00:00	Saída	-150.00	Jantar de Negócios	Despesas Operacionais	Cartão Crédito	Cartão Crédito	Compensado	Restaurante E	CP005
2116	2025-12-12	16:00:00	Entrada	8500.00	Venda Lote 31	Vendas	Banco A (Corrente)	PIX	Compensado	Cliente Gamma	CP006
2117	2025-12-15	14:00:00	Saída	-10000.00	Pagamento Fornecedor Alpha	Fornecedores	Banco A (Corrente)	TED	Compensado	Fornecedor Kappa	CP007
2118	2025-12-16	10:00:00	Entrada	3500.00	Pagamento de Serviços Recorrentes	Serviços Recorrentes	Banco A (Corrente)	TED	Compensado	Empresa Serviços Z	CP008
2119	2025-12-17	18:00:00	Saída	-450.00	Contas de Consumo (Água/Luz)	Contas Fixas	Banco A (Corrente)	Débito Automático	Compensado	Concessionária A	CR009
2120	2025-12-18	11:00:00	Entrada	4200.00	Venda Lote 32	Vendas	Banco A (Corrente)	Boleto	Compensado	Cliente Mu	CP010
2121	2025-12-19	15:30:00	Saída	-15000.00	13º Salário (Provisão)	Folha de Pagamento	Banco A (Corrente)	TED	Compensado	RH - Funcionários	CR011
2122	2025-12-20	15:30:00	Saída	-23000.00	Salários (Dezembro)	Folha de Pagamento	Banco A (Corrente)	TED	Compensado	RH - Funcionários	CP012
2123	2025-12-21	10:00:00	Entrada	900.00	Venda de Reparo	Prestação de Serviços	Caixa	Dinheiro	Compensado	Cliente Z	CP013
2124	2025-12-22	14:00:00	Saída	-2500.00	Consultoria de Fim de Ano	Despesas Operacionais	Banco A (Corrente)	Boleto	Compensado	Consultor F	CP014
2125	2025-12-23	16:00:00	Entrada	7500.00	Venda Lote 33 (Última do Ano)	Vendas	Banco A (Corrente)	TED	Compensado	Cliente Delta	CP015
2126	2025-12-24	11:00:00	Saída	-120.00	Compra de Brindes	Marketing	Caixa	Dinheiro	Compensado	Loja de Presentes	CP016
2127	2025-12-26	14:00:00	Entrada	600.00	Renda de Aluguéis Imóvel 2	Renda Extra	Banco B (Poupança)	TED	Compensado	Inquilino B	CR017
2128	2025-12-27	10:00:00	Saída	-500.00	Licença de Software Mensal	Contas Fixas	Cartão Crédito	Cartão Crédito	Compensado	Software Service	CP018
2129	2025-12-28	16:00:00	Entrada	300.00	Venda Avulsa	Vendas	Caixa	PIX	Compensado	Cliente X	CP019
2130	2025-12-29	09:20:00	Saída	-6000.00	Impostos Mensais (IRPJ/CSLL)	Contas Fixas	Banco A (Corrente)	Boleto	Compensado	Receita Federal	CR020
2131	2025-12-30	14:00:00	Entrada	1500.00	Venda de Consultoria	Prestação de Serviços	Banco A (Corrente)	TED	Compensado	Empresa K	CP021
2132	2025-12-01	12:00:00	Entrada	700.00	Venda Lote 28 - Parcela 2	Vendas	Banco A (Corrente)	Boleto	Compensado	Cliente Mu	CP022
2133	2025-12-04	09:00:00	Saída	-180.00	Mensalidade de Internet	Contas Fixas	Banco A (Corrente)	Débito Automático	Compensado	Provedor NET	CR023
2134	2025-12-07	14:30:00	Saída	-200.00	Combustível (Viagem)	Logística	Cartão Crédito	Cartão Crédito	Compensado	Posto H	CP024
2135	2025-12-10	16:00:00	Saída	-1200.00	Serviço de Limpeza (Fim de Ano)	Despesas Operacionais	Banco A (Corrente)	TED	Compensado	Empresa Limpeza	CP025
2136	2025-12-13	10:00:00	Entrada	3000.00	Venda Lote 34	Vendas	Banco A (Corrente)	PIX	Compensado	Cliente Tau	CP026
2137	2025-12-16	12:30:00	Saída	-50.00	Estacionamento (Shopping)	Despesas Operacionais	Caixa	Dinheiro	Compensado	Shopping Y	CR027
2138	2025-12-19	10:00:00	Entrada	800.00	Reembolso de Despesa	Renda Extra	Banco B (Poupança)	PIX	Compensado	Sócio Alfa	CP028
2139	2025-12-25	14:00:00	Entrada	1500.00	Venda Online	Vendas	Banco A (Corrente)	PIX	Pendente	Cliente W	CP029
2140	2025-12-28	11:00:00	Saída	-300.00	Taxa Bancária (Extra)	Contas Fixas	Banco A (Corrente)	Débito Automático	Compensado	Banco A	CP030
2141	2026-01-02	10:00:00	Saída	-20000.00	Compra de Estoque (Reabastecimento)	Fornecedores	Banco A (Corrente)	TED	Compensado	Fornecedor Delta	CR031
2142	2026-01-03	14:00:00	Entrada	5500.00	Venda Lote 35	Vendas	Banco A (Corrente)	PIX	Compensado	Cliente Gama	CP032
2143	2026-01-05	10:30:00	Saída	-3500.00	Aluguel do Escritório	Contas Fixas	Banco A (Corrente)	Boleto	Compensado	Locadora Imóveis	CP033
2144	2026-01-05	11:00:00	Saída	-850.00	Mensalidade de Software ERP (Jan)	Despesas Operacionais	Banco A (Corrente)	Boleto	Compensado	Fornecedor de TI	CP034
2145	2026-01-06	15:00:00	Saída	-150.00	Material de Copa	Despesas Operacionais	Caixa	Dinheiro	Compensado	Supermercado Local	CP035
2146	2026-01-07	11:00:00	Entrada	7500.00	Venda Lote 27 (Fatura)	Vendas	Banco A (Corrente)	TED	Compensado	Cliente Gama	CR036
2147	2026-01-08	13:00:00	Saída	-500.00	Licença de Software Mensal	Contas Fixas	Cartão Crédito	Cartão Crédito	Compensado	Software Service	CP037
2148	2026-01-09	10:00:00	Entrada	1800.00	Renda de Aluguéis Imóvel 1	Renda Extra	Banco B (Poupança)	TED	Compensado	Inquilino A	CP038
2149	2026-01-10	16:00:00	Saída	-21000.00	Compra de Matéria-Prima (Pedido 56)	Fornecedores	Banco A (Corrente)	TED	Compensado	Fornecedor Delta	CP039
2150	2026-01-12	14:00:00	Entrada	3500.00	Venda Lote 36	Vendas	Banco A (Corrente)	PIX	Compensado	Cliente Sigma	CR040
2151	2026-01-14	11:00:00	Saída	-120.00	Combustível	Logística	Cartão Crédito	Cartão Crédito	Compensado	Posto R	CP041
2152	2026-01-15	14:00:00	Entrada	2800.00	Venda Lote 37	Vendas	Banco A (Corrente)	TED	Compensado	Cliente P	CP042
2153	2026-01-16	16:00:00	Saída	-500.00	Contas de Consumo (Jan)	Contas Fixas	Banco A (Corrente)	Débito Automático	Compensado	Concessionária A	CP043
2154	2026-01-17	10:00:00	Entrada	900.00	Reembolso de Despesa	Renda Extra	Caixa	Dinheiro	Compensado	Sócio João	CR044
2155	2026-01-20	15:30:00	Saída	-24000.00	Salários (Janeiro)	Folha de Pagamento	Banco A (Corrente)	TED	Compensado	RH - Funcionários	CP045
2156	2026-01-21	14:00:00	Entrada	3500.00	Pagamento de Serviços de Janeiro	Serviços Recorrentes	Banco A (Corrente)	TED	Compensado	Empresa Serviços Z	CP046
2157	2026-01-22	10:00:00	Saída	-400.00	Manutenção de Equipamento	Despesas Operacionais	Caixa	Dinheiro	Compensado	Oficina Geral	CP047
2158	2026-01-23	16:00:00	Entrada	4800.00	Venda Lote 38	Vendas	Banco A (Corrente)	PIX	Compensado	Cliente Omicron	CR048
2159	2026-01-26	11:00:00	Saída	-6500.00	Impostos Mensais (Jan)	Contas Fixas	Banco A (Corrente)	Boleto	Compensado	Receita Federal	CP049
2160	2026-01-27	14:00:00	Entrada	1500.00	Venda de Consultoria	Prestação de Serviços	Banco A (Corrente)	TED	Compensado	Empresa K	CP050
2161	2026-01-28	14:00:00	Saída	-15000.00	Renovação de Contrato Anual TI	Despesas Operacionais	Banco A (Corrente)	TED	Compensado	Fornecedor de TI	CP051
2162	2026-01-29	10:00:00	Entrada	9500.00	Venda Lote 39	Vendas	Banco A (Corrente)	Boleto	Compensado	Cliente Tau	CR052
2163	2026-01-30	12:00:00	Saída	-50.00	Despesa Cartório	Despesas Operacionais	Caixa	Dinheiro	Compensado	Cartório O	CP053
2164	2026-01-31	16:00:00	Entrada	400.00	Venda Avulsa	Vendas	Caixa	PIX	Compensado	Cliente Y	CP054
2165	2026-01-01	12:00:00	Entrada	600.00	Renda de Aluguéis Imóvel 2	Renda Extra	Banco B (Poupança)	TED	Compensado	Inquilino B	CP055
2166	2026-01-04	14:30:00	Saída	-200.00	Passagens de Ônibus	Logística	Caixa	Dinheiro	Compensado	Viação Y	CR001
2167	2026-01-07	18:00:00	Saída	-180.00	Telefonia Mensal	Contas Fixas	Banco A (Corrente)	Débito Automático	Compensado	VIVO	CP001
2168	2026-01-13	10:00:00	Saída	-40.00	Tarifa de Extrato	Contas Fixas	Banco A (Corrente)	Débito Automático	Compensado	Banco A	CP002
2169	2026-01-18	12:30:00	Saída	-100.00	Almoço de Equipe	Despesas Operacionais	Cartão Crédito	Cartão Crédito	Compensado	Restaurante D	CR003
2170	2026-01-20	10:00:00	Entrada	5000.00	Adiantamento de Cliente	Vendas	Banco A (Corrente)	TED	Compensado	Cliente Delta	CP005
2171	2026-01-24	14:00:00	Entrada	800.00	Reembolso de Despesa	Renda Extra	Caixa	Dinheiro	Compensado	Sócio Alfa	CP006
2172	2026-01-25	10:00:00	Saída	-300.00	Compra de Equipamento Pequeno	Despesas Operacionais	Caixa	Dinheiro	Compensado	Loja Elétrica	CP007
2173	2026-01-26	18:00:00	Saída	-180.00	Telefonia (Adicional)	Contas Fixas	Banco A (Corrente)	Débito Automático	Compensado	VIVO	CP008
2174	2026-01-28	12:00:00	Saída	-50.00	Despesa com Cartório	Despesas Operacionais	Caixa	Dinheiro	Compensado	Cartório O	CR009
2175	2026-01-29	14:00:00	Entrada	1500.00	Venda de Serviço (Fechamento)	Prestação de Serviços	Banco A (Corrente)	PIX	Compensado	Empresa K	CP010
2176	2026-02-02	10:00:00	Saída	-15000.00	Compra de Estoque (Promoção)	Fornecedores	Banco A (Corrente)	TED	Compensado	Fornecedor Beta	CR011
2177	2026-02-03	14:00:00	Entrada	5200.00	Venda Lote 40	Vendas	Banco A (Corrente)	PIX	Compensado	Cliente Epsilon	CP012
2178	2026-02-05	10:30:00	Saída	-3500.00	Aluguel do Escritório	Contas Fixas	Banco A (Corrente)	Boleto	Compensado	Locadora Imóveis	CP013
2179	2026-02-05	11:00:00	Saída	-850.00	Mensalidade de Software ERP (Fev)	Despesas Operacionais	Banco A (Corrente)	Boleto	Compensado	Fornecedor de TI	CP014
2180	2026-02-06	15:00:00	Saída	-150.00	Material de Copa	Despesas Operacionais	Caixa	Dinheiro	Compensado	Supermercado Local	CP015
2181	2026-02-07	11:00:00	Entrada	4800.00	Venda Lote 28 (Fatura)	Vendas	Banco A (Corrente)	TED	Compensado	Cliente Omicron	CP016
2182	2026-02-08	13:00:00	Saída	-500.00	Licença de Software Mensal	Contas Fixas	Cartão Crédito	Cartão Crédito	Compensado	Software Service	CR017
2183	2026-02-09	10:00:00	Entrada	1800.00	Renda de Aluguéis Imóvel 1	Renda Extra	Banco B (Poupança)	TED	Compensado	Inquilino A	CP018
2184	2026-02-10	16:00:00	Saída	-7000.00	Marketing de Lançamento (Fev)	Marketing	Banco A (Corrente)	Boleto	Compensado	Agência Digital	CP019
2185	2026-02-12	14:00:00	Entrada	6000.00	Venda Lote 41	Vendas	Banco A (Corrente)	PIX	Compensado	Cliente Alpha	CR020
2186	2026-02-14	11:00:00	Saída	-120.00	Combustível	Logística	Cartão Crédito	Cartão Crédito	Compensado	Posto R	CP021
2187	2026-02-15	14:00:00	Entrada	11000.00	Fatura de Venda Lote 29	Vendas	Banco A (Corrente)	TED	Compensado	Cliente Tau	CP022
2188	2026-02-16	16:00:00	Saída	-480.00	Contas de Consumo (Fev)	Contas Fixas	Banco A (Corrente)	Débito Automático	Compensado	Concessionária A	CR023
2189	2026-02-17	10:00:00	Entrada	900.00	Reembolso de Despesa	Renda Extra	Caixa	Dinheiro	Compensado	Sócio João	CP024
2190	2026-02-20	15:30:00	Saída	-24500.00	Salários (Fevereiro)	Folha de Pagamento	Banco A (Corrente)	TED	Compensado	RH - Funcionários	CP025
2191	2026-02-21	14:00:00	Entrada	3500.00	Pagamento de Serviços de Fevereiro	Serviços Recorrentes	Banco A (Corrente)	TED	Compensado	Empresa Serviços Z	CP026
2192	2026-02-22	10:00:00	Saída	-400.00	Manutenção de Equipamento	Despesas Operacionais	Caixa	Dinheiro	Compensado	Oficina Geral	CR027
2193	2026-02-23	16:00:00	Entrada	7800.00	Venda Lote 42	Vendas	Banco A (Corrente)	PIX	Compensado	Cliente Beta	CP028
2194	2026-02-26	11:00:00	Saída	-6500.00	Impostos Mensais (Fev)	Contas Fixas	Banco A (Corrente)	Boleto	Compensado	Receita Federal	CP029
2195	2026-02-27	14:00:00	Entrada	1500.00	Venda de Consultoria	Prestação de Serviços	Banco A (Corrente)	TED	Compensado	Empresa K	CP030
2196	2026-02-28	12:00:00	Saída	-50.00	Despesa Cartório	Despesas Operacionais	Caixa	Dinheiro	Compensado	Cartório O	CR031
2349	2026-06-28	14:00:00	Entrada	400.00	Venda Avulsa	Vendas	Caixa	PIX	Compensado	Cliente Y	CP019
2197	2026-02-01	12:00:00	Entrada	600.00	Renda de Aluguéis Imóvel 2	Renda Extra	Banco B (Poupança)	TED	Compensado	Inquilino B	CP032
2198	2026-02-04	14:30:00	Saída	-200.00	Passagens de Ônibus	Logística	Caixa	Dinheiro	Compensado	Viação Y	CP033
2199	2026-02-07	18:00:00	Saída	-180.00	Telefonia Mensal	Contas Fixas	Banco A (Corrente)	Débito Automático	Compensado	VIVO	CP034
2200	2026-02-10	09:00:00	Saída	-40.00	Tarifa de Extrato	Contas Fixas	Banco A (Corrente)	Débito Automático	Compensado	Banco A	CP035
2201	2026-02-13	15:00:00	Entrada	5000.00	Adiantamento de Cliente	Vendas	Banco A (Corrente)	TED	Compensado	Cliente Delta	CR036
2202	2026-02-18	12:30:00	Saída	-100.00	Almoço de Equipe	Despesas Operacionais	Cartão Crédito	Cartão Crédito	Compensado	Restaurante D	CP037
2203	2026-02-20	10:00:00	Entrada	800.00	Reembolso de Despesa	Renda Extra	Caixa	Dinheiro	Compensado	Sócio Alfa	CP038
2204	2026-02-24	14:00:00	Entrada	4500.00	Venda Lote 43	Vendas	Banco A (Corrente)	Boleto	Compensado	Cliente Mu	CP039
2205	2026-02-25	10:00:00	Saída	-300.00	Compra de Equipamento Pequeno	Despesas Operacionais	Caixa	Dinheiro	Compensado	Loja Elétrica	CR040
2206	2026-02-26	18:00:00	Saída	-180.00	Telefonia (Adicional)	Contas Fixas	Banco A (Corrente)	Débito Automático	Compensado	VIVO	CP041
2207	2026-02-27	10:00:00	Entrada	2500.00	Venda Lote 44	Vendas	Banco A (Corrente)	PIX	Compensado	Cliente Gama	CP042
2208	2026-02-28	14:00:00	Entrada	400.00	Venda Avulsa	Vendas	Caixa	PIX	Compensado	Cliente Y	CP043
2209	2026-02-23	11:00:00	Saída	-50.00	Taxa de Saque	Contas Fixas	Banco B (Poupança)	Saque	Compensado	Banco B	CR044
2210	2026-02-24	12:00:00	Saída	-1200.00	Serviço de Limpeza (Fev)	Despesas Operacionais	Banco A (Corrente)	TED	Compensado	Empresa Limpeza	CP045
2211	2026-03-02	10:00:00	Saída	-30000.00	Compra de Estoque (Renovação)	Fornecedores	Banco A (Corrente)	TED	Compensado	Fornecedor Kappa	CP046
2212	2026-03-03	14:00:00	Entrada	6500.00	Venda Lote 45	Vendas	Banco A (Corrente)	PIX	Compensado	Cliente Mu	CP047
2213	2026-03-05	10:30:00	Saída	-3500.00	Aluguel do Escritório	Contas Fixas	Banco A (Corrente)	Boleto	Compensado	Locadora Imóveis	CR048
2214	2026-03-05	11:00:00	Saída	-850.00	Mensalidade de Software ERP (Mar)	Despesas Operacionais	Banco A (Corrente)	Boleto	Compensado	Fornecedor de TI	CP049
2215	2026-03-06	15:00:00	Saída	-150.00	Material de Copa	Despesas Operacionais	Caixa	Dinheiro	Compensado	Supermercado Local	CP050
2216	2026-03-07	11:00:00	Entrada	8800.00	Fatura de Venda Lote 31	Vendas	Banco A (Corrente)	TED	Compensado	Cliente Mu	CP051
2217	2026-03-08	13:00:00	Saída	-500.00	Licença de Software Mensal	Contas Fixas	Cartão Crédito	Cartão Crédito	Compensado	Software Service	CR052
2218	2026-03-09	10:00:00	Entrada	1800.00	Renda de Aluguéis Imóvel 1	Renda Extra	Banco B (Poupança)	TED	Compensado	Inquilino A	CP053
2219	2026-03-10	16:00:00	Saída	-19000.00	Compra de Estoque (Mar)	Fornecedores	Banco A (Corrente)	TED	Compensado	Fornecedor Kappa	CP054
2220	2026-03-12	14:00:00	Entrada	4500.00	Venda Lote 46	Vendas	Banco A (Corrente)	PIX	Compensado	Cliente Delta	CP055
2221	2026-03-14	11:00:00	Saída	-120.00	Combustível	Logística	Cartão Crédito	Cartão Crédito	Compensado	Posto R	CR001
2222	2026-03-15	14:00:00	Entrada	9500.00	Venda Lote 35 (Fatura)	Vendas	Banco A (Corrente)	TED	Compensado	Cliente Delta	CP001
2223	2026-03-16	16:00:00	Saída	-500.00	Contas de Consumo (Mar)	Contas Fixas	Banco A (Corrente)	Débito Automático	Compensado	Concessionária A	CP002
2224	2026-03-17	10:00:00	Entrada	900.00	Reembolso de Despesa	Renda Extra	Caixa	Dinheiro	Compensado	Sócio João	CR003
2225	2026-03-20	15:30:00	Saída	-24500.00	Salários (Março)	Folha de Pagamento	Banco A (Corrente)	TED	Compensado	RH - Funcionários	CP005
2226	2026-03-21	14:00:00	Entrada	3500.00	Pagamento de Serviços de Março	Serviços Recorrentes	Banco A (Corrente)	TED	Compensado	Empresa Serviços Z	CP006
2227	2026-03-22	10:00:00	Saída	-400.00	Manutenção de Equipamento	Despesas Operacionais	Caixa	Dinheiro	Compensado	Oficina Geral	CP007
2228	2026-03-23	16:00:00	Entrada	5500.00	Venda Lote 47	Vendas	Banco A (Corrente)	PIX	Compensado	Cliente Zeta	CP008
2229	2026-03-26	11:00:00	Saída	-6500.00	Impostos Mensais (Mar)	Contas Fixas	Banco A (Corrente)	Boleto	Compensado	Receita Federal	CR009
2230	2026-03-27	14:00:00	Entrada	1500.00	Venda de Consultoria	Prestação de Serviços	Banco A (Corrente)	TED	Compensado	Empresa K	CP010
2231	2026-03-28	12:00:00	Saída	-50.00	Despesa Cartório	Despesas Operacionais	Caixa	Dinheiro	Compensado	Cartório O	CR011
2232	2026-03-30	16:00:00	Entrada	400.00	Venda Avulsa	Vendas	Caixa	PIX	Compensado	Cliente Y	CP012
2233	2026-03-01	12:00:00	Entrada	600.00	Renda de Aluguéis Imóvel 2	Renda Extra	Banco B (Poupança)	TED	Compensado	Inquilino B	CP013
2234	2026-03-04	14:30:00	Saída	-200.00	Passagens de Ônibus	Logística	Caixa	Dinheiro	Compensado	Viação Y	CP014
2235	2026-03-07	18:00:00	Saída	-180.00	Telefonia Mensal	Contas Fixas	Banco A (Corrente)	Débito Automático	Compensado	VIVO	CP015
2236	2026-03-10	09:00:00	Saída	-40.00	Tarifa de Extrato	Contas Fixas	Banco A (Corrente)	Débito Automático	Compensado	Banco A	CP016
2237	2026-03-13	15:00:00	Entrada	5000.00	Adiantamento de Cliente	Vendas	Banco A (Corrente)	TED	Compensado	Cliente Delta	CR017
2238	2026-03-18	12:30:00	Saída	-100.00	Almoço de Equipe	Despesas Operacionais	Cartão Crédito	Cartão Crédito	Compensado	Restaurante D	CP018
2239	2026-03-20	10:00:00	Entrada	800.00	Reembolso de Despesa	Renda Extra	Caixa	Dinheiro	Compensado	Sócio Alfa	CP019
2240	2026-03-24	14:00:00	Entrada	4500.00	Venda Lote 48	Vendas	Banco A (Corrente)	Boleto	Compensado	Cliente Tau	CR020
2241	2026-03-25	10:00:00	Saída	-300.00	Compra de Equipamento Pequeno	Despesas Operacionais	Caixa	Dinheiro	Compensado	Loja Elétrica	CP021
2242	2026-03-26	18:00:00	Saída	-180.00	Telefonia (Adicional)	Contas Fixas	Banco A (Corrente)	Débito Automático	Compensado	VIVO	CP022
2243	2026-03-27	10:00:00	Entrada	2500.00	Venda Lote 49	Vendas	Banco A (Corrente)	PIX	Compensado	Cliente Gama	CR023
2244	2026-03-28	14:00:00	Entrada	400.00	Venda Avulsa	Vendas	Caixa	PIX	Compensado	Cliente Y	CP024
2245	2026-03-29	11:00:00	Saída	-50.00	Taxa de Saque	Contas Fixas	Banco B (Poupança)	Saque	Compensado	Banco B	CP025
2246	2026-04-01	10:00:00	Saída	-18000.00	Compra de Estoque (Abril)	Fornecedores	Banco A (Corrente)	TED	Compensado	Fornecedor Delta	CP026
2247	2026-04-02	14:00:00	Entrada	7000.00	Venda Lote 50	Vendas	Banco A (Corrente)	PIX	Compensado	Cliente Alpha	CR027
2248	2026-04-05	10:30:00	Saída	-3500.00	Aluguel do Escritório	Contas Fixas	Banco A (Corrente)	Boleto	Compensado	Locadora Imóveis	CP028
2249	2026-04-05	11:00:00	Saída	-850.00	Mensalidade de Software ERP (Abr)	Despesas Operacionais	Banco A (Corrente)	Boleto	Compensado	Fornecedor de TI	CP029
2250	2026-04-06	15:00:00	Saída	-150.00	Material de Copa	Despesas Operacionais	Caixa	Dinheiro	Compensado	Supermercado Local	CP030
2251	2026-04-07	11:00:00	Entrada	3600.00	Pagamento de Serviços Recorrentes (Abr)	Serviços Recorrentes	Banco A (Corrente)	TED	Compensado	Empresa Serviços Z	CR031
2252	2026-04-08	13:00:00	Saída	-500.00	Licença de Software Mensal	Contas Fixas	Cartão Crédito	Cartão Crédito	Compensado	Software Service	CP032
2253	2026-04-09	10:00:00	Entrada	1800.00	Renda de Aluguéis Imóvel 1	Renda Extra	Banco B (Poupança)	TED	Compensado	Inquilino A	CP033
2254	2026-04-10	16:00:00	Saída	-1500.00	Treinamento de Equipe	Despesas Operacionais	Banco A (Corrente)	TED	Compensado	Consultor F	CP034
2255	2026-04-12	14:00:00	Entrada	5500.00	Venda Lote 51	Vendas	Banco A (Corrente)	PIX	Compensado	Cliente Sigma	CP035
2256	2026-04-14	11:00:00	Saída	-120.00	Combustível	Logística	Cartão Crédito	Cartão Crédito	Compensado	Posto R	CR036
2257	2026-04-15	14:00:00	Entrada	11000.00	Venda Lote 40 (Fatura)	Vendas	Banco A (Corrente)	TED	Compensado	Cliente Alpha	CP037
2258	2026-04-16	16:00:00	Saída	-450.00	Contas de Consumo (Abr)	Contas Fixas	Banco A (Corrente)	Débito Automático	Compensado	Concessionária A	CP038
2259	2026-04-17	10:00:00	Entrada	900.00	Reembolso de Despesa	Renda Extra	Caixa	Dinheiro	Compensado	Sócio João	CP039
2260	2026-04-20	15:30:00	Saída	-24500.00	Salários (Abril)	Folha de Pagamento	Banco A (Corrente)	TED	Compensado	RH - Funcionários	CR040
2261	2026-04-21	14:00:00	Entrada	3500.00	Venda Lote 52	Vendas	Banco A (Corrente)	TED	Compensado	Cliente Zeta	CP041
2262	2026-04-22	10:00:00	Saída	-400.00	Manutenção de Equipamento	Despesas Operacionais	Caixa	Dinheiro	Compensado	Oficina Geral	CP042
2263	2026-04-23	16:00:00	Entrada	6000.00	Venda Lote 53	Vendas	Banco A (Corrente)	PIX	Compensado	Cliente Beta	CP043
2264	2026-04-26	11:00:00	Saída	-5500.00	Impostos Trimestrais	Contas Fixas	Banco A (Corrente)	Boleto	Compensado	Receita Federal	CR044
2265	2026-04-27	14:00:00	Entrada	1500.00	Venda de Consultoria	Prestação de Serviços	Banco A (Corrente)	TED	Compensado	Empresa K	CP045
2266	2026-04-28	12:00:00	Saída	-50.00	Despesa Cartório	Despesas Operacionais	Caixa	Dinheiro	Compensado	Cartório O	CP046
2267	2026-04-30	16:00:00	Entrada	400.00	Venda Avulsa	Vendas	Caixa	PIX	Compensado	Cliente Y	CP047
2268	2026-04-01	12:00:00	Entrada	600.00	Renda de Aluguéis Imóvel 2	Renda Extra	Banco B (Poupança)	TED	Compensado	Inquilino B	CR048
2269	2026-04-04	14:30:00	Saída	-200.00	Passagens de Ônibus	Logística	Caixa	Dinheiro	Compensado	Viação Y	CP049
2270	2026-04-07	18:00:00	Saída	-180.00	Telefonia Mensal	Contas Fixas	Banco A (Corrente)	Débito Automático	Compensado	VIVO	CP050
2271	2026-04-10	09:00:00	Saída	-40.00	Tarifa de Extrato	Contas Fixas	Banco A (Corrente)	Débito Automático	Compensado	Banco A	CP051
2272	2026-04-13	15:00:00	Entrada	5000.00	Adiantamento de Cliente	Vendas	Banco A (Corrente)	TED	Compensado	Cliente Delta	CR052
2273	2026-04-18	12:30:00	Saída	-100.00	Almoço de Equipe	Despesas Operacionais	Cartão Crédito	Cartão Crédito	Compensado	Restaurante D	CP053
2274	2026-04-20	10:00:00	Entrada	800.00	Reembolso de Despesa	Renda Extra	Caixa	Dinheiro	Compensado	Sócio Alfa	CP054
2275	2026-04-24	14:00:00	Entrada	4500.00	Venda Lote 54	Vendas	Banco A (Corrente)	Boleto	Compensado	Cliente Mu	CP055
2276	2026-04-25	10:00:00	Saída	-300.00	Compra de Equipamento Pequeno	Despesas Operacionais	Caixa	Dinheiro	Compensado	Loja Elétrica	CR001
2326	2026-06-14	11:00:00	Saída	-120.00	Combustível	Logística	Cartão Crédito	Cartão Crédito	Compensado	Posto R	CP051
2277	2026-04-26	18:00:00	Saída	-180.00	Telefonia (Adicional)	Contas Fixas	Banco A (Corrente)	Débito Automático	Compensado	VIVO	CP001
2278	2026-04-27	10:00:00	Entrada	2500.00	Venda Lote 55	Vendas	Banco A (Corrente)	PIX	Compensado	Cliente Gama	CP002
2279	2026-04-28	14:00:00	Entrada	400.00	Venda Avulsa	Vendas	Caixa	PIX	Compensado	Cliente Y	CR003
2280	2026-04-29	11:00:00	Saída	-50.00	Taxa de Saque	Contas Fixas	Banco B (Poupança)	Saque	Compensado	Banco B	CP005
2281	2026-05-01	10:00:00	Saída	-15000.00	Compra de Estoque (Maio)	Fornecedores	Banco A (Corrente)	TED	Compensado	Fornecedor Beta	CP006
2282	2026-05-02	14:00:00	Entrada	5500.00	Venda Lote 38 (Fatura)	Vendas	Banco A (Corrente)	PIX	Compensado	Cliente Zeta	CP007
2283	2026-05-05	10:30:00	Saída	-3500.00	Aluguel do Escritório	Contas Fixas	Banco A (Corrente)	Boleto	Compensado	Locadora Imóveis	CP008
2284	2026-05-05	11:00:00	Saída	-850.00	Mensalidade de Software ERP (Mai)	Despesas Operacionais	Banco A (Corrente)	Boleto	Compensado	Fornecedor de TI	CR009
2285	2026-05-06	15:00:00	Saída	-150.00	Material de Copa	Despesas Operacionais	Caixa	Dinheiro	Compensado	Supermercado Local	CP010
2286	2026-05-07	11:00:00	Entrada	3600.00	Pagamento de Serviços Recorrentes (Mai)	Serviços Recorrentes	Banco A (Corrente)	TED	Compensado	Empresa Serviços Z	CR011
2287	2026-05-08	13:00:00	Saída	-500.00	Licença de Software Mensal	Contas Fixas	Cartão Crédito	Cartão Crédito	Compensado	Software Service	CP012
2288	2026-05-09	10:00:00	Entrada	1800.00	Renda de Aluguéis Imóvel 1	Renda Extra	Banco B (Poupança)	TED	Compensado	Inquilino A	CP013
2289	2026-05-10	16:00:00	Saída	-10000.00	Marketing (Meio do Ano)	Marketing	Banco A (Corrente)	TED	Compensado	Agência Digital	CP014
2290	2026-05-12	14:00:00	Entrada	7800.00	Venda Lote 45 (Fatura)	Vendas	Banco A (Corrente)	PIX	Compensado	Cliente Sigma	CP015
2291	2026-05-14	11:00:00	Saída	-120.00	Combustível	Logística	Cartão Crédito	Cartão Crédito	Compensado	Posto R	CP016
2292	2026-05-15	14:00:00	Entrada	5500.00	Venda Lote 38 (Fatura)	Vendas	Banco A (Corrente)	TED	Compensado	Cliente Zeta	CR017
2293	2026-05-16	16:00:00	Saída	-450.00	Contas de Consumo (Mai)	Contas Fixas	Banco A (Corrente)	Débito Automático	Compensado	Concessionária A	CP018
2294	2026-05-17	10:00:00	Entrada	900.00	Reembolso de Despesa	Renda Extra	Caixa	Dinheiro	Compensado	Sócio João	CP019
2295	2026-05-20	15:30:00	Saída	-24500.00	Salários (Maio)	Folha de Pagamento	Banco A (Corrente)	TED	Compensado	RH - Funcionários	CR020
2296	2026-05-21	14:00:00	Entrada	3500.00	Venda Lote 56	Vendas	Banco A (Corrente)	TED	Compensado	Cliente Mu	CP021
2297	2026-05-22	10:00:00	Saída	-400.00	Manutenção de Equipamento	Despesas Operacionais	Caixa	Dinheiro	Compensado	Oficina Geral	CP022
2298	2026-05-23	16:00:00	Entrada	6500.00	Venda Lote 57	Vendas	Banco A (Corrente)	PIX	Compensado	Cliente Gamma	CR023
2299	2026-05-26	11:00:00	Saída	-6000.00	Impostos Mensais (Mai)	Contas Fixas	Banco A (Corrente)	Boleto	Compensado	Receita Federal	CP024
2300	2026-05-27	14:00:00	Entrada	1500.00	Venda de Consultoria	Prestação de Serviços	Banco A (Corrente)	TED	Compensado	Empresa K	CP025
2301	2026-05-28	12:00:00	Saída	-50.00	Despesa Cartório	Despesas Operacionais	Caixa	Dinheiro	Compensado	Cartório O	CP026
2302	2026-05-30	16:00:00	Entrada	400.00	Venda Avulsa	Vendas	Caixa	PIX	Compensado	Cliente Y	CR027
2303	2026-05-01	12:00:00	Entrada	600.00	Renda de Aluguéis Imóvel 2	Renda Extra	Banco B (Poupança)	TED	Compensado	Inquilino B	CP028
2304	2026-05-04	14:30:00	Saída	-200.00	Passagens de Ônibus	Logística	Caixa	Dinheiro	Compensado	Viação Y	CP029
2305	2026-05-07	18:00:00	Saída	-180.00	Telefonia Mensal	Contas Fixas	Banco A (Corrente)	Débito Automático	Compensado	VIVO	CP030
2306	2026-05-10	09:00:00	Saída	-40.00	Tarifa de Extrato	Contas Fixas	Banco A (Corrente)	Débito Automático	Compensado	Banco A	CR031
2307	2026-05-13	15:00:00	Entrada	5000.00	Adiantamento de Cliente	Vendas	Banco A (Corrente)	TED	Compensado	Cliente Delta	CP032
2308	2026-05-18	12:30:00	Saída	-100.00	Almoço de Equipe	Despesas Operacionais	Cartão Crédito	Cartão Crédito	Compensado	Restaurante D	CP033
2309	2026-05-20	10:00:00	Entrada	800.00	Reembolso de Despesa	Renda Extra	Caixa	Dinheiro	Compensado	Sócio Alfa	CP034
2310	2026-05-24	14:00:00	Entrada	4500.00	Venda Lote 58	Vendas	Banco A (Corrente)	Boleto	Compensado	Cliente Tau	CP035
2311	2026-05-25	10:00:00	Saída	-300.00	Compra de Equipamento Pequeno	Despesas Operacionais	Caixa	Dinheiro	Compensado	Loja Elétrica	CR036
2312	2026-05-26	18:00:00	Saída	-180.00	Telefonia (Adicional)	Contas Fixas	Banco A (Corrente)	Débito Automático	Compensado	VIVO	CP037
2313	2026-05-27	10:00:00	Entrada	2500.00	Venda Lote 59	Vendas	Banco A (Corrente)	PIX	Compensado	Cliente Gama	CP038
2314	2026-05-28	14:00:00	Entrada	400.00	Venda Avulsa	Vendas	Caixa	PIX	Compensado	Cliente Y	CP039
2315	2026-05-29	11:00:00	Saída	-50.00	Taxa de Saque	Contas Fixas	Banco B (Poupança)	Saque	Compensado	Banco B	CR040
2316	2026-06-01	10:00:00	Saída	-25000.00	Compra de Estoque (Inverno)	Fornecedores	Banco A (Corrente)	TED	Compensado	Fornecedor Delta	CP041
2317	2026-06-02	14:00:00	Entrada	5000.00	Venda Lote 60	Vendas	Banco A (Corrente)	PIX	Compensado	Cliente Alpha	CP042
2318	2026-06-05	10:30:00	Saída	-3500.00	Aluguel do Escritório	Contas Fixas	Banco A (Corrente)	Boleto	Compensado	Locadora Imóveis	CP043
2319	2026-06-05	11:00:00	Saída	-850.00	Mensalidade de Software ERP (Jun)	Despesas Operacionais	Banco A (Corrente)	Boleto	Compensado	Fornecedor de TI	CR044
2320	2026-06-06	15:00:00	Saída	-150.00	Material de Copa	Despesas Operacionais	Caixa	Dinheiro	Compensado	Supermercado Local	CP045
2321	2026-06-07	11:00:00	Entrada	3600.00	Pagamento de Serviços Recorrentes (Jun)	Serviços Recorrentes	Banco A (Corrente)	TED	Compensado	Empresa Serviços Z	CP046
2322	2026-06-08	13:00:00	Saída	-500.00	Licença de Software Mensal	Contas Fixas	Cartão Crédito	Cartão Crédito	Compensado	Software Service	CP047
2323	2026-06-09	10:00:00	Entrada	1800.00	Renda de Aluguéis Imóvel 1	Renda Extra	Banco B (Poupança)	TED	Compensado	Inquilino A	CR048
2324	2026-06-10	16:00:00	Saída	-1500.00	Manutenção Corretiva	Manutenção	Banco A (Corrente)	TED	Compensado	Serviço L	CP049
2325	2026-06-12	14:00:00	Entrada	12500.00	Fatura de Venda Lote 42	Vendas	Banco A (Corrente)	PIX	Compensado	Cliente Lambda	CP050
2327	2026-06-15	14:00:00	Entrada	7000.00	Venda Lote 61	Vendas	Banco A (Corrente)	TED	Compensado	Cliente Gamma	CR052
2328	2026-06-16	16:00:00	Saída	-450.00	Contas de Consumo (Jun)	Contas Fixas	Banco A (Corrente)	Débito Automático	Compensado	Concessionária A	CP053
2329	2026-06-17	10:00:00	Entrada	900.00	Reembolso de Despesa	Renda Extra	Caixa	Dinheiro	Compensado	Sócio João	CP054
2330	2026-06-20	15:30:00	Saída	-24500.00	Salários (Junho)	Folha de Pagamento	Banco A (Corrente)	TED	Compensado	RH - Funcionários	CP055
2331	2026-06-21	14:00:00	Entrada	3500.00	Venda Lote 62	Vendas	Banco A (Corrente)	TED	Compensado	Cliente Zeta	CR001
2332	2026-06-22	10:00:00	Saída	-400.00	Manutenção de Equipamento	Despesas Operacionais	Caixa	Dinheiro	Compensado	Oficina Geral	CP001
2333	2026-06-23	16:00:00	Entrada	13000.00	Venda Lote 50 (Fatura)	Vendas	Banco A (Corrente)	PIX	Compensado	Cliente Beta	CP002
2334	2026-06-26	11:00:00	Saída	-6000.00	Impostos Mensais (Jun)	Contas Fixas	Banco A (Corrente)	Boleto	Compensado	Receita Federal	CR003
2335	2026-06-27	14:00:00	Entrada	1500.00	Venda de Consultoria	Prestação de Serviços	Banco A (Corrente)	TED	Compensado	Empresa K	CP005
2336	2026-06-28	12:00:00	Saída	-50.00	Despesa Cartório	Despesas Operacionais	Caixa	Dinheiro	Compensado	Cartório O	CP006
2337	2026-06-30	16:00:00	Entrada	400.00	Venda Avulsa	Vendas	Caixa	PIX	Compensado	Cliente Y	CP007
2338	2026-06-01	12:00:00	Entrada	600.00	Renda de Aluguéis Imóvel 2	Renda Extra	Banco B (Poupança)	TED	Compensado	Inquilino B	CP008
2339	2026-06-04	14:30:00	Saída	-200.00	Passagens de Ônibus	Logística	Caixa	Dinheiro	Compensado	Viação Y	CR009
2340	2026-06-07	18:00:00	Saída	-180.00	Telefonia Mensal	Contas Fixas	Banco A (Corrente)	Débito Automático	Compensado	VIVO	CP010
2341	2026-06-10	09:00:00	Saída	-40.00	Tarifa de Extrato	Contas Fixas	Banco A (Corrente)	Débito Automático	Compensado	Banco A	CR011
2342	2026-06-13	15:00:00	Entrada	5000.00	Adiantamento de Cliente	Vendas	Banco A (Corrente)	TED	Compensado	Cliente Delta	CP012
2343	2026-06-18	12:30:00	Saída	-100.00	Almoço de Equipe	Despesas Operacionais	Cartão Crédito	Cartão Crédito	Compensado	Restaurante D	CP013
2344	2026-06-20	10:00:00	Entrada	800.00	Reembolso de Despesa	Renda Extra	Caixa	Dinheiro	Compensado	Sócio Alfa	CP014
2345	2026-06-24	14:00:00	Entrada	4500.00	Venda Lote 63	Vendas	Banco A (Corrente)	Boleto	Compensado	Cliente Tau	CP015
2346	2026-06-25	10:00:00	Saída	-300.00	Compra de Equipamento Pequeno	Despesas Operacionais	Caixa	Dinheiro	Compensado	Loja Elétrica	CP016
2347	2026-06-26	18:00:00	Saída	-180.00	Telefonia (Adicional)	Contas Fixas	Banco A (Corrente)	Débito Automático	Compensado	VIVO	CR017
2348	2026-06-27	10:00:00	Entrada	2500.00	Venda Lote 64	Vendas	Banco A (Corrente)	PIX	Compensado	Cliente Gama	CP018
2350	2026-06-29	11:00:00	Saída	-50.00	Taxa de Saque	Contas Fixas	Banco B (Poupança)	Saque	Compensado	Banco B	CR020
2351	2026-07-01	10:00:00	Saída	-20000.00	Compra de Estoque (Julho)	Fornecedores	Banco A (Corrente)	TED	Compensado	Fornecedor Kappa	CP021
2352	2026-07-02	14:00:00	Entrada	6200.00	Venda Lote 55 (Fatura)	Vendas	Banco A (Corrente)	PIX	Compensado	Cliente Gamma	CP022
2353	2026-07-05	10:30:00	Saída	-3500.00	Aluguel do Escritório	Contas Fixas	Banco A (Corrente)	Boleto	Compensado	Locadora Imóveis	CR023
2354	2026-07-05	11:00:00	Saída	-850.00	Mensalidade de Software ERP (Jul)	Despesas Operacionais	Banco A (Corrente)	Boleto	Compensado	Fornecedor de TI	CP024
2355	2026-07-06	15:00:00	Saída	-150.00	Material de Copa	Despesas Operacionais	Caixa	Dinheiro	Compensado	Supermercado Local	CP025
2356	2026-07-07	11:00:00	Entrada	3600.00	Pagamento de Serviços Recorrentes (Jul)	Serviços Recorrentes	Banco A (Corrente)	TED	Compensado	Empresa Serviços Z	CP026
2357	2026-07-08	13:00:00	Saída	-500.00	Licença de Software Mensal	Contas Fixas	Cartão Crédito	Cartão Crédito	Compensado	Software Service	CR027
2358	2026-07-09	10:00:00	Entrada	1800.00	Renda de Aluguéis Imóvel 1	Renda Extra	Banco B (Poupança)	TED	Compensado	Inquilino A	CP028
2359	2026-07-10	16:00:00	Saída	-1500.00	Manutenção Corretiva	Manutenção	Banco A (Corrente)	TED	Compensado	Serviço L	CP029
2360	2026-07-12	14:00:00	Entrada	8500.00	Venda Lote 65	Vendas	Banco A (Corrente)	PIX	Compensado	Cliente Sigma	CP030
2361	2026-07-14	11:00:00	Saída	-120.00	Combustível	Logística	Cartão Crédito	Cartão Crédito	Compensado	Posto R	CR031
2362	2026-07-15	14:00:00	Entrada	6200.00	Venda Lote 55	Vendas	Banco A (Corrente)	TED	Compensado	Cliente Gamma	CP032
2363	2026-07-16	16:00:00	Saída	-450.00	Contas de Consumo (Jul)	Contas Fixas	Banco A (Corrente)	Débito Automático	Compensado	Concessionária A	CP033
2364	2026-07-17	10:00:00	Entrada	900.00	Reembolso de Despesa	Renda Extra	Caixa	Dinheiro	Compensado	Sócio João	CP034
2365	2026-07-20	15:30:00	Saída	-24500.00	Salários (Julho)	Folha de Pagamento	Banco A (Corrente)	TED	Compensado	RH - Funcionários	CP035
2366	2026-07-21	14:00:00	Entrada	3500.00	Venda Lote 66	Vendas	Banco A (Corrente)	TED	Compensado	Cliente Mu	CR036
2367	2026-07-22	10:00:00	Saída	-400.00	Manutenção de Equipamento	Despesas Operacionais	Caixa	Dinheiro	Compensado	Oficina Geral	CP037
2368	2026-07-23	16:00:00	Entrada	7800.00	Venda Lote 67	Vendas	Banco A (Corrente)	PIX	Compensado	Cliente Beta	CP038
2369	2026-07-26	11:00:00	Saída	-6000.00	Impostos Mensais (Jul)	Contas Fixas	Banco A (Corrente)	Boleto	Compensado	Receita Federal	CP039
2370	2026-07-27	14:00:00	Entrada	1500.00	Venda de Consultoria	Prestação de Serviços	Banco A (Corrente)	TED	Compensado	Empresa K	CR040
2371	2026-07-28	12:00:00	Saída	-50.00	Despesa Cartório	Despesas Operacionais	Caixa	Dinheiro	Compensado	Cartório O	CP041
2372	2026-07-30	16:00:00	Entrada	400.00	Venda Avulsa	Vendas	Caixa	PIX	Compensado	Cliente Y	CP042
2373	2026-07-01	12:00:00	Entrada	600.00	Renda de Aluguéis Imóvel 2	Renda Extra	Banco B (Poupança)	TED	Compensado	Inquilino B	CP043
2374	2026-07-04	14:30:00	Saída	-200.00	Passagens de Ônibus	Logística	Caixa	Dinheiro	Compensado	Viação Y	CR044
2375	2026-07-07	18:00:00	Saída	-180.00	Telefonia Mensal	Contas Fixas	Banco A (Corrente)	Débito Automático	Compensado	VIVO	CP045
2376	2026-07-10	09:00:00	Saída	-40.00	Tarifa de Extrato	Contas Fixas	Banco A (Corrente)	Débito Automático	Compensado	Banco A	CP046
2377	2026-07-13	15:00:00	Entrada	5000.00	Adiantamento de Cliente	Vendas	Banco A (Corrente)	TED	Compensado	Cliente Delta	CP047
2378	2026-07-18	12:30:00	Saída	-100.00	Almoço de Equipe	Despesas Operacionais	Cartão Crédito	Cartão Crédito	Compensado	Restaurante D	CR048
2379	2026-07-20	10:00:00	Entrada	800.00	Reembolso de Despesa	Renda Extra	Caixa	Dinheiro	Compensado	Sócio Alfa	CP049
2380	2026-07-24	14:00:00	Entrada	4500.00	Venda Lote 68	Vendas	Banco A (Corrente)	Boleto	Compensado	Cliente Tau	CP050
2381	2026-07-25	10:00:00	Saída	-300.00	Compra de Equipamento Pequeno	Despesas Operacionais	Caixa	Dinheiro	Compensado	Loja Elétrica	CP051
2382	2026-07-26	18:00:00	Saída	-180.00	Telefonia (Adicional)	Contas Fixas	Banco A (Corrente)	Débito Automático	Compensado	VIVO	CR052
2383	2026-07-27	10:00:00	Entrada	2500.00	Venda Lote 69	Vendas	Banco A (Corrente)	PIX	Compensado	Cliente Gama	CP053
2384	2026-07-28	14:00:00	Entrada	400.00	Venda Avulsa	Vendas	Caixa	PIX	Compensado	Cliente Y	CP054
2385	2026-07-29	11:00:00	Saída	-50.00	Taxa de Saque	Contas Fixas	Banco B (Poupança)	Saque	Compensado	Banco B	CP055
2386	2026-08-01	10:00:00	Saída	-22000.00	Compra de Estoque (Agosto)	Fornecedores	Banco A (Corrente)	TED	Compensado	Fornecedor Delta	CR001
2387	2026-08-02	14:00:00	Entrada	7500.00	Venda Lote 70	Vendas	Banco A (Corrente)	PIX	Compensado	Cliente Alpha	CP001
2388	2026-08-05	10:30:00	Saída	-3500.00	Aluguel do Escritório	Contas Fixas	Banco A (Corrente)	Boleto	Compensado	Locadora Imóveis	CP002
2389	2026-08-05	11:00:00	Saída	-850.00	Mensalidade de Software ERP (Ago)	Despesas Operacionais	Banco A (Corrente)	Boleto	Compensado	Fornecedor de TI	CR003
2390	2026-08-06	15:00:00	Saída	-150.00	Material de Copa	Despesas Operacionais	Caixa	Dinheiro	Compensado	Supermercado Local	CP005
2391	2026-08-07	11:00:00	Entrada	3600.00	Pagamento de Serviços Recorrentes (Ago)	Serviços Recorrentes	Banco A (Corrente)	TED	Compensado	Empresa Serviços Z	CP006
2392	2026-08-08	13:00:00	Saída	-500.00	Licença de Software Mensal	Contas Fixas	Cartão Crédito	Cartão Crédito	Compensado	Software Service	CP007
2393	2026-08-09	10:00:00	Entrada	1800.00	Renda de Aluguéis Imóvel 1	Renda Extra	Banco B (Poupança)	TED	Compensado	Inquilino A	CP008
2394	2026-08-10	16:00:00	Saída	-7500.00	Marketing (Nova Campanha)	Marketing	Banco A (Corrente)	Boleto	Compensado	Agência Digital	CR009
2395	2026-08-12	14:00:00	Entrada	9000.00	Venda Lote 60 (Fatura)	Vendas	Banco A (Corrente)	PIX	Compensado	Cliente Alpha	CP010
2396	2026-08-14	11:00:00	Saída	-120.00	Combustível	Logística	Cartão Crédito	Cartão Crédito	Compensado	Posto R	CR011
2397	2026-08-15	14:00:00	Entrada	9500.00	Venda Lote 48 (Fatura)	Vendas	Banco A (Corrente)	TED	Compensado	Cliente Tau	CP012
2398	2026-08-16	16:00:00	Saída	-450.00	Contas de Consumo (Ago)	Contas Fixas	Banco A (Corrente)	Débito Automático	Compensado	Concessionária A	CP013
2399	2026-08-17	10:00:00	Entrada	900.00	Reembolso de Despesa	Renda Extra	Caixa	Dinheiro	Compensado	Sócio João	CP014
2400	2026-08-20	15:30:00	Saída	-24500.00	Salários (Agosto)	Folha de Pagamento	Banco A (Corrente)	TED	Compensado	RH - Funcionários	CP015
2401	2026-08-21	14:00:00	Entrada	3500.00	Venda Lote 71	Vendas	Banco A (Corrente)	TED	Compensado	Cliente Zeta	CP016
2402	2026-08-22	10:00:00	Saída	-400.00	Manutenção de Equipamento	Despesas Operacionais	Caixa	Dinheiro	Compensado	Oficina Geral	CR017
2403	2026-08-23	16:00:00	Entrada	6500.00	Venda Lote 72	Vendas	Banco A (Corrente)	PIX	Compensado	Cliente Gamma	CP018
2404	2026-08-26	11:00:00	Saída	-6000.00	Impostos Mensais (Ago)	Contas Fixas	Banco A (Corrente)	Boleto	Compensado	Receita Federal	CP019
2405	2026-08-27	14:00:00	Entrada	1500.00	Venda de Consultoria	Prestação de Serviços	Banco A (Corrente)	TED	Compensado	Empresa K	CR020
2406	2026-08-28	12:00:00	Saída	-50.00	Despesa Cartório	Despesas Operacionais	Caixa	Dinheiro	Compensado	Cartório O	CP021
2408	2026-08-01	12:00:00	Entrada	600.00	Renda de Aluguéis Imóvel 2	Renda Extra	Banco B (Poupança)	TED	Compensado	Inquilino B	CR023
2409	2026-08-04	14:30:00	Saída	-200.00	Passagens de Ônibus	Logística	Caixa	Dinheiro	Compensado	Viação Y	CP024
2410	2026-08-07	18:00:00	Saída	-180.00	Telefonia Mensal	Contas Fixas	Banco A (Corrente)	Débito Automático	Compensado	VIVO	CP025
2411	2026-08-10	09:00:00	Saída	-40.00	Tarifa de Extrato	Contas Fixas	Banco A (Corrente)	Débito Automático	Compensado	Banco A	CP026
2412	2026-08-13	15:00:00	Entrada	5000.00	Adiantamento de Cliente	Vendas	Banco A (Corrente)	TED	Compensado	Cliente Delta	CR027
2413	2026-08-18	12:30:00	Saída	-100.00	Almoço de Equipe	Despesas Operacionais	Cartão Crédito	Cartão Crédito	Compensado	Restaurante D	CP028
2414	2026-08-20	10:00:00	Entrada	800.00	Reembolso de Despesa	Renda Extra	Caixa	Dinheiro	Compensado	Sócio Alfa	CP029
2415	2026-08-24	14:00:00	Entrada	4500.00	Venda Lote 73	Vendas	Banco A (Corrente)	Boleto	Compensado	Cliente Tau	CP030
2416	2026-08-25	10:00:00	Saída	-300.00	Compra de Equipamento Pequeno	Despesas Operacionais	Caixa	Dinheiro	Compensado	Loja Elétrica	CR031
2417	2026-08-26	18:00:00	Saída	-180.00	Telefonia (Adicional)	Contas Fixas	Banco A (Corrente)	Débito Automático	Compensado	VIVO	CP032
2418	2026-08-27	10:00:00	Entrada	2500.00	Venda Lote 74	Vendas	Banco A (Corrente)	PIX	Compensado	Cliente Gama	CP033
2419	2026-08-28	14:00:00	Entrada	400.00	Venda Avulsa	Vendas	Caixa	PIX	Compensado	Cliente Y	CP034
2420	2026-08-29	11:00:00	Saída	-50.00	Taxa de Saque	Contas Fixas	Banco B (Poupança)	Saque	Compensado	Banco B	CP035
\.


--
-- TOC entry 4961 (class 0 OID 49204)
-- Dependencies: 229
-- Data for Name: dim_conta; Type: TABLE DATA; Schema: gold; Owner: postgres
--

COPY gold.dim_conta (id_conta, tipo_conta, descricao_detalhada) FROM stdin;
CR001	Receber	Fatura de Venda Lote 25
CP001	Pagar	Salários de Novembro (Provisão)
CP002	Pagar	Campanha Black Friday (2ª parcela)
CR003	Receber	Venda de Produto Especial
CP005	Pagar	Aluguel do Escritório (Dez)
CP006	Pagar	Compra de Estoque (Natal)
CP007	Pagar	13º Salário (Provisão)
CP008	Pagar	Salários de Dezembro
CR009	Receber	Pagamento de Serviço de Dezembro
CP010	Pagar	Impostos Mensais (Dez)
CR011	Receber	Venda Lote 27
CP012	Pagar	Aluguel do Escritório (Jan)
CP013	Pagar	Mensalidade de Software ERP (Jan)
CP014	Pagar	Compra de Matéria-Prima (Pedido 56)
CP015	Pagar	Salários de Janeiro (Provisão)
CP016	Pagar	Renovação de Contrato Anual TI
CR017	Receber	Venda Lote 28
CP018	Pagar	Aluguel do Escritório (Fev)
CP019	Pagar	Marketing de Lançamento (Fev)
CR020	Receber	Fatura de Venda Lote 29
CP021	Pagar	Salários de Fevereiro (Provisão)
CP022	Pagar	Impostos Mensais (Fev)
CR023	Receber	Fatura de Venda Lote 31
CP024	Pagar	Aluguel do Escritório (Mar)
CP025	Pagar	Compra de Estoque (Mar)
CP026	Pagar	Salários de Março (Provisão)
CR027	Receber	Pagamento de Serviços Recorrentes (Abr)
CP028	Pagar	Aluguel do Escritório (Abr)
CP029	Pagar	Salários de Abril (Provisão)
CP030	Pagar	Impostos Trimestrais
CR031	Receber	Venda Lote 38
CP032	Pagar	Aluguel do Escritório (Mai)
CP033	Pagar	Marketing (Meio do Ano)
CP034	Pagar	Salários de Maio (Provisão)
CP035	Pagar	Impostos Mensais (Mai)
CR036	Receber	Fatura de Venda Lote 42
CP037	Pagar	Aluguel do Escritório (Jun)
CP038	Pagar	Compra de Estoque (Jun)
CP039	Pagar	Salários de Junho (Provisão)
CR040	Receber	Renda de Aluguéis Imóvel 1 (Jul)
CP041	Pagar	Aluguel do Escritório (Jul)
CP042	Pagar	Salários de Julho (Provisão)
CP043	Pagar	Impostos Mensais (Jul)
CR044	Receber	Venda Lote 48
CP045	Pagar	Aluguel do Escritório (Ago)
CP046	Pagar	Salários de Agosto (Provisão)
CP047	Pagar	Marketing (Nova Campanha)
CR048	Receber	Fatura de Venda Lote 52
CP049	Pagar	Aluguel do Escritório (Set)
CP050	Pagar	Salários de Setembro (Provisão)
CP051	Pagar	Compra de Estoque (Set)
CR052	Receber	Venda Lote 55
CP053	Pagar	Aluguel do Escritório (Out)
CP054	Pagar	Salários de Outubro (Provisão)
CP055	Pagar	Impostos Mensais (Out)
\.


--
-- TOC entry 4960 (class 0 OID 49193)
-- Dependencies: 228
-- Data for Name: dim_tempo; Type: TABLE DATA; Schema: gold; Owner: postgres
--

COPY gold.dim_tempo (data, ano, mes, nome_mes, dia_semana, nome_dia_semana) FROM stdin;
2026-03-02	2026	3	Março	1	Segunda-Feira
2026-01-27	2026	1	Janeiro	2	Terça-Feira
2026-05-15	2026	5	Maio	5	Sexta-Feira
2026-07-08	2026	7	Julho	3	Quarta-Feira
2025-10-15	2025	10	Outubro	3	Quarta-Feira
2025-09-03	2025	9	Setembro	3	Quarta-Feira
2026-05-26	2026	5	Maio	2	Terça-Feira
2025-12-08	2025	12	Dezembro	1	Segunda-Feira
2026-01-07	2026	1	Janeiro	3	Quarta-Feira
2026-02-17	2026	2	Fevereiro	2	Terça-Feira
2026-02-26	2026	2	Fevereiro	4	Quinta-Feira
2025-10-14	2025	10	Outubro	2	Terça-Feira
2026-07-24	2026	7	Julho	5	Sexta-Feira
2025-11-06	2025	11	Novembro	4	Quinta-Feira
2026-06-25	2026	6	Junho	4	Quinta-Feira
2025-11-25	2025	11	Novembro	2	Terça-Feira
2026-08-29	2026	8	Agosto	6	Sábado
2026-05-20	2026	5	Maio	3	Quarta-Feira
2025-10-04	2025	10	Outubro	6	Sábado
2025-09-02	2025	9	Setembro	2	Terça-Feira
2025-11-04	2025	11	Novembro	2	Terça-Feira
2026-03-04	2026	3	Março	3	Quarta-Feira
2026-02-12	2026	2	Fevereiro	4	Quinta-Feira
2025-11-12	2025	11	Novembro	3	Quarta-Feira
2026-01-24	2026	1	Janeiro	6	Sábado
2025-09-22	2025	9	Setembro	1	Segunda-Feira
2026-08-02	2026	8	Agosto	0	Domingo
2026-06-09	2026	6	Junho	2	Terça-Feira
2025-11-08	2025	11	Novembro	6	Sábado
2026-05-27	2026	5	Maio	3	Quarta-Feira
2026-01-18	2026	1	Janeiro	0	Domingo
2025-11-20	2025	11	Novembro	4	Quinta-Feira
2026-05-02	2026	5	Maio	6	Sábado
2025-10-26	2025	10	Outubro	0	Domingo
2026-01-13	2026	1	Janeiro	2	Terça-Feira
2025-10-30	2025	10	Outubro	4	Quinta-Feira
2026-08-22	2026	8	Agosto	6	Sábado
2026-07-04	2026	7	Julho	6	Sábado
2026-07-28	2026	7	Julho	2	Terça-Feira
2025-10-22	2025	10	Outubro	3	Quarta-Feira
2026-08-18	2026	8	Agosto	2	Terça-Feira
2026-06-21	2026	6	Junho	0	Domingo
2026-04-25	2026	4	Abril	6	Sábado
2026-08-20	2026	8	Agosto	4	Quinta-Feira
2025-09-23	2025	9	Setembro	2	Terça-Feira
2026-01-12	2026	1	Janeiro	1	Segunda-Feira
2026-02-25	2026	2	Fevereiro	3	Quarta-Feira
2025-09-16	2025	9	Setembro	2	Terça-Feira
2026-08-30	2026	8	Agosto	0	Domingo
2026-08-04	2026	8	Agosto	2	Terça-Feira
2026-05-13	2026	5	Maio	3	Quarta-Feira
2026-05-14	2026	5	Maio	4	Quinta-Feira
2026-02-08	2026	2	Fevereiro	0	Domingo
2026-01-28	2026	1	Janeiro	3	Quarta-Feira
2026-03-01	2026	3	Março	0	Domingo
2025-09-04	2025	9	Setembro	4	Quinta-Feira
2025-12-09	2025	12	Dezembro	2	Terça-Feira
2025-10-16	2025	10	Outubro	4	Quinta-Feira
2026-07-21	2026	7	Julho	2	Terça-Feira
2025-10-10	2025	10	Outubro	5	Sexta-Feira
2025-09-06	2025	9	Setembro	6	Sábado
2026-01-31	2026	1	Janeiro	6	Sábado
2025-12-11	2025	12	Dezembro	4	Quinta-Feira
2026-03-16	2026	3	Março	1	Segunda-Feira
2025-11-17	2025	11	Novembro	1	Segunda-Feira
2026-06-17	2026	6	Junho	3	Quarta-Feira
2025-12-30	2025	12	Dezembro	2	Terça-Feira
2026-02-09	2026	2	Fevereiro	1	Segunda-Feira
2025-09-26	2025	9	Setembro	5	Sexta-Feira
2025-11-28	2025	11	Novembro	5	Sexta-Feira
2025-11-14	2025	11	Novembro	5	Sexta-Feira
2026-06-08	2026	6	Junho	1	Segunda-Feira
2026-05-30	2026	5	Maio	6	Sábado
2025-12-10	2025	12	Dezembro	3	Quarta-Feira
2025-12-27	2025	12	Dezembro	6	Sábado
2026-01-09	2026	1	Janeiro	5	Sexta-Feira
2026-04-22	2026	4	Abril	3	Quarta-Feira
2026-02-03	2026	2	Fevereiro	2	Terça-Feira
2025-11-01	2025	11	Novembro	6	Sábado
2025-12-03	2025	12	Dezembro	3	Quarta-Feira
2026-06-23	2026	6	Junho	2	Terça-Feira
2026-03-24	2026	3	Março	2	Terça-Feira
2026-04-29	2026	4	Abril	3	Quarta-Feira
2025-10-06	2025	10	Outubro	1	Segunda-Feira
2026-03-25	2026	3	Março	3	Quarta-Feira
2025-12-17	2025	12	Dezembro	3	Quarta-Feira
2026-02-04	2026	2	Fevereiro	3	Quarta-Feira
2026-08-16	2026	8	Agosto	0	Domingo
2025-11-10	2025	11	Novembro	1	Segunda-Feira
2026-07-02	2026	7	Julho	4	Quinta-Feira
2026-03-17	2026	3	Março	2	Terça-Feira
2026-02-22	2026	2	Fevereiro	0	Domingo
2026-02-20	2026	2	Fevereiro	5	Sexta-Feira
2026-08-23	2026	8	Agosto	0	Domingo
2025-11-16	2025	11	Novembro	0	Domingo
2026-02-10	2026	2	Fevereiro	2	Terça-Feira
2026-07-10	2026	7	Julho	5	Sexta-Feira
2026-06-12	2026	6	Junho	5	Sexta-Feira
2025-10-07	2025	10	Outubro	2	Terça-Feira
2025-11-11	2025	11	Novembro	2	Terça-Feira
2026-05-23	2026	5	Maio	6	Sábado
2026-03-07	2026	3	Março	6	Sábado
2025-12-07	2025	12	Dezembro	0	Domingo
2026-06-05	2026	6	Junho	5	Sexta-Feira
2026-01-17	2026	1	Janeiro	6	Sábado
2026-05-09	2026	5	Maio	6	Sábado
2026-07-23	2026	7	Julho	4	Quinta-Feira
2026-03-03	2026	3	Março	2	Terça-Feira
2025-11-19	2025	11	Novembro	3	Quarta-Feira
2026-01-16	2026	1	Janeiro	5	Sexta-Feira
2026-07-09	2026	7	Julho	4	Quinta-Feira
2026-05-24	2026	5	Maio	0	Domingo
2026-04-10	2026	4	Abril	5	Sexta-Feira
2026-07-20	2026	7	Julho	1	Segunda-Feira
2026-07-14	2026	7	Julho	2	Terça-Feira
2026-03-27	2026	3	Março	5	Sexta-Feira
2026-05-17	2026	5	Maio	0	Domingo
2026-08-05	2026	8	Agosto	3	Quarta-Feira
2025-11-21	2025	11	Novembro	5	Sexta-Feira
2025-09-15	2025	9	Setembro	1	Segunda-Feira
2026-03-05	2026	3	Março	4	Quinta-Feira
2025-10-19	2025	10	Outubro	0	Domingo
2025-10-25	2025	10	Outubro	6	Sábado
2026-03-06	2026	3	Março	5	Sexta-Feira
2026-02-06	2026	2	Fevereiro	5	Sexta-Feira
2025-10-13	2025	10	Outubro	1	Segunda-Feira
2026-04-26	2026	4	Abril	0	Domingo
2026-06-26	2026	6	Junho	5	Sexta-Feira
2026-02-18	2026	2	Fevereiro	3	Quarta-Feira
2025-12-12	2025	12	Dezembro	5	Sexta-Feira
2025-11-02	2025	11	Novembro	0	Domingo
2026-08-01	2026	8	Agosto	6	Sábado
2026-02-28	2026	2	Fevereiro	6	Sábado
2025-09-18	2025	9	Setembro	4	Quinta-Feira
2026-01-04	2026	1	Janeiro	0	Domingo
2026-05-28	2026	5	Maio	4	Quinta-Feira
2026-05-05	2026	5	Maio	2	Terça-Feira
2026-05-01	2026	5	Maio	5	Sexta-Feira
2026-02-15	2026	2	Fevereiro	0	Domingo
2026-01-05	2026	1	Janeiro	1	Segunda-Feira
2025-12-13	2025	12	Dezembro	6	Sábado
2026-08-21	2026	8	Agosto	5	Sexta-Feira
2025-12-05	2025	12	Dezembro	5	Sexta-Feira
2025-09-11	2025	9	Setembro	4	Quinta-Feira
2026-07-25	2026	7	Julho	6	Sábado
2026-03-23	2026	3	Março	1	Segunda-Feira
2026-01-25	2026	1	Janeiro	0	Domingo
2026-05-16	2026	5	Maio	6	Sábado
2026-08-14	2026	8	Agosto	5	Sexta-Feira
2026-01-29	2026	1	Janeiro	4	Quinta-Feira
2026-05-22	2026	5	Maio	5	Sexta-Feira
2025-09-20	2025	9	Setembro	6	Sábado
2026-04-30	2026	4	Abril	4	Quinta-Feira
2025-12-04	2025	12	Dezembro	4	Quinta-Feira
2026-08-13	2026	8	Agosto	4	Quinta-Feira
2026-01-20	2026	1	Janeiro	2	Terça-Feira
2026-02-05	2026	2	Fevereiro	4	Quinta-Feira
2025-11-05	2025	11	Novembro	3	Quarta-Feira
2025-09-30	2025	9	Setembro	2	Terça-Feira
2025-10-17	2025	10	Outubro	5	Sexta-Feira
2026-04-16	2026	4	Abril	4	Quinta-Feira
2026-02-23	2026	2	Fevereiro	1	Segunda-Feira
2025-11-22	2025	11	Novembro	6	Sábado
2026-04-21	2026	4	Abril	2	Terça-Feira
2026-03-14	2026	3	Março	6	Sábado
2026-05-06	2026	5	Maio	3	Quarta-Feira
2025-12-22	2025	12	Dezembro	1	Segunda-Feira
2026-08-27	2026	8	Agosto	4	Quinta-Feira
2025-12-25	2025	12	Dezembro	4	Quinta-Feira
2025-10-03	2025	10	Outubro	5	Sexta-Feira
2026-03-10	2026	3	Março	2	Terça-Feira
2025-10-05	2025	10	Outubro	0	Domingo
2026-05-18	2026	5	Maio	1	Segunda-Feira
2026-07-26	2026	7	Julho	0	Domingo
2026-01-26	2026	1	Janeiro	1	Segunda-Feira
2026-07-05	2026	7	Julho	0	Domingo
2026-08-26	2026	8	Agosto	3	Quarta-Feira
2026-07-18	2026	7	Julho	6	Sábado
2026-05-21	2026	5	Maio	4	Quinta-Feira
2026-08-17	2026	8	Agosto	1	Segunda-Feira
2026-06-16	2026	6	Junho	2	Terça-Feira
2025-10-29	2025	10	Outubro	3	Quarta-Feira
2026-06-15	2026	6	Junho	1	Segunda-Feira
2026-03-08	2026	3	Março	0	Domingo
2026-07-29	2026	7	Julho	3	Quarta-Feira
2026-04-08	2026	4	Abril	3	Quarta-Feira
2026-04-15	2026	4	Abril	3	Quarta-Feira
2025-11-26	2025	11	Novembro	3	Quarta-Feira
2026-08-10	2026	8	Agosto	1	Segunda-Feira
2026-06-07	2026	6	Junho	0	Domingo
2026-03-20	2026	3	Março	5	Sexta-Feira
2025-12-21	2025	12	Dezembro	0	Domingo
2026-03-18	2026	3	Março	3	Quarta-Feira
2025-09-05	2025	9	Setembro	5	Sexta-Feira
2026-02-24	2026	2	Fevereiro	2	Terça-Feira
2026-02-01	2026	2	Fevereiro	0	Domingo
2025-11-07	2025	11	Novembro	5	Sexta-Feira
2025-10-08	2025	10	Outubro	3	Quarta-Feira
2025-12-28	2025	12	Dezembro	0	Domingo
2026-01-10	2026	1	Janeiro	6	Sábado
2026-04-23	2026	4	Abril	4	Quinta-Feira
2025-12-24	2025	12	Dezembro	3	Quarta-Feira
2025-10-09	2025	10	Outubro	4	Quinta-Feira
2026-04-05	2026	4	Abril	0	Domingo
2025-11-18	2025	11	Novembro	2	Terça-Feira
2026-05-25	2026	5	Maio	1	Segunda-Feira
2026-02-27	2026	2	Fevereiro	5	Sexta-Feira
2025-12-16	2025	12	Dezembro	2	Terça-Feira
2026-04-01	2026	4	Abril	3	Quarta-Feira
2026-04-17	2026	4	Abril	5	Sexta-Feira
2026-07-16	2026	7	Julho	4	Quinta-Feira
2025-09-24	2025	9	Setembro	3	Quarta-Feira
2026-03-22	2026	3	Março	0	Domingo
2025-10-23	2025	10	Outubro	4	Quinta-Feira
2026-07-12	2026	7	Julho	0	Domingo
2026-01-06	2026	1	Janeiro	2	Terça-Feira
2025-09-25	2025	9	Setembro	4	Quinta-Feira
2026-05-29	2026	5	Maio	5	Sexta-Feira
2026-04-28	2026	4	Abril	2	Terça-Feira
2026-02-16	2026	2	Fevereiro	1	Segunda-Feira
2026-06-22	2026	6	Junho	1	Segunda-Feira
2026-07-13	2026	7	Julho	1	Segunda-Feira
2026-06-27	2026	6	Junho	6	Sábado
2026-01-30	2026	1	Janeiro	5	Sexta-Feira
2025-12-29	2025	12	Dezembro	1	Segunda-Feira
2026-07-01	2026	7	Julho	3	Quarta-Feira
2026-01-14	2026	1	Janeiro	3	Quarta-Feira
2026-07-17	2026	7	Julho	5	Sexta-Feira
2026-04-14	2026	4	Abril	2	Terça-Feira
2025-12-23	2025	12	Dezembro	2	Terça-Feira
2026-05-07	2026	5	Maio	4	Quinta-Feira
2025-09-10	2025	9	Setembro	3	Quarta-Feira
2025-12-15	2025	12	Dezembro	1	Segunda-Feira
2025-10-24	2025	10	Outubro	5	Sexta-Feira
2026-01-02	2026	1	Janeiro	5	Sexta-Feira
2025-11-27	2025	11	Novembro	4	Quinta-Feira
2026-06-01	2026	6	Junho	1	Segunda-Feira
2026-01-15	2026	1	Janeiro	4	Quinta-Feira
2025-12-02	2025	12	Dezembro	2	Terça-Feira
2026-08-07	2026	8	Agosto	5	Sexta-Feira
2026-08-25	2026	8	Agosto	2	Terça-Feira
2026-03-15	2026	3	Março	0	Domingo
2025-12-01	2025	12	Dezembro	1	Segunda-Feira
2026-02-02	2026	2	Fevereiro	1	Segunda-Feira
2026-04-04	2026	4	Abril	6	Sábado
2025-10-31	2025	10	Outubro	5	Sexta-Feira
2026-05-04	2026	5	Maio	1	Segunda-Feira
2025-09-17	2025	9	Setembro	3	Quarta-Feira
2025-09-29	2025	9	Setembro	1	Segunda-Feira
2026-04-06	2026	4	Abril	1	Segunda-Feira
2026-07-15	2026	7	Julho	3	Quarta-Feira
2026-02-21	2026	2	Fevereiro	6	Sábado
2026-03-28	2026	3	Março	6	Sábado
2025-10-18	2025	10	Outubro	6	Sábado
2025-10-20	2025	10	Outubro	1	Segunda-Feira
2025-10-28	2025	10	Outubro	2	Terça-Feira
2026-07-27	2026	7	Julho	1	Segunda-Feira
2026-04-02	2026	4	Abril	4	Quinta-Feira
2025-11-15	2025	11	Novembro	6	Sábado
2026-07-22	2026	7	Julho	3	Quarta-Feira
2026-05-10	2026	5	Maio	0	Domingo
2026-04-12	2026	4	Abril	0	Domingo
2026-07-07	2026	7	Julho	2	Terça-Feira
2025-11-03	2025	11	Novembro	1	Segunda-Feira
2026-06-29	2026	6	Junho	1	Segunda-Feira
2026-08-24	2026	8	Agosto	1	Segunda-Feira
2026-08-08	2026	8	Agosto	6	Sábado
2026-04-24	2026	4	Abril	5	Sexta-Feira
2026-03-29	2026	3	Março	0	Domingo
2026-03-21	2026	3	Março	6	Sábado
2025-12-26	2025	12	Dezembro	5	Sexta-Feira
2026-04-27	2026	4	Abril	1	Segunda-Feira
2026-06-10	2026	6	Junho	3	Quarta-Feira
2026-02-07	2026	2	Fevereiro	6	Sábado
2025-10-01	2025	10	Outubro	3	Quarta-Feira
2026-07-06	2026	7	Julho	1	Segunda-Feira
2026-03-09	2026	3	Março	1	Segunda-Feira
2025-12-20	2025	12	Dezembro	6	Sábado
2026-06-20	2026	6	Junho	6	Sábado
2025-12-06	2025	12	Dezembro	6	Sábado
2026-04-13	2026	4	Abril	1	Segunda-Feira
2025-11-30	2025	11	Novembro	0	Domingo
2026-06-18	2026	6	Junho	4	Quinta-Feira
2025-12-19	2025	12	Dezembro	5	Sexta-Feira
2026-05-12	2026	5	Maio	2	Terça-Feira
2026-05-08	2026	5	Maio	5	Sexta-Feira
2025-11-24	2025	11	Novembro	1	Segunda-Feira
2025-09-21	2025	9	Setembro	0	Domingo
2026-04-20	2026	4	Abril	1	Segunda-Feira
2026-06-13	2026	6	Junho	6	Sábado
2025-09-01	2025	9	Setembro	1	Segunda-Feira
2025-10-27	2025	10	Outubro	1	Segunda-Feira
2025-09-13	2025	9	Setembro	6	Sábado
2026-08-12	2026	8	Agosto	3	Quarta-Feira
2026-08-28	2026	8	Agosto	5	Sexta-Feira
2026-06-02	2026	6	Junho	2	Terça-Feira
2026-01-21	2026	1	Janeiro	3	Quarta-Feira
2025-09-09	2025	9	Setembro	2	Terça-Feira
2025-12-18	2025	12	Dezembro	4	Quinta-Feira
2026-06-30	2026	6	Junho	2	Terça-Feira
2025-09-12	2025	9	Setembro	5	Sexta-Feira
2026-03-26	2026	3	Março	4	Quinta-Feira
2026-03-13	2026	3	Março	5	Sexta-Feira
2026-01-08	2026	1	Janeiro	4	Quinta-Feira
2025-09-19	2025	9	Setembro	5	Sexta-Feira
2026-01-22	2026	1	Janeiro	4	Quinta-Feira
2026-06-14	2026	6	Junho	0	Domingo
2026-04-18	2026	4	Abril	6	Sábado
2026-04-09	2026	4	Abril	4	Quinta-Feira
2026-01-23	2026	1	Janeiro	5	Sexta-Feira
2026-08-06	2026	8	Agosto	4	Quinta-Feira
2026-06-28	2026	6	Junho	0	Domingo
2026-06-04	2026	6	Junho	4	Quinta-Feira
2026-04-07	2026	4	Abril	2	Terça-Feira
2026-06-06	2026	6	Junho	6	Sábado
2026-02-14	2026	2	Fevereiro	6	Sábado
2026-08-09	2026	8	Agosto	0	Domingo
2026-06-24	2026	6	Junho	3	Quarta-Feira
2025-10-21	2025	10	Outubro	2	Terça-Feira
2026-07-30	2026	7	Julho	4	Quinta-Feira
2026-08-15	2026	8	Agosto	6	Sábado
2026-03-12	2026	3	Março	4	Quinta-Feira
2025-11-23	2025	11	Novembro	0	Domingo
2026-02-13	2026	2	Fevereiro	5	Sexta-Feira
2025-11-29	2025	11	Novembro	6	Sábado
2025-10-02	2025	10	Outubro	4	Quinta-Feira
2026-01-01	2026	1	Janeiro	4	Quinta-Feira
2026-03-30	2026	3	Março	1	Segunda-Feira
2026-01-03	2026	1	Janeiro	6	Sábado
2025-09-08	2025	9	Setembro	1	Segunda-Feira
2026-10-15	2026	10	Outubro	4	Quinta-Feira
2026-09-05	2026	9	Setembro	6	Sábado
2026-09-15	2026	9	Setembro	2	Terça-Feira
2026-10-05	2026	10	Outubro	1	Segunda-Feira
2026-10-20	2026	10	Outubro	2	Terça-Feira
2026-10-30	2026	10	Outubro	5	Sexta-Feira
2026-09-20	2026	9	Setembro	0	Domingo
2026-09-25	2026	9	Setembro	5	Sexta-Feira
\.


--
-- TOC entry 4963 (class 0 OID 49214)
-- Dependencies: 231
-- Data for Name: ft_fluxo_caixa; Type: TABLE DATA; Schema: gold; Owner: postgres
--

COPY gold.ft_fluxo_caixa (sk_transacao_planejamento, id_transacao, id_conta, data_ref, valor_realizado, valor_planejado, tipo_movimento, categoria, status, is_realizado, is_planejado, is_entrada, is_saida, valor_net) FROM stdin;
2183	2279	CR003	2026-04-28	400.00	\N	Realizado	Vendas	Compensado	t	f	t	f	400.00
2376	\N	CP022	2026-02-28	\N	6500.00	Planejado	Contas Fixas	Aberto	f	t	t	f	6500.00
2377	\N	CP037	2026-06-05	\N	3500.00	Planejado	Contas Fixas	Aberto	f	t	t	f	3500.00
2378	\N	CP013	2026-01-05	\N	850.00	Planejado	Despesas Operacionais	Aberto	f	t	t	f	850.00
2379	\N	CP025	2026-03-10	\N	19000.00	Planejado	Fornecedores	Aberto	f	t	t	f	19000.00
2380	\N	CR020	2026-02-15	\N	11000.00	Planejado	Vendas Futuras	Aberto	f	t	t	f	11000.00
2381	\N	CP005	2025-12-05	\N	3500.00	Planejado	Contas Fixas	Aberto	f	t	t	f	3500.00
2382	\N	CR027	2026-04-05	\N	3600.00	Planejado	Serviços Recorrentes	Aberto	f	t	t	f	3600.00
2383	\N	CP007	2025-12-20	\N	15000.00	Planejado	Folha de Pagamento	Aberto	f	t	t	f	15000.00
2384	\N	CP033	2026-05-10	\N	10000.00	Planejado	Marketing	Aberto	f	t	t	f	10000.00
2385	\N	CP034	2026-05-20	\N	24500.00	Planejado	Folha de Pagamento	Aberto	f	t	t	f	24500.00
2386	\N	CP042	2026-07-20	\N	24500.00	Planejado	Folha de Pagamento	Aberto	f	t	t	f	24500.00
2387	\N	CP038	2026-06-18	\N	25000.00	Planejado	Fornecedores	Aberto	f	t	t	f	25000.00
2388	\N	CP019	2026-02-15	\N	7000.00	Planejado	Marketing	Aberto	f	t	t	f	7000.00
2389	\N	CP026	2026-03-20	\N	24500.00	Planejado	Folha de Pagamento	Aberto	f	t	t	f	24500.00
2390	\N	CP010	2025-12-30	\N	6000.00	Planejado	Contas Fixas	Aberto	f	t	t	f	6000.00
2391	\N	CP024	2026-03-05	\N	3500.00	Planejado	Contas Fixas	Aberto	f	t	t	f	3500.00
2392	\N	CP001	2025-11-20	\N	23000.00	Planejado	Folha de Pagamento	Pago	f	t	t	f	23000.00
2393	\N	CP043	2026-07-30	\N	6000.00	Planejado	Contas Fixas	Aberto	f	t	t	f	6000.00
2394	\N	CP032	2026-05-05	\N	3500.00	Planejado	Contas Fixas	Aberto	f	t	t	f	3500.00
2395	\N	CP035	2026-05-30	\N	6000.00	Planejado	Contas Fixas	Aberto	f	t	t	f	6000.00
2396	\N	CP014	2026-01-10	\N	21000.00	Planejado	Fornecedores	Aberto	f	t	t	f	21000.00
2397	\N	CP041	2026-07-05	\N	3500.00	Planejado	Contas Fixas	Aberto	f	t	t	f	3500.00
2398	\N	CR023	2026-03-05	\N	8800.00	Planejado	Vendas Futuras	Aberto	f	t	t	f	8800.00
2399	\N	CP053	2026-10-05	\N	3500.00	Planejado	Contas Fixas	Aberto	f	t	t	f	3500.00
2400	\N	CR052	2026-10-15	\N	15000.00	Planejado	Vendas Futuras	Aberto	f	t	t	f	15000.00
2401	\N	CP047	2026-08-25	\N	7500.00	Planejado	Marketing	Aberto	f	t	t	f	7500.00
2402	\N	CR003	2025-12-05	\N	1200.00	Planejado	Vendas Futuras	Aberto	f	t	t	f	1200.00
2403	\N	CP015	2026-01-20	\N	24000.00	Planejado	Folha de Pagamento	Aberto	f	t	t	f	24000.00
2404	\N	CR017	2026-02-05	\N	4800.00	Planejado	Vendas Futuras	Aberto	f	t	t	f	4800.00
2405	\N	CP012	2026-01-05	\N	3500.00	Planejado	Contas Fixas	Aberto	f	t	t	f	3500.00
2406	\N	CP008	2025-12-20	\N	23000.00	Planejado	Folha de Pagamento	Aberto	f	t	t	f	23000.00
2407	\N	CP046	2026-08-20	\N	24500.00	Planejado	Folha de Pagamento	Aberto	f	t	t	f	24500.00
2408	\N	CR044	2026-08-15	\N	9500.00	Planejado	Vendas Futuras	Aberto	f	t	t	f	9500.00
2409	\N	CP054	2026-10-20	\N	25000.00	Planejado	Folha de Pagamento	Aberto	f	t	t	f	25000.00
2410	\N	CP039	2026-06-20	\N	24500.00	Planejado	Folha de Pagamento	Aberto	f	t	t	f	24500.00
2411	\N	CP006	2025-12-08	\N	15000.00	Planejado	Fornecedores	Aberto	f	t	t	f	15000.00
2412	\N	CP055	2026-10-30	\N	6200.00	Planejado	Contas Fixas	Aberto	f	t	t	f	6200.00
2413	\N	CP050	2026-09-20	\N	25000.00	Planejado	Folha de Pagamento	Aberto	f	t	t	f	25000.00
2414	\N	CR036	2026-06-15	\N	12500.00	Planejado	Vendas Futuras	Aberto	f	t	t	f	12500.00
2415	\N	CR031	2026-05-15	\N	5500.00	Planejado	Vendas Futuras	Aberto	f	t	t	f	5500.00
2416	\N	CR040	2026-07-10	\N	1800.00	Planejado	Renda Extra	Aberto	f	t	t	f	1800.00
2417	\N	CP049	2026-09-05	\N	3500.00	Planejado	Contas Fixas	Aberto	f	t	t	f	3500.00
2418	\N	CP029	2026-04-20	\N	24500.00	Planejado	Folha de Pagamento	Aberto	f	t	t	f	24500.00
2419	\N	CP002	2025-11-30	\N	4000.00	Planejado	Marketing	Pago	f	t	t	f	4000.00
2420	\N	CP045	2026-08-05	\N	3500.00	Planejado	Contas Fixas	Aberto	f	t	t	f	3500.00
2421	\N	CP030	2026-04-28	\N	5500.00	Planejado	Contas Fixas	Aberto	f	t	t	f	5500.00
2422	\N	CP051	2026-09-25	\N	28000.00	Planejado	Fornecedores	Aberto	f	t	t	f	28000.00
2423	\N	CP016	2026-01-28	\N	15000.00	Planejado	Despesas Operacionais	Aberto	f	t	t	f	15000.00
2424	\N	CP021	2026-02-20	\N	24500.00	Planejado	Folha de Pagamento	Aberto	f	t	t	f	24500.00
2425	\N	CR011	2026-01-05	\N	7500.00	Planejado	Vendas Futuras	Aberto	f	t	t	f	7500.00
2426	\N	CR048	2026-09-15	\N	7200.00	Planejado	Vendas Futuras	Aberto	f	t	t	f	7200.00
2427	\N	CP018	2026-02-05	\N	3500.00	Planejado	Contas Fixas	Aberto	f	t	t	f	3500.00
2428	\N	CR009	2025-12-25	\N	3500.00	Planejado	Serviços Recorrentes	Aberto	f	t	t	f	3500.00
2429	\N	CR001	2025-11-15	\N	9500.00	Planejado	Vendas Futuras	Pago	f	t	t	f	9500.00
2430	\N	CP028	2026-04-05	\N	3500.00	Planejado	Contas Fixas	Aberto	f	t	t	f	3500.00
1905	2004	CR003	2025-09-02	25000.00	\N	Realizado	Fornecedores	Compensado	t	f	t	f	25000.00
1906	2371	CP041	2026-07-28	50.00	\N	Realizado	Despesas Operacionais	Compensado	t	f	t	f	50.00
1907	2005	CP005	2025-09-03	30.00	\N	Realizado	Contas Fixas	Compensado	t	f	t	f	30.00
1908	2006	CP006	2025-09-04	8000.00	\N	Realizado	Marketing	Compensado	t	f	t	f	8000.00
1909	2007	CP007	2025-09-04	600.00	\N	Realizado	Renda Extra	Compensado	t	f	t	f	600.00
1910	2008	CP008	2025-09-05	3500.00	\N	Realizado	Contas Fixas	Compensado	t	f	t	f	3500.00
1911	2009	CR009	2025-09-05	3500.00	\N	Realizado	Vendas	Compensado	t	f	t	f	3500.00
1912	2010	CP010	2025-09-06	150.00	\N	Realizado	Despesas Operacionais	Compensado	t	f	t	f	150.00
1913	2011	CR011	2025-09-08	7500.00	\N	Realizado	Vendas	Compensado	t	f	t	f	7500.00
1914	2012	CP012	2025-09-08	200.00	\N	Realizado	Logística	Compensado	t	f	t	f	200.00
1916	2014	CP014	2025-09-10	1200.00	\N	Realizado	Despesas Operacionais	Compensado	t	f	t	f	1200.00
1917	2015	CP015	2025-09-11	900.00	\N	Realizado	Vendas	Compensado	t	f	t	f	900.00
1918	2016	CP016	2025-09-11	40000.00	\N	Realizado	Fornecedores	Compensado	t	f	t	f	40000.00
1919	2017	CR017	2025-09-12	500.00	\N	Realizado	Renda Extra	Compensado	t	f	t	f	500.00
1920	2018	CP018	2025-09-13	180.00	\N	Realizado	Contas Fixas	Compensado	t	f	t	f	180.00
1921	2019	CP019	2025-09-15	15000.00	\N	Realizado	Vendas	Compensado	t	f	t	f	15000.00
1922	2020	CR020	2025-09-16	1500.00	\N	Realizado	Despesas Operacionais	Compensado	t	f	t	f	1500.00
1923	2021	CP021	2025-09-17	2200.00	\N	Realizado	Vendas	Compensado	t	f	t	f	2200.00
1924	2022	CP022	2025-09-17	150.00	\N	Realizado	Despesas Operacionais	Compensado	t	f	t	f	150.00
1925	2023	CR023	2025-09-18	800.00	\N	Realizado	Prestação de Serviços	Compensado	t	f	t	f	800.00
1926	2024	CP024	2025-09-18	500.00	\N	Realizado	Contas Fixas	Compensado	t	f	t	f	500.00
1927	2025	CP025	2025-09-19	3000.00	\N	Realizado	Fornecedores	Compensado	t	f	t	f	3000.00
1928	2026	CP026	2025-09-20	6500.00	\N	Realizado	Vendas	Compensado	t	f	t	f	6500.00
1929	2027	CR027	2025-09-21	250.00	\N	Realizado	Despesas Operacionais	Pendente	t	f	t	f	250.00
1930	2028	CP028	2025-09-22	1200.00	\N	Realizado	Renda Extra	Compensado	t	f	t	f	1200.00
1931	2029	CP029	2025-09-22	18000.00	\N	Realizado	Folha de Pagamento	Compensado	t	f	t	f	18000.00
1932	2030	CP030	2025-09-23	1000.00	\N	Realizado	Contas Fixas	Compensado	t	f	t	f	1000.00
1933	2031	CR031	2025-09-24	3800.00	\N	Realizado	Vendas	Pendente	t	f	t	f	3800.00
1934	2032	CP032	2025-09-25	450.00	\N	Realizado	Despesas Operacionais	Compensado	t	f	t	f	450.00
1935	2033	CP033	2025-09-26	250.00	\N	Realizado	Vendas	Compensado	t	f	t	f	250.00
1936	2034	CP034	2025-09-29	5000.00	\N	Realizado	Contas Fixas	Compensado	t	f	t	f	5000.00
1937	2407	CP022	2026-08-30	400.00	\N	Realizado	Vendas	Compensado	t	f	t	f	400.00
1938	2035	CP035	2025-09-30	8500.00	\N	Realizado	Vendas	Compensado	t	f	t	f	8500.00
1939	2036	CR036	2025-10-01	5800.00	\N	Realizado	Vendas	Compensado	t	f	t	f	5800.00
1940	2037	CP037	2025-10-02	350.00	\N	Realizado	Despesas Operacionais	Compensado	t	f	t	f	350.00
1941	2038	CP038	2025-10-03	1500.00	\N	Realizado	Fornecedores	Compensado	t	f	t	f	1500.00
1942	2039	CP039	2025-10-04	2100.00	\N	Realizado	Prestação de Serviços	Compensado	t	f	t	f	2100.00
1943	2040	CR040	2025-10-05	3500.00	\N	Realizado	Contas Fixas	Compensado	t	f	t	f	3500.00
1944	2041	CP041	2025-10-06	4500.00	\N	Realizado	Vendas	Compensado	t	f	t	f	4500.00
1945	2042	CP042	2025-10-07	4000.00	\N	Realizado	Despesas Operacionais	Compensado	t	f	t	f	4000.00
1946	2043	CP043	2025-10-08	500.00	\N	Realizado	Despesas Operacionais	Compensado	t	f	t	f	500.00
1947	2044	CR044	2025-10-09	1500.00	\N	Realizado	Renda Extra	Compensado	t	f	t	f	1500.00
1948	2045	CP045	2025-10-10	120.00	\N	Realizado	Despesas Operacionais	Compensado	t	f	t	f	120.00
1949	2046	CP046	2025-10-13	1800.00	\N	Realizado	Vendas	Compensado	t	f	t	f	1800.00
1950	2047	CP047	2025-10-14	7500.00	\N	Realizado	Fornecedores	Compensado	t	f	t	f	7500.00
1951	2048	CR048	2025-10-15	9000.00	\N	Realizado	Vendas	Compensado	t	f	t	f	9000.00
1952	2049	CP049	2025-10-16	250.00	\N	Realizado	Manutenção	Compensado	t	f	t	f	250.00
1953	2050	CP050	2025-10-17	3000.00	\N	Realizado	Vendas	Compensado	t	f	t	f	3000.00
1954	2051	CP051	2025-10-20	50.00	\N	Realizado	Contas Fixas	Compensado	t	f	t	f	50.00
1955	2052	CR052	2025-10-21	15000.00	\N	Realizado	Folha de Pagamento	Compensado	t	f	t	f	15000.00
1956	2053	CP053	2025-10-22	600.00	\N	Realizado	Renda Extra	Compensado	t	f	t	f	600.00
1957	2054	CP054	2025-10-23	4500.00	\N	Realizado	Contas Fixas	Compensado	t	f	t	f	4500.00
1958	2055	CP055	2025-10-24	10000.00	\N	Realizado	Vendas	Compensado	t	f	t	f	10000.00
1959	2056	CR001	2025-10-25	180.00	\N	Realizado	Contas Fixas	Compensado	t	f	t	f	180.00
1960	2057	CP001	2025-10-26	2500.00	\N	Realizado	Vendas	Compensado	t	f	t	f	2500.00
1961	2058	CP002	2025-10-27	600.00	\N	Realizado	Despesas Operacionais	Compensado	t	f	t	f	600.00
1962	2059	CR003	2025-10-27	350.00	\N	Realizado	Vendas	Compensado	t	f	t	f	350.00
1963	2060	CP005	2025-10-28	50.00	\N	Realizado	Despesas Operacionais	Compensado	t	f	t	f	50.00
1964	2061	CP006	2025-10-28	4200.00	\N	Realizado	Prestação de Serviços	Compensado	t	f	t	f	4200.00
1965	2062	CP007	2025-10-29	800.00	\N	Realizado	Manutenção	Compensado	t	f	t	f	800.00
1966	2063	CP008	2025-10-29	750.00	\N	Realizado	Renda Extra	Compensado	t	f	t	f	750.00
1967	2064	CR009	2025-10-30	2000.00	\N	Realizado	Despesas Operacionais	Compensado	t	f	t	f	2000.00
1968	2065	CP010	2025-10-30	300.00	\N	Realizado	Renda Extra	Compensado	t	f	t	f	300.00
1969	2066	CR011	2025-10-31	50.00	\N	Realizado	Despesas Operacionais	Compensado	t	f	t	f	50.00
1970	2067	CP012	2025-10-31	1500.00	\N	Realizado	Vendas	Compensado	t	f	t	f	1500.00
1971	2068	CP013	2025-10-18	500.00	\N	Realizado	Renda Extra	Compensado	t	f	t	f	500.00
1972	2069	CP014	2025-10-19	150.00	\N	Realizado	Despesas Operacionais	Compensado	t	f	t	f	150.00
1973	2070	CP015	2025-10-25	1200.00	\N	Realizado	Despesas Operacionais	Compensado	t	f	t	f	1200.00
1974	2071	CP016	2025-11-03	35000.00	\N	Realizado	Fornecedores	Compensado	t	f	t	f	35000.00
1975	2072	CR017	2025-11-04	4500.00	\N	Realizado	Vendas	Compensado	t	f	t	f	4500.00
1976	2073	CP018	2025-11-05	3500.00	\N	Realizado	Contas Fixas	Compensado	t	f	t	f	3500.00
1977	2074	CP019	2025-11-05	850.00	\N	Realizado	Despesas Operacionais	Compensado	t	f	t	f	850.00
1978	2075	CR020	2025-11-06	150.00	\N	Realizado	Despesas Operacionais	Compensado	t	f	t	f	150.00
1979	2076	CP021	2025-11-07	2800.00	\N	Realizado	Vendas	Compensado	t	f	t	f	2800.00
1980	2077	CP022	2025-11-10	18000.00	\N	Realizado	Fornecedores	Compensado	t	f	t	f	18000.00
1981	2078	CR023	2025-11-12	1500.00	\N	Realizado	Vendas	Compensado	t	f	t	f	1500.00
1982	2079	CP024	2025-11-14	300.00	\N	Realizado	Contas Fixas	Compensado	t	f	t	f	300.00
1983	2080	CP025	2025-11-15	9500.00	\N	Realizado	Vendas	Compensado	t	f	t	f	9500.00
1984	2081	CP026	2025-11-17	120.00	\N	Realizado	Logística	Compensado	t	f	t	f	120.00
1985	2082	CR027	2025-11-18	600.00	\N	Realizado	Renda Extra	Compensado	t	f	t	f	600.00
1986	2083	CP028	2025-11-19	8000.00	\N	Realizado	Marketing	Compensado	t	f	t	f	8000.00
1987	2084	CP029	2025-11-20	23000.00	\N	Realizado	Folha de Pagamento	Compensado	t	f	t	f	23000.00
1988	2085	CP030	2025-11-21	3200.00	\N	Realizado	Vendas	Compensado	t	f	t	f	3200.00
1989	2086	CR031	2025-11-22	400.00	\N	Realizado	Fornecedores	Compensado	t	f	t	f	400.00
1990	2087	CP032	2025-11-24	3500.00	\N	Realizado	Serviços Recorrentes	Compensado	t	f	t	f	3500.00
1991	2088	CP033	2025-11-25	500.00	\N	Realizado	Contas Fixas	Compensado	t	f	t	f	500.00
1992	2089	CP034	2025-11-26	7000.00	\N	Realizado	Vendas	Compensado	t	f	t	f	7000.00
1993	2090	CP035	2025-11-27	2500.00	\N	Realizado	Despesas Operacionais	Compensado	t	f	t	f	2500.00
1994	2091	CR036	2025-11-28	12000.00	\N	Realizado	Vendas	Compensado	t	f	t	f	12000.00
1995	2092	CP037	2025-11-29	5200.00	\N	Realizado	Contas Fixas	Compensado	t	f	t	f	5200.00
1996	2093	CP038	2025-11-30	450.00	\N	Realizado	Vendas	Compensado	t	f	t	f	450.00
1997	2094	CP039	2025-11-01	1500.00	\N	Realizado	Renda Extra	Compensado	t	f	t	f	1500.00
1998	2095	CR040	2025-11-02	200.00	\N	Realizado	Logística	Compensado	t	f	t	f	200.00
1999	2096	CP041	2025-11-08	900.00	\N	Realizado	Prestação de Serviços	Compensado	t	f	t	f	900.00
2000	2097	CP042	2025-11-10	40.00	\N	Realizado	Contas Fixas	Compensado	t	f	t	f	40.00
2001	2098	CP043	2025-11-11	5000.00	\N	Realizado	Vendas	Compensado	t	f	t	f	5000.00
2002	2099	CR044	2025-11-16	100.00	\N	Realizado	Despesas Operacionais	Compensado	t	f	t	f	100.00
2003	2100	CP045	2025-11-23	800.00	\N	Realizado	Renda Extra	Compensado	t	f	t	f	800.00
2004	2101	CP046	2025-11-24	300.00	\N	Realizado	Despesas Operacionais	Compensado	t	f	t	f	300.00
2005	2102	CP047	2025-11-26	180.00	\N	Realizado	Contas Fixas	Compensado	t	f	t	f	180.00
2006	2103	CR048	2025-11-27	4500.00	\N	Realizado	Vendas	Compensado	t	f	t	f	4500.00
2007	2104	CP049	2025-11-28	50.00	\N	Realizado	Despesas Operacionais	Compensado	t	f	t	f	50.00
2008	2105	CP050	2025-11-29	1500.00	\N	Realizado	Prestação de Serviços	Compensado	t	f	t	f	1500.00
2009	2106	CP051	2025-12-02	25000.00	\N	Realizado	Fornecedores	Compensado	t	f	t	f	25000.00
2010	2107	CR052	2025-12-03	5000.00	\N	Realizado	Vendas	Compensado	t	f	t	f	5000.00
2011	2108	CP053	2025-12-04	150.00	\N	Realizado	Despesas Operacionais	Compensado	t	f	t	f	150.00
2012	2109	CP054	2025-12-05	3500.00	\N	Realizado	Contas Fixas	Compensado	t	f	t	f	3500.00
2013	2110	CP055	2025-12-05	850.00	\N	Realizado	Despesas Operacionais	Compensado	t	f	t	f	850.00
2014	2111	CR001	2025-12-06	1200.00	\N	Realizado	Vendas	Compensado	t	f	t	f	1200.00
2015	2112	CP001	2025-12-08	40.00	\N	Realizado	Contas Fixas	Compensado	t	f	t	f	40.00
2016	2113	CP002	2025-12-09	6000.00	\N	Realizado	Vendas	Compensado	t	f	t	f	6000.00
2017	2114	CR003	2025-12-10	1800.00	\N	Realizado	Renda Extra	Compensado	t	f	t	f	1800.00
2018	2115	CP005	2025-12-11	150.00	\N	Realizado	Despesas Operacionais	Compensado	t	f	t	f	150.00
2019	2116	CP006	2025-12-12	8500.00	\N	Realizado	Vendas	Compensado	t	f	t	f	8500.00
2020	2117	CP007	2025-12-15	10000.00	\N	Realizado	Fornecedores	Compensado	t	f	t	f	10000.00
2021	2118	CP008	2025-12-16	3500.00	\N	Realizado	Serviços Recorrentes	Compensado	t	f	t	f	3500.00
2022	2119	CR009	2025-12-17	450.00	\N	Realizado	Contas Fixas	Compensado	t	f	t	f	450.00
2023	2120	CP010	2025-12-18	4200.00	\N	Realizado	Vendas	Compensado	t	f	t	f	4200.00
2024	2121	CR011	2025-12-19	15000.00	\N	Realizado	Folha de Pagamento	Compensado	t	f	t	f	15000.00
2025	2122	CP012	2025-12-20	23000.00	\N	Realizado	Folha de Pagamento	Compensado	t	f	t	f	23000.00
2026	2123	CP013	2025-12-21	900.00	\N	Realizado	Prestação de Serviços	Compensado	t	f	t	f	900.00
2027	2124	CP014	2025-12-22	2500.00	\N	Realizado	Despesas Operacionais	Compensado	t	f	t	f	2500.00
2028	2125	CP015	2025-12-23	7500.00	\N	Realizado	Vendas	Compensado	t	f	t	f	7500.00
2029	2126	CP016	2025-12-24	120.00	\N	Realizado	Marketing	Compensado	t	f	t	f	120.00
2030	2127	CR017	2025-12-26	600.00	\N	Realizado	Renda Extra	Compensado	t	f	t	f	600.00
2031	2128	CP018	2025-12-27	500.00	\N	Realizado	Contas Fixas	Compensado	t	f	t	f	500.00
2032	2129	CP019	2025-12-28	300.00	\N	Realizado	Vendas	Compensado	t	f	t	f	300.00
2033	2130	CR020	2025-12-29	6000.00	\N	Realizado	Contas Fixas	Compensado	t	f	t	f	6000.00
2034	2131	CP021	2025-12-30	1500.00	\N	Realizado	Prestação de Serviços	Compensado	t	f	t	f	1500.00
2035	2132	CP022	2025-12-01	700.00	\N	Realizado	Vendas	Compensado	t	f	t	f	700.00
2036	2133	CR023	2025-12-04	180.00	\N	Realizado	Contas Fixas	Compensado	t	f	t	f	180.00
2037	2134	CP024	2025-12-07	200.00	\N	Realizado	Logística	Compensado	t	f	t	f	200.00
2038	2135	CP025	2025-12-10	1200.00	\N	Realizado	Despesas Operacionais	Compensado	t	f	t	f	1200.00
2039	2136	CP026	2025-12-13	3000.00	\N	Realizado	Vendas	Compensado	t	f	t	f	3000.00
2040	2137	CR027	2025-12-16	50.00	\N	Realizado	Despesas Operacionais	Compensado	t	f	t	f	50.00
2041	2138	CP028	2025-12-19	800.00	\N	Realizado	Renda Extra	Compensado	t	f	t	f	800.00
2042	2139	CP029	2025-12-25	1500.00	\N	Realizado	Vendas	Pendente	t	f	t	f	1500.00
2043	2140	CP030	2025-12-28	300.00	\N	Realizado	Contas Fixas	Compensado	t	f	t	f	300.00
2044	2141	CR031	2026-01-02	20000.00	\N	Realizado	Fornecedores	Compensado	t	f	t	f	20000.00
2045	2142	CP032	2026-01-03	5500.00	\N	Realizado	Vendas	Compensado	t	f	t	f	5500.00
2046	2143	CP033	2026-01-05	3500.00	\N	Realizado	Contas Fixas	Compensado	t	f	t	f	3500.00
2047	2144	CP034	2026-01-05	850.00	\N	Realizado	Despesas Operacionais	Compensado	t	f	t	f	850.00
2048	2145	CP035	2026-01-06	150.00	\N	Realizado	Despesas Operacionais	Compensado	t	f	t	f	150.00
2049	2146	CR036	2026-01-07	7500.00	\N	Realizado	Vendas	Compensado	t	f	t	f	7500.00
2050	2147	CP037	2026-01-08	500.00	\N	Realizado	Contas Fixas	Compensado	t	f	t	f	500.00
2051	2148	CP038	2026-01-09	1800.00	\N	Realizado	Renda Extra	Compensado	t	f	t	f	1800.00
2052	2149	CP039	2026-01-10	21000.00	\N	Realizado	Fornecedores	Compensado	t	f	t	f	21000.00
2053	2150	CR040	2026-01-12	3500.00	\N	Realizado	Vendas	Compensado	t	f	t	f	3500.00
2054	2151	CP041	2026-01-14	120.00	\N	Realizado	Logística	Compensado	t	f	t	f	120.00
2055	2152	CP042	2026-01-15	2800.00	\N	Realizado	Vendas	Compensado	t	f	t	f	2800.00
2056	2153	CP043	2026-01-16	500.00	\N	Realizado	Contas Fixas	Compensado	t	f	t	f	500.00
2057	2154	CR044	2026-01-17	900.00	\N	Realizado	Renda Extra	Compensado	t	f	t	f	900.00
2058	2155	CP045	2026-01-20	24000.00	\N	Realizado	Folha de Pagamento	Compensado	t	f	t	f	24000.00
2059	2156	CP046	2026-01-21	3500.00	\N	Realizado	Serviços Recorrentes	Compensado	t	f	t	f	3500.00
2060	2157	CP047	2026-01-22	400.00	\N	Realizado	Despesas Operacionais	Compensado	t	f	t	f	400.00
2061	2158	CR048	2026-01-23	4800.00	\N	Realizado	Vendas	Compensado	t	f	t	f	4800.00
2062	2159	CP049	2026-01-26	6500.00	\N	Realizado	Contas Fixas	Compensado	t	f	t	f	6500.00
2063	2160	CP050	2026-01-27	1500.00	\N	Realizado	Prestação de Serviços	Compensado	t	f	t	f	1500.00
2064	2161	CP051	2026-01-28	15000.00	\N	Realizado	Despesas Operacionais	Compensado	t	f	t	f	15000.00
2065	2162	CR052	2026-01-29	9500.00	\N	Realizado	Vendas	Compensado	t	f	t	f	9500.00
2066	2163	CP053	2026-01-30	50.00	\N	Realizado	Despesas Operacionais	Compensado	t	f	t	f	50.00
2067	2165	CP055	2026-01-01	600.00	\N	Realizado	Renda Extra	Compensado	t	f	t	f	600.00
2068	2166	CR001	2026-01-04	200.00	\N	Realizado	Logística	Compensado	t	f	t	f	200.00
2069	2167	CP001	2026-01-07	180.00	\N	Realizado	Contas Fixas	Compensado	t	f	t	f	180.00
2070	2168	CP002	2026-01-13	40.00	\N	Realizado	Contas Fixas	Compensado	t	f	t	f	40.00
2071	2169	CR003	2026-01-18	100.00	\N	Realizado	Despesas Operacionais	Compensado	t	f	t	f	100.00
2072	2170	CP005	2026-01-20	5000.00	\N	Realizado	Vendas	Compensado	t	f	t	f	5000.00
2073	2171	CP006	2026-01-24	800.00	\N	Realizado	Renda Extra	Compensado	t	f	t	f	800.00
2074	2172	CP007	2026-01-25	300.00	\N	Realizado	Despesas Operacionais	Compensado	t	f	t	f	300.00
2075	2173	CP008	2026-01-26	180.00	\N	Realizado	Contas Fixas	Compensado	t	f	t	f	180.00
2076	2174	CR009	2026-01-28	50.00	\N	Realizado	Despesas Operacionais	Compensado	t	f	t	f	50.00
2077	2175	CP010	2026-01-29	1500.00	\N	Realizado	Prestação de Serviços	Compensado	t	f	t	f	1500.00
2078	2176	CR011	2026-02-02	15000.00	\N	Realizado	Fornecedores	Compensado	t	f	t	f	15000.00
2079	2177	CP012	2026-02-03	5200.00	\N	Realizado	Vendas	Compensado	t	f	t	f	5200.00
2080	2178	CP013	2026-02-05	3500.00	\N	Realizado	Contas Fixas	Compensado	t	f	t	f	3500.00
2081	2179	CP014	2026-02-05	850.00	\N	Realizado	Despesas Operacionais	Compensado	t	f	t	f	850.00
2082	2180	CP015	2026-02-06	150.00	\N	Realizado	Despesas Operacionais	Compensado	t	f	t	f	150.00
2083	2181	CP016	2026-02-07	4800.00	\N	Realizado	Vendas	Compensado	t	f	t	f	4800.00
2084	2182	CR017	2026-02-08	500.00	\N	Realizado	Contas Fixas	Compensado	t	f	t	f	500.00
2085	2183	CP018	2026-02-09	1800.00	\N	Realizado	Renda Extra	Compensado	t	f	t	f	1800.00
2086	2184	CP019	2026-02-10	7000.00	\N	Realizado	Marketing	Compensado	t	f	t	f	7000.00
2087	2185	CR020	2026-02-12	6000.00	\N	Realizado	Vendas	Compensado	t	f	t	f	6000.00
2088	2186	CP021	2026-02-14	120.00	\N	Realizado	Logística	Compensado	t	f	t	f	120.00
2089	2187	CP022	2026-02-15	11000.00	\N	Realizado	Vendas	Compensado	t	f	t	f	11000.00
2090	2188	CR023	2026-02-16	480.00	\N	Realizado	Contas Fixas	Compensado	t	f	t	f	480.00
2091	2189	CP024	2026-02-17	900.00	\N	Realizado	Renda Extra	Compensado	t	f	t	f	900.00
2092	2190	CP025	2026-02-20	24500.00	\N	Realizado	Folha de Pagamento	Compensado	t	f	t	f	24500.00
2093	2191	CP026	2026-02-21	3500.00	\N	Realizado	Serviços Recorrentes	Compensado	t	f	t	f	3500.00
2094	2192	CR027	2026-02-22	400.00	\N	Realizado	Despesas Operacionais	Compensado	t	f	t	f	400.00
2095	2193	CP028	2026-02-23	7800.00	\N	Realizado	Vendas	Compensado	t	f	t	f	7800.00
2096	2194	CP029	2026-02-26	6500.00	\N	Realizado	Contas Fixas	Compensado	t	f	t	f	6500.00
2097	2195	CP030	2026-02-27	1500.00	\N	Realizado	Prestação de Serviços	Compensado	t	f	t	f	1500.00
2098	2196	CR031	2026-02-28	50.00	\N	Realizado	Despesas Operacionais	Compensado	t	f	t	f	50.00
2099	2349	CP019	2026-06-28	400.00	\N	Realizado	Vendas	Compensado	t	f	t	f	400.00
2100	2197	CP032	2026-02-01	600.00	\N	Realizado	Renda Extra	Compensado	t	f	t	f	600.00
2101	2198	CP033	2026-02-04	200.00	\N	Realizado	Logística	Compensado	t	f	t	f	200.00
2102	2199	CP034	2026-02-07	180.00	\N	Realizado	Contas Fixas	Compensado	t	f	t	f	180.00
2103	2200	CP035	2026-02-10	40.00	\N	Realizado	Contas Fixas	Compensado	t	f	t	f	40.00
2104	2201	CR036	2026-02-13	5000.00	\N	Realizado	Vendas	Compensado	t	f	t	f	5000.00
2105	2202	CP037	2026-02-18	100.00	\N	Realizado	Despesas Operacionais	Compensado	t	f	t	f	100.00
2106	2203	CP038	2026-02-20	800.00	\N	Realizado	Renda Extra	Compensado	t	f	t	f	800.00
2107	2204	CP039	2026-02-24	4500.00	\N	Realizado	Vendas	Compensado	t	f	t	f	4500.00
2108	2205	CR040	2026-02-25	300.00	\N	Realizado	Despesas Operacionais	Compensado	t	f	t	f	300.00
2109	2206	CP041	2026-02-26	180.00	\N	Realizado	Contas Fixas	Compensado	t	f	t	f	180.00
2110	2207	CP042	2026-02-27	2500.00	\N	Realizado	Vendas	Compensado	t	f	t	f	2500.00
2111	2208	CP043	2026-02-28	400.00	\N	Realizado	Vendas	Compensado	t	f	t	f	400.00
2112	2209	CR044	2026-02-23	50.00	\N	Realizado	Contas Fixas	Compensado	t	f	t	f	50.00
2113	2210	CP045	2026-02-24	1200.00	\N	Realizado	Despesas Operacionais	Compensado	t	f	t	f	1200.00
2114	2211	CP046	2026-03-02	30000.00	\N	Realizado	Fornecedores	Compensado	t	f	t	f	30000.00
2115	2212	CP047	2026-03-03	6500.00	\N	Realizado	Vendas	Compensado	t	f	t	f	6500.00
2116	2213	CR048	2026-03-05	3500.00	\N	Realizado	Contas Fixas	Compensado	t	f	t	f	3500.00
2117	2214	CP049	2026-03-05	850.00	\N	Realizado	Despesas Operacionais	Compensado	t	f	t	f	850.00
2118	2215	CP050	2026-03-06	150.00	\N	Realizado	Despesas Operacionais	Compensado	t	f	t	f	150.00
2119	2216	CP051	2026-03-07	8800.00	\N	Realizado	Vendas	Compensado	t	f	t	f	8800.00
2120	2217	CR052	2026-03-08	500.00	\N	Realizado	Contas Fixas	Compensado	t	f	t	f	500.00
2121	2218	CP053	2026-03-09	1800.00	\N	Realizado	Renda Extra	Compensado	t	f	t	f	1800.00
2122	2219	CP054	2026-03-10	19000.00	\N	Realizado	Fornecedores	Compensado	t	f	t	f	19000.00
2123	2220	CP055	2026-03-12	4500.00	\N	Realizado	Vendas	Compensado	t	f	t	f	4500.00
2124	2221	CR001	2026-03-14	120.00	\N	Realizado	Logística	Compensado	t	f	t	f	120.00
2125	2222	CP001	2026-03-15	9500.00	\N	Realizado	Vendas	Compensado	t	f	t	f	9500.00
2126	2223	CP002	2026-03-16	500.00	\N	Realizado	Contas Fixas	Compensado	t	f	t	f	500.00
2127	2224	CR003	2026-03-17	900.00	\N	Realizado	Renda Extra	Compensado	t	f	t	f	900.00
2128	2225	CP005	2026-03-20	24500.00	\N	Realizado	Folha de Pagamento	Compensado	t	f	t	f	24500.00
2129	2226	CP006	2026-03-21	3500.00	\N	Realizado	Serviços Recorrentes	Compensado	t	f	t	f	3500.00
2130	2227	CP007	2026-03-22	400.00	\N	Realizado	Despesas Operacionais	Compensado	t	f	t	f	400.00
2131	2228	CP008	2026-03-23	5500.00	\N	Realizado	Vendas	Compensado	t	f	t	f	5500.00
2132	2229	CR009	2026-03-26	6500.00	\N	Realizado	Contas Fixas	Compensado	t	f	t	f	6500.00
2133	2230	CP010	2026-03-27	1500.00	\N	Realizado	Prestação de Serviços	Compensado	t	f	t	f	1500.00
2134	2231	CR011	2026-03-28	50.00	\N	Realizado	Despesas Operacionais	Compensado	t	f	t	f	50.00
2135	2232	CP012	2026-03-30	400.00	\N	Realizado	Vendas	Compensado	t	f	t	f	400.00
2136	2233	CP013	2026-03-01	600.00	\N	Realizado	Renda Extra	Compensado	t	f	t	f	600.00
2137	2234	CP014	2026-03-04	200.00	\N	Realizado	Logística	Compensado	t	f	t	f	200.00
2138	2235	CP015	2026-03-07	180.00	\N	Realizado	Contas Fixas	Compensado	t	f	t	f	180.00
2139	2236	CP016	2026-03-10	40.00	\N	Realizado	Contas Fixas	Compensado	t	f	t	f	40.00
2140	2237	CR017	2026-03-13	5000.00	\N	Realizado	Vendas	Compensado	t	f	t	f	5000.00
2141	2238	CP018	2026-03-18	100.00	\N	Realizado	Despesas Operacionais	Compensado	t	f	t	f	100.00
2142	2239	CP019	2026-03-20	800.00	\N	Realizado	Renda Extra	Compensado	t	f	t	f	800.00
2143	2240	CR020	2026-03-24	4500.00	\N	Realizado	Vendas	Compensado	t	f	t	f	4500.00
2144	2241	CP021	2026-03-25	300.00	\N	Realizado	Despesas Operacionais	Compensado	t	f	t	f	300.00
2145	2242	CP022	2026-03-26	180.00	\N	Realizado	Contas Fixas	Compensado	t	f	t	f	180.00
2146	2243	CR023	2026-03-27	2500.00	\N	Realizado	Vendas	Compensado	t	f	t	f	2500.00
2147	2244	CP024	2026-03-28	400.00	\N	Realizado	Vendas	Compensado	t	f	t	f	400.00
2148	2245	CP025	2026-03-29	50.00	\N	Realizado	Contas Fixas	Compensado	t	f	t	f	50.00
2149	2246	CP026	2026-04-01	18000.00	\N	Realizado	Fornecedores	Compensado	t	f	t	f	18000.00
2150	2247	CR027	2026-04-02	7000.00	\N	Realizado	Vendas	Compensado	t	f	t	f	7000.00
2151	2248	CP028	2026-04-05	3500.00	\N	Realizado	Contas Fixas	Compensado	t	f	t	f	3500.00
2152	2249	CP029	2026-04-05	850.00	\N	Realizado	Despesas Operacionais	Compensado	t	f	t	f	850.00
2153	2250	CP030	2026-04-06	150.00	\N	Realizado	Despesas Operacionais	Compensado	t	f	t	f	150.00
2154	2251	CR031	2026-04-07	3600.00	\N	Realizado	Serviços Recorrentes	Compensado	t	f	t	f	3600.00
2155	2252	CP032	2026-04-08	500.00	\N	Realizado	Contas Fixas	Compensado	t	f	t	f	500.00
2156	2253	CP033	2026-04-09	1800.00	\N	Realizado	Renda Extra	Compensado	t	f	t	f	1800.00
2157	2254	CP034	2026-04-10	1500.00	\N	Realizado	Despesas Operacionais	Compensado	t	f	t	f	1500.00
2158	2255	CP035	2026-04-12	5500.00	\N	Realizado	Vendas	Compensado	t	f	t	f	5500.00
2159	2256	CR036	2026-04-14	120.00	\N	Realizado	Logística	Compensado	t	f	t	f	120.00
2160	2257	CP037	2026-04-15	11000.00	\N	Realizado	Vendas	Compensado	t	f	t	f	11000.00
2161	2258	CP038	2026-04-16	450.00	\N	Realizado	Contas Fixas	Compensado	t	f	t	f	450.00
2162	2259	CP039	2026-04-17	900.00	\N	Realizado	Renda Extra	Compensado	t	f	t	f	900.00
2163	2260	CR040	2026-04-20	24500.00	\N	Realizado	Folha de Pagamento	Compensado	t	f	t	f	24500.00
2164	2261	CP041	2026-04-21	3500.00	\N	Realizado	Vendas	Compensado	t	f	t	f	3500.00
2165	2262	CP042	2026-04-22	400.00	\N	Realizado	Despesas Operacionais	Compensado	t	f	t	f	400.00
2166	2263	CP043	2026-04-23	6000.00	\N	Realizado	Vendas	Compensado	t	f	t	f	6000.00
2167	2264	CR044	2026-04-26	5500.00	\N	Realizado	Contas Fixas	Compensado	t	f	t	f	5500.00
2168	2265	CP045	2026-04-27	1500.00	\N	Realizado	Prestação de Serviços	Compensado	t	f	t	f	1500.00
2169	2266	CP046	2026-04-28	50.00	\N	Realizado	Despesas Operacionais	Compensado	t	f	t	f	50.00
2170	2267	CP047	2026-04-30	400.00	\N	Realizado	Vendas	Compensado	t	f	t	f	400.00
2171	2268	CR048	2026-04-01	600.00	\N	Realizado	Renda Extra	Compensado	t	f	t	f	600.00
2172	2269	CP049	2026-04-04	200.00	\N	Realizado	Logística	Compensado	t	f	t	f	200.00
2173	2270	CP050	2026-04-07	180.00	\N	Realizado	Contas Fixas	Compensado	t	f	t	f	180.00
2174	2271	CP051	2026-04-10	40.00	\N	Realizado	Contas Fixas	Compensado	t	f	t	f	40.00
2175	2272	CR052	2026-04-13	5000.00	\N	Realizado	Vendas	Compensado	t	f	t	f	5000.00
2176	2273	CP053	2026-04-18	100.00	\N	Realizado	Despesas Operacionais	Compensado	t	f	t	f	100.00
2177	2274	CP054	2026-04-20	800.00	\N	Realizado	Renda Extra	Compensado	t	f	t	f	800.00
2178	2275	CP055	2026-04-24	4500.00	\N	Realizado	Vendas	Compensado	t	f	t	f	4500.00
2179	2276	CR001	2026-04-25	300.00	\N	Realizado	Despesas Operacionais	Compensado	t	f	t	f	300.00
2180	2326	CP051	2026-06-14	120.00	\N	Realizado	Logística	Compensado	t	f	t	f	120.00
2181	2277	CP001	2026-04-26	180.00	\N	Realizado	Contas Fixas	Compensado	t	f	t	f	180.00
2182	2278	CP002	2026-04-27	2500.00	\N	Realizado	Vendas	Compensado	t	f	t	f	2500.00
2184	2280	CP005	2026-04-29	50.00	\N	Realizado	Contas Fixas	Compensado	t	f	t	f	50.00
2185	2281	CP006	2026-05-01	15000.00	\N	Realizado	Fornecedores	Compensado	t	f	t	f	15000.00
2186	2282	CP007	2026-05-02	5500.00	\N	Realizado	Vendas	Compensado	t	f	t	f	5500.00
2187	2283	CP008	2026-05-05	3500.00	\N	Realizado	Contas Fixas	Compensado	t	f	t	f	3500.00
2188	2284	CR009	2026-05-05	850.00	\N	Realizado	Despesas Operacionais	Compensado	t	f	t	f	850.00
2189	2285	CP010	2026-05-06	150.00	\N	Realizado	Despesas Operacionais	Compensado	t	f	t	f	150.00
2190	2286	CR011	2026-05-07	3600.00	\N	Realizado	Serviços Recorrentes	Compensado	t	f	t	f	3600.00
2191	2287	CP012	2026-05-08	500.00	\N	Realizado	Contas Fixas	Compensado	t	f	t	f	500.00
2192	2288	CP013	2026-05-09	1800.00	\N	Realizado	Renda Extra	Compensado	t	f	t	f	1800.00
2193	2289	CP014	2026-05-10	10000.00	\N	Realizado	Marketing	Compensado	t	f	t	f	10000.00
2194	2290	CP015	2026-05-12	7800.00	\N	Realizado	Vendas	Compensado	t	f	t	f	7800.00
2195	2291	CP016	2026-05-14	120.00	\N	Realizado	Logística	Compensado	t	f	t	f	120.00
2196	2292	CR017	2026-05-15	5500.00	\N	Realizado	Vendas	Compensado	t	f	t	f	5500.00
2197	2293	CP018	2026-05-16	450.00	\N	Realizado	Contas Fixas	Compensado	t	f	t	f	450.00
2198	2294	CP019	2026-05-17	900.00	\N	Realizado	Renda Extra	Compensado	t	f	t	f	900.00
2199	2295	CR020	2026-05-20	24500.00	\N	Realizado	Folha de Pagamento	Compensado	t	f	t	f	24500.00
2200	2296	CP021	2026-05-21	3500.00	\N	Realizado	Vendas	Compensado	t	f	t	f	3500.00
2201	2297	CP022	2026-05-22	400.00	\N	Realizado	Despesas Operacionais	Compensado	t	f	t	f	400.00
2202	2298	CR023	2026-05-23	6500.00	\N	Realizado	Vendas	Compensado	t	f	t	f	6500.00
2203	2299	CP024	2026-05-26	6000.00	\N	Realizado	Contas Fixas	Compensado	t	f	t	f	6000.00
2204	2300	CP025	2026-05-27	1500.00	\N	Realizado	Prestação de Serviços	Compensado	t	f	t	f	1500.00
2205	2301	CP026	2026-05-28	50.00	\N	Realizado	Despesas Operacionais	Compensado	t	f	t	f	50.00
2206	2302	CR027	2026-05-30	400.00	\N	Realizado	Vendas	Compensado	t	f	t	f	400.00
2207	2303	CP028	2026-05-01	600.00	\N	Realizado	Renda Extra	Compensado	t	f	t	f	600.00
2208	2304	CP029	2026-05-04	200.00	\N	Realizado	Logística	Compensado	t	f	t	f	200.00
2209	2305	CP030	2026-05-07	180.00	\N	Realizado	Contas Fixas	Compensado	t	f	t	f	180.00
2210	2306	CR031	2026-05-10	40.00	\N	Realizado	Contas Fixas	Compensado	t	f	t	f	40.00
2211	2307	CP032	2026-05-13	5000.00	\N	Realizado	Vendas	Compensado	t	f	t	f	5000.00
2212	2308	CP033	2026-05-18	100.00	\N	Realizado	Despesas Operacionais	Compensado	t	f	t	f	100.00
2213	2309	CP034	2026-05-20	800.00	\N	Realizado	Renda Extra	Compensado	t	f	t	f	800.00
2214	2310	CP035	2026-05-24	4500.00	\N	Realizado	Vendas	Compensado	t	f	t	f	4500.00
2215	2311	CR036	2026-05-25	300.00	\N	Realizado	Despesas Operacionais	Compensado	t	f	t	f	300.00
2216	2312	CP037	2026-05-26	180.00	\N	Realizado	Contas Fixas	Compensado	t	f	t	f	180.00
2217	2313	CP038	2026-05-27	2500.00	\N	Realizado	Vendas	Compensado	t	f	t	f	2500.00
2218	2314	CP039	2026-05-28	400.00	\N	Realizado	Vendas	Compensado	t	f	t	f	400.00
2219	2315	CR040	2026-05-29	50.00	\N	Realizado	Contas Fixas	Compensado	t	f	t	f	50.00
2220	2316	CP041	2026-06-01	25000.00	\N	Realizado	Fornecedores	Compensado	t	f	t	f	25000.00
2221	2317	CP042	2026-06-02	5000.00	\N	Realizado	Vendas	Compensado	t	f	t	f	5000.00
2222	2318	CP043	2026-06-05	3500.00	\N	Realizado	Contas Fixas	Compensado	t	f	t	f	3500.00
2223	2319	CR044	2026-06-05	850.00	\N	Realizado	Despesas Operacionais	Compensado	t	f	t	f	850.00
2224	2320	CP045	2026-06-06	150.00	\N	Realizado	Despesas Operacionais	Compensado	t	f	t	f	150.00
2225	2321	CP046	2026-06-07	3600.00	\N	Realizado	Serviços Recorrentes	Compensado	t	f	t	f	3600.00
2226	2322	CP047	2026-06-08	500.00	\N	Realizado	Contas Fixas	Compensado	t	f	t	f	500.00
2227	2323	CR048	2026-06-09	1800.00	\N	Realizado	Renda Extra	Compensado	t	f	t	f	1800.00
2228	2324	CP049	2026-06-10	1500.00	\N	Realizado	Manutenção	Compensado	t	f	t	f	1500.00
2229	2325	CP050	2026-06-12	12500.00	\N	Realizado	Vendas	Compensado	t	f	t	f	12500.00
2230	2327	CR052	2026-06-15	7000.00	\N	Realizado	Vendas	Compensado	t	f	t	f	7000.00
2231	2328	CP053	2026-06-16	450.00	\N	Realizado	Contas Fixas	Compensado	t	f	t	f	450.00
2232	2329	CP054	2026-06-17	900.00	\N	Realizado	Renda Extra	Compensado	t	f	t	f	900.00
2233	2330	CP055	2026-06-20	24500.00	\N	Realizado	Folha de Pagamento	Compensado	t	f	t	f	24500.00
2234	2331	CR001	2026-06-21	3500.00	\N	Realizado	Vendas	Compensado	t	f	t	f	3500.00
2235	2332	CP001	2026-06-22	400.00	\N	Realizado	Despesas Operacionais	Compensado	t	f	t	f	400.00
2236	2333	CP002	2026-06-23	13000.00	\N	Realizado	Vendas	Compensado	t	f	t	f	13000.00
2237	2334	CR003	2026-06-26	6000.00	\N	Realizado	Contas Fixas	Compensado	t	f	t	f	6000.00
2238	2335	CP005	2026-06-27	1500.00	\N	Realizado	Prestação de Serviços	Compensado	t	f	t	f	1500.00
2239	2336	CP006	2026-06-28	50.00	\N	Realizado	Despesas Operacionais	Compensado	t	f	t	f	50.00
2240	2337	CP007	2026-06-30	400.00	\N	Realizado	Vendas	Compensado	t	f	t	f	400.00
2241	2338	CP008	2026-06-01	600.00	\N	Realizado	Renda Extra	Compensado	t	f	t	f	600.00
2242	2339	CR009	2026-06-04	200.00	\N	Realizado	Logística	Compensado	t	f	t	f	200.00
2243	2340	CP010	2026-06-07	180.00	\N	Realizado	Contas Fixas	Compensado	t	f	t	f	180.00
2244	2341	CR011	2026-06-10	40.00	\N	Realizado	Contas Fixas	Compensado	t	f	t	f	40.00
2245	2342	CP012	2026-06-13	5000.00	\N	Realizado	Vendas	Compensado	t	f	t	f	5000.00
2246	2343	CP013	2026-06-18	100.00	\N	Realizado	Despesas Operacionais	Compensado	t	f	t	f	100.00
2247	2344	CP014	2026-06-20	800.00	\N	Realizado	Renda Extra	Compensado	t	f	t	f	800.00
2248	2345	CP015	2026-06-24	4500.00	\N	Realizado	Vendas	Compensado	t	f	t	f	4500.00
2249	2346	CP016	2026-06-25	300.00	\N	Realizado	Despesas Operacionais	Compensado	t	f	t	f	300.00
2250	2347	CR017	2026-06-26	180.00	\N	Realizado	Contas Fixas	Compensado	t	f	t	f	180.00
2251	2348	CP018	2026-06-27	2500.00	\N	Realizado	Vendas	Compensado	t	f	t	f	2500.00
2252	2350	CR020	2026-06-29	50.00	\N	Realizado	Contas Fixas	Compensado	t	f	t	f	50.00
2253	2351	CP021	2026-07-01	20000.00	\N	Realizado	Fornecedores	Compensado	t	f	t	f	20000.00
2254	2352	CP022	2026-07-02	6200.00	\N	Realizado	Vendas	Compensado	t	f	t	f	6200.00
2255	2353	CR023	2026-07-05	3500.00	\N	Realizado	Contas Fixas	Compensado	t	f	t	f	3500.00
2256	2354	CP024	2026-07-05	850.00	\N	Realizado	Despesas Operacionais	Compensado	t	f	t	f	850.00
2257	2355	CP025	2026-07-06	150.00	\N	Realizado	Despesas Operacionais	Compensado	t	f	t	f	150.00
2258	2356	CP026	2026-07-07	3600.00	\N	Realizado	Serviços Recorrentes	Compensado	t	f	t	f	3600.00
2259	2357	CR027	2026-07-08	500.00	\N	Realizado	Contas Fixas	Compensado	t	f	t	f	500.00
2260	2358	CP028	2026-07-09	1800.00	\N	Realizado	Renda Extra	Compensado	t	f	t	f	1800.00
2261	2359	CP029	2026-07-10	1500.00	\N	Realizado	Manutenção	Compensado	t	f	t	f	1500.00
2262	2360	CP030	2026-07-12	8500.00	\N	Realizado	Vendas	Compensado	t	f	t	f	8500.00
2263	2361	CR031	2026-07-14	120.00	\N	Realizado	Logística	Compensado	t	f	t	f	120.00
2264	2362	CP032	2026-07-15	6200.00	\N	Realizado	Vendas	Compensado	t	f	t	f	6200.00
2265	2363	CP033	2026-07-16	450.00	\N	Realizado	Contas Fixas	Compensado	t	f	t	f	450.00
2266	2364	CP034	2026-07-17	900.00	\N	Realizado	Renda Extra	Compensado	t	f	t	f	900.00
2267	2365	CP035	2026-07-20	24500.00	\N	Realizado	Folha de Pagamento	Compensado	t	f	t	f	24500.00
2268	2366	CR036	2026-07-21	3500.00	\N	Realizado	Vendas	Compensado	t	f	t	f	3500.00
2269	2367	CP037	2026-07-22	400.00	\N	Realizado	Despesas Operacionais	Compensado	t	f	t	f	400.00
2270	2368	CP038	2026-07-23	7800.00	\N	Realizado	Vendas	Compensado	t	f	t	f	7800.00
2295	2394	CR009	2026-08-10	7500.00	\N	Realizado	Marketing	Compensado	t	f	t	f	7500.00
2296	2395	CP010	2026-08-12	9000.00	\N	Realizado	Vendas	Compensado	t	f	t	f	9000.00
2297	2396	CR011	2026-08-14	120.00	\N	Realizado	Logística	Compensado	t	f	t	f	120.00
2298	2397	CP012	2026-08-15	9500.00	\N	Realizado	Vendas	Compensado	t	f	t	f	9500.00
2299	2398	CP013	2026-08-16	450.00	\N	Realizado	Contas Fixas	Compensado	t	f	t	f	450.00
2300	2399	CP014	2026-08-17	900.00	\N	Realizado	Renda Extra	Compensado	t	f	t	f	900.00
2301	2400	CP015	2026-08-20	24500.00	\N	Realizado	Folha de Pagamento	Compensado	t	f	t	f	24500.00
2302	2401	CP016	2026-08-21	3500.00	\N	Realizado	Vendas	Compensado	t	f	t	f	3500.00
2303	2402	CR017	2026-08-22	400.00	\N	Realizado	Despesas Operacionais	Compensado	t	f	t	f	400.00
2304	2403	CP018	2026-08-23	6500.00	\N	Realizado	Vendas	Compensado	t	f	t	f	6500.00
2305	2404	CP019	2026-08-26	6000.00	\N	Realizado	Contas Fixas	Compensado	t	f	t	f	6000.00
2306	2405	CR020	2026-08-27	1500.00	\N	Realizado	Prestação de Serviços	Compensado	t	f	t	f	1500.00
2307	2406	CP021	2026-08-28	50.00	\N	Realizado	Despesas Operacionais	Compensado	t	f	t	f	50.00
2308	2408	CR023	2026-08-01	600.00	\N	Realizado	Renda Extra	Compensado	t	f	t	f	600.00
2309	2409	CP024	2026-08-04	200.00	\N	Realizado	Logística	Compensado	t	f	t	f	200.00
2310	2410	CP025	2026-08-07	180.00	\N	Realizado	Contas Fixas	Compensado	t	f	t	f	180.00
2311	2411	CP026	2026-08-10	40.00	\N	Realizado	Contas Fixas	Compensado	t	f	t	f	40.00
2312	2412	CR027	2026-08-13	5000.00	\N	Realizado	Vendas	Compensado	t	f	t	f	5000.00
2313	2413	CP028	2026-08-18	100.00	\N	Realizado	Despesas Operacionais	Compensado	t	f	t	f	100.00
2314	2414	CP029	2026-08-20	800.00	\N	Realizado	Renda Extra	Compensado	t	f	t	f	800.00
2315	2415	CP030	2026-08-24	4500.00	\N	Realizado	Vendas	Compensado	t	f	t	f	4500.00
2316	2416	CR031	2026-08-25	300.00	\N	Realizado	Despesas Operacionais	Compensado	t	f	t	f	300.00
2317	2417	CP032	2026-08-26	180.00	\N	Realizado	Contas Fixas	Compensado	t	f	t	f	180.00
2318	2418	CP033	2026-08-27	2500.00	\N	Realizado	Vendas	Compensado	t	f	t	f	2500.00
2319	2419	CP034	2026-08-28	400.00	\N	Realizado	Vendas	Compensado	t	f	t	f	400.00
2320	2420	CP035	2026-08-29	50.00	\N	Realizado	Contas Fixas	Compensado	t	f	t	f	50.00
1915	2013	CP013	2025-09-09	4200.00	\N	Realizado	Vendas	Compensado	t	f	t	f	4200.00
1901	2164	CP054	2026-01-31	400.00	\N	Realizado	Vendas	Compensado	t	f	t	f	400.00
1902	2001	CR001	2025-09-01	5200.00	\N	Realizado	Vendas	Compensado	t	f	t	f	5200.00
1903	2002	CP001	2025-09-01	450.00	\N	Realizado	Despesas Operacionais	Compensado	t	f	t	f	450.00
1904	2003	CP002	2025-09-01	1800.00	\N	Realizado	Prestação de Serviços	Compensado	t	f	t	f	1800.00
2271	2369	CP039	2026-07-26	6000.00	\N	Realizado	Contas Fixas	Compensado	t	f	t	f	6000.00
2272	2370	CR040	2026-07-27	1500.00	\N	Realizado	Prestação de Serviços	Compensado	t	f	t	f	1500.00
2273	2372	CP042	2026-07-30	400.00	\N	Realizado	Vendas	Compensado	t	f	t	f	400.00
2274	2373	CP043	2026-07-01	600.00	\N	Realizado	Renda Extra	Compensado	t	f	t	f	600.00
2275	2374	CR044	2026-07-04	200.00	\N	Realizado	Logística	Compensado	t	f	t	f	200.00
2276	2375	CP045	2026-07-07	180.00	\N	Realizado	Contas Fixas	Compensado	t	f	t	f	180.00
2277	2376	CP046	2026-07-10	40.00	\N	Realizado	Contas Fixas	Compensado	t	f	t	f	40.00
2278	2377	CP047	2026-07-13	5000.00	\N	Realizado	Vendas	Compensado	t	f	t	f	5000.00
2279	2378	CR048	2026-07-18	100.00	\N	Realizado	Despesas Operacionais	Compensado	t	f	t	f	100.00
2280	2379	CP049	2026-07-20	800.00	\N	Realizado	Renda Extra	Compensado	t	f	t	f	800.00
2281	2380	CP050	2026-07-24	4500.00	\N	Realizado	Vendas	Compensado	t	f	t	f	4500.00
2282	2381	CP051	2026-07-25	300.00	\N	Realizado	Despesas Operacionais	Compensado	t	f	t	f	300.00
2283	2382	CR052	2026-07-26	180.00	\N	Realizado	Contas Fixas	Compensado	t	f	t	f	180.00
2284	2383	CP053	2026-07-27	2500.00	\N	Realizado	Vendas	Compensado	t	f	t	f	2500.00
2285	2384	CP054	2026-07-28	400.00	\N	Realizado	Vendas	Compensado	t	f	t	f	400.00
2286	2385	CP055	2026-07-29	50.00	\N	Realizado	Contas Fixas	Compensado	t	f	t	f	50.00
2287	2386	CR001	2026-08-01	22000.00	\N	Realizado	Fornecedores	Compensado	t	f	t	f	22000.00
2288	2387	CP001	2026-08-02	7500.00	\N	Realizado	Vendas	Compensado	t	f	t	f	7500.00
2289	2388	CP002	2026-08-05	3500.00	\N	Realizado	Contas Fixas	Compensado	t	f	t	f	3500.00
2290	2389	CR003	2026-08-05	850.00	\N	Realizado	Despesas Operacionais	Compensado	t	f	t	f	850.00
2291	2390	CP005	2026-08-06	150.00	\N	Realizado	Despesas Operacionais	Compensado	t	f	t	f	150.00
2292	2391	CP006	2026-08-07	3600.00	\N	Realizado	Serviços Recorrentes	Compensado	t	f	t	f	3600.00
2293	2392	CP007	2026-08-08	500.00	\N	Realizado	Contas Fixas	Compensado	t	f	t	f	500.00
2294	2393	CP008	2026-08-09	1800.00	\N	Realizado	Renda Extra	Compensado	t	f	t	f	1800.00
\.


--
-- TOC entry 4955 (class 0 OID 41018)
-- Dependencies: 223
-- Data for Name: contas_planejadas; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.contas_planejadas (id_conta, tipo_conta, descricao_detalhada, valor_previsto, data_vencimento, categoria_financeira, status_cobranca, parceiro, condicao_pagamento) FROM stdin;
CR001	Receber	Fatura de Venda Lote 25	9500.00	2025-11-15	Vendas Futuras	Pago	Cliente Tau	15 DDL
CP001	Pagar	Salários de Novembro (Provisão)	-23000.00	2025-11-20	Folha de Pagamento	Pago	RH - Funcionários	Mensal
CP002	Pagar	Campanha Black Friday (2ª parcela)	-4000.00	2025-11-30	Marketing	Pago	Agência Digital	2x
CR003	Receber	Venda de Produto Especial	1200.00	2025-12-05	Vendas Futuras	Aberto	Cliente Epsilon	À Vista
CP005	Pagar	Aluguel do Escritório (Dez)	-3500.00	2025-12-05	Contas Fixas	Aberto	Locadora Imóveis	Mensal
CP006	Pagar	Compra de Estoque (Natal)	-15000.00	2025-12-08	Fornecedores	Aberto	Fornecedor Beta	45 DDL
CP007	Pagar	13º Salário (Provisão)	-15000.00	2025-12-20	Folha de Pagamento	Aberto	RH - Funcionários	Único
CP008	Pagar	Salários de Dezembro	-23000.00	2025-12-20	Folha de Pagamento	Aberto	RH - Funcionários	Mensal
CR009	Receber	Pagamento de Serviço de Dezembro	3500.00	2025-12-25	Serviços Recorrentes	Aberto	Empresa Serviços Z	Mensal
CP010	Pagar	Impostos Mensais (Dez)	-6000.00	2025-12-30	Contas Fixas	Aberto	Receita Federal	Mensal
CR011	Receber	Venda Lote 27	7500.00	2026-01-05	Vendas Futuras	Aberto	Cliente Gama	30 DDL
CP012	Pagar	Aluguel do Escritório (Jan)	-3500.00	2026-01-05	Contas Fixas	Aberto	Locadora Imóveis	Mensal
CP013	Pagar	Mensalidade de Software ERP (Jan)	-850.00	2026-01-05	Despesas Operacionais	Aberto	Fornecedor de TI	Boleto
CP014	Pagar	Compra de Matéria-Prima (Pedido 56)	-21000.00	2026-01-10	Fornecedores	Aberto	Fornecedor Delta	30 DDL
CP015	Pagar	Salários de Janeiro (Provisão)	-24000.00	2026-01-20	Folha de Pagamento	Aberto	RH - Funcionários	Mensal
CP016	Pagar	Renovação de Contrato Anual TI	-15000.00	2026-01-28	Despesas Operacionais	Aberto	Fornecedor de TI	TED
CR017	Receber	Venda Lote 28	4800.00	2026-02-05	Vendas Futuras	Aberto	Cliente Omicron	45 DDL
CP018	Pagar	Aluguel do Escritório (Fev)	-3500.00	2026-02-05	Contas Fixas	Aberto	Locadora Imóveis	Mensal
CP019	Pagar	Marketing de Lançamento (Fev)	-7000.00	2026-02-15	Marketing	Aberto	Agência Digital	30 DDL
CR020	Receber	Fatura de Venda Lote 29	11000.00	2026-02-15	Vendas Futuras	Aberto	Cliente Tau	30 DDL
CP021	Pagar	Salários de Fevereiro (Provisão)	-24500.00	2026-02-20	Folha de Pagamento	Aberto	RH - Funcionários	Mensal
CP022	Pagar	Impostos Mensais (Fev)	-6500.00	2026-02-28	Contas Fixas	Aberto	Receita Federal	Mensal
CR023	Receber	Fatura de Venda Lote 31	8800.00	2026-03-05	Vendas Futuras	Aberto	Cliente Mu	30 DDL
CP024	Pagar	Aluguel do Escritório (Mar)	-3500.00	2026-03-05	Contas Fixas	Aberto	Locadora Imóveis	Mensal
CP025	Pagar	Compra de Estoque (Mar)	-19000.00	2026-03-10	Fornecedores	Aberto	Fornecedor Kappa	45 DDL
CP026	Pagar	Salários de Março (Provisão)	-24500.00	2026-03-20	Folha de Pagamento	Aberto	RH - Funcionários	Mensal
CR027	Receber	Pagamento de Serviços Recorrentes (Abr)	3600.00	2026-04-05	Serviços Recorrentes	Aberto	Empresa Serviços Z	Mensal
CP028	Pagar	Aluguel do Escritório (Abr)	-3500.00	2026-04-05	Contas Fixas	Aberto	Locadora Imóveis	Mensal
CP029	Pagar	Salários de Abril (Provisão)	-24500.00	2026-04-20	Folha de Pagamento	Aberto	RH - Funcionários	Mensal
CP030	Pagar	Impostos Trimestrais	-5500.00	2026-04-28	Contas Fixas	Aberto	Receita Federal	Trimestral
CR031	Receber	Venda Lote 38	5500.00	2026-05-15	Vendas Futuras	Aberto	Cliente Zeta	30 DDL
CP032	Pagar	Aluguel do Escritório (Mai)	-3500.00	2026-05-05	Contas Fixas	Aberto	Locadora Imóveis	Mensal
CP033	Pagar	Marketing (Meio do Ano)	-10000.00	2026-05-10	Marketing	Aberto	Agência Digital	TED
CP034	Pagar	Salários de Maio (Provisão)	-24500.00	2026-05-20	Folha de Pagamento	Aberto	RH - Funcionários	Mensal
CP035	Pagar	Impostos Mensais (Mai)	-6000.00	2026-05-30	Contas Fixas	Aberto	Receita Federal	Mensal
CR036	Receber	Fatura de Venda Lote 42	12500.00	2026-06-15	Vendas Futuras	Aberto	Cliente Lambda	30 DDL
CP037	Pagar	Aluguel do Escritório (Jun)	-3500.00	2026-06-05	Contas Fixas	Aberto	Locadora Imóveis	Mensal
CP038	Pagar	Compra de Estoque (Jun)	-25000.00	2026-06-18	Fornecedores	Aberto	Fornecedor Delta	30 DDL
CP039	Pagar	Salários de Junho (Provisão)	-24500.00	2026-06-20	Folha de Pagamento	Aberto	RH - Funcionários	Mensal
CR040	Receber	Renda de Aluguéis Imóvel 1 (Jul)	1800.00	2026-07-10	Renda Extra	Aberto	Inquilino A	Mensal
CP041	Pagar	Aluguel do Escritório (Jul)	-3500.00	2026-07-05	Contas Fixas	Aberto	Locadora Imóveis	Mensal
CP042	Pagar	Salários de Julho (Provisão)	-24500.00	2026-07-20	Folha de Pagamento	Aberto	RH - Funcionários	Mensal
CP043	Pagar	Impostos Mensais (Jul)	-6000.00	2026-07-30	Contas Fixas	Aberto	Receita Federal	Mensal
CR044	Receber	Venda Lote 48	9500.00	2026-08-15	Vendas Futuras	Aberto	Cliente Tau	30 DDL
CP045	Pagar	Aluguel do Escritório (Ago)	-3500.00	2026-08-05	Contas Fixas	Aberto	Locadora Imóveis	Mensal
CP046	Pagar	Salários de Agosto (Provisão)	-24500.00	2026-08-20	Folha de Pagamento	Aberto	RH - Funcionários	Mensal
CP047	Pagar	Marketing (Nova Campanha)	-7500.00	2026-08-25	Marketing	Aberto	Agência Digital	Boleto
CR048	Receber	Fatura de Venda Lote 52	7200.00	2026-09-15	Vendas Futuras	Aberto	Cliente Gamma	45 DDL
CP049	Pagar	Aluguel do Escritório (Set)	-3500.00	2026-09-05	Contas Fixas	Aberto	Locadora Imóveis	Mensal
CP050	Pagar	Salários de Setembro (Provisão)	-25000.00	2026-09-20	Folha de Pagamento	Aberto	RH - Funcionários	Mensal
CP051	Pagar	Compra de Estoque (Set)	-28000.00	2026-09-25	Fornecedores	Aberto	Fornecedor Kappa	45 DDL
CR052	Receber	Venda Lote 55	15000.00	2026-10-15	Vendas Futuras	Aberto	Cliente Alfa	60 DDL
CP053	Pagar	Aluguel do Escritório (Out)	-3500.00	2026-10-05	Contas Fixas	Aberto	Locadora Imóveis	Mensal
CP054	Pagar	Salários de Outubro (Provisão)	-25000.00	2026-10-20	Folha de Pagamento	Aberto	RH - Funcionários	Mensal
CP055	Pagar	Impostos Mensais (Out)	-6200.00	2026-10-30	Contas Fixas	Aberto	Receita Federal	Mensal
\.


--
-- TOC entry 4954 (class 0 OID 41007)
-- Dependencies: 222
-- Data for Name: transacoes_realizadas; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.transacoes_realizadas (id_transacao, data_transacao, hora_transacao, data_hora, tipo, valor, descricao, categoria, conta, meio_pagamento, status, estabelecimento, id_conta) FROM stdin;
2001	2025-09-01	09:15:00	2025-09-01 09:15:00	Entrada	5200.00	Venda Lote 1	Vendas	Banco A (Corrente)	PIX	Compensado	Cliente Alfa	CR001
2002	2025-09-01	14:45:00	2025-09-01 14:45:00	Saída	-450.00	Material de Escritório	Despesas Operacionais	Caixa	Dinheiro	Compensado	Papelaria Central	CP001
2003	2025-09-01	17:55:00	2025-09-01 17:55:00	Entrada	1800.00	Prestação de Serviço (Mês Anterior)	Prestação de Serviços	Banco A (Corrente)	Boleto	Compensado	Empresa Serviços Z	CP002
2004	2025-09-02	11:30:00	2025-09-02 11:30:00	Saída	-25000.00	Pagamento Fornecedor Principal	Fornecedores	Banco A (Corrente)	TED	Compensado	Fornecedor Delta	CR003
2005	2025-09-03	08:50:00	2025-09-03 08:50:00	Saída	-30.00	Taxa Bancária Mensal	Contas Fixas	Banco A (Corrente)	Débito Automático	Compensado	Banco A	CP005
2006	2025-09-04	10:00:00	2025-09-04 10:00:00	Saída	-8000.00	Campanha de Marketing Digital	Marketing	Banco A (Corrente)	Boleto	Compensado	Agência Digital	CP006
2007	2025-09-04	14:00:00	2025-09-04 14:00:00	Entrada	600.00	Renda de Aluguéis Imóvel 1	Renda Extra	Banco B (Poupança)	TED	Compensado	Inquilino A	CP007
2008	2025-09-05	10:30:00	2025-09-05 10:30:00	Saída	-3500.00	Aluguel do Escritório	Contas Fixas	Banco A (Corrente)	Boleto	Compensado	Locadora Imóveis	CP008
2009	2025-09-05	14:00:00	2025-09-05 14:00:00	Entrada	3500.00	Venda Lote 2	Vendas	Banco A (Corrente)	PIX	Compensado	Cliente Gamma	CR009
2010	2025-09-06	15:20:00	2025-09-06 15:20:00	Saída	-150.00	Manutenção de Computadores	Despesas Operacionais	Caixa	Dinheiro	Compensado	Técnico Info	CP010
2011	2025-09-08	09:00:00	2025-09-08 09:00:00	Entrada	7500.00	Venda Lote 3 (Grande)	Vendas	Banco A (Corrente)	TED	Compensado	Cliente Delta	CR011
2012	2025-09-08	11:45:00	2025-09-08 11:45:00	Saída	-200.00	Combustível para Entrega	Logística	Cartão Crédito	Cartão Crédito	Compensado	Posto Ipiranga	CP012
2013	2025-09-09	13:00:00	2025-09-09 13:00:00	Entrada	4200.00	Venda Lote 4	Vendas	Banco A (Corrente)	PIX	Compensado	Cliente Alfa	CP013
2014	2025-09-10	16:50:00	2025-09-10 16:50:00	Saída	-1200.00	Serviço de Limpeza	Despesas Operacionais	Banco A (Corrente)	TED	Compensado	Empresa Limpeza	CP014
2015	2025-09-11	10:00:00	2025-09-11 10:00:00	Entrada	900.00	Venda de Acessórios	Vendas	Caixa	Dinheiro	Compensado	Cliente Eta	CP015
2016	2025-09-11	17:15:00	2025-09-11 17:15:00	Saída	-40000.00	Compra de Matéria-Prima	Fornecedores	Banco A (Corrente)	TED	Compensado	Fornecedor Kappa	CP016
2017	2025-09-12	14:20:00	2025-09-12 14:20:00	Entrada	500.00	Reembolso de Despesa de Viagem	Renda Extra	Banco B (Poupança)	PIX	Compensado	Sócio Alfa	CR017
2018	2025-09-13	09:30:00	2025-09-13 09:30:00	Saída	-180.00	Mensalidade de Internet	Contas Fixas	Banco A (Corrente)	Débito Automático	Compensado	Provedor NET	CP018
2019	2025-09-15	16:00:00	2025-09-15 16:00:00	Entrada	15000.00	Venda Lote 5 (Muito Grande)	Vendas	Banco A (Corrente)	TED	Compensado	Cliente Beta	CP019
2020	2025-09-16	12:00:00	2025-09-16 12:00:00	Saída	-1500.00	Serviço de Contabilidade	Despesas Operacionais	Banco A (Corrente)	Boleto	Compensado	Contador XPTO	CR020
2021	2025-09-17	14:00:00	2025-09-17 14:00:00	Entrada	2200.00	Venda Lote 6	Vendas	Banco A (Corrente)	PIX	Compensado	Cliente Zeta	CP021
2022	2025-09-17	18:00:00	2025-09-17 18:00:00	Saída	-150.00	Material de Copa	Despesas Operacionais	Caixa	Dinheiro	Compensado	Supermercado Local	CP022
2023	2025-09-18	11:00:00	2025-09-18 11:00:00	Entrada	800.00	Venda de Conserto	Prestação de Serviços	Banco A (Corrente)	PIX	Compensado	Cliente Theta	CR023
2024	2025-09-18	16:00:00	2025-09-18 16:00:00	Saída	-500.00	Licença de Software Mensal	Contas Fixas	Cartão Crédito	Cartão Crédito	Compensado	Software Service	CP024
2025	2025-09-19	10:00:00	2025-09-19 10:00:00	Saída	-3000.00	Pagamento Parcial Fornecedor Beta	Fornecedores	Banco A (Corrente)	TED	Compensado	Fornecedor Beta	CP025
2026	2025-09-20	14:00:00	2025-09-20 14:00:00	Entrada	6500.00	Venda Lote 7 (Fechamento)	Vendas	Banco A (Corrente)	TED	Compensado	Cliente Iota	CP026
2027	2025-09-21	10:00:00	2025-09-21 10:00:00	Saída	-250.00	Jantar de Negócios	Despesas Operacionais	Cartão Crédito	Cartão Crédito	Pendente	Restaurante A	CR027
2028	2025-09-22	12:00:00	2025-09-22 12:00:00	Entrada	1200.00	Renda de Aluguéis Imóvel 2	Renda Extra	Banco B (Poupança)	TED	Compensado	Inquilino B	CP028
2029	2025-09-22	15:30:00	2025-09-22 15:30:00	Saída	-18000.00	Salários (Final do Mês)	Folha de Pagamento	Banco A (Corrente)	TED	Compensado	RH - Funcionários	CP029
2030	2025-09-23	09:00:00	2025-09-23 09:00:00	Saída	-1000.00	Seguro Mensal	Contas Fixas	Banco A (Corrente)	Débito Automático	Compensado	Seguradora X	CP030
2031	2025-09-24	14:00:00	2025-09-24 14:00:00	Entrada	3800.00	Venda Lote 8	Vendas	Banco A (Corrente)	Boleto	Pendente	Cliente Kappa	CR031
2032	2025-09-25	11:00:00	2025-09-25 11:00:00	Saída	-450.00	Manutenção de Equipamento	Despesas Operacionais	Caixa	Dinheiro	Compensado	Oficina Geral	CP032
2033	2025-09-26	16:00:00	2025-09-26 16:00:00	Entrada	250.00	Venda Avulsa	Vendas	Caixa	PIX	Compensado	Cliente Lambda	CP033
2034	2025-09-29	09:20:00	2025-09-29 09:20:00	Saída	-5000.00	Pagamento de Impostos	Contas Fixas	Banco A (Corrente)	Boleto	Compensado	Receita Federal	CP034
2407	2026-08-30	16:00:00	2026-08-30 16:00:00	Entrada	400.00	Venda Avulsa	Vendas	Caixa	PIX	Compensado	Cliente Y	CP022
2035	2025-09-30	15:00:00	2025-09-30 15:00:00	Entrada	8500.00	Venda Lote 9 (Fechamento)	Vendas	Banco A (Corrente)	TED	Compensado	Cliente Mu	CP035
2036	2025-10-01	11:30:00	2025-10-01 11:30:00	Entrada	5800.00	Venda Lote 14	Vendas	Banco A (Corrente)	PIX	Compensado	Cliente Alfa	CR036
2037	2025-10-02	09:15:00	2025-10-02 09:15:00	Saída	-350.00	Material de Higiene	Despesas Operacionais	Caixa	Dinheiro	Compensado	Supermercado Local	CP037
2038	2025-10-03	09:40:00	2025-10-03 09:40:00	Saída	-1500.00	Material de Embalagem	Fornecedores	Banco A (Corrente)	Boleto	Compensado	Fornecedor Beta	CP038
2039	2025-10-04	16:55:00	2025-10-04 16:55:00	Entrada	2100.00	Prestação de Serviço (Treinamento)	Prestação de Serviços	Banco B (Poupança)	TED	Compensado	Empresa Serviços Z	CP039
2040	2025-10-05	14:00:00	2025-10-05 14:00:00	Saída	-3500.00	Aluguel do Escritório	Contas Fixas	Banco A (Corrente)	Boleto	Compensado	Locadora Imóveis	CR040
2041	2025-10-06	09:10:00	2025-10-06 09:10:00	Entrada	4500.00	Venda Lote 15	Vendas	Banco A (Corrente)	PIX	Compensado	Cliente Gamma	CP041
2042	2025-10-07	17:30:00	2025-10-07 17:30:00	Saída	-4000.00	Compra de Software	Despesas Operacionais	Banco A (Corrente)	Boleto	Compensado	Fornecedor de TI	CP042
2043	2025-10-08	10:00:00	2025-10-08 10:00:00	Saída	-500.00	Doação Institucional	Despesas Operacionais	Banco A (Corrente)	TED	Compensado	Instituição ABC	CP043
2044	2025-10-09	12:00:00	2025-10-09 12:00:00	Entrada	1500.00	Reembolso de Despesas	Renda Extra	Banco B (Poupança)	PIX	Compensado	Sócio João	CR044
2045	2025-10-10	14:30:00	2025-10-10 14:30:00	Saída	-120.00	Compra de Café/Almoço	Despesas Operacionais	Caixa	Dinheiro	Compensado	Padaria Central	CP045
2046	2025-10-13	11:10:00	2025-10-13 11:10:00	Entrada	1800.00	Venda Lote 16	Vendas	Banco A (Corrente)	PIX	Compensado	Cliente Epsilon	CP046
2047	2025-10-14	13:00:00	2025-10-14 13:00:00	Saída	-7500.00	Pagamento Parcial Fornecedor Principal	Fornecedores	Banco A (Corrente)	TED	Compensado	Fornecedor Delta	CP047
2048	2025-10-15	17:00:00	2025-10-15 17:00:00	Entrada	9000.00	Venda Lote 17 (Grande)	Vendas	Banco A (Corrente)	Boleto	Compensado	Cliente Alfa	CR048
2049	2025-10-16	09:00:00	2025-10-16 09:00:00	Saída	-250.00	Reparo de Vazamento	Manutenção	Caixa	Dinheiro	Compensado	Encanador Z	CP049
2050	2025-10-17	14:00:00	2025-10-17 14:00:00	Entrada	3000.00	Venda Lote 18	Vendas	Banco A (Corrente)	PIX	Compensado	Cliente Zeta	CP050
2051	2025-10-20	11:30:00	2025-10-20 11:30:00	Saída	-50.00	Taxa de Saque	Contas Fixas	Banco B (Poupança)	Saque	Compensado	Banco B	CP051
2052	2025-10-21	18:05:00	2025-10-21 18:05:00	Saída	-15000.00	Salários (Parte Final)	Folha de Pagamento	Banco A (Corrente)	TED	Compensado	RH - Funcionários	CR052
2053	2025-10-22	10:00:00	2025-10-22 10:00:00	Entrada	600.00	Renda de Aluguéis Imóvel 2	Renda Extra	Banco B (Poupança)	TED	Compensado	Inquilino B	CP053
2054	2025-10-23	13:45:00	2025-10-23 13:45:00	Saída	-4500.00	Pagamento de Impostos (Complemento)	Contas Fixas	Banco A (Corrente)	Boleto	Compensado	Receita Federal	CP054
2055	2025-10-24	16:00:00	2025-10-24 16:00:00	Entrada	10000.00	Venda Lote 19 (Fechamento)	Vendas	Banco A (Corrente)	TED	Compensado	Cliente Alpha	CP055
2056	2025-10-25	10:00:00	2025-10-25 10:00:00	Saída	-180.00	Telefonia Mensal	Contas Fixas	Banco A (Corrente)	Débito Automático	Compensado	VIVO	CR001
2057	2025-10-26	14:00:00	2025-10-26 14:00:00	Entrada	2500.00	Venda Lote 14 - Parcela 1	Vendas	Banco A (Corrente)	Boleto	Compensado	Cliente F	CP001
2058	2025-10-27	10:00:00	2025-10-27 10:00:00	Saída	-600.00	Assinatura Adobe	Despesas Operacionais	Cartão Crédito	Cartão Crédito	Compensado	Adobe	CP002
2059	2025-10-27	16:00:00	2025-10-27 16:00:00	Entrada	350.00	Venda Avulsa (Caixa)	Vendas	Caixa	Dinheiro	Compensado	Cliente G	CR003
2060	2025-10-28	11:00:00	2025-10-28 11:00:00	Saída	-50.00	Estacionamento	Despesas Operacionais	Caixa	Dinheiro	Compensado	Estacionamento H	CP005
2061	2025-10-28	15:00:00	2025-10-28 15:00:00	Entrada	4200.00	Fatura de Serviço	Prestação de Serviços	Banco A (Corrente)	TED	Compensado	Empresa K	CP006
2062	2025-10-29	09:00:00	2025-10-29 09:00:00	Saída	-800.00	Manutenção Predial	Manutenção	Banco A (Corrente)	PIX	Compensado	Serviço L	CP007
2063	2025-10-29	13:00:00	2025-10-29 13:00:00	Entrada	750.00	Comissão Recebida	Renda Extra	Banco B (Poupança)	PIX	Compensado	Parceiro M	CP008
2064	2025-10-30	14:00:00	2025-10-30 14:00:00	Saída	-2000.00	Consultoria Jurídica	Despesas Operacionais	Banco A (Corrente)	Boleto	Compensado	Advogados N	CR009
2065	2025-10-30	16:00:00	2025-10-30 16:00:00	Entrada	300.00	Reembolso de Taxa	Renda Extra	Banco A (Corrente)	PIX	Compensado	Banco A	CP010
2066	2025-10-31	10:00:00	2025-10-31 10:00:00	Saída	-50.00	Despesa Cartório	Despesas Operacionais	Caixa	Dinheiro	Compensado	Cartório O	CR011
2067	2025-10-31	12:00:00	2025-10-31 12:00:00	Entrada	1500.00	Venda Avulsa de Produto	Vendas	Caixa	Dinheiro	Compensado	Cliente P	CP012
2068	2025-10-18	12:30:00	2025-10-18 12:30:00	Entrada	500.00	Reembolso de Combustível	Renda Extra	Caixa	Dinheiro	Compensado	Funcionário X	CP013
2069	2025-10-19	14:30:00	2025-10-19 14:30:00	Saída	-150.00	Almoço Executivo	Despesas Operacionais	Cartão Crédito	Cartão Crédito	Compensado	Restaurante C	CP014
2070	2025-10-25	12:00:00	2025-10-25 12:00:00	Saída	-1200.00	Licença Anual de Antivírus	Despesas Operacionais	Banco A (Corrente)	Boleto	Compensado	Fornecedor de TI	CP015
2071	2025-11-03	10:00:00	2025-11-03 10:00:00	Saída	-35000.00	Compra de Estoque (Grande)	Fornecedores	Banco A (Corrente)	TED	Compensado	Fornecedor Delta	CP016
2072	2025-11-04	14:00:00	2025-11-04 14:00:00	Entrada	4500.00	Venda Lote 20	Vendas	Banco A (Corrente)	PIX	Compensado	Cliente Alfa	CR017
2073	2025-11-05	10:30:00	2025-11-05 10:30:00	Saída	-3500.00	Aluguel do Escritório	Contas Fixas	Banco A (Corrente)	Boleto	Compensado	Locadora Imóveis	CP018
2074	2025-11-05	11:00:00	2025-11-05 11:00:00	Saída	-850.00	Mensalidade de Software ERP	Despesas Operacionais	Banco A (Corrente)	Boleto	Compensado	Fornecedor de TI	CP019
2075	2025-11-06	15:00:00	2025-11-06 15:00:00	Saída	-150.00	Material de Copa	Despesas Operacionais	Caixa	Dinheiro	Compensado	Supermercado Local	CR020
2076	2025-11-07	11:00:00	2025-11-07 11:00:00	Entrada	2800.00	Venda Lote 21	Vendas	Banco A (Corrente)	TED	Compensado	Cliente P	CP021
2077	2025-11-10	13:00:00	2025-11-10 13:00:00	Saída	-18000.00	Compra de Matéria-Prima (Pedido 55)	Fornecedores	Banco A (Corrente)	TED	Compensado	Fornecedor Delta	CP022
2078	2025-11-12	10:00:00	2025-11-12 10:00:00	Entrada	1500.00	Venda Avulsa	Vendas	Caixa	PIX	Compensado	Cliente Q	CR023
2079	2025-11-14	16:00:00	2025-11-14 16:00:00	Saída	-300.00	Taxa de Manutenção	Contas Fixas	Banco A (Corrente)	Débito Automático	Compensado	Banco A	CP024
2080	2025-11-15	14:00:00	2025-11-15 14:00:00	Entrada	9500.00	Fatura de Venda Lote 25	Vendas	Banco A (Corrente)	TED	Compensado	Cliente Tau	CP025
2081	2025-11-17	11:00:00	2025-11-17 11:00:00	Saída	-120.00	Combustível	Logística	Cartão Crédito	Cartão Crédito	Compensado	Posto R	CP026
2082	2025-11-18	10:00:00	2025-11-18 10:00:00	Entrada	600.00	Renda de Aluguéis Imóvel 1	Renda Extra	Banco B (Poupança)	TED	Compensado	Inquilino A	CR027
2083	2025-11-19	11:15:00	2025-11-19 11:15:00	Saída	-8000.00	Campanha de Marketing (Black Friday)	Marketing	Banco A (Corrente)	TED	Compensado	Agência Digital	CP028
2084	2025-11-20	15:30:00	2025-11-20 15:30:00	Saída	-23000.00	Salários (Novembro)	Folha de Pagamento	Banco A (Corrente)	TED	Compensado	RH - Funcionários	CP029
2085	2025-11-21	14:00:00	2025-11-21 14:00:00	Entrada	3200.00	Venda Lote 26	Vendas	Banco A (Corrente)	PIX	Compensado	Cliente S	CP030
2086	2025-11-22	10:00:00	2025-11-22 10:00:00	Saída	-400.00	Material de Embalagem	Fornecedores	Caixa	Dinheiro	Compensado	Fornecedor U	CR031
2087	2025-11-24	16:00:00	2025-11-24 16:00:00	Entrada	3500.00	Pagamento de Serviços Recorrentes	Serviços Recorrentes	Banco A (Corrente)	TED	Compensado	Empresa Serviços Z	CP032
2088	2025-11-25	11:00:00	2025-11-25 11:00:00	Saída	-500.00	Licença de Software Mensal	Contas Fixas	Cartão Crédito	Cartão Crédito	Compensado	Software Service	CP033
2089	2025-11-26	09:00:00	2025-11-26 09:00:00	Entrada	7000.00	Venda Lote 27	Vendas	Banco A (Corrente)	Boleto	Compensado	Cliente V	CP034
2090	2025-11-27	13:00:00	2025-11-27 13:00:00	Saída	-2500.00	Consultoria Financeira	Despesas Operacionais	Banco A (Corrente)	TED	Compensado	Consultor W	CP035
2091	2025-11-28	15:00:00	2025-11-28 15:00:00	Entrada	12000.00	Venda Black Friday (Alta)	Vendas	Banco A (Corrente)	PIX	Compensado	Cliente Sigma	CR036
2092	2025-11-29	09:20:00	2025-11-29 09:20:00	Saída	-5200.00	Pagamento de Impostos (Novembro)	Contas Fixas	Banco A (Corrente)	Boleto	Compensado	Receita Federal	CP037
2093	2025-11-30	16:00:00	2025-11-30 16:00:00	Entrada	450.00	Venda Avulsa (Caixa)	Vendas	Caixa	Dinheiro	Compensado	Cliente X	CP038
2094	2025-11-01	12:00:00	2025-11-01 12:00:00	Entrada	1500.00	Renda de Aluguéis Imóvel 2	Renda Extra	Banco B (Poupança)	TED	Compensado	Inquilino B	CP039
2095	2025-11-02	14:30:00	2025-11-02 14:30:00	Saída	-200.00	Passagens de Ônibus	Logística	Caixa	Dinheiro	Compensado	Viação Y	CR040
2096	2025-11-08	16:00:00	2025-11-08 16:00:00	Entrada	900.00	Venda de Reparo	Prestação de Serviços	Banco A (Corrente)	PIX	Compensado	Cliente Z	CP041
2097	2025-11-10	09:00:00	2025-11-10 09:00:00	Saída	-40.00	Tarifa de Extrato	Contas Fixas	Banco A (Corrente)	Débito Automático	Compensado	Banco A	CP042
2098	2025-11-11	15:00:00	2025-11-11 15:00:00	Entrada	5000.00	Adiantamento de Cliente	Vendas	Banco A (Corrente)	TED	Compensado	Cliente Delta	CP043
2099	2025-11-16	12:30:00	2025-11-16 12:30:00	Saída	-100.00	Almoço de Equipe	Despesas Operacionais	Cartão Crédito	Cartão Crédito	Compensado	Restaurante D	CR044
2100	2025-11-23	14:00:00	2025-11-23 14:00:00	Entrada	800.00	Reembolso de Despesa	Renda Extra	Caixa	Dinheiro	Compensado	Sócio Alfa	CP045
2101	2025-11-24	10:00:00	2025-11-24 10:00:00	Saída	-300.00	Compra de Equipamento Pequeno	Despesas Operacionais	Caixa	Dinheiro	Compensado	Loja Elétrica	CP046
2102	2025-11-26	18:00:00	2025-11-26 18:00:00	Saída	-180.00	Telefonia (Adicional)	Contas Fixas	Banco A (Corrente)	Débito Automático	Compensado	VIVO	CP047
2103	2025-11-27	10:00:00	2025-11-27 10:00:00	Entrada	4500.00	Venda Lote 28	Vendas	Banco A (Corrente)	Boleto	Compensado	Cliente Mu	CR048
2104	2025-11-28	12:00:00	2025-11-28 12:00:00	Saída	-50.00	Despesa com Cartório	Despesas Operacionais	Caixa	Dinheiro	Compensado	Cartório O	CP049
2105	2025-11-29	14:00:00	2025-11-29 14:00:00	Entrada	1500.00	Venda de Serviço (Fechamento)	Prestação de Serviços	Banco A (Corrente)	PIX	Compensado	Empresa K	CP050
2106	2025-12-02	10:00:00	2025-12-02 10:00:00	Saída	-25000.00	Compra de Estoque (Natal)	Fornecedores	Banco A (Corrente)	TED	Compensado	Fornecedor Beta	CP051
2107	2025-12-03	14:00:00	2025-12-03 14:00:00	Entrada	5000.00	Venda Lote 29	Vendas	Banco A (Corrente)	PIX	Compensado	Cliente Epsilon	CR052
2108	2025-12-04	15:00:00	2025-12-04 15:00:00	Saída	-150.00	Material de Limpeza	Despesas Operacionais	Caixa	Dinheiro	Compensado	Supermercado Local	CP053
2109	2025-12-05	10:30:00	2025-12-05 10:30:00	Saída	-3500.00	Aluguel do Escritório	Contas Fixas	Banco A (Corrente)	Boleto	Compensado	Locadora Imóveis	CP054
2110	2025-12-05	11:00:00	2025-12-05 11:00:00	Saída	-850.00	Mensalidade de Software ERP	Despesas Operacionais	Banco A (Corrente)	Boleto	Compensado	Fornecedor de TI	CP055
2111	2025-12-06	12:00:00	2025-12-06 12:00:00	Entrada	1200.00	Venda de Produto Especial	Vendas	Caixa	Dinheiro	Compensado	Cliente Epsilon	CR001
2112	2025-12-08	09:00:00	2025-12-08 09:00:00	Saída	-40.00	Tarifa de Extrato	Contas Fixas	Banco A (Corrente)	Débito Automático	Compensado	Banco A	CP001
2113	2025-12-09	14:00:00	2025-12-09 14:00:00	Entrada	6000.00	Venda Lote 30	Vendas	Banco A (Corrente)	TED	Compensado	Cliente Lambda	CP002
2114	2025-12-10	10:00:00	2025-12-10 10:00:00	Entrada	1800.00	Renda de Aluguéis Imóvel 1	Renda Extra	Banco B (Poupança)	TED	Compensado	Inquilino A	CR003
2115	2025-12-11	13:00:00	2025-12-11 13:00:00	Saída	-150.00	Jantar de Negócios	Despesas Operacionais	Cartão Crédito	Cartão Crédito	Compensado	Restaurante E	CP005
2116	2025-12-12	16:00:00	2025-12-12 16:00:00	Entrada	8500.00	Venda Lote 31	Vendas	Banco A (Corrente)	PIX	Compensado	Cliente Gamma	CP006
2117	2025-12-15	14:00:00	2025-12-15 14:00:00	Saída	-10000.00	Pagamento Fornecedor Alpha	Fornecedores	Banco A (Corrente)	TED	Compensado	Fornecedor Kappa	CP007
2118	2025-12-16	10:00:00	2025-12-16 10:00:00	Entrada	3500.00	Pagamento de Serviços Recorrentes	Serviços Recorrentes	Banco A (Corrente)	TED	Compensado	Empresa Serviços Z	CP008
2119	2025-12-17	18:00:00	2025-12-17 18:00:00	Saída	-450.00	Contas de Consumo (Água/Luz)	Contas Fixas	Banco A (Corrente)	Débito Automático	Compensado	Concessionária A	CR009
2120	2025-12-18	11:00:00	2025-12-18 11:00:00	Entrada	4200.00	Venda Lote 32	Vendas	Banco A (Corrente)	Boleto	Compensado	Cliente Mu	CP010
2121	2025-12-19	15:30:00	2025-12-19 15:30:00	Saída	-15000.00	13º Salário (Provisão)	Folha de Pagamento	Banco A (Corrente)	TED	Compensado	RH - Funcionários	CR011
2122	2025-12-20	15:30:00	2025-12-20 15:30:00	Saída	-23000.00	Salários (Dezembro)	Folha de Pagamento	Banco A (Corrente)	TED	Compensado	RH - Funcionários	CP012
2123	2025-12-21	10:00:00	2025-12-21 10:00:00	Entrada	900.00	Venda de Reparo	Prestação de Serviços	Caixa	Dinheiro	Compensado	Cliente Z	CP013
2124	2025-12-22	14:00:00	2025-12-22 14:00:00	Saída	-2500.00	Consultoria de Fim de Ano	Despesas Operacionais	Banco A (Corrente)	Boleto	Compensado	Consultor F	CP014
2125	2025-12-23	16:00:00	2025-12-23 16:00:00	Entrada	7500.00	Venda Lote 33 (Última do Ano)	Vendas	Banco A (Corrente)	TED	Compensado	Cliente Delta	CP015
2126	2025-12-24	11:00:00	2025-12-24 11:00:00	Saída	-120.00	Compra de Brindes	Marketing	Caixa	Dinheiro	Compensado	Loja de Presentes	CP016
2127	2025-12-26	14:00:00	2025-12-26 14:00:00	Entrada	600.00	Renda de Aluguéis Imóvel 2	Renda Extra	Banco B (Poupança)	TED	Compensado	Inquilino B	CR017
2128	2025-12-27	10:00:00	2025-12-27 10:00:00	Saída	-500.00	Licença de Software Mensal	Contas Fixas	Cartão Crédito	Cartão Crédito	Compensado	Software Service	CP018
2129	2025-12-28	16:00:00	2025-12-28 16:00:00	Entrada	300.00	Venda Avulsa	Vendas	Caixa	PIX	Compensado	Cliente X	CP019
2130	2025-12-29	09:20:00	2025-12-29 09:20:00	Saída	-6000.00	Impostos Mensais (IRPJ/CSLL)	Contas Fixas	Banco A (Corrente)	Boleto	Compensado	Receita Federal	CR020
2131	2025-12-30	14:00:00	2025-12-30 14:00:00	Entrada	1500.00	Venda de Consultoria	Prestação de Serviços	Banco A (Corrente)	TED	Compensado	Empresa K	CP021
2132	2025-12-01	12:00:00	2025-12-01 12:00:00	Entrada	700.00	Venda Lote 28 - Parcela 2	Vendas	Banco A (Corrente)	Boleto	Compensado	Cliente Mu	CP022
2133	2025-12-04	09:00:00	2025-12-04 09:00:00	Saída	-180.00	Mensalidade de Internet	Contas Fixas	Banco A (Corrente)	Débito Automático	Compensado	Provedor NET	CR023
2134	2025-12-07	14:30:00	2025-12-07 14:30:00	Saída	-200.00	Combustível (Viagem)	Logística	Cartão Crédito	Cartão Crédito	Compensado	Posto H	CP024
2135	2025-12-10	16:00:00	2025-12-10 16:00:00	Saída	-1200.00	Serviço de Limpeza (Fim de Ano)	Despesas Operacionais	Banco A (Corrente)	TED	Compensado	Empresa Limpeza	CP025
2136	2025-12-13	10:00:00	2025-12-13 10:00:00	Entrada	3000.00	Venda Lote 34	Vendas	Banco A (Corrente)	PIX	Compensado	Cliente Tau	CP026
2137	2025-12-16	12:30:00	2025-12-16 12:30:00	Saída	-50.00	Estacionamento (Shopping)	Despesas Operacionais	Caixa	Dinheiro	Compensado	Shopping Y	CR027
2138	2025-12-19	10:00:00	2025-12-19 10:00:00	Entrada	800.00	Reembolso de Despesa	Renda Extra	Banco B (Poupança)	PIX	Compensado	Sócio Alfa	CP028
2139	2025-12-25	14:00:00	2025-12-25 14:00:00	Entrada	1500.00	Venda Online	Vendas	Banco A (Corrente)	PIX	Pendente	Cliente W	CP029
2140	2025-12-28	11:00:00	2025-12-28 11:00:00	Saída	-300.00	Taxa Bancária (Extra)	Contas Fixas	Banco A (Corrente)	Débito Automático	Compensado	Banco A	CP030
2141	2026-01-02	10:00:00	2026-01-02 10:00:00	Saída	-20000.00	Compra de Estoque (Reabastecimento)	Fornecedores	Banco A (Corrente)	TED	Compensado	Fornecedor Delta	CR031
2142	2026-01-03	14:00:00	2026-01-03 14:00:00	Entrada	5500.00	Venda Lote 35	Vendas	Banco A (Corrente)	PIX	Compensado	Cliente Gama	CP032
2143	2026-01-05	10:30:00	2026-01-05 10:30:00	Saída	-3500.00	Aluguel do Escritório	Contas Fixas	Banco A (Corrente)	Boleto	Compensado	Locadora Imóveis	CP033
2144	2026-01-05	11:00:00	2026-01-05 11:00:00	Saída	-850.00	Mensalidade de Software ERP (Jan)	Despesas Operacionais	Banco A (Corrente)	Boleto	Compensado	Fornecedor de TI	CP034
2145	2026-01-06	15:00:00	2026-01-06 15:00:00	Saída	-150.00	Material de Copa	Despesas Operacionais	Caixa	Dinheiro	Compensado	Supermercado Local	CP035
2146	2026-01-07	11:00:00	2026-01-07 11:00:00	Entrada	7500.00	Venda Lote 27 (Fatura)	Vendas	Banco A (Corrente)	TED	Compensado	Cliente Gama	CR036
2147	2026-01-08	13:00:00	2026-01-08 13:00:00	Saída	-500.00	Licença de Software Mensal	Contas Fixas	Cartão Crédito	Cartão Crédito	Compensado	Software Service	CP037
2148	2026-01-09	10:00:00	2026-01-09 10:00:00	Entrada	1800.00	Renda de Aluguéis Imóvel 1	Renda Extra	Banco B (Poupança)	TED	Compensado	Inquilino A	CP038
2149	2026-01-10	16:00:00	2026-01-10 16:00:00	Saída	-21000.00	Compra de Matéria-Prima (Pedido 56)	Fornecedores	Banco A (Corrente)	TED	Compensado	Fornecedor Delta	CP039
2150	2026-01-12	14:00:00	2026-01-12 14:00:00	Entrada	3500.00	Venda Lote 36	Vendas	Banco A (Corrente)	PIX	Compensado	Cliente Sigma	CR040
2151	2026-01-14	11:00:00	2026-01-14 11:00:00	Saída	-120.00	Combustível	Logística	Cartão Crédito	Cartão Crédito	Compensado	Posto R	CP041
2152	2026-01-15	14:00:00	2026-01-15 14:00:00	Entrada	2800.00	Venda Lote 37	Vendas	Banco A (Corrente)	TED	Compensado	Cliente P	CP042
2153	2026-01-16	16:00:00	2026-01-16 16:00:00	Saída	-500.00	Contas de Consumo (Jan)	Contas Fixas	Banco A (Corrente)	Débito Automático	Compensado	Concessionária A	CP043
2154	2026-01-17	10:00:00	2026-01-17 10:00:00	Entrada	900.00	Reembolso de Despesa	Renda Extra	Caixa	Dinheiro	Compensado	Sócio João	CR044
2155	2026-01-20	15:30:00	2026-01-20 15:30:00	Saída	-24000.00	Salários (Janeiro)	Folha de Pagamento	Banco A (Corrente)	TED	Compensado	RH - Funcionários	CP045
2156	2026-01-21	14:00:00	2026-01-21 14:00:00	Entrada	3500.00	Pagamento de Serviços de Janeiro	Serviços Recorrentes	Banco A (Corrente)	TED	Compensado	Empresa Serviços Z	CP046
2157	2026-01-22	10:00:00	2026-01-22 10:00:00	Saída	-400.00	Manutenção de Equipamento	Despesas Operacionais	Caixa	Dinheiro	Compensado	Oficina Geral	CP047
2158	2026-01-23	16:00:00	2026-01-23 16:00:00	Entrada	4800.00	Venda Lote 38	Vendas	Banco A (Corrente)	PIX	Compensado	Cliente Omicron	CR048
2159	2026-01-26	11:00:00	2026-01-26 11:00:00	Saída	-6500.00	Impostos Mensais (Jan)	Contas Fixas	Banco A (Corrente)	Boleto	Compensado	Receita Federal	CP049
2160	2026-01-27	14:00:00	2026-01-27 14:00:00	Entrada	1500.00	Venda de Consultoria	Prestação de Serviços	Banco A (Corrente)	TED	Compensado	Empresa K	CP050
2161	2026-01-28	14:00:00	2026-01-28 14:00:00	Saída	-15000.00	Renovação de Contrato Anual TI	Despesas Operacionais	Banco A (Corrente)	TED	Compensado	Fornecedor de TI	CP051
2162	2026-01-29	10:00:00	2026-01-29 10:00:00	Entrada	9500.00	Venda Lote 39	Vendas	Banco A (Corrente)	Boleto	Compensado	Cliente Tau	CR052
2163	2026-01-30	12:00:00	2026-01-30 12:00:00	Saída	-50.00	Despesa Cartório	Despesas Operacionais	Caixa	Dinheiro	Compensado	Cartório O	CP053
2164	2026-01-31	16:00:00	2026-01-31 16:00:00	Entrada	400.00	Venda Avulsa	Vendas	Caixa	PIX	Compensado	Cliente Y	CP054
2165	2026-01-01	12:00:00	2026-01-01 12:00:00	Entrada	600.00	Renda de Aluguéis Imóvel 2	Renda Extra	Banco B (Poupança)	TED	Compensado	Inquilino B	CP055
2166	2026-01-04	14:30:00	2026-01-04 14:30:00	Saída	-200.00	Passagens de Ônibus	Logística	Caixa	Dinheiro	Compensado	Viação Y	CR001
2167	2026-01-07	18:00:00	2026-01-07 18:00:00	Saída	-180.00	Telefonia Mensal	Contas Fixas	Banco A (Corrente)	Débito Automático	Compensado	VIVO	CP001
2168	2026-01-13	10:00:00	2026-01-13 10:00:00	Saída	-40.00	Tarifa de Extrato	Contas Fixas	Banco A (Corrente)	Débito Automático	Compensado	Banco A	CP002
2169	2026-01-18	12:30:00	2026-01-18 12:30:00	Saída	-100.00	Almoço de Equipe	Despesas Operacionais	Cartão Crédito	Cartão Crédito	Compensado	Restaurante D	CR003
2170	2026-01-20	10:00:00	2026-01-20 10:00:00	Entrada	5000.00	Adiantamento de Cliente	Vendas	Banco A (Corrente)	TED	Compensado	Cliente Delta	CP005
2171	2026-01-24	14:00:00	2026-01-24 14:00:00	Entrada	800.00	Reembolso de Despesa	Renda Extra	Caixa	Dinheiro	Compensado	Sócio Alfa	CP006
2172	2026-01-25	10:00:00	2026-01-25 10:00:00	Saída	-300.00	Compra de Equipamento Pequeno	Despesas Operacionais	Caixa	Dinheiro	Compensado	Loja Elétrica	CP007
2173	2026-01-26	18:00:00	2026-01-26 18:00:00	Saída	-180.00	Telefonia (Adicional)	Contas Fixas	Banco A (Corrente)	Débito Automático	Compensado	VIVO	CP008
2174	2026-01-28	12:00:00	2026-01-28 12:00:00	Saída	-50.00	Despesa com Cartório	Despesas Operacionais	Caixa	Dinheiro	Compensado	Cartório O	CR009
2175	2026-01-29	14:00:00	2026-01-29 14:00:00	Entrada	1500.00	Venda de Serviço (Fechamento)	Prestação de Serviços	Banco A (Corrente)	PIX	Compensado	Empresa K	CP010
2176	2026-02-02	10:00:00	2026-02-02 10:00:00	Saída	-15000.00	Compra de Estoque (Promoção)	Fornecedores	Banco A (Corrente)	TED	Compensado	Fornecedor Beta	CR011
2177	2026-02-03	14:00:00	2026-02-03 14:00:00	Entrada	5200.00	Venda Lote 40	Vendas	Banco A (Corrente)	PIX	Compensado	Cliente Epsilon	CP012
2178	2026-02-05	10:30:00	2026-02-05 10:30:00	Saída	-3500.00	Aluguel do Escritório	Contas Fixas	Banco A (Corrente)	Boleto	Compensado	Locadora Imóveis	CP013
2179	2026-02-05	11:00:00	2026-02-05 11:00:00	Saída	-850.00	Mensalidade de Software ERP (Fev)	Despesas Operacionais	Banco A (Corrente)	Boleto	Compensado	Fornecedor de TI	CP014
2180	2026-02-06	15:00:00	2026-02-06 15:00:00	Saída	-150.00	Material de Copa	Despesas Operacionais	Caixa	Dinheiro	Compensado	Supermercado Local	CP015
2181	2026-02-07	11:00:00	2026-02-07 11:00:00	Entrada	4800.00	Venda Lote 28 (Fatura)	Vendas	Banco A (Corrente)	TED	Compensado	Cliente Omicron	CP016
2182	2026-02-08	13:00:00	2026-02-08 13:00:00	Saída	-500.00	Licença de Software Mensal	Contas Fixas	Cartão Crédito	Cartão Crédito	Compensado	Software Service	CR017
2183	2026-02-09	10:00:00	2026-02-09 10:00:00	Entrada	1800.00	Renda de Aluguéis Imóvel 1	Renda Extra	Banco B (Poupança)	TED	Compensado	Inquilino A	CP018
2184	2026-02-10	16:00:00	2026-02-10 16:00:00	Saída	-7000.00	Marketing de Lançamento (Fev)	Marketing	Banco A (Corrente)	Boleto	Compensado	Agência Digital	CP019
2185	2026-02-12	14:00:00	2026-02-12 14:00:00	Entrada	6000.00	Venda Lote 41	Vendas	Banco A (Corrente)	PIX	Compensado	Cliente Alpha	CR020
2186	2026-02-14	11:00:00	2026-02-14 11:00:00	Saída	-120.00	Combustível	Logística	Cartão Crédito	Cartão Crédito	Compensado	Posto R	CP021
2187	2026-02-15	14:00:00	2026-02-15 14:00:00	Entrada	11000.00	Fatura de Venda Lote 29	Vendas	Banco A (Corrente)	TED	Compensado	Cliente Tau	CP022
2188	2026-02-16	16:00:00	2026-02-16 16:00:00	Saída	-480.00	Contas de Consumo (Fev)	Contas Fixas	Banco A (Corrente)	Débito Automático	Compensado	Concessionária A	CR023
2189	2026-02-17	10:00:00	2026-02-17 10:00:00	Entrada	900.00	Reembolso de Despesa	Renda Extra	Caixa	Dinheiro	Compensado	Sócio João	CP024
2190	2026-02-20	15:30:00	2026-02-20 15:30:00	Saída	-24500.00	Salários (Fevereiro)	Folha de Pagamento	Banco A (Corrente)	TED	Compensado	RH - Funcionários	CP025
2191	2026-02-21	14:00:00	2026-02-21 14:00:00	Entrada	3500.00	Pagamento de Serviços de Fevereiro	Serviços Recorrentes	Banco A (Corrente)	TED	Compensado	Empresa Serviços Z	CP026
2192	2026-02-22	10:00:00	2026-02-22 10:00:00	Saída	-400.00	Manutenção de Equipamento	Despesas Operacionais	Caixa	Dinheiro	Compensado	Oficina Geral	CR027
2193	2026-02-23	16:00:00	2026-02-23 16:00:00	Entrada	7800.00	Venda Lote 42	Vendas	Banco A (Corrente)	PIX	Compensado	Cliente Beta	CP028
2194	2026-02-26	11:00:00	2026-02-26 11:00:00	Saída	-6500.00	Impostos Mensais (Fev)	Contas Fixas	Banco A (Corrente)	Boleto	Compensado	Receita Federal	CP029
2195	2026-02-27	14:00:00	2026-02-27 14:00:00	Entrada	1500.00	Venda de Consultoria	Prestação de Serviços	Banco A (Corrente)	TED	Compensado	Empresa K	CP030
2196	2026-02-28	12:00:00	2026-02-28 12:00:00	Saída	-50.00	Despesa Cartório	Despesas Operacionais	Caixa	Dinheiro	Compensado	Cartório O	CR031
2197	2026-02-01	12:00:00	2026-02-01 12:00:00	Entrada	600.00	Renda de Aluguéis Imóvel 2	Renda Extra	Banco B (Poupança)	TED	Compensado	Inquilino B	CP032
2198	2026-02-04	14:30:00	2026-02-04 14:30:00	Saída	-200.00	Passagens de Ônibus	Logística	Caixa	Dinheiro	Compensado	Viação Y	CP033
2199	2026-02-07	18:00:00	2026-02-07 18:00:00	Saída	-180.00	Telefonia Mensal	Contas Fixas	Banco A (Corrente)	Débito Automático	Compensado	VIVO	CP034
2200	2026-02-10	09:00:00	2026-02-10 09:00:00	Saída	-40.00	Tarifa de Extrato	Contas Fixas	Banco A (Corrente)	Débito Automático	Compensado	Banco A	CP035
2201	2026-02-13	15:00:00	2026-02-13 15:00:00	Entrada	5000.00	Adiantamento de Cliente	Vendas	Banco A (Corrente)	TED	Compensado	Cliente Delta	CR036
2202	2026-02-18	12:30:00	2026-02-18 12:30:00	Saída	-100.00	Almoço de Equipe	Despesas Operacionais	Cartão Crédito	Cartão Crédito	Compensado	Restaurante D	CP037
2203	2026-02-20	10:00:00	2026-02-20 10:00:00	Entrada	800.00	Reembolso de Despesa	Renda Extra	Caixa	Dinheiro	Compensado	Sócio Alfa	CP038
2204	2026-02-24	14:00:00	2026-02-24 14:00:00	Entrada	4500.00	Venda Lote 43	Vendas	Banco A (Corrente)	Boleto	Compensado	Cliente Mu	CP039
2205	2026-02-25	10:00:00	2026-02-25 10:00:00	Saída	-300.00	Compra de Equipamento Pequeno	Despesas Operacionais	Caixa	Dinheiro	Compensado	Loja Elétrica	CR040
2206	2026-02-26	18:00:00	2026-02-26 18:00:00	Saída	-180.00	Telefonia (Adicional)	Contas Fixas	Banco A (Corrente)	Débito Automático	Compensado	VIVO	CP041
2207	2026-02-27	10:00:00	2026-02-27 10:00:00	Entrada	2500.00	Venda Lote 44	Vendas	Banco A (Corrente)	PIX	Compensado	Cliente Gama	CP042
2208	2026-02-28	14:00:00	2026-02-28 14:00:00	Entrada	400.00	Venda Avulsa	Vendas	Caixa	PIX	Compensado	Cliente Y	CP043
2209	2026-02-23	11:00:00	2026-02-23 11:00:00	Saída	-50.00	Taxa de Saque	Contas Fixas	Banco B (Poupança)	Saque	Compensado	Banco B	CR044
2210	2026-02-24	12:00:00	2026-02-24 12:00:00	Saída	-1200.00	Serviço de Limpeza (Fev)	Despesas Operacionais	Banco A (Corrente)	TED	Compensado	Empresa Limpeza	CP045
2211	2026-03-02	10:00:00	2026-03-02 10:00:00	Saída	-30000.00	Compra de Estoque (Renovação)	Fornecedores	Banco A (Corrente)	TED	Compensado	Fornecedor Kappa	CP046
2212	2026-03-03	14:00:00	2026-03-03 14:00:00	Entrada	6500.00	Venda Lote 45	Vendas	Banco A (Corrente)	PIX	Compensado	Cliente Mu	CP047
2213	2026-03-05	10:30:00	2026-03-05 10:30:00	Saída	-3500.00	Aluguel do Escritório	Contas Fixas	Banco A (Corrente)	Boleto	Compensado	Locadora Imóveis	CR048
2214	2026-03-05	11:00:00	2026-03-05 11:00:00	Saída	-850.00	Mensalidade de Software ERP (Mar)	Despesas Operacionais	Banco A (Corrente)	Boleto	Compensado	Fornecedor de TI	CP049
2215	2026-03-06	15:00:00	2026-03-06 15:00:00	Saída	-150.00	Material de Copa	Despesas Operacionais	Caixa	Dinheiro	Compensado	Supermercado Local	CP050
2216	2026-03-07	11:00:00	2026-03-07 11:00:00	Entrada	8800.00	Fatura de Venda Lote 31	Vendas	Banco A (Corrente)	TED	Compensado	Cliente Mu	CP051
2217	2026-03-08	13:00:00	2026-03-08 13:00:00	Saída	-500.00	Licença de Software Mensal	Contas Fixas	Cartão Crédito	Cartão Crédito	Compensado	Software Service	CR052
2218	2026-03-09	10:00:00	2026-03-09 10:00:00	Entrada	1800.00	Renda de Aluguéis Imóvel 1	Renda Extra	Banco B (Poupança)	TED	Compensado	Inquilino A	CP053
2219	2026-03-10	16:00:00	2026-03-10 16:00:00	Saída	-19000.00	Compra de Estoque (Mar)	Fornecedores	Banco A (Corrente)	TED	Compensado	Fornecedor Kappa	CP054
2220	2026-03-12	14:00:00	2026-03-12 14:00:00	Entrada	4500.00	Venda Lote 46	Vendas	Banco A (Corrente)	PIX	Compensado	Cliente Delta	CP055
2221	2026-03-14	11:00:00	2026-03-14 11:00:00	Saída	-120.00	Combustível	Logística	Cartão Crédito	Cartão Crédito	Compensado	Posto R	CR001
2222	2026-03-15	14:00:00	2026-03-15 14:00:00	Entrada	9500.00	Venda Lote 35 (Fatura)	Vendas	Banco A (Corrente)	TED	Compensado	Cliente Delta	CP001
2223	2026-03-16	16:00:00	2026-03-16 16:00:00	Saída	-500.00	Contas de Consumo (Mar)	Contas Fixas	Banco A (Corrente)	Débito Automático	Compensado	Concessionária A	CP002
2224	2026-03-17	10:00:00	2026-03-17 10:00:00	Entrada	900.00	Reembolso de Despesa	Renda Extra	Caixa	Dinheiro	Compensado	Sócio João	CR003
2225	2026-03-20	15:30:00	2026-03-20 15:30:00	Saída	-24500.00	Salários (Março)	Folha de Pagamento	Banco A (Corrente)	TED	Compensado	RH - Funcionários	CP005
2226	2026-03-21	14:00:00	2026-03-21 14:00:00	Entrada	3500.00	Pagamento de Serviços de Março	Serviços Recorrentes	Banco A (Corrente)	TED	Compensado	Empresa Serviços Z	CP006
2227	2026-03-22	10:00:00	2026-03-22 10:00:00	Saída	-400.00	Manutenção de Equipamento	Despesas Operacionais	Caixa	Dinheiro	Compensado	Oficina Geral	CP007
2228	2026-03-23	16:00:00	2026-03-23 16:00:00	Entrada	5500.00	Venda Lote 47	Vendas	Banco A (Corrente)	PIX	Compensado	Cliente Zeta	CP008
2229	2026-03-26	11:00:00	2026-03-26 11:00:00	Saída	-6500.00	Impostos Mensais (Mar)	Contas Fixas	Banco A (Corrente)	Boleto	Compensado	Receita Federal	CR009
2230	2026-03-27	14:00:00	2026-03-27 14:00:00	Entrada	1500.00	Venda de Consultoria	Prestação de Serviços	Banco A (Corrente)	TED	Compensado	Empresa K	CP010
2231	2026-03-28	12:00:00	2026-03-28 12:00:00	Saída	-50.00	Despesa Cartório	Despesas Operacionais	Caixa	Dinheiro	Compensado	Cartório O	CR011
2232	2026-03-30	16:00:00	2026-03-30 16:00:00	Entrada	400.00	Venda Avulsa	Vendas	Caixa	PIX	Compensado	Cliente Y	CP012
2233	2026-03-01	12:00:00	2026-03-01 12:00:00	Entrada	600.00	Renda de Aluguéis Imóvel 2	Renda Extra	Banco B (Poupança)	TED	Compensado	Inquilino B	CP013
2234	2026-03-04	14:30:00	2026-03-04 14:30:00	Saída	-200.00	Passagens de Ônibus	Logística	Caixa	Dinheiro	Compensado	Viação Y	CP014
2235	2026-03-07	18:00:00	2026-03-07 18:00:00	Saída	-180.00	Telefonia Mensal	Contas Fixas	Banco A (Corrente)	Débito Automático	Compensado	VIVO	CP015
2236	2026-03-10	09:00:00	2026-03-10 09:00:00	Saída	-40.00	Tarifa de Extrato	Contas Fixas	Banco A (Corrente)	Débito Automático	Compensado	Banco A	CP016
2237	2026-03-13	15:00:00	2026-03-13 15:00:00	Entrada	5000.00	Adiantamento de Cliente	Vendas	Banco A (Corrente)	TED	Compensado	Cliente Delta	CR017
2238	2026-03-18	12:30:00	2026-03-18 12:30:00	Saída	-100.00	Almoço de Equipe	Despesas Operacionais	Cartão Crédito	Cartão Crédito	Compensado	Restaurante D	CP018
2239	2026-03-20	10:00:00	2026-03-20 10:00:00	Entrada	800.00	Reembolso de Despesa	Renda Extra	Caixa	Dinheiro	Compensado	Sócio Alfa	CP019
2240	2026-03-24	14:00:00	2026-03-24 14:00:00	Entrada	4500.00	Venda Lote 48	Vendas	Banco A (Corrente)	Boleto	Compensado	Cliente Tau	CR020
2241	2026-03-25	10:00:00	2026-03-25 10:00:00	Saída	-300.00	Compra de Equipamento Pequeno	Despesas Operacionais	Caixa	Dinheiro	Compensado	Loja Elétrica	CP021
2242	2026-03-26	18:00:00	2026-03-26 18:00:00	Saída	-180.00	Telefonia (Adicional)	Contas Fixas	Banco A (Corrente)	Débito Automático	Compensado	VIVO	CP022
2243	2026-03-27	10:00:00	2026-03-27 10:00:00	Entrada	2500.00	Venda Lote 49	Vendas	Banco A (Corrente)	PIX	Compensado	Cliente Gama	CR023
2244	2026-03-28	14:00:00	2026-03-28 14:00:00	Entrada	400.00	Venda Avulsa	Vendas	Caixa	PIX	Compensado	Cliente Y	CP024
2245	2026-03-29	11:00:00	2026-03-29 11:00:00	Saída	-50.00	Taxa de Saque	Contas Fixas	Banco B (Poupança)	Saque	Compensado	Banco B	CP025
2246	2026-04-01	10:00:00	2026-04-01 10:00:00	Saída	-18000.00	Compra de Estoque (Abril)	Fornecedores	Banco A (Corrente)	TED	Compensado	Fornecedor Delta	CP026
2247	2026-04-02	14:00:00	2026-04-02 14:00:00	Entrada	7000.00	Venda Lote 50	Vendas	Banco A (Corrente)	PIX	Compensado	Cliente Alpha	CR027
2248	2026-04-05	10:30:00	2026-04-05 10:30:00	Saída	-3500.00	Aluguel do Escritório	Contas Fixas	Banco A (Corrente)	Boleto	Compensado	Locadora Imóveis	CP028
2249	2026-04-05	11:00:00	2026-04-05 11:00:00	Saída	-850.00	Mensalidade de Software ERP (Abr)	Despesas Operacionais	Banco A (Corrente)	Boleto	Compensado	Fornecedor de TI	CP029
2250	2026-04-06	15:00:00	2026-04-06 15:00:00	Saída	-150.00	Material de Copa	Despesas Operacionais	Caixa	Dinheiro	Compensado	Supermercado Local	CP030
2251	2026-04-07	11:00:00	2026-04-07 11:00:00	Entrada	3600.00	Pagamento de Serviços Recorrentes (Abr)	Serviços Recorrentes	Banco A (Corrente)	TED	Compensado	Empresa Serviços Z	CR031
2252	2026-04-08	13:00:00	2026-04-08 13:00:00	Saída	-500.00	Licença de Software Mensal	Contas Fixas	Cartão Crédito	Cartão Crédito	Compensado	Software Service	CP032
2253	2026-04-09	10:00:00	2026-04-09 10:00:00	Entrada	1800.00	Renda de Aluguéis Imóvel 1	Renda Extra	Banco B (Poupança)	TED	Compensado	Inquilino A	CP033
2254	2026-04-10	16:00:00	2026-04-10 16:00:00	Saída	-1500.00	Treinamento de Equipe	Despesas Operacionais	Banco A (Corrente)	TED	Compensado	Consultor F	CP034
2255	2026-04-12	14:00:00	2026-04-12 14:00:00	Entrada	5500.00	Venda Lote 51	Vendas	Banco A (Corrente)	PIX	Compensado	Cliente Sigma	CP035
2256	2026-04-14	11:00:00	2026-04-14 11:00:00	Saída	-120.00	Combustível	Logística	Cartão Crédito	Cartão Crédito	Compensado	Posto R	CR036
2257	2026-04-15	14:00:00	2026-04-15 14:00:00	Entrada	11000.00	Venda Lote 40 (Fatura)	Vendas	Banco A (Corrente)	TED	Compensado	Cliente Alpha	CP037
2258	2026-04-16	16:00:00	2026-04-16 16:00:00	Saída	-450.00	Contas de Consumo (Abr)	Contas Fixas	Banco A (Corrente)	Débito Automático	Compensado	Concessionária A	CP038
2259	2026-04-17	10:00:00	2026-04-17 10:00:00	Entrada	900.00	Reembolso de Despesa	Renda Extra	Caixa	Dinheiro	Compensado	Sócio João	CP039
2260	2026-04-20	15:30:00	2026-04-20 15:30:00	Saída	-24500.00	Salários (Abril)	Folha de Pagamento	Banco A (Corrente)	TED	Compensado	RH - Funcionários	CR040
2261	2026-04-21	14:00:00	2026-04-21 14:00:00	Entrada	3500.00	Venda Lote 52	Vendas	Banco A (Corrente)	TED	Compensado	Cliente Zeta	CP041
2262	2026-04-22	10:00:00	2026-04-22 10:00:00	Saída	-400.00	Manutenção de Equipamento	Despesas Operacionais	Caixa	Dinheiro	Compensado	Oficina Geral	CP042
2263	2026-04-23	16:00:00	2026-04-23 16:00:00	Entrada	6000.00	Venda Lote 53	Vendas	Banco A (Corrente)	PIX	Compensado	Cliente Beta	CP043
2264	2026-04-26	11:00:00	2026-04-26 11:00:00	Saída	-5500.00	Impostos Trimestrais	Contas Fixas	Banco A (Corrente)	Boleto	Compensado	Receita Federal	CR044
2265	2026-04-27	14:00:00	2026-04-27 14:00:00	Entrada	1500.00	Venda de Consultoria	Prestação de Serviços	Banco A (Corrente)	TED	Compensado	Empresa K	CP045
2266	2026-04-28	12:00:00	2026-04-28 12:00:00	Saída	-50.00	Despesa Cartório	Despesas Operacionais	Caixa	Dinheiro	Compensado	Cartório O	CP046
2267	2026-04-30	16:00:00	2026-04-30 16:00:00	Entrada	400.00	Venda Avulsa	Vendas	Caixa	PIX	Compensado	Cliente Y	CP047
2268	2026-04-01	12:00:00	2026-04-01 12:00:00	Entrada	600.00	Renda de Aluguéis Imóvel 2	Renda Extra	Banco B (Poupança)	TED	Compensado	Inquilino B	CR048
2269	2026-04-04	14:30:00	2026-04-04 14:30:00	Saída	-200.00	Passagens de Ônibus	Logística	Caixa	Dinheiro	Compensado	Viação Y	CP049
2270	2026-04-07	18:00:00	2026-04-07 18:00:00	Saída	-180.00	Telefonia Mensal	Contas Fixas	Banco A (Corrente)	Débito Automático	Compensado	VIVO	CP050
2271	2026-04-10	09:00:00	2026-04-10 09:00:00	Saída	-40.00	Tarifa de Extrato	Contas Fixas	Banco A (Corrente)	Débito Automático	Compensado	Banco A	CP051
2272	2026-04-13	15:00:00	2026-04-13 15:00:00	Entrada	5000.00	Adiantamento de Cliente	Vendas	Banco A (Corrente)	TED	Compensado	Cliente Delta	CR052
2273	2026-04-18	12:30:00	2026-04-18 12:30:00	Saída	-100.00	Almoço de Equipe	Despesas Operacionais	Cartão Crédito	Cartão Crédito	Compensado	Restaurante D	CP053
2274	2026-04-20	10:00:00	2026-04-20 10:00:00	Entrada	800.00	Reembolso de Despesa	Renda Extra	Caixa	Dinheiro	Compensado	Sócio Alfa	CP054
2275	2026-04-24	14:00:00	2026-04-24 14:00:00	Entrada	4500.00	Venda Lote 54	Vendas	Banco A (Corrente)	Boleto	Compensado	Cliente Mu	CP055
2276	2026-04-25	10:00:00	2026-04-25 10:00:00	Saída	-300.00	Compra de Equipamento Pequeno	Despesas Operacionais	Caixa	Dinheiro	Compensado	Loja Elétrica	CR001
2326	2026-06-14	11:00:00	2026-06-14 11:00:00	Saída	-120.00	Combustível	Logística	Cartão Crédito	Cartão Crédito	Compensado	Posto R	CP051
2277	2026-04-26	18:00:00	2026-04-26 18:00:00	Saída	-180.00	Telefonia (Adicional)	Contas Fixas	Banco A (Corrente)	Débito Automático	Compensado	VIVO	CP001
2278	2026-04-27	10:00:00	2026-04-27 10:00:00	Entrada	2500.00	Venda Lote 55	Vendas	Banco A (Corrente)	PIX	Compensado	Cliente Gama	CP002
2279	2026-04-28	14:00:00	2026-04-28 14:00:00	Entrada	400.00	Venda Avulsa	Vendas	Caixa	PIX	Compensado	Cliente Y	CR003
2280	2026-04-29	11:00:00	2026-04-29 11:00:00	Saída	-50.00	Taxa de Saque	Contas Fixas	Banco B (Poupança)	Saque	Compensado	Banco B	CP005
2281	2026-05-01	10:00:00	2026-05-01 10:00:00	Saída	-15000.00	Compra de Estoque (Maio)	Fornecedores	Banco A (Corrente)	TED	Compensado	Fornecedor Beta	CP006
2282	2026-05-02	14:00:00	2026-05-02 14:00:00	Entrada	5500.00	Venda Lote 38 (Fatura)	Vendas	Banco A (Corrente)	PIX	Compensado	Cliente Zeta	CP007
2283	2026-05-05	10:30:00	2026-05-05 10:30:00	Saída	-3500.00	Aluguel do Escritório	Contas Fixas	Banco A (Corrente)	Boleto	Compensado	Locadora Imóveis	CP008
2284	2026-05-05	11:00:00	2026-05-05 11:00:00	Saída	-850.00	Mensalidade de Software ERP (Mai)	Despesas Operacionais	Banco A (Corrente)	Boleto	Compensado	Fornecedor de TI	CR009
2285	2026-05-06	15:00:00	2026-05-06 15:00:00	Saída	-150.00	Material de Copa	Despesas Operacionais	Caixa	Dinheiro	Compensado	Supermercado Local	CP010
2286	2026-05-07	11:00:00	2026-05-07 11:00:00	Entrada	3600.00	Pagamento de Serviços Recorrentes (Mai)	Serviços Recorrentes	Banco A (Corrente)	TED	Compensado	Empresa Serviços Z	CR011
2287	2026-05-08	13:00:00	2026-05-08 13:00:00	Saída	-500.00	Licença de Software Mensal	Contas Fixas	Cartão Crédito	Cartão Crédito	Compensado	Software Service	CP012
2288	2026-05-09	10:00:00	2026-05-09 10:00:00	Entrada	1800.00	Renda de Aluguéis Imóvel 1	Renda Extra	Banco B (Poupança)	TED	Compensado	Inquilino A	CP013
2289	2026-05-10	16:00:00	2026-05-10 16:00:00	Saída	-10000.00	Marketing (Meio do Ano)	Marketing	Banco A (Corrente)	TED	Compensado	Agência Digital	CP014
2290	2026-05-12	14:00:00	2026-05-12 14:00:00	Entrada	7800.00	Venda Lote 45 (Fatura)	Vendas	Banco A (Corrente)	PIX	Compensado	Cliente Sigma	CP015
2291	2026-05-14	11:00:00	2026-05-14 11:00:00	Saída	-120.00	Combustível	Logística	Cartão Crédito	Cartão Crédito	Compensado	Posto R	CP016
2292	2026-05-15	14:00:00	2026-05-15 14:00:00	Entrada	5500.00	Venda Lote 38 (Fatura)	Vendas	Banco A (Corrente)	TED	Compensado	Cliente Zeta	CR017
2293	2026-05-16	16:00:00	2026-05-16 16:00:00	Saída	-450.00	Contas de Consumo (Mai)	Contas Fixas	Banco A (Corrente)	Débito Automático	Compensado	Concessionária A	CP018
2294	2026-05-17	10:00:00	2026-05-17 10:00:00	Entrada	900.00	Reembolso de Despesa	Renda Extra	Caixa	Dinheiro	Compensado	Sócio João	CP019
2295	2026-05-20	15:30:00	2026-05-20 15:30:00	Saída	-24500.00	Salários (Maio)	Folha de Pagamento	Banco A (Corrente)	TED	Compensado	RH - Funcionários	CR020
2296	2026-05-21	14:00:00	2026-05-21 14:00:00	Entrada	3500.00	Venda Lote 56	Vendas	Banco A (Corrente)	TED	Compensado	Cliente Mu	CP021
2297	2026-05-22	10:00:00	2026-05-22 10:00:00	Saída	-400.00	Manutenção de Equipamento	Despesas Operacionais	Caixa	Dinheiro	Compensado	Oficina Geral	CP022
2298	2026-05-23	16:00:00	2026-05-23 16:00:00	Entrada	6500.00	Venda Lote 57	Vendas	Banco A (Corrente)	PIX	Compensado	Cliente Gamma	CR023
2299	2026-05-26	11:00:00	2026-05-26 11:00:00	Saída	-6000.00	Impostos Mensais (Mai)	Contas Fixas	Banco A (Corrente)	Boleto	Compensado	Receita Federal	CP024
2300	2026-05-27	14:00:00	2026-05-27 14:00:00	Entrada	1500.00	Venda de Consultoria	Prestação de Serviços	Banco A (Corrente)	TED	Compensado	Empresa K	CP025
2301	2026-05-28	12:00:00	2026-05-28 12:00:00	Saída	-50.00	Despesa Cartório	Despesas Operacionais	Caixa	Dinheiro	Compensado	Cartório O	CP026
2302	2026-05-30	16:00:00	2026-05-30 16:00:00	Entrada	400.00	Venda Avulsa	Vendas	Caixa	PIX	Compensado	Cliente Y	CR027
2303	2026-05-01	12:00:00	2026-05-01 12:00:00	Entrada	600.00	Renda de Aluguéis Imóvel 2	Renda Extra	Banco B (Poupança)	TED	Compensado	Inquilino B	CP028
2304	2026-05-04	14:30:00	2026-05-04 14:30:00	Saída	-200.00	Passagens de Ônibus	Logística	Caixa	Dinheiro	Compensado	Viação Y	CP029
2305	2026-05-07	18:00:00	2026-05-07 18:00:00	Saída	-180.00	Telefonia Mensal	Contas Fixas	Banco A (Corrente)	Débito Automático	Compensado	VIVO	CP030
2306	2026-05-10	09:00:00	2026-05-10 09:00:00	Saída	-40.00	Tarifa de Extrato	Contas Fixas	Banco A (Corrente)	Débito Automático	Compensado	Banco A	CR031
2307	2026-05-13	15:00:00	2026-05-13 15:00:00	Entrada	5000.00	Adiantamento de Cliente	Vendas	Banco A (Corrente)	TED	Compensado	Cliente Delta	CP032
2308	2026-05-18	12:30:00	2026-05-18 12:30:00	Saída	-100.00	Almoço de Equipe	Despesas Operacionais	Cartão Crédito	Cartão Crédito	Compensado	Restaurante D	CP033
2309	2026-05-20	10:00:00	2026-05-20 10:00:00	Entrada	800.00	Reembolso de Despesa	Renda Extra	Caixa	Dinheiro	Compensado	Sócio Alfa	CP034
2310	2026-05-24	14:00:00	2026-05-24 14:00:00	Entrada	4500.00	Venda Lote 58	Vendas	Banco A (Corrente)	Boleto	Compensado	Cliente Tau	CP035
2311	2026-05-25	10:00:00	2026-05-25 10:00:00	Saída	-300.00	Compra de Equipamento Pequeno	Despesas Operacionais	Caixa	Dinheiro	Compensado	Loja Elétrica	CR036
2312	2026-05-26	18:00:00	2026-05-26 18:00:00	Saída	-180.00	Telefonia (Adicional)	Contas Fixas	Banco A (Corrente)	Débito Automático	Compensado	VIVO	CP037
2313	2026-05-27	10:00:00	2026-05-27 10:00:00	Entrada	2500.00	Venda Lote 59	Vendas	Banco A (Corrente)	PIX	Compensado	Cliente Gama	CP038
2314	2026-05-28	14:00:00	2026-05-28 14:00:00	Entrada	400.00	Venda Avulsa	Vendas	Caixa	PIX	Compensado	Cliente Y	CP039
2315	2026-05-29	11:00:00	2026-05-29 11:00:00	Saída	-50.00	Taxa de Saque	Contas Fixas	Banco B (Poupança)	Saque	Compensado	Banco B	CR040
2316	2026-06-01	10:00:00	2026-06-01 10:00:00	Saída	-25000.00	Compra de Estoque (Inverno)	Fornecedores	Banco A (Corrente)	TED	Compensado	Fornecedor Delta	CP041
2317	2026-06-02	14:00:00	2026-06-02 14:00:00	Entrada	5000.00	Venda Lote 60	Vendas	Banco A (Corrente)	PIX	Compensado	Cliente Alpha	CP042
2318	2026-06-05	10:30:00	2026-06-05 10:30:00	Saída	-3500.00	Aluguel do Escritório	Contas Fixas	Banco A (Corrente)	Boleto	Compensado	Locadora Imóveis	CP043
2319	2026-06-05	11:00:00	2026-06-05 11:00:00	Saída	-850.00	Mensalidade de Software ERP (Jun)	Despesas Operacionais	Banco A (Corrente)	Boleto	Compensado	Fornecedor de TI	CR044
2320	2026-06-06	15:00:00	2026-06-06 15:00:00	Saída	-150.00	Material de Copa	Despesas Operacionais	Caixa	Dinheiro	Compensado	Supermercado Local	CP045
2321	2026-06-07	11:00:00	2026-06-07 11:00:00	Entrada	3600.00	Pagamento de Serviços Recorrentes (Jun)	Serviços Recorrentes	Banco A (Corrente)	TED	Compensado	Empresa Serviços Z	CP046
2322	2026-06-08	13:00:00	2026-06-08 13:00:00	Saída	-500.00	Licença de Software Mensal	Contas Fixas	Cartão Crédito	Cartão Crédito	Compensado	Software Service	CP047
2323	2026-06-09	10:00:00	2026-06-09 10:00:00	Entrada	1800.00	Renda de Aluguéis Imóvel 1	Renda Extra	Banco B (Poupança)	TED	Compensado	Inquilino A	CR048
2324	2026-06-10	16:00:00	2026-06-10 16:00:00	Saída	-1500.00	Manutenção Corretiva	Manutenção	Banco A (Corrente)	TED	Compensado	Serviço L	CP049
2325	2026-06-12	14:00:00	2026-06-12 14:00:00	Entrada	12500.00	Fatura de Venda Lote 42	Vendas	Banco A (Corrente)	PIX	Compensado	Cliente Lambda	CP050
2327	2026-06-15	14:00:00	2026-06-15 14:00:00	Entrada	7000.00	Venda Lote 61	Vendas	Banco A (Corrente)	TED	Compensado	Cliente Gamma	CR052
2328	2026-06-16	16:00:00	2026-06-16 16:00:00	Saída	-450.00	Contas de Consumo (Jun)	Contas Fixas	Banco A (Corrente)	Débito Automático	Compensado	Concessionária A	CP053
2329	2026-06-17	10:00:00	2026-06-17 10:00:00	Entrada	900.00	Reembolso de Despesa	Renda Extra	Caixa	Dinheiro	Compensado	Sócio João	CP054
2330	2026-06-20	15:30:00	2026-06-20 15:30:00	Saída	-24500.00	Salários (Junho)	Folha de Pagamento	Banco A (Corrente)	TED	Compensado	RH - Funcionários	CP055
2331	2026-06-21	14:00:00	2026-06-21 14:00:00	Entrada	3500.00	Venda Lote 62	Vendas	Banco A (Corrente)	TED	Compensado	Cliente Zeta	CR001
2332	2026-06-22	10:00:00	2026-06-22 10:00:00	Saída	-400.00	Manutenção de Equipamento	Despesas Operacionais	Caixa	Dinheiro	Compensado	Oficina Geral	CP001
2333	2026-06-23	16:00:00	2026-06-23 16:00:00	Entrada	13000.00	Venda Lote 50 (Fatura)	Vendas	Banco A (Corrente)	PIX	Compensado	Cliente Beta	CP002
2334	2026-06-26	11:00:00	2026-06-26 11:00:00	Saída	-6000.00	Impostos Mensais (Jun)	Contas Fixas	Banco A (Corrente)	Boleto	Compensado	Receita Federal	CR003
2335	2026-06-27	14:00:00	2026-06-27 14:00:00	Entrada	1500.00	Venda de Consultoria	Prestação de Serviços	Banco A (Corrente)	TED	Compensado	Empresa K	CP005
2336	2026-06-28	12:00:00	2026-06-28 12:00:00	Saída	-50.00	Despesa Cartório	Despesas Operacionais	Caixa	Dinheiro	Compensado	Cartório O	CP006
2337	2026-06-30	16:00:00	2026-06-30 16:00:00	Entrada	400.00	Venda Avulsa	Vendas	Caixa	PIX	Compensado	Cliente Y	CP007
2338	2026-06-01	12:00:00	2026-06-01 12:00:00	Entrada	600.00	Renda de Aluguéis Imóvel 2	Renda Extra	Banco B (Poupança)	TED	Compensado	Inquilino B	CP008
2339	2026-06-04	14:30:00	2026-06-04 14:30:00	Saída	-200.00	Passagens de Ônibus	Logística	Caixa	Dinheiro	Compensado	Viação Y	CR009
2340	2026-06-07	18:00:00	2026-06-07 18:00:00	Saída	-180.00	Telefonia Mensal	Contas Fixas	Banco A (Corrente)	Débito Automático	Compensado	VIVO	CP010
2341	2026-06-10	09:00:00	2026-06-10 09:00:00	Saída	-40.00	Tarifa de Extrato	Contas Fixas	Banco A (Corrente)	Débito Automático	Compensado	Banco A	CR011
2342	2026-06-13	15:00:00	2026-06-13 15:00:00	Entrada	5000.00	Adiantamento de Cliente	Vendas	Banco A (Corrente)	TED	Compensado	Cliente Delta	CP012
2343	2026-06-18	12:30:00	2026-06-18 12:30:00	Saída	-100.00	Almoço de Equipe	Despesas Operacionais	Cartão Crédito	Cartão Crédito	Compensado	Restaurante D	CP013
2344	2026-06-20	10:00:00	2026-06-20 10:00:00	Entrada	800.00	Reembolso de Despesa	Renda Extra	Caixa	Dinheiro	Compensado	Sócio Alfa	CP014
2345	2026-06-24	14:00:00	2026-06-24 14:00:00	Entrada	4500.00	Venda Lote 63	Vendas	Banco A (Corrente)	Boleto	Compensado	Cliente Tau	CP015
2346	2026-06-25	10:00:00	2026-06-25 10:00:00	Saída	-300.00	Compra de Equipamento Pequeno	Despesas Operacionais	Caixa	Dinheiro	Compensado	Loja Elétrica	CP016
2347	2026-06-26	18:00:00	2026-06-26 18:00:00	Saída	-180.00	Telefonia (Adicional)	Contas Fixas	Banco A (Corrente)	Débito Automático	Compensado	VIVO	CR017
2348	2026-06-27	10:00:00	2026-06-27 10:00:00	Entrada	2500.00	Venda Lote 64	Vendas	Banco A (Corrente)	PIX	Compensado	Cliente Gama	CP018
2349	2026-06-28	14:00:00	2026-06-28 14:00:00	Entrada	400.00	Venda Avulsa	Vendas	Caixa	PIX	Compensado	Cliente Y	CP019
2350	2026-06-29	11:00:00	2026-06-29 11:00:00	Saída	-50.00	Taxa de Saque	Contas Fixas	Banco B (Poupança)	Saque	Compensado	Banco B	CR020
2351	2026-07-01	10:00:00	2026-07-01 10:00:00	Saída	-20000.00	Compra de Estoque (Julho)	Fornecedores	Banco A (Corrente)	TED	Compensado	Fornecedor Kappa	CP021
2352	2026-07-02	14:00:00	2026-07-02 14:00:00	Entrada	6200.00	Venda Lote 55 (Fatura)	Vendas	Banco A (Corrente)	PIX	Compensado	Cliente Gamma	CP022
2353	2026-07-05	10:30:00	2026-07-05 10:30:00	Saída	-3500.00	Aluguel do Escritório	Contas Fixas	Banco A (Corrente)	Boleto	Compensado	Locadora Imóveis	CR023
2354	2026-07-05	11:00:00	2026-07-05 11:00:00	Saída	-850.00	Mensalidade de Software ERP (Jul)	Despesas Operacionais	Banco A (Corrente)	Boleto	Compensado	Fornecedor de TI	CP024
2355	2026-07-06	15:00:00	2026-07-06 15:00:00	Saída	-150.00	Material de Copa	Despesas Operacionais	Caixa	Dinheiro	Compensado	Supermercado Local	CP025
2356	2026-07-07	11:00:00	2026-07-07 11:00:00	Entrada	3600.00	Pagamento de Serviços Recorrentes (Jul)	Serviços Recorrentes	Banco A (Corrente)	TED	Compensado	Empresa Serviços Z	CP026
2357	2026-07-08	13:00:00	2026-07-08 13:00:00	Saída	-500.00	Licença de Software Mensal	Contas Fixas	Cartão Crédito	Cartão Crédito	Compensado	Software Service	CR027
2358	2026-07-09	10:00:00	2026-07-09 10:00:00	Entrada	1800.00	Renda de Aluguéis Imóvel 1	Renda Extra	Banco B (Poupança)	TED	Compensado	Inquilino A	CP028
2359	2026-07-10	16:00:00	2026-07-10 16:00:00	Saída	-1500.00	Manutenção Corretiva	Manutenção	Banco A (Corrente)	TED	Compensado	Serviço L	CP029
2360	2026-07-12	14:00:00	2026-07-12 14:00:00	Entrada	8500.00	Venda Lote 65	Vendas	Banco A (Corrente)	PIX	Compensado	Cliente Sigma	CP030
2361	2026-07-14	11:00:00	2026-07-14 11:00:00	Saída	-120.00	Combustível	Logística	Cartão Crédito	Cartão Crédito	Compensado	Posto R	CR031
2362	2026-07-15	14:00:00	2026-07-15 14:00:00	Entrada	6200.00	Venda Lote 55	Vendas	Banco A (Corrente)	TED	Compensado	Cliente Gamma	CP032
2363	2026-07-16	16:00:00	2026-07-16 16:00:00	Saída	-450.00	Contas de Consumo (Jul)	Contas Fixas	Banco A (Corrente)	Débito Automático	Compensado	Concessionária A	CP033
2364	2026-07-17	10:00:00	2026-07-17 10:00:00	Entrada	900.00	Reembolso de Despesa	Renda Extra	Caixa	Dinheiro	Compensado	Sócio João	CP034
2365	2026-07-20	15:30:00	2026-07-20 15:30:00	Saída	-24500.00	Salários (Julho)	Folha de Pagamento	Banco A (Corrente)	TED	Compensado	RH - Funcionários	CP035
2366	2026-07-21	14:00:00	2026-07-21 14:00:00	Entrada	3500.00	Venda Lote 66	Vendas	Banco A (Corrente)	TED	Compensado	Cliente Mu	CR036
2367	2026-07-22	10:00:00	2026-07-22 10:00:00	Saída	-400.00	Manutenção de Equipamento	Despesas Operacionais	Caixa	Dinheiro	Compensado	Oficina Geral	CP037
2368	2026-07-23	16:00:00	2026-07-23 16:00:00	Entrada	7800.00	Venda Lote 67	Vendas	Banco A (Corrente)	PIX	Compensado	Cliente Beta	CP038
2369	2026-07-26	11:00:00	2026-07-26 11:00:00	Saída	-6000.00	Impostos Mensais (Jul)	Contas Fixas	Banco A (Corrente)	Boleto	Compensado	Receita Federal	CP039
2370	2026-07-27	14:00:00	2026-07-27 14:00:00	Entrada	1500.00	Venda de Consultoria	Prestação de Serviços	Banco A (Corrente)	TED	Compensado	Empresa K	CR040
2371	2026-07-28	12:00:00	2026-07-28 12:00:00	Saída	-50.00	Despesa Cartório	Despesas Operacionais	Caixa	Dinheiro	Compensado	Cartório O	CP041
2372	2026-07-30	16:00:00	2026-07-30 16:00:00	Entrada	400.00	Venda Avulsa	Vendas	Caixa	PIX	Compensado	Cliente Y	CP042
2373	2026-07-01	12:00:00	2026-07-01 12:00:00	Entrada	600.00	Renda de Aluguéis Imóvel 2	Renda Extra	Banco B (Poupança)	TED	Compensado	Inquilino B	CP043
2374	2026-07-04	14:30:00	2026-07-04 14:30:00	Saída	-200.00	Passagens de Ônibus	Logística	Caixa	Dinheiro	Compensado	Viação Y	CR044
2375	2026-07-07	18:00:00	2026-07-07 18:00:00	Saída	-180.00	Telefonia Mensal	Contas Fixas	Banco A (Corrente)	Débito Automático	Compensado	VIVO	CP045
2376	2026-07-10	09:00:00	2026-07-10 09:00:00	Saída	-40.00	Tarifa de Extrato	Contas Fixas	Banco A (Corrente)	Débito Automático	Compensado	Banco A	CP046
2377	2026-07-13	15:00:00	2026-07-13 15:00:00	Entrada	5000.00	Adiantamento de Cliente	Vendas	Banco A (Corrente)	TED	Compensado	Cliente Delta	CP047
2378	2026-07-18	12:30:00	2026-07-18 12:30:00	Saída	-100.00	Almoço de Equipe	Despesas Operacionais	Cartão Crédito	Cartão Crédito	Compensado	Restaurante D	CR048
2379	2026-07-20	10:00:00	2026-07-20 10:00:00	Entrada	800.00	Reembolso de Despesa	Renda Extra	Caixa	Dinheiro	Compensado	Sócio Alfa	CP049
2380	2026-07-24	14:00:00	2026-07-24 14:00:00	Entrada	4500.00	Venda Lote 68	Vendas	Banco A (Corrente)	Boleto	Compensado	Cliente Tau	CP050
2381	2026-07-25	10:00:00	2026-07-25 10:00:00	Saída	-300.00	Compra de Equipamento Pequeno	Despesas Operacionais	Caixa	Dinheiro	Compensado	Loja Elétrica	CP051
2382	2026-07-26	18:00:00	2026-07-26 18:00:00	Saída	-180.00	Telefonia (Adicional)	Contas Fixas	Banco A (Corrente)	Débito Automático	Compensado	VIVO	CR052
2383	2026-07-27	10:00:00	2026-07-27 10:00:00	Entrada	2500.00	Venda Lote 69	Vendas	Banco A (Corrente)	PIX	Compensado	Cliente Gama	CP053
2384	2026-07-28	14:00:00	2026-07-28 14:00:00	Entrada	400.00	Venda Avulsa	Vendas	Caixa	PIX	Compensado	Cliente Y	CP054
2385	2026-07-29	11:00:00	2026-07-29 11:00:00	Saída	-50.00	Taxa de Saque	Contas Fixas	Banco B (Poupança)	Saque	Compensado	Banco B	CP055
2386	2026-08-01	10:00:00	2026-08-01 10:00:00	Saída	-22000.00	Compra de Estoque (Agosto)	Fornecedores	Banco A (Corrente)	TED	Compensado	Fornecedor Delta	CR001
2387	2026-08-02	14:00:00	2026-08-02 14:00:00	Entrada	7500.00	Venda Lote 70	Vendas	Banco A (Corrente)	PIX	Compensado	Cliente Alpha	CP001
2388	2026-08-05	10:30:00	2026-08-05 10:30:00	Saída	-3500.00	Aluguel do Escritório	Contas Fixas	Banco A (Corrente)	Boleto	Compensado	Locadora Imóveis	CP002
2389	2026-08-05	11:00:00	2026-08-05 11:00:00	Saída	-850.00	Mensalidade de Software ERP (Ago)	Despesas Operacionais	Banco A (Corrente)	Boleto	Compensado	Fornecedor de TI	CR003
2390	2026-08-06	15:00:00	2026-08-06 15:00:00	Saída	-150.00	Material de Copa	Despesas Operacionais	Caixa	Dinheiro	Compensado	Supermercado Local	CP005
2391	2026-08-07	11:00:00	2026-08-07 11:00:00	Entrada	3600.00	Pagamento de Serviços Recorrentes (Ago)	Serviços Recorrentes	Banco A (Corrente)	TED	Compensado	Empresa Serviços Z	CP006
2392	2026-08-08	13:00:00	2026-08-08 13:00:00	Saída	-500.00	Licença de Software Mensal	Contas Fixas	Cartão Crédito	Cartão Crédito	Compensado	Software Service	CP007
2393	2026-08-09	10:00:00	2026-08-09 10:00:00	Entrada	1800.00	Renda de Aluguéis Imóvel 1	Renda Extra	Banco B (Poupança)	TED	Compensado	Inquilino A	CP008
2394	2026-08-10	16:00:00	2026-08-10 16:00:00	Saída	-7500.00	Marketing (Nova Campanha)	Marketing	Banco A (Corrente)	Boleto	Compensado	Agência Digital	CR009
2395	2026-08-12	14:00:00	2026-08-12 14:00:00	Entrada	9000.00	Venda Lote 60 (Fatura)	Vendas	Banco A (Corrente)	PIX	Compensado	Cliente Alpha	CP010
2396	2026-08-14	11:00:00	2026-08-14 11:00:00	Saída	-120.00	Combustível	Logística	Cartão Crédito	Cartão Crédito	Compensado	Posto R	CR011
2397	2026-08-15	14:00:00	2026-08-15 14:00:00	Entrada	9500.00	Venda Lote 48 (Fatura)	Vendas	Banco A (Corrente)	TED	Compensado	Cliente Tau	CP012
2398	2026-08-16	16:00:00	2026-08-16 16:00:00	Saída	-450.00	Contas de Consumo (Ago)	Contas Fixas	Banco A (Corrente)	Débito Automático	Compensado	Concessionária A	CP013
2399	2026-08-17	10:00:00	2026-08-17 10:00:00	Entrada	900.00	Reembolso de Despesa	Renda Extra	Caixa	Dinheiro	Compensado	Sócio João	CP014
2400	2026-08-20	15:30:00	2026-08-20 15:30:00	Saída	-24500.00	Salários (Agosto)	Folha de Pagamento	Banco A (Corrente)	TED	Compensado	RH - Funcionários	CP015
2401	2026-08-21	14:00:00	2026-08-21 14:00:00	Entrada	3500.00	Venda Lote 71	Vendas	Banco A (Corrente)	TED	Compensado	Cliente Zeta	CP016
2402	2026-08-22	10:00:00	2026-08-22 10:00:00	Saída	-400.00	Manutenção de Equipamento	Despesas Operacionais	Caixa	Dinheiro	Compensado	Oficina Geral	CR017
2403	2026-08-23	16:00:00	2026-08-23 16:00:00	Entrada	6500.00	Venda Lote 72	Vendas	Banco A (Corrente)	PIX	Compensado	Cliente Gamma	CP018
2404	2026-08-26	11:00:00	2026-08-26 11:00:00	Saída	-6000.00	Impostos Mensais (Ago)	Contas Fixas	Banco A (Corrente)	Boleto	Compensado	Receita Federal	CP019
2405	2026-08-27	14:00:00	2026-08-27 14:00:00	Entrada	1500.00	Venda de Consultoria	Prestação de Serviços	Banco A (Corrente)	TED	Compensado	Empresa K	CR020
2406	2026-08-28	12:00:00	2026-08-28 12:00:00	Saída	-50.00	Despesa Cartório	Despesas Operacionais	Caixa	Dinheiro	Compensado	Cartório O	CP021
2408	2026-08-01	12:00:00	2026-08-01 12:00:00	Entrada	600.00	Renda de Aluguéis Imóvel 2	Renda Extra	Banco B (Poupança)	TED	Compensado	Inquilino B	CR023
2409	2026-08-04	14:30:00	2026-08-04 14:30:00	Saída	-200.00	Passagens de Ônibus	Logística	Caixa	Dinheiro	Compensado	Viação Y	CP024
2410	2026-08-07	18:00:00	2026-08-07 18:00:00	Saída	-180.00	Telefonia Mensal	Contas Fixas	Banco A (Corrente)	Débito Automático	Compensado	VIVO	CP025
2411	2026-08-10	09:00:00	2026-08-10 09:00:00	Saída	-40.00	Tarifa de Extrato	Contas Fixas	Banco A (Corrente)	Débito Automático	Compensado	Banco A	CP026
2412	2026-08-13	15:00:00	2026-08-13 15:00:00	Entrada	5000.00	Adiantamento de Cliente	Vendas	Banco A (Corrente)	TED	Compensado	Cliente Delta	CR027
2413	2026-08-18	12:30:00	2026-08-18 12:30:00	Saída	-100.00	Almoço de Equipe	Despesas Operacionais	Cartão Crédito	Cartão Crédito	Compensado	Restaurante D	CP028
2414	2026-08-20	10:00:00	2026-08-20 10:00:00	Entrada	800.00	Reembolso de Despesa	Renda Extra	Caixa	Dinheiro	Compensado	Sócio Alfa	CP029
2415	2026-08-24	14:00:00	2026-08-24 14:00:00	Entrada	4500.00	Venda Lote 73	Vendas	Banco A (Corrente)	Boleto	Compensado	Cliente Tau	CP030
2416	2026-08-25	10:00:00	2026-08-25 10:00:00	Saída	-300.00	Compra de Equipamento Pequeno	Despesas Operacionais	Caixa	Dinheiro	Compensado	Loja Elétrica	CR031
2417	2026-08-26	18:00:00	2026-08-26 18:00:00	Saída	-180.00	Telefonia (Adicional)	Contas Fixas	Banco A (Corrente)	Débito Automático	Compensado	VIVO	CP032
2418	2026-08-27	10:00:00	2026-08-27 10:00:00	Entrada	2500.00	Venda Lote 74	Vendas	Banco A (Corrente)	PIX	Compensado	Cliente Gama	CP033
2419	2026-08-28	14:00:00	2026-08-28 14:00:00	Entrada	400.00	Venda Avulsa	Vendas	Caixa	PIX	Compensado	Cliente Y	CP034
2420	2026-08-29	11:00:00	2026-08-29 11:00:00	Saída	-50.00	Taxa de Saque	Contas Fixas	Banco B (Poupança)	Saque	Compensado	Banco B	CP035
\.


--
-- TOC entry 4958 (class 0 OID 49169)
-- Dependencies: 226
-- Data for Name: contas_planejadas; Type: TABLE DATA; Schema: silver; Owner: postgres
--

COPY silver.contas_planejadas (id_conta, tipo_conta, descricao_detalhada, valor_previsto, data_vencimento, categoria_financeira, status_cobranca, parceiro, condicao_pgto) FROM stdin;
CR001	Receber	Fatura de Venda Lote 25	9500.00	2025-11-15	Vendas Futuras	Pago	Cliente Tau	15 DDL
CP001	Pagar	Salários de Novembro (Provisão)	-23000.00	2025-11-20	Folha de Pagamento	Pago	RH - Funcionários	Mensal
CP002	Pagar	Campanha Black Friday (2ª parcela)	-4000.00	2025-11-30	Marketing	Pago	Agência Digital	2x
CR003	Receber	Venda de Produto Especial	1200.00	2025-12-05	Vendas Futuras	Aberto	Cliente Epsilon	À Vista
CP005	Pagar	Aluguel do Escritório (Dez)	-3500.00	2025-12-05	Contas Fixas	Aberto	Locadora Imóveis	Mensal
CP006	Pagar	Compra de Estoque (Natal)	-15000.00	2025-12-08	Fornecedores	Aberto	Fornecedor Beta	45 DDL
CP007	Pagar	13º Salário (Provisão)	-15000.00	2025-12-20	Folha de Pagamento	Aberto	RH - Funcionários	Único
CP008	Pagar	Salários de Dezembro	-23000.00	2025-12-20	Folha de Pagamento	Aberto	RH - Funcionários	Mensal
CR009	Receber	Pagamento de Serviço de Dezembro	3500.00	2025-12-25	Serviços Recorrentes	Aberto	Empresa Serviços Z	Mensal
CP010	Pagar	Impostos Mensais (Dez)	-6000.00	2025-12-30	Contas Fixas	Aberto	Receita Federal	Mensal
CR011	Receber	Venda Lote 27	7500.00	2026-01-05	Vendas Futuras	Aberto	Cliente Gama	30 DDL
CP012	Pagar	Aluguel do Escritório (Jan)	-3500.00	2026-01-05	Contas Fixas	Aberto	Locadora Imóveis	Mensal
CP013	Pagar	Mensalidade de Software ERP (Jan)	-850.00	2026-01-05	Despesas Operacionais	Aberto	Fornecedor de TI	Boleto
CP014	Pagar	Compra de Matéria-Prima (Pedido 56)	-21000.00	2026-01-10	Fornecedores	Aberto	Fornecedor Delta	30 DDL
CP015	Pagar	Salários de Janeiro (Provisão)	-24000.00	2026-01-20	Folha de Pagamento	Aberto	RH - Funcionários	Mensal
CP016	Pagar	Renovação de Contrato Anual TI	-15000.00	2026-01-28	Despesas Operacionais	Aberto	Fornecedor de TI	TED
CR017	Receber	Venda Lote 28	4800.00	2026-02-05	Vendas Futuras	Aberto	Cliente Omicron	45 DDL
CP018	Pagar	Aluguel do Escritório (Fev)	-3500.00	2026-02-05	Contas Fixas	Aberto	Locadora Imóveis	Mensal
CP019	Pagar	Marketing de Lançamento (Fev)	-7000.00	2026-02-15	Marketing	Aberto	Agência Digital	30 DDL
CR020	Receber	Fatura de Venda Lote 29	11000.00	2026-02-15	Vendas Futuras	Aberto	Cliente Tau	30 DDL
CP021	Pagar	Salários de Fevereiro (Provisão)	-24500.00	2026-02-20	Folha de Pagamento	Aberto	RH - Funcionários	Mensal
CP022	Pagar	Impostos Mensais (Fev)	-6500.00	2026-02-28	Contas Fixas	Aberto	Receita Federal	Mensal
CR023	Receber	Fatura de Venda Lote 31	8800.00	2026-03-05	Vendas Futuras	Aberto	Cliente Mu	30 DDL
CP024	Pagar	Aluguel do Escritório (Mar)	-3500.00	2026-03-05	Contas Fixas	Aberto	Locadora Imóveis	Mensal
CP025	Pagar	Compra de Estoque (Mar)	-19000.00	2026-03-10	Fornecedores	Aberto	Fornecedor Kappa	45 DDL
CP026	Pagar	Salários de Março (Provisão)	-24500.00	2026-03-20	Folha de Pagamento	Aberto	RH - Funcionários	Mensal
CR027	Receber	Pagamento de Serviços Recorrentes (Abr)	3600.00	2026-04-05	Serviços Recorrentes	Aberto	Empresa Serviços Z	Mensal
CP028	Pagar	Aluguel do Escritório (Abr)	-3500.00	2026-04-05	Contas Fixas	Aberto	Locadora Imóveis	Mensal
CP029	Pagar	Salários de Abril (Provisão)	-24500.00	2026-04-20	Folha de Pagamento	Aberto	RH - Funcionários	Mensal
CP030	Pagar	Impostos Trimestrais	-5500.00	2026-04-28	Contas Fixas	Aberto	Receita Federal	Trimestral
CR031	Receber	Venda Lote 38	5500.00	2026-05-15	Vendas Futuras	Aberto	Cliente Zeta	30 DDL
CP032	Pagar	Aluguel do Escritório (Mai)	-3500.00	2026-05-05	Contas Fixas	Aberto	Locadora Imóveis	Mensal
CP033	Pagar	Marketing (Meio do Ano)	-10000.00	2026-05-10	Marketing	Aberto	Agência Digital	TED
CP034	Pagar	Salários de Maio (Provisão)	-24500.00	2026-05-20	Folha de Pagamento	Aberto	RH - Funcionários	Mensal
CP035	Pagar	Impostos Mensais (Mai)	-6000.00	2026-05-30	Contas Fixas	Aberto	Receita Federal	Mensal
CR036	Receber	Fatura de Venda Lote 42	12500.00	2026-06-15	Vendas Futuras	Aberto	Cliente Lambda	30 DDL
CP037	Pagar	Aluguel do Escritório (Jun)	-3500.00	2026-06-05	Contas Fixas	Aberto	Locadora Imóveis	Mensal
CP038	Pagar	Compra de Estoque (Jun)	-25000.00	2026-06-18	Fornecedores	Aberto	Fornecedor Delta	30 DDL
CP039	Pagar	Salários de Junho (Provisão)	-24500.00	2026-06-20	Folha de Pagamento	Aberto	RH - Funcionários	Mensal
CR040	Receber	Renda de Aluguéis Imóvel 1 (Jul)	1800.00	2026-07-10	Renda Extra	Aberto	Inquilino A	Mensal
CP041	Pagar	Aluguel do Escritório (Jul)	-3500.00	2026-07-05	Contas Fixas	Aberto	Locadora Imóveis	Mensal
CP042	Pagar	Salários de Julho (Provisão)	-24500.00	2026-07-20	Folha de Pagamento	Aberto	RH - Funcionários	Mensal
CP043	Pagar	Impostos Mensais (Jul)	-6000.00	2026-07-30	Contas Fixas	Aberto	Receita Federal	Mensal
CR044	Receber	Venda Lote 48	9500.00	2026-08-15	Vendas Futuras	Aberto	Cliente Tau	30 DDL
CP045	Pagar	Aluguel do Escritório (Ago)	-3500.00	2026-08-05	Contas Fixas	Aberto	Locadora Imóveis	Mensal
CP046	Pagar	Salários de Agosto (Provisão)	-24500.00	2026-08-20	Folha de Pagamento	Aberto	RH - Funcionários	Mensal
CP047	Pagar	Marketing (Nova Campanha)	-7500.00	2026-08-25	Marketing	Aberto	Agência Digital	Boleto
CR048	Receber	Fatura de Venda Lote 52	7200.00	2026-09-15	Vendas Futuras	Aberto	Cliente Gamma	45 DDL
CP049	Pagar	Aluguel do Escritório (Set)	-3500.00	2026-09-05	Contas Fixas	Aberto	Locadora Imóveis	Mensal
CP050	Pagar	Salários de Setembro (Provisão)	-25000.00	2026-09-20	Folha de Pagamento	Aberto	RH - Funcionários	Mensal
CP051	Pagar	Compra de Estoque (Set)	-28000.00	2026-09-25	Fornecedores	Aberto	Fornecedor Kappa	45 DDL
CR052	Receber	Venda Lote 55	15000.00	2026-10-15	Vendas Futuras	Aberto	Cliente Alfa	60 DDL
CP053	Pagar	Aluguel do Escritório (Out)	-3500.00	2026-10-05	Contas Fixas	Aberto	Locadora Imóveis	Mensal
CP054	Pagar	Salários de Outubro (Provisão)	-25000.00	2026-10-20	Folha de Pagamento	Aberto	RH - Funcionários	Mensal
CP055	Pagar	Impostos Mensais (Out)	-6200.00	2026-10-30	Contas Fixas	Aberto	Receita Federal	Mensal
\.


--
-- TOC entry 4959 (class 0 OID 49180)
-- Dependencies: 227
-- Data for Name: transacoes_realizadas; Type: TABLE DATA; Schema: silver; Owner: postgres
--

COPY silver.transacoes_realizadas (id_transacao, id_conta, data_transacao, hora_transacao, tipo_transacao, valor, descricao, categoria, conta_origem, meio_pgto, status_transacao, estabelecimento) FROM stdin;
2164	CP054	2026-01-31	16:00:00	Entrada	400.00	Venda Avulsa	Vendas	Caixa	PIX	Compensado	Cliente Y
2001	CR001	2025-09-01	09:15:00	Entrada	5200.00	Venda Lote 1	Vendas	Banco A (Corrente)	PIX	Compensado	Cliente Alfa
2002	CP001	2025-09-01	14:45:00	Saída	-450.00	Material de Escritório	Despesas Operacionais	Caixa	Dinheiro	Compensado	Papelaria Central
2003	CP002	2025-09-01	17:55:00	Entrada	1800.00	Prestação de Serviço (Mês Anterior)	Prestação de Serviços	Banco A (Corrente)	Boleto	Compensado	Empresa Serviços Z
2004	CR003	2025-09-02	11:30:00	Saída	-25000.00	Pagamento Fornecedor Principal	Fornecedores	Banco A (Corrente)	TED	Compensado	Fornecedor Delta
2371	CP041	2026-07-28	12:00:00	Saída	-50.00	Despesa Cartório	Despesas Operacionais	Caixa	Dinheiro	Compensado	Cartório O
2005	CP005	2025-09-03	08:50:00	Saída	-30.00	Taxa Bancária Mensal	Contas Fixas	Banco A (Corrente)	Débito Automático	Compensado	Banco A
2006	CP006	2025-09-04	10:00:00	Saída	-8000.00	Campanha de Marketing Digital	Marketing	Banco A (Corrente)	Boleto	Compensado	Agência Digital
2007	CP007	2025-09-04	14:00:00	Entrada	600.00	Renda de Aluguéis Imóvel 1	Renda Extra	Banco B (Poupança)	TED	Compensado	Inquilino A
2008	CP008	2025-09-05	10:30:00	Saída	-3500.00	Aluguel do Escritório	Contas Fixas	Banco A (Corrente)	Boleto	Compensado	Locadora Imóveis
2009	CR009	2025-09-05	14:00:00	Entrada	3500.00	Venda Lote 2	Vendas	Banco A (Corrente)	PIX	Compensado	Cliente Gamma
2010	CP010	2025-09-06	15:20:00	Saída	-150.00	Manutenção de Computadores	Despesas Operacionais	Caixa	Dinheiro	Compensado	Técnico Info
2011	CR011	2025-09-08	09:00:00	Entrada	7500.00	Venda Lote 3 (Grande)	Vendas	Banco A (Corrente)	TED	Compensado	Cliente Delta
2012	CP012	2025-09-08	11:45:00	Saída	-200.00	Combustível para Entrega	Logística	Cartão Crédito	Cartão Crédito	Compensado	Posto Ipiranga
2013	CP013	2025-09-09	13:00:00	Entrada	4200.00	Venda Lote 4	Vendas	Banco A (Corrente)	PIX	Compensado	Cliente Alfa
2014	CP014	2025-09-10	16:50:00	Saída	-1200.00	Serviço de Limpeza	Despesas Operacionais	Banco A (Corrente)	TED	Compensado	Empresa Limpeza
2015	CP015	2025-09-11	10:00:00	Entrada	900.00	Venda de Acessórios	Vendas	Caixa	Dinheiro	Compensado	Cliente Eta
2016	CP016	2025-09-11	17:15:00	Saída	-40000.00	Compra de Matéria-Prima	Fornecedores	Banco A (Corrente)	TED	Compensado	Fornecedor Kappa
2017	CR017	2025-09-12	14:20:00	Entrada	500.00	Reembolso de Despesa de Viagem	Renda Extra	Banco B (Poupança)	PIX	Compensado	Sócio Alfa
2018	CP018	2025-09-13	09:30:00	Saída	-180.00	Mensalidade de Internet	Contas Fixas	Banco A (Corrente)	Débito Automático	Compensado	Provedor NET
2019	CP019	2025-09-15	16:00:00	Entrada	15000.00	Venda Lote 5 (Muito Grande)	Vendas	Banco A (Corrente)	TED	Compensado	Cliente Beta
2020	CR020	2025-09-16	12:00:00	Saída	-1500.00	Serviço de Contabilidade	Despesas Operacionais	Banco A (Corrente)	Boleto	Compensado	Contador XPTO
2021	CP021	2025-09-17	14:00:00	Entrada	2200.00	Venda Lote 6	Vendas	Banco A (Corrente)	PIX	Compensado	Cliente Zeta
2022	CP022	2025-09-17	18:00:00	Saída	-150.00	Material de Copa	Despesas Operacionais	Caixa	Dinheiro	Compensado	Supermercado Local
2023	CR023	2025-09-18	11:00:00	Entrada	800.00	Venda de Conserto	Prestação de Serviços	Banco A (Corrente)	PIX	Compensado	Cliente Theta
2024	CP024	2025-09-18	16:00:00	Saída	-500.00	Licença de Software Mensal	Contas Fixas	Cartão Crédito	Cartão Crédito	Compensado	Software Service
2025	CP025	2025-09-19	10:00:00	Saída	-3000.00	Pagamento Parcial Fornecedor Beta	Fornecedores	Banco A (Corrente)	TED	Compensado	Fornecedor Beta
2026	CP026	2025-09-20	14:00:00	Entrada	6500.00	Venda Lote 7 (Fechamento)	Vendas	Banco A (Corrente)	TED	Compensado	Cliente Iota
2027	CR027	2025-09-21	10:00:00	Saída	-250.00	Jantar de Negócios	Despesas Operacionais	Cartão Crédito	Cartão Crédito	Pendente	Restaurante A
2028	CP028	2025-09-22	12:00:00	Entrada	1200.00	Renda de Aluguéis Imóvel 2	Renda Extra	Banco B (Poupança)	TED	Compensado	Inquilino B
2029	CP029	2025-09-22	15:30:00	Saída	-18000.00	Salários (Final do Mês)	Folha de Pagamento	Banco A (Corrente)	TED	Compensado	RH - Funcionários
2030	CP030	2025-09-23	09:00:00	Saída	-1000.00	Seguro Mensal	Contas Fixas	Banco A (Corrente)	Débito Automático	Compensado	Seguradora X
2031	CR031	2025-09-24	14:00:00	Entrada	3800.00	Venda Lote 8	Vendas	Banco A (Corrente)	Boleto	Pendente	Cliente Kappa
2032	CP032	2025-09-25	11:00:00	Saída	-450.00	Manutenção de Equipamento	Despesas Operacionais	Caixa	Dinheiro	Compensado	Oficina Geral
2033	CP033	2025-09-26	16:00:00	Entrada	250.00	Venda Avulsa	Vendas	Caixa	PIX	Compensado	Cliente Lambda
2034	CP034	2025-09-29	09:20:00	Saída	-5000.00	Pagamento de Impostos	Contas Fixas	Banco A (Corrente)	Boleto	Compensado	Receita Federal
2407	CP022	2026-08-30	16:00:00	Entrada	400.00	Venda Avulsa	Vendas	Caixa	PIX	Compensado	Cliente Y
2035	CP035	2025-09-30	15:00:00	Entrada	8500.00	Venda Lote 9 (Fechamento)	Vendas	Banco A (Corrente)	TED	Compensado	Cliente Mu
2036	CR036	2025-10-01	11:30:00	Entrada	5800.00	Venda Lote 14	Vendas	Banco A (Corrente)	PIX	Compensado	Cliente Alfa
2037	CP037	2025-10-02	09:15:00	Saída	-350.00	Material de Higiene	Despesas Operacionais	Caixa	Dinheiro	Compensado	Supermercado Local
2038	CP038	2025-10-03	09:40:00	Saída	-1500.00	Material de Embalagem	Fornecedores	Banco A (Corrente)	Boleto	Compensado	Fornecedor Beta
2039	CP039	2025-10-04	16:55:00	Entrada	2100.00	Prestação de Serviço (Treinamento)	Prestação de Serviços	Banco B (Poupança)	TED	Compensado	Empresa Serviços Z
2040	CR040	2025-10-05	14:00:00	Saída	-3500.00	Aluguel do Escritório	Contas Fixas	Banco A (Corrente)	Boleto	Compensado	Locadora Imóveis
2041	CP041	2025-10-06	09:10:00	Entrada	4500.00	Venda Lote 15	Vendas	Banco A (Corrente)	PIX	Compensado	Cliente Gamma
2042	CP042	2025-10-07	17:30:00	Saída	-4000.00	Compra de Software	Despesas Operacionais	Banco A (Corrente)	Boleto	Compensado	Fornecedor de TI
2043	CP043	2025-10-08	10:00:00	Saída	-500.00	Doação Institucional	Despesas Operacionais	Banco A (Corrente)	TED	Compensado	Instituição ABC
2044	CR044	2025-10-09	12:00:00	Entrada	1500.00	Reembolso de Despesas	Renda Extra	Banco B (Poupança)	PIX	Compensado	Sócio João
2045	CP045	2025-10-10	14:30:00	Saída	-120.00	Compra de Café/Almoço	Despesas Operacionais	Caixa	Dinheiro	Compensado	Padaria Central
2046	CP046	2025-10-13	11:10:00	Entrada	1800.00	Venda Lote 16	Vendas	Banco A (Corrente)	PIX	Compensado	Cliente Epsilon
2047	CP047	2025-10-14	13:00:00	Saída	-7500.00	Pagamento Parcial Fornecedor Principal	Fornecedores	Banco A (Corrente)	TED	Compensado	Fornecedor Delta
2048	CR048	2025-10-15	17:00:00	Entrada	9000.00	Venda Lote 17 (Grande)	Vendas	Banco A (Corrente)	Boleto	Compensado	Cliente Alfa
2049	CP049	2025-10-16	09:00:00	Saída	-250.00	Reparo de Vazamento	Manutenção	Caixa	Dinheiro	Compensado	Encanador Z
2050	CP050	2025-10-17	14:00:00	Entrada	3000.00	Venda Lote 18	Vendas	Banco A (Corrente)	PIX	Compensado	Cliente Zeta
2051	CP051	2025-10-20	11:30:00	Saída	-50.00	Taxa de Saque	Contas Fixas	Banco B (Poupança)	Saque	Compensado	Banco B
2052	CR052	2025-10-21	18:05:00	Saída	-15000.00	Salários (Parte Final)	Folha de Pagamento	Banco A (Corrente)	TED	Compensado	RH - Funcionários
2053	CP053	2025-10-22	10:00:00	Entrada	600.00	Renda de Aluguéis Imóvel 2	Renda Extra	Banco B (Poupança)	TED	Compensado	Inquilino B
2054	CP054	2025-10-23	13:45:00	Saída	-4500.00	Pagamento de Impostos (Complemento)	Contas Fixas	Banco A (Corrente)	Boleto	Compensado	Receita Federal
2055	CP055	2025-10-24	16:00:00	Entrada	10000.00	Venda Lote 19 (Fechamento)	Vendas	Banco A (Corrente)	TED	Compensado	Cliente Alpha
2056	CR001	2025-10-25	10:00:00	Saída	-180.00	Telefonia Mensal	Contas Fixas	Banco A (Corrente)	Débito Automático	Compensado	VIVO
2057	CP001	2025-10-26	14:00:00	Entrada	2500.00	Venda Lote 14 - Parcela 1	Vendas	Banco A (Corrente)	Boleto	Compensado	Cliente F
2058	CP002	2025-10-27	10:00:00	Saída	-600.00	Assinatura Adobe	Despesas Operacionais	Cartão Crédito	Cartão Crédito	Compensado	Adobe
2059	CR003	2025-10-27	16:00:00	Entrada	350.00	Venda Avulsa (Caixa)	Vendas	Caixa	Dinheiro	Compensado	Cliente G
2060	CP005	2025-10-28	11:00:00	Saída	-50.00	Estacionamento	Despesas Operacionais	Caixa	Dinheiro	Compensado	Estacionamento H
2061	CP006	2025-10-28	15:00:00	Entrada	4200.00	Fatura de Serviço	Prestação de Serviços	Banco A (Corrente)	TED	Compensado	Empresa K
2062	CP007	2025-10-29	09:00:00	Saída	-800.00	Manutenção Predial	Manutenção	Banco A (Corrente)	PIX	Compensado	Serviço L
2063	CP008	2025-10-29	13:00:00	Entrada	750.00	Comissão Recebida	Renda Extra	Banco B (Poupança)	PIX	Compensado	Parceiro M
2064	CR009	2025-10-30	14:00:00	Saída	-2000.00	Consultoria Jurídica	Despesas Operacionais	Banco A (Corrente)	Boleto	Compensado	Advogados N
2065	CP010	2025-10-30	16:00:00	Entrada	300.00	Reembolso de Taxa	Renda Extra	Banco A (Corrente)	PIX	Compensado	Banco A
2066	CR011	2025-10-31	10:00:00	Saída	-50.00	Despesa Cartório	Despesas Operacionais	Caixa	Dinheiro	Compensado	Cartório O
2067	CP012	2025-10-31	12:00:00	Entrada	1500.00	Venda Avulsa de Produto	Vendas	Caixa	Dinheiro	Compensado	Cliente P
2068	CP013	2025-10-18	12:30:00	Entrada	500.00	Reembolso de Combustível	Renda Extra	Caixa	Dinheiro	Compensado	Funcionário X
2069	CP014	2025-10-19	14:30:00	Saída	-150.00	Almoço Executivo	Despesas Operacionais	Cartão Crédito	Cartão Crédito	Compensado	Restaurante C
2070	CP015	2025-10-25	12:00:00	Saída	-1200.00	Licença Anual de Antivírus	Despesas Operacionais	Banco A (Corrente)	Boleto	Compensado	Fornecedor de TI
2071	CP016	2025-11-03	10:00:00	Saída	-35000.00	Compra de Estoque (Grande)	Fornecedores	Banco A (Corrente)	TED	Compensado	Fornecedor Delta
2072	CR017	2025-11-04	14:00:00	Entrada	4500.00	Venda Lote 20	Vendas	Banco A (Corrente)	PIX	Compensado	Cliente Alfa
2073	CP018	2025-11-05	10:30:00	Saída	-3500.00	Aluguel do Escritório	Contas Fixas	Banco A (Corrente)	Boleto	Compensado	Locadora Imóveis
2074	CP019	2025-11-05	11:00:00	Saída	-850.00	Mensalidade de Software ERP	Despesas Operacionais	Banco A (Corrente)	Boleto	Compensado	Fornecedor de TI
2075	CR020	2025-11-06	15:00:00	Saída	-150.00	Material de Copa	Despesas Operacionais	Caixa	Dinheiro	Compensado	Supermercado Local
2076	CP021	2025-11-07	11:00:00	Entrada	2800.00	Venda Lote 21	Vendas	Banco A (Corrente)	TED	Compensado	Cliente P
2077	CP022	2025-11-10	13:00:00	Saída	-18000.00	Compra de Matéria-Prima (Pedido 55)	Fornecedores	Banco A (Corrente)	TED	Compensado	Fornecedor Delta
2078	CR023	2025-11-12	10:00:00	Entrada	1500.00	Venda Avulsa	Vendas	Caixa	PIX	Compensado	Cliente Q
2079	CP024	2025-11-14	16:00:00	Saída	-300.00	Taxa de Manutenção	Contas Fixas	Banco A (Corrente)	Débito Automático	Compensado	Banco A
2080	CP025	2025-11-15	14:00:00	Entrada	9500.00	Fatura de Venda Lote 25	Vendas	Banco A (Corrente)	TED	Compensado	Cliente Tau
2081	CP026	2025-11-17	11:00:00	Saída	-120.00	Combustível	Logística	Cartão Crédito	Cartão Crédito	Compensado	Posto R
2082	CR027	2025-11-18	10:00:00	Entrada	600.00	Renda de Aluguéis Imóvel 1	Renda Extra	Banco B (Poupança)	TED	Compensado	Inquilino A
2083	CP028	2025-11-19	11:15:00	Saída	-8000.00	Campanha de Marketing (Black Friday)	Marketing	Banco A (Corrente)	TED	Compensado	Agência Digital
2084	CP029	2025-11-20	15:30:00	Saída	-23000.00	Salários (Novembro)	Folha de Pagamento	Banco A (Corrente)	TED	Compensado	RH - Funcionários
2085	CP030	2025-11-21	14:00:00	Entrada	3200.00	Venda Lote 26	Vendas	Banco A (Corrente)	PIX	Compensado	Cliente S
2086	CR031	2025-11-22	10:00:00	Saída	-400.00	Material de Embalagem	Fornecedores	Caixa	Dinheiro	Compensado	Fornecedor U
2087	CP032	2025-11-24	16:00:00	Entrada	3500.00	Pagamento de Serviços Recorrentes	Serviços Recorrentes	Banco A (Corrente)	TED	Compensado	Empresa Serviços Z
2088	CP033	2025-11-25	11:00:00	Saída	-500.00	Licença de Software Mensal	Contas Fixas	Cartão Crédito	Cartão Crédito	Compensado	Software Service
2089	CP034	2025-11-26	09:00:00	Entrada	7000.00	Venda Lote 27	Vendas	Banco A (Corrente)	Boleto	Compensado	Cliente V
2090	CP035	2025-11-27	13:00:00	Saída	-2500.00	Consultoria Financeira	Despesas Operacionais	Banco A (Corrente)	TED	Compensado	Consultor W
2091	CR036	2025-11-28	15:00:00	Entrada	12000.00	Venda Black Friday (Alta)	Vendas	Banco A (Corrente)	PIX	Compensado	Cliente Sigma
2092	CP037	2025-11-29	09:20:00	Saída	-5200.00	Pagamento de Impostos (Novembro)	Contas Fixas	Banco A (Corrente)	Boleto	Compensado	Receita Federal
2093	CP038	2025-11-30	16:00:00	Entrada	450.00	Venda Avulsa (Caixa)	Vendas	Caixa	Dinheiro	Compensado	Cliente X
2094	CP039	2025-11-01	12:00:00	Entrada	1500.00	Renda de Aluguéis Imóvel 2	Renda Extra	Banco B (Poupança)	TED	Compensado	Inquilino B
2095	CR040	2025-11-02	14:30:00	Saída	-200.00	Passagens de Ônibus	Logística	Caixa	Dinheiro	Compensado	Viação Y
2096	CP041	2025-11-08	16:00:00	Entrada	900.00	Venda de Reparo	Prestação de Serviços	Banco A (Corrente)	PIX	Compensado	Cliente Z
2097	CP042	2025-11-10	09:00:00	Saída	-40.00	Tarifa de Extrato	Contas Fixas	Banco A (Corrente)	Débito Automático	Compensado	Banco A
2098	CP043	2025-11-11	15:00:00	Entrada	5000.00	Adiantamento de Cliente	Vendas	Banco A (Corrente)	TED	Compensado	Cliente Delta
2099	CR044	2025-11-16	12:30:00	Saída	-100.00	Almoço de Equipe	Despesas Operacionais	Cartão Crédito	Cartão Crédito	Compensado	Restaurante D
2100	CP045	2025-11-23	14:00:00	Entrada	800.00	Reembolso de Despesa	Renda Extra	Caixa	Dinheiro	Compensado	Sócio Alfa
2101	CP046	2025-11-24	10:00:00	Saída	-300.00	Compra de Equipamento Pequeno	Despesas Operacionais	Caixa	Dinheiro	Compensado	Loja Elétrica
2102	CP047	2025-11-26	18:00:00	Saída	-180.00	Telefonia (Adicional)	Contas Fixas	Banco A (Corrente)	Débito Automático	Compensado	VIVO
2103	CR048	2025-11-27	10:00:00	Entrada	4500.00	Venda Lote 28	Vendas	Banco A (Corrente)	Boleto	Compensado	Cliente Mu
2104	CP049	2025-11-28	12:00:00	Saída	-50.00	Despesa com Cartório	Despesas Operacionais	Caixa	Dinheiro	Compensado	Cartório O
2105	CP050	2025-11-29	14:00:00	Entrada	1500.00	Venda de Serviço (Fechamento)	Prestação de Serviços	Banco A (Corrente)	PIX	Compensado	Empresa K
2106	CP051	2025-12-02	10:00:00	Saída	-25000.00	Compra de Estoque (Natal)	Fornecedores	Banco A (Corrente)	TED	Compensado	Fornecedor Beta
2107	CR052	2025-12-03	14:00:00	Entrada	5000.00	Venda Lote 29	Vendas	Banco A (Corrente)	PIX	Compensado	Cliente Epsilon
2108	CP053	2025-12-04	15:00:00	Saída	-150.00	Material de Limpeza	Despesas Operacionais	Caixa	Dinheiro	Compensado	Supermercado Local
2109	CP054	2025-12-05	10:30:00	Saída	-3500.00	Aluguel do Escritório	Contas Fixas	Banco A (Corrente)	Boleto	Compensado	Locadora Imóveis
2110	CP055	2025-12-05	11:00:00	Saída	-850.00	Mensalidade de Software ERP	Despesas Operacionais	Banco A (Corrente)	Boleto	Compensado	Fornecedor de TI
2111	CR001	2025-12-06	12:00:00	Entrada	1200.00	Venda de Produto Especial	Vendas	Caixa	Dinheiro	Compensado	Cliente Epsilon
2112	CP001	2025-12-08	09:00:00	Saída	-40.00	Tarifa de Extrato	Contas Fixas	Banco A (Corrente)	Débito Automático	Compensado	Banco A
2113	CP002	2025-12-09	14:00:00	Entrada	6000.00	Venda Lote 30	Vendas	Banco A (Corrente)	TED	Compensado	Cliente Lambda
2114	CR003	2025-12-10	10:00:00	Entrada	1800.00	Renda de Aluguéis Imóvel 1	Renda Extra	Banco B (Poupança)	TED	Compensado	Inquilino A
2115	CP005	2025-12-11	13:00:00	Saída	-150.00	Jantar de Negócios	Despesas Operacionais	Cartão Crédito	Cartão Crédito	Compensado	Restaurante E
2116	CP006	2025-12-12	16:00:00	Entrada	8500.00	Venda Lote 31	Vendas	Banco A (Corrente)	PIX	Compensado	Cliente Gamma
2117	CP007	2025-12-15	14:00:00	Saída	-10000.00	Pagamento Fornecedor Alpha	Fornecedores	Banco A (Corrente)	TED	Compensado	Fornecedor Kappa
2118	CP008	2025-12-16	10:00:00	Entrada	3500.00	Pagamento de Serviços Recorrentes	Serviços Recorrentes	Banco A (Corrente)	TED	Compensado	Empresa Serviços Z
2119	CR009	2025-12-17	18:00:00	Saída	-450.00	Contas de Consumo (Água/Luz)	Contas Fixas	Banco A (Corrente)	Débito Automático	Compensado	Concessionária A
2120	CP010	2025-12-18	11:00:00	Entrada	4200.00	Venda Lote 32	Vendas	Banco A (Corrente)	Boleto	Compensado	Cliente Mu
2121	CR011	2025-12-19	15:30:00	Saída	-15000.00	13º Salário (Provisão)	Folha de Pagamento	Banco A (Corrente)	TED	Compensado	RH - Funcionários
2122	CP012	2025-12-20	15:30:00	Saída	-23000.00	Salários (Dezembro)	Folha de Pagamento	Banco A (Corrente)	TED	Compensado	RH - Funcionários
2123	CP013	2025-12-21	10:00:00	Entrada	900.00	Venda de Reparo	Prestação de Serviços	Caixa	Dinheiro	Compensado	Cliente Z
2124	CP014	2025-12-22	14:00:00	Saída	-2500.00	Consultoria de Fim de Ano	Despesas Operacionais	Banco A (Corrente)	Boleto	Compensado	Consultor F
2125	CP015	2025-12-23	16:00:00	Entrada	7500.00	Venda Lote 33 (Última do Ano)	Vendas	Banco A (Corrente)	TED	Compensado	Cliente Delta
2126	CP016	2025-12-24	11:00:00	Saída	-120.00	Compra de Brindes	Marketing	Caixa	Dinheiro	Compensado	Loja de Presentes
2127	CR017	2025-12-26	14:00:00	Entrada	600.00	Renda de Aluguéis Imóvel 2	Renda Extra	Banco B (Poupança)	TED	Compensado	Inquilino B
2128	CP018	2025-12-27	10:00:00	Saída	-500.00	Licença de Software Mensal	Contas Fixas	Cartão Crédito	Cartão Crédito	Compensado	Software Service
2129	CP019	2025-12-28	16:00:00	Entrada	300.00	Venda Avulsa	Vendas	Caixa	PIX	Compensado	Cliente X
2130	CR020	2025-12-29	09:20:00	Saída	-6000.00	Impostos Mensais (IRPJ/CSLL)	Contas Fixas	Banco A (Corrente)	Boleto	Compensado	Receita Federal
2131	CP021	2025-12-30	14:00:00	Entrada	1500.00	Venda de Consultoria	Prestação de Serviços	Banco A (Corrente)	TED	Compensado	Empresa K
2132	CP022	2025-12-01	12:00:00	Entrada	700.00	Venda Lote 28 - Parcela 2	Vendas	Banco A (Corrente)	Boleto	Compensado	Cliente Mu
2133	CR023	2025-12-04	09:00:00	Saída	-180.00	Mensalidade de Internet	Contas Fixas	Banco A (Corrente)	Débito Automático	Compensado	Provedor NET
2134	CP024	2025-12-07	14:30:00	Saída	-200.00	Combustível (Viagem)	Logística	Cartão Crédito	Cartão Crédito	Compensado	Posto H
2135	CP025	2025-12-10	16:00:00	Saída	-1200.00	Serviço de Limpeza (Fim de Ano)	Despesas Operacionais	Banco A (Corrente)	TED	Compensado	Empresa Limpeza
2136	CP026	2025-12-13	10:00:00	Entrada	3000.00	Venda Lote 34	Vendas	Banco A (Corrente)	PIX	Compensado	Cliente Tau
2137	CR027	2025-12-16	12:30:00	Saída	-50.00	Estacionamento (Shopping)	Despesas Operacionais	Caixa	Dinheiro	Compensado	Shopping Y
2138	CP028	2025-12-19	10:00:00	Entrada	800.00	Reembolso de Despesa	Renda Extra	Banco B (Poupança)	PIX	Compensado	Sócio Alfa
2139	CP029	2025-12-25	14:00:00	Entrada	1500.00	Venda Online	Vendas	Banco A (Corrente)	PIX	Pendente	Cliente W
2140	CP030	2025-12-28	11:00:00	Saída	-300.00	Taxa Bancária (Extra)	Contas Fixas	Banco A (Corrente)	Débito Automático	Compensado	Banco A
2141	CR031	2026-01-02	10:00:00	Saída	-20000.00	Compra de Estoque (Reabastecimento)	Fornecedores	Banco A (Corrente)	TED	Compensado	Fornecedor Delta
2142	CP032	2026-01-03	14:00:00	Entrada	5500.00	Venda Lote 35	Vendas	Banco A (Corrente)	PIX	Compensado	Cliente Gama
2143	CP033	2026-01-05	10:30:00	Saída	-3500.00	Aluguel do Escritório	Contas Fixas	Banco A (Corrente)	Boleto	Compensado	Locadora Imóveis
2144	CP034	2026-01-05	11:00:00	Saída	-850.00	Mensalidade de Software ERP (Jan)	Despesas Operacionais	Banco A (Corrente)	Boleto	Compensado	Fornecedor de TI
2145	CP035	2026-01-06	15:00:00	Saída	-150.00	Material de Copa	Despesas Operacionais	Caixa	Dinheiro	Compensado	Supermercado Local
2146	CR036	2026-01-07	11:00:00	Entrada	7500.00	Venda Lote 27 (Fatura)	Vendas	Banco A (Corrente)	TED	Compensado	Cliente Gama
2147	CP037	2026-01-08	13:00:00	Saída	-500.00	Licença de Software Mensal	Contas Fixas	Cartão Crédito	Cartão Crédito	Compensado	Software Service
2148	CP038	2026-01-09	10:00:00	Entrada	1800.00	Renda de Aluguéis Imóvel 1	Renda Extra	Banco B (Poupança)	TED	Compensado	Inquilino A
2149	CP039	2026-01-10	16:00:00	Saída	-21000.00	Compra de Matéria-Prima (Pedido 56)	Fornecedores	Banco A (Corrente)	TED	Compensado	Fornecedor Delta
2150	CR040	2026-01-12	14:00:00	Entrada	3500.00	Venda Lote 36	Vendas	Banco A (Corrente)	PIX	Compensado	Cliente Sigma
2151	CP041	2026-01-14	11:00:00	Saída	-120.00	Combustível	Logística	Cartão Crédito	Cartão Crédito	Compensado	Posto R
2152	CP042	2026-01-15	14:00:00	Entrada	2800.00	Venda Lote 37	Vendas	Banco A (Corrente)	TED	Compensado	Cliente P
2153	CP043	2026-01-16	16:00:00	Saída	-500.00	Contas de Consumo (Jan)	Contas Fixas	Banco A (Corrente)	Débito Automático	Compensado	Concessionária A
2154	CR044	2026-01-17	10:00:00	Entrada	900.00	Reembolso de Despesa	Renda Extra	Caixa	Dinheiro	Compensado	Sócio João
2155	CP045	2026-01-20	15:30:00	Saída	-24000.00	Salários (Janeiro)	Folha de Pagamento	Banco A (Corrente)	TED	Compensado	RH - Funcionários
2156	CP046	2026-01-21	14:00:00	Entrada	3500.00	Pagamento de Serviços de Janeiro	Serviços Recorrentes	Banco A (Corrente)	TED	Compensado	Empresa Serviços Z
2157	CP047	2026-01-22	10:00:00	Saída	-400.00	Manutenção de Equipamento	Despesas Operacionais	Caixa	Dinheiro	Compensado	Oficina Geral
2158	CR048	2026-01-23	16:00:00	Entrada	4800.00	Venda Lote 38	Vendas	Banco A (Corrente)	PIX	Compensado	Cliente Omicron
2159	CP049	2026-01-26	11:00:00	Saída	-6500.00	Impostos Mensais (Jan)	Contas Fixas	Banco A (Corrente)	Boleto	Compensado	Receita Federal
2160	CP050	2026-01-27	14:00:00	Entrada	1500.00	Venda de Consultoria	Prestação de Serviços	Banco A (Corrente)	TED	Compensado	Empresa K
2161	CP051	2026-01-28	14:00:00	Saída	-15000.00	Renovação de Contrato Anual TI	Despesas Operacionais	Banco A (Corrente)	TED	Compensado	Fornecedor de TI
2162	CR052	2026-01-29	10:00:00	Entrada	9500.00	Venda Lote 39	Vendas	Banco A (Corrente)	Boleto	Compensado	Cliente Tau
2163	CP053	2026-01-30	12:00:00	Saída	-50.00	Despesa Cartório	Despesas Operacionais	Caixa	Dinheiro	Compensado	Cartório O
2165	CP055	2026-01-01	12:00:00	Entrada	600.00	Renda de Aluguéis Imóvel 2	Renda Extra	Banco B (Poupança)	TED	Compensado	Inquilino B
2166	CR001	2026-01-04	14:30:00	Saída	-200.00	Passagens de Ônibus	Logística	Caixa	Dinheiro	Compensado	Viação Y
2167	CP001	2026-01-07	18:00:00	Saída	-180.00	Telefonia Mensal	Contas Fixas	Banco A (Corrente)	Débito Automático	Compensado	VIVO
2168	CP002	2026-01-13	10:00:00	Saída	-40.00	Tarifa de Extrato	Contas Fixas	Banco A (Corrente)	Débito Automático	Compensado	Banco A
2169	CR003	2026-01-18	12:30:00	Saída	-100.00	Almoço de Equipe	Despesas Operacionais	Cartão Crédito	Cartão Crédito	Compensado	Restaurante D
2170	CP005	2026-01-20	10:00:00	Entrada	5000.00	Adiantamento de Cliente	Vendas	Banco A (Corrente)	TED	Compensado	Cliente Delta
2171	CP006	2026-01-24	14:00:00	Entrada	800.00	Reembolso de Despesa	Renda Extra	Caixa	Dinheiro	Compensado	Sócio Alfa
2172	CP007	2026-01-25	10:00:00	Saída	-300.00	Compra de Equipamento Pequeno	Despesas Operacionais	Caixa	Dinheiro	Compensado	Loja Elétrica
2173	CP008	2026-01-26	18:00:00	Saída	-180.00	Telefonia (Adicional)	Contas Fixas	Banco A (Corrente)	Débito Automático	Compensado	VIVO
2174	CR009	2026-01-28	12:00:00	Saída	-50.00	Despesa com Cartório	Despesas Operacionais	Caixa	Dinheiro	Compensado	Cartório O
2175	CP010	2026-01-29	14:00:00	Entrada	1500.00	Venda de Serviço (Fechamento)	Prestação de Serviços	Banco A (Corrente)	PIX	Compensado	Empresa K
2176	CR011	2026-02-02	10:00:00	Saída	-15000.00	Compra de Estoque (Promoção)	Fornecedores	Banco A (Corrente)	TED	Compensado	Fornecedor Beta
2177	CP012	2026-02-03	14:00:00	Entrada	5200.00	Venda Lote 40	Vendas	Banco A (Corrente)	PIX	Compensado	Cliente Epsilon
2178	CP013	2026-02-05	10:30:00	Saída	-3500.00	Aluguel do Escritório	Contas Fixas	Banco A (Corrente)	Boleto	Compensado	Locadora Imóveis
2179	CP014	2026-02-05	11:00:00	Saída	-850.00	Mensalidade de Software ERP (Fev)	Despesas Operacionais	Banco A (Corrente)	Boleto	Compensado	Fornecedor de TI
2180	CP015	2026-02-06	15:00:00	Saída	-150.00	Material de Copa	Despesas Operacionais	Caixa	Dinheiro	Compensado	Supermercado Local
2181	CP016	2026-02-07	11:00:00	Entrada	4800.00	Venda Lote 28 (Fatura)	Vendas	Banco A (Corrente)	TED	Compensado	Cliente Omicron
2182	CR017	2026-02-08	13:00:00	Saída	-500.00	Licença de Software Mensal	Contas Fixas	Cartão Crédito	Cartão Crédito	Compensado	Software Service
2183	CP018	2026-02-09	10:00:00	Entrada	1800.00	Renda de Aluguéis Imóvel 1	Renda Extra	Banco B (Poupança)	TED	Compensado	Inquilino A
2184	CP019	2026-02-10	16:00:00	Saída	-7000.00	Marketing de Lançamento (Fev)	Marketing	Banco A (Corrente)	Boleto	Compensado	Agência Digital
2185	CR020	2026-02-12	14:00:00	Entrada	6000.00	Venda Lote 41	Vendas	Banco A (Corrente)	PIX	Compensado	Cliente Alpha
2186	CP021	2026-02-14	11:00:00	Saída	-120.00	Combustível	Logística	Cartão Crédito	Cartão Crédito	Compensado	Posto R
2187	CP022	2026-02-15	14:00:00	Entrada	11000.00	Fatura de Venda Lote 29	Vendas	Banco A (Corrente)	TED	Compensado	Cliente Tau
2188	CR023	2026-02-16	16:00:00	Saída	-480.00	Contas de Consumo (Fev)	Contas Fixas	Banco A (Corrente)	Débito Automático	Compensado	Concessionária A
2189	CP024	2026-02-17	10:00:00	Entrada	900.00	Reembolso de Despesa	Renda Extra	Caixa	Dinheiro	Compensado	Sócio João
2190	CP025	2026-02-20	15:30:00	Saída	-24500.00	Salários (Fevereiro)	Folha de Pagamento	Banco A (Corrente)	TED	Compensado	RH - Funcionários
2191	CP026	2026-02-21	14:00:00	Entrada	3500.00	Pagamento de Serviços de Fevereiro	Serviços Recorrentes	Banco A (Corrente)	TED	Compensado	Empresa Serviços Z
2192	CR027	2026-02-22	10:00:00	Saída	-400.00	Manutenção de Equipamento	Despesas Operacionais	Caixa	Dinheiro	Compensado	Oficina Geral
2193	CP028	2026-02-23	16:00:00	Entrada	7800.00	Venda Lote 42	Vendas	Banco A (Corrente)	PIX	Compensado	Cliente Beta
2194	CP029	2026-02-26	11:00:00	Saída	-6500.00	Impostos Mensais (Fev)	Contas Fixas	Banco A (Corrente)	Boleto	Compensado	Receita Federal
2195	CP030	2026-02-27	14:00:00	Entrada	1500.00	Venda de Consultoria	Prestação de Serviços	Banco A (Corrente)	TED	Compensado	Empresa K
2196	CR031	2026-02-28	12:00:00	Saída	-50.00	Despesa Cartório	Despesas Operacionais	Caixa	Dinheiro	Compensado	Cartório O
2349	CP019	2026-06-28	14:00:00	Entrada	400.00	Venda Avulsa	Vendas	Caixa	PIX	Compensado	Cliente Y
2197	CP032	2026-02-01	12:00:00	Entrada	600.00	Renda de Aluguéis Imóvel 2	Renda Extra	Banco B (Poupança)	TED	Compensado	Inquilino B
2198	CP033	2026-02-04	14:30:00	Saída	-200.00	Passagens de Ônibus	Logística	Caixa	Dinheiro	Compensado	Viação Y
2199	CP034	2026-02-07	18:00:00	Saída	-180.00	Telefonia Mensal	Contas Fixas	Banco A (Corrente)	Débito Automático	Compensado	VIVO
2200	CP035	2026-02-10	09:00:00	Saída	-40.00	Tarifa de Extrato	Contas Fixas	Banco A (Corrente)	Débito Automático	Compensado	Banco A
2201	CR036	2026-02-13	15:00:00	Entrada	5000.00	Adiantamento de Cliente	Vendas	Banco A (Corrente)	TED	Compensado	Cliente Delta
2202	CP037	2026-02-18	12:30:00	Saída	-100.00	Almoço de Equipe	Despesas Operacionais	Cartão Crédito	Cartão Crédito	Compensado	Restaurante D
2203	CP038	2026-02-20	10:00:00	Entrada	800.00	Reembolso de Despesa	Renda Extra	Caixa	Dinheiro	Compensado	Sócio Alfa
2204	CP039	2026-02-24	14:00:00	Entrada	4500.00	Venda Lote 43	Vendas	Banco A (Corrente)	Boleto	Compensado	Cliente Mu
2205	CR040	2026-02-25	10:00:00	Saída	-300.00	Compra de Equipamento Pequeno	Despesas Operacionais	Caixa	Dinheiro	Compensado	Loja Elétrica
2206	CP041	2026-02-26	18:00:00	Saída	-180.00	Telefonia (Adicional)	Contas Fixas	Banco A (Corrente)	Débito Automático	Compensado	VIVO
2207	CP042	2026-02-27	10:00:00	Entrada	2500.00	Venda Lote 44	Vendas	Banco A (Corrente)	PIX	Compensado	Cliente Gama
2208	CP043	2026-02-28	14:00:00	Entrada	400.00	Venda Avulsa	Vendas	Caixa	PIX	Compensado	Cliente Y
2209	CR044	2026-02-23	11:00:00	Saída	-50.00	Taxa de Saque	Contas Fixas	Banco B (Poupança)	Saque	Compensado	Banco B
2210	CP045	2026-02-24	12:00:00	Saída	-1200.00	Serviço de Limpeza (Fev)	Despesas Operacionais	Banco A (Corrente)	TED	Compensado	Empresa Limpeza
2211	CP046	2026-03-02	10:00:00	Saída	-30000.00	Compra de Estoque (Renovação)	Fornecedores	Banco A (Corrente)	TED	Compensado	Fornecedor Kappa
2212	CP047	2026-03-03	14:00:00	Entrada	6500.00	Venda Lote 45	Vendas	Banco A (Corrente)	PIX	Compensado	Cliente Mu
2213	CR048	2026-03-05	10:30:00	Saída	-3500.00	Aluguel do Escritório	Contas Fixas	Banco A (Corrente)	Boleto	Compensado	Locadora Imóveis
2214	CP049	2026-03-05	11:00:00	Saída	-850.00	Mensalidade de Software ERP (Mar)	Despesas Operacionais	Banco A (Corrente)	Boleto	Compensado	Fornecedor de TI
2215	CP050	2026-03-06	15:00:00	Saída	-150.00	Material de Copa	Despesas Operacionais	Caixa	Dinheiro	Compensado	Supermercado Local
2216	CP051	2026-03-07	11:00:00	Entrada	8800.00	Fatura de Venda Lote 31	Vendas	Banco A (Corrente)	TED	Compensado	Cliente Mu
2217	CR052	2026-03-08	13:00:00	Saída	-500.00	Licença de Software Mensal	Contas Fixas	Cartão Crédito	Cartão Crédito	Compensado	Software Service
2218	CP053	2026-03-09	10:00:00	Entrada	1800.00	Renda de Aluguéis Imóvel 1	Renda Extra	Banco B (Poupança)	TED	Compensado	Inquilino A
2219	CP054	2026-03-10	16:00:00	Saída	-19000.00	Compra de Estoque (Mar)	Fornecedores	Banco A (Corrente)	TED	Compensado	Fornecedor Kappa
2220	CP055	2026-03-12	14:00:00	Entrada	4500.00	Venda Lote 46	Vendas	Banco A (Corrente)	PIX	Compensado	Cliente Delta
2221	CR001	2026-03-14	11:00:00	Saída	-120.00	Combustível	Logística	Cartão Crédito	Cartão Crédito	Compensado	Posto R
2222	CP001	2026-03-15	14:00:00	Entrada	9500.00	Venda Lote 35 (Fatura)	Vendas	Banco A (Corrente)	TED	Compensado	Cliente Delta
2223	CP002	2026-03-16	16:00:00	Saída	-500.00	Contas de Consumo (Mar)	Contas Fixas	Banco A (Corrente)	Débito Automático	Compensado	Concessionária A
2224	CR003	2026-03-17	10:00:00	Entrada	900.00	Reembolso de Despesa	Renda Extra	Caixa	Dinheiro	Compensado	Sócio João
2225	CP005	2026-03-20	15:30:00	Saída	-24500.00	Salários (Março)	Folha de Pagamento	Banco A (Corrente)	TED	Compensado	RH - Funcionários
2226	CP006	2026-03-21	14:00:00	Entrada	3500.00	Pagamento de Serviços de Março	Serviços Recorrentes	Banco A (Corrente)	TED	Compensado	Empresa Serviços Z
2227	CP007	2026-03-22	10:00:00	Saída	-400.00	Manutenção de Equipamento	Despesas Operacionais	Caixa	Dinheiro	Compensado	Oficina Geral
2228	CP008	2026-03-23	16:00:00	Entrada	5500.00	Venda Lote 47	Vendas	Banco A (Corrente)	PIX	Compensado	Cliente Zeta
2229	CR009	2026-03-26	11:00:00	Saída	-6500.00	Impostos Mensais (Mar)	Contas Fixas	Banco A (Corrente)	Boleto	Compensado	Receita Federal
2230	CP010	2026-03-27	14:00:00	Entrada	1500.00	Venda de Consultoria	Prestação de Serviços	Banco A (Corrente)	TED	Compensado	Empresa K
2231	CR011	2026-03-28	12:00:00	Saída	-50.00	Despesa Cartório	Despesas Operacionais	Caixa	Dinheiro	Compensado	Cartório O
2232	CP012	2026-03-30	16:00:00	Entrada	400.00	Venda Avulsa	Vendas	Caixa	PIX	Compensado	Cliente Y
2233	CP013	2026-03-01	12:00:00	Entrada	600.00	Renda de Aluguéis Imóvel 2	Renda Extra	Banco B (Poupança)	TED	Compensado	Inquilino B
2234	CP014	2026-03-04	14:30:00	Saída	-200.00	Passagens de Ônibus	Logística	Caixa	Dinheiro	Compensado	Viação Y
2235	CP015	2026-03-07	18:00:00	Saída	-180.00	Telefonia Mensal	Contas Fixas	Banco A (Corrente)	Débito Automático	Compensado	VIVO
2236	CP016	2026-03-10	09:00:00	Saída	-40.00	Tarifa de Extrato	Contas Fixas	Banco A (Corrente)	Débito Automático	Compensado	Banco A
2237	CR017	2026-03-13	15:00:00	Entrada	5000.00	Adiantamento de Cliente	Vendas	Banco A (Corrente)	TED	Compensado	Cliente Delta
2238	CP018	2026-03-18	12:30:00	Saída	-100.00	Almoço de Equipe	Despesas Operacionais	Cartão Crédito	Cartão Crédito	Compensado	Restaurante D
2239	CP019	2026-03-20	10:00:00	Entrada	800.00	Reembolso de Despesa	Renda Extra	Caixa	Dinheiro	Compensado	Sócio Alfa
2240	CR020	2026-03-24	14:00:00	Entrada	4500.00	Venda Lote 48	Vendas	Banco A (Corrente)	Boleto	Compensado	Cliente Tau
2241	CP021	2026-03-25	10:00:00	Saída	-300.00	Compra de Equipamento Pequeno	Despesas Operacionais	Caixa	Dinheiro	Compensado	Loja Elétrica
2242	CP022	2026-03-26	18:00:00	Saída	-180.00	Telefonia (Adicional)	Contas Fixas	Banco A (Corrente)	Débito Automático	Compensado	VIVO
2243	CR023	2026-03-27	10:00:00	Entrada	2500.00	Venda Lote 49	Vendas	Banco A (Corrente)	PIX	Compensado	Cliente Gama
2244	CP024	2026-03-28	14:00:00	Entrada	400.00	Venda Avulsa	Vendas	Caixa	PIX	Compensado	Cliente Y
2245	CP025	2026-03-29	11:00:00	Saída	-50.00	Taxa de Saque	Contas Fixas	Banco B (Poupança)	Saque	Compensado	Banco B
2246	CP026	2026-04-01	10:00:00	Saída	-18000.00	Compra de Estoque (Abril)	Fornecedores	Banco A (Corrente)	TED	Compensado	Fornecedor Delta
2247	CR027	2026-04-02	14:00:00	Entrada	7000.00	Venda Lote 50	Vendas	Banco A (Corrente)	PIX	Compensado	Cliente Alpha
2248	CP028	2026-04-05	10:30:00	Saída	-3500.00	Aluguel do Escritório	Contas Fixas	Banco A (Corrente)	Boleto	Compensado	Locadora Imóveis
2249	CP029	2026-04-05	11:00:00	Saída	-850.00	Mensalidade de Software ERP (Abr)	Despesas Operacionais	Banco A (Corrente)	Boleto	Compensado	Fornecedor de TI
2250	CP030	2026-04-06	15:00:00	Saída	-150.00	Material de Copa	Despesas Operacionais	Caixa	Dinheiro	Compensado	Supermercado Local
2251	CR031	2026-04-07	11:00:00	Entrada	3600.00	Pagamento de Serviços Recorrentes (Abr)	Serviços Recorrentes	Banco A (Corrente)	TED	Compensado	Empresa Serviços Z
2252	CP032	2026-04-08	13:00:00	Saída	-500.00	Licença de Software Mensal	Contas Fixas	Cartão Crédito	Cartão Crédito	Compensado	Software Service
2253	CP033	2026-04-09	10:00:00	Entrada	1800.00	Renda de Aluguéis Imóvel 1	Renda Extra	Banco B (Poupança)	TED	Compensado	Inquilino A
2254	CP034	2026-04-10	16:00:00	Saída	-1500.00	Treinamento de Equipe	Despesas Operacionais	Banco A (Corrente)	TED	Compensado	Consultor F
2255	CP035	2026-04-12	14:00:00	Entrada	5500.00	Venda Lote 51	Vendas	Banco A (Corrente)	PIX	Compensado	Cliente Sigma
2256	CR036	2026-04-14	11:00:00	Saída	-120.00	Combustível	Logística	Cartão Crédito	Cartão Crédito	Compensado	Posto R
2257	CP037	2026-04-15	14:00:00	Entrada	11000.00	Venda Lote 40 (Fatura)	Vendas	Banco A (Corrente)	TED	Compensado	Cliente Alpha
2258	CP038	2026-04-16	16:00:00	Saída	-450.00	Contas de Consumo (Abr)	Contas Fixas	Banco A (Corrente)	Débito Automático	Compensado	Concessionária A
2259	CP039	2026-04-17	10:00:00	Entrada	900.00	Reembolso de Despesa	Renda Extra	Caixa	Dinheiro	Compensado	Sócio João
2260	CR040	2026-04-20	15:30:00	Saída	-24500.00	Salários (Abril)	Folha de Pagamento	Banco A (Corrente)	TED	Compensado	RH - Funcionários
2261	CP041	2026-04-21	14:00:00	Entrada	3500.00	Venda Lote 52	Vendas	Banco A (Corrente)	TED	Compensado	Cliente Zeta
2262	CP042	2026-04-22	10:00:00	Saída	-400.00	Manutenção de Equipamento	Despesas Operacionais	Caixa	Dinheiro	Compensado	Oficina Geral
2263	CP043	2026-04-23	16:00:00	Entrada	6000.00	Venda Lote 53	Vendas	Banco A (Corrente)	PIX	Compensado	Cliente Beta
2264	CR044	2026-04-26	11:00:00	Saída	-5500.00	Impostos Trimestrais	Contas Fixas	Banco A (Corrente)	Boleto	Compensado	Receita Federal
2265	CP045	2026-04-27	14:00:00	Entrada	1500.00	Venda de Consultoria	Prestação de Serviços	Banco A (Corrente)	TED	Compensado	Empresa K
2266	CP046	2026-04-28	12:00:00	Saída	-50.00	Despesa Cartório	Despesas Operacionais	Caixa	Dinheiro	Compensado	Cartório O
2267	CP047	2026-04-30	16:00:00	Entrada	400.00	Venda Avulsa	Vendas	Caixa	PIX	Compensado	Cliente Y
2268	CR048	2026-04-01	12:00:00	Entrada	600.00	Renda de Aluguéis Imóvel 2	Renda Extra	Banco B (Poupança)	TED	Compensado	Inquilino B
2269	CP049	2026-04-04	14:30:00	Saída	-200.00	Passagens de Ônibus	Logística	Caixa	Dinheiro	Compensado	Viação Y
2270	CP050	2026-04-07	18:00:00	Saída	-180.00	Telefonia Mensal	Contas Fixas	Banco A (Corrente)	Débito Automático	Compensado	VIVO
2271	CP051	2026-04-10	09:00:00	Saída	-40.00	Tarifa de Extrato	Contas Fixas	Banco A (Corrente)	Débito Automático	Compensado	Banco A
2272	CR052	2026-04-13	15:00:00	Entrada	5000.00	Adiantamento de Cliente	Vendas	Banco A (Corrente)	TED	Compensado	Cliente Delta
2273	CP053	2026-04-18	12:30:00	Saída	-100.00	Almoço de Equipe	Despesas Operacionais	Cartão Crédito	Cartão Crédito	Compensado	Restaurante D
2274	CP054	2026-04-20	10:00:00	Entrada	800.00	Reembolso de Despesa	Renda Extra	Caixa	Dinheiro	Compensado	Sócio Alfa
2275	CP055	2026-04-24	14:00:00	Entrada	4500.00	Venda Lote 54	Vendas	Banco A (Corrente)	Boleto	Compensado	Cliente Mu
2276	CR001	2026-04-25	10:00:00	Saída	-300.00	Compra de Equipamento Pequeno	Despesas Operacionais	Caixa	Dinheiro	Compensado	Loja Elétrica
2326	CP051	2026-06-14	11:00:00	Saída	-120.00	Combustível	Logística	Cartão Crédito	Cartão Crédito	Compensado	Posto R
2277	CP001	2026-04-26	18:00:00	Saída	-180.00	Telefonia (Adicional)	Contas Fixas	Banco A (Corrente)	Débito Automático	Compensado	VIVO
2278	CP002	2026-04-27	10:00:00	Entrada	2500.00	Venda Lote 55	Vendas	Banco A (Corrente)	PIX	Compensado	Cliente Gama
2279	CR003	2026-04-28	14:00:00	Entrada	400.00	Venda Avulsa	Vendas	Caixa	PIX	Compensado	Cliente Y
2280	CP005	2026-04-29	11:00:00	Saída	-50.00	Taxa de Saque	Contas Fixas	Banco B (Poupança)	Saque	Compensado	Banco B
2281	CP006	2026-05-01	10:00:00	Saída	-15000.00	Compra de Estoque (Maio)	Fornecedores	Banco A (Corrente)	TED	Compensado	Fornecedor Beta
2282	CP007	2026-05-02	14:00:00	Entrada	5500.00	Venda Lote 38 (Fatura)	Vendas	Banco A (Corrente)	PIX	Compensado	Cliente Zeta
2283	CP008	2026-05-05	10:30:00	Saída	-3500.00	Aluguel do Escritório	Contas Fixas	Banco A (Corrente)	Boleto	Compensado	Locadora Imóveis
2284	CR009	2026-05-05	11:00:00	Saída	-850.00	Mensalidade de Software ERP (Mai)	Despesas Operacionais	Banco A (Corrente)	Boleto	Compensado	Fornecedor de TI
2285	CP010	2026-05-06	15:00:00	Saída	-150.00	Material de Copa	Despesas Operacionais	Caixa	Dinheiro	Compensado	Supermercado Local
2286	CR011	2026-05-07	11:00:00	Entrada	3600.00	Pagamento de Serviços Recorrentes (Mai)	Serviços Recorrentes	Banco A (Corrente)	TED	Compensado	Empresa Serviços Z
2287	CP012	2026-05-08	13:00:00	Saída	-500.00	Licença de Software Mensal	Contas Fixas	Cartão Crédito	Cartão Crédito	Compensado	Software Service
2288	CP013	2026-05-09	10:00:00	Entrada	1800.00	Renda de Aluguéis Imóvel 1	Renda Extra	Banco B (Poupança)	TED	Compensado	Inquilino A
2289	CP014	2026-05-10	16:00:00	Saída	-10000.00	Marketing (Meio do Ano)	Marketing	Banco A (Corrente)	TED	Compensado	Agência Digital
2290	CP015	2026-05-12	14:00:00	Entrada	7800.00	Venda Lote 45 (Fatura)	Vendas	Banco A (Corrente)	PIX	Compensado	Cliente Sigma
2291	CP016	2026-05-14	11:00:00	Saída	-120.00	Combustível	Logística	Cartão Crédito	Cartão Crédito	Compensado	Posto R
2292	CR017	2026-05-15	14:00:00	Entrada	5500.00	Venda Lote 38 (Fatura)	Vendas	Banco A (Corrente)	TED	Compensado	Cliente Zeta
2293	CP018	2026-05-16	16:00:00	Saída	-450.00	Contas de Consumo (Mai)	Contas Fixas	Banco A (Corrente)	Débito Automático	Compensado	Concessionária A
2294	CP019	2026-05-17	10:00:00	Entrada	900.00	Reembolso de Despesa	Renda Extra	Caixa	Dinheiro	Compensado	Sócio João
2295	CR020	2026-05-20	15:30:00	Saída	-24500.00	Salários (Maio)	Folha de Pagamento	Banco A (Corrente)	TED	Compensado	RH - Funcionários
2296	CP021	2026-05-21	14:00:00	Entrada	3500.00	Venda Lote 56	Vendas	Banco A (Corrente)	TED	Compensado	Cliente Mu
2297	CP022	2026-05-22	10:00:00	Saída	-400.00	Manutenção de Equipamento	Despesas Operacionais	Caixa	Dinheiro	Compensado	Oficina Geral
2298	CR023	2026-05-23	16:00:00	Entrada	6500.00	Venda Lote 57	Vendas	Banco A (Corrente)	PIX	Compensado	Cliente Gamma
2299	CP024	2026-05-26	11:00:00	Saída	-6000.00	Impostos Mensais (Mai)	Contas Fixas	Banco A (Corrente)	Boleto	Compensado	Receita Federal
2300	CP025	2026-05-27	14:00:00	Entrada	1500.00	Venda de Consultoria	Prestação de Serviços	Banco A (Corrente)	TED	Compensado	Empresa K
2301	CP026	2026-05-28	12:00:00	Saída	-50.00	Despesa Cartório	Despesas Operacionais	Caixa	Dinheiro	Compensado	Cartório O
2302	CR027	2026-05-30	16:00:00	Entrada	400.00	Venda Avulsa	Vendas	Caixa	PIX	Compensado	Cliente Y
2303	CP028	2026-05-01	12:00:00	Entrada	600.00	Renda de Aluguéis Imóvel 2	Renda Extra	Banco B (Poupança)	TED	Compensado	Inquilino B
2304	CP029	2026-05-04	14:30:00	Saída	-200.00	Passagens de Ônibus	Logística	Caixa	Dinheiro	Compensado	Viação Y
2305	CP030	2026-05-07	18:00:00	Saída	-180.00	Telefonia Mensal	Contas Fixas	Banco A (Corrente)	Débito Automático	Compensado	VIVO
2306	CR031	2026-05-10	09:00:00	Saída	-40.00	Tarifa de Extrato	Contas Fixas	Banco A (Corrente)	Débito Automático	Compensado	Banco A
2307	CP032	2026-05-13	15:00:00	Entrada	5000.00	Adiantamento de Cliente	Vendas	Banco A (Corrente)	TED	Compensado	Cliente Delta
2308	CP033	2026-05-18	12:30:00	Saída	-100.00	Almoço de Equipe	Despesas Operacionais	Cartão Crédito	Cartão Crédito	Compensado	Restaurante D
2309	CP034	2026-05-20	10:00:00	Entrada	800.00	Reembolso de Despesa	Renda Extra	Caixa	Dinheiro	Compensado	Sócio Alfa
2310	CP035	2026-05-24	14:00:00	Entrada	4500.00	Venda Lote 58	Vendas	Banco A (Corrente)	Boleto	Compensado	Cliente Tau
2311	CR036	2026-05-25	10:00:00	Saída	-300.00	Compra de Equipamento Pequeno	Despesas Operacionais	Caixa	Dinheiro	Compensado	Loja Elétrica
2312	CP037	2026-05-26	18:00:00	Saída	-180.00	Telefonia (Adicional)	Contas Fixas	Banco A (Corrente)	Débito Automático	Compensado	VIVO
2313	CP038	2026-05-27	10:00:00	Entrada	2500.00	Venda Lote 59	Vendas	Banco A (Corrente)	PIX	Compensado	Cliente Gama
2314	CP039	2026-05-28	14:00:00	Entrada	400.00	Venda Avulsa	Vendas	Caixa	PIX	Compensado	Cliente Y
2315	CR040	2026-05-29	11:00:00	Saída	-50.00	Taxa de Saque	Contas Fixas	Banco B (Poupança)	Saque	Compensado	Banco B
2316	CP041	2026-06-01	10:00:00	Saída	-25000.00	Compra de Estoque (Inverno)	Fornecedores	Banco A (Corrente)	TED	Compensado	Fornecedor Delta
2317	CP042	2026-06-02	14:00:00	Entrada	5000.00	Venda Lote 60	Vendas	Banco A (Corrente)	PIX	Compensado	Cliente Alpha
2318	CP043	2026-06-05	10:30:00	Saída	-3500.00	Aluguel do Escritório	Contas Fixas	Banco A (Corrente)	Boleto	Compensado	Locadora Imóveis
2319	CR044	2026-06-05	11:00:00	Saída	-850.00	Mensalidade de Software ERP (Jun)	Despesas Operacionais	Banco A (Corrente)	Boleto	Compensado	Fornecedor de TI
2320	CP045	2026-06-06	15:00:00	Saída	-150.00	Material de Copa	Despesas Operacionais	Caixa	Dinheiro	Compensado	Supermercado Local
2321	CP046	2026-06-07	11:00:00	Entrada	3600.00	Pagamento de Serviços Recorrentes (Jun)	Serviços Recorrentes	Banco A (Corrente)	TED	Compensado	Empresa Serviços Z
2322	CP047	2026-06-08	13:00:00	Saída	-500.00	Licença de Software Mensal	Contas Fixas	Cartão Crédito	Cartão Crédito	Compensado	Software Service
2323	CR048	2026-06-09	10:00:00	Entrada	1800.00	Renda de Aluguéis Imóvel 1	Renda Extra	Banco B (Poupança)	TED	Compensado	Inquilino A
2324	CP049	2026-06-10	16:00:00	Saída	-1500.00	Manutenção Corretiva	Manutenção	Banco A (Corrente)	TED	Compensado	Serviço L
2325	CP050	2026-06-12	14:00:00	Entrada	12500.00	Fatura de Venda Lote 42	Vendas	Banco A (Corrente)	PIX	Compensado	Cliente Lambda
2327	CR052	2026-06-15	14:00:00	Entrada	7000.00	Venda Lote 61	Vendas	Banco A (Corrente)	TED	Compensado	Cliente Gamma
2328	CP053	2026-06-16	16:00:00	Saída	-450.00	Contas de Consumo (Jun)	Contas Fixas	Banco A (Corrente)	Débito Automático	Compensado	Concessionária A
2329	CP054	2026-06-17	10:00:00	Entrada	900.00	Reembolso de Despesa	Renda Extra	Caixa	Dinheiro	Compensado	Sócio João
2330	CP055	2026-06-20	15:30:00	Saída	-24500.00	Salários (Junho)	Folha de Pagamento	Banco A (Corrente)	TED	Compensado	RH - Funcionários
2331	CR001	2026-06-21	14:00:00	Entrada	3500.00	Venda Lote 62	Vendas	Banco A (Corrente)	TED	Compensado	Cliente Zeta
2332	CP001	2026-06-22	10:00:00	Saída	-400.00	Manutenção de Equipamento	Despesas Operacionais	Caixa	Dinheiro	Compensado	Oficina Geral
2333	CP002	2026-06-23	16:00:00	Entrada	13000.00	Venda Lote 50 (Fatura)	Vendas	Banco A (Corrente)	PIX	Compensado	Cliente Beta
2334	CR003	2026-06-26	11:00:00	Saída	-6000.00	Impostos Mensais (Jun)	Contas Fixas	Banco A (Corrente)	Boleto	Compensado	Receita Federal
2335	CP005	2026-06-27	14:00:00	Entrada	1500.00	Venda de Consultoria	Prestação de Serviços	Banco A (Corrente)	TED	Compensado	Empresa K
2336	CP006	2026-06-28	12:00:00	Saída	-50.00	Despesa Cartório	Despesas Operacionais	Caixa	Dinheiro	Compensado	Cartório O
2337	CP007	2026-06-30	16:00:00	Entrada	400.00	Venda Avulsa	Vendas	Caixa	PIX	Compensado	Cliente Y
2338	CP008	2026-06-01	12:00:00	Entrada	600.00	Renda de Aluguéis Imóvel 2	Renda Extra	Banco B (Poupança)	TED	Compensado	Inquilino B
2339	CR009	2026-06-04	14:30:00	Saída	-200.00	Passagens de Ônibus	Logística	Caixa	Dinheiro	Compensado	Viação Y
2340	CP010	2026-06-07	18:00:00	Saída	-180.00	Telefonia Mensal	Contas Fixas	Banco A (Corrente)	Débito Automático	Compensado	VIVO
2341	CR011	2026-06-10	09:00:00	Saída	-40.00	Tarifa de Extrato	Contas Fixas	Banco A (Corrente)	Débito Automático	Compensado	Banco A
2342	CP012	2026-06-13	15:00:00	Entrada	5000.00	Adiantamento de Cliente	Vendas	Banco A (Corrente)	TED	Compensado	Cliente Delta
2343	CP013	2026-06-18	12:30:00	Saída	-100.00	Almoço de Equipe	Despesas Operacionais	Cartão Crédito	Cartão Crédito	Compensado	Restaurante D
2344	CP014	2026-06-20	10:00:00	Entrada	800.00	Reembolso de Despesa	Renda Extra	Caixa	Dinheiro	Compensado	Sócio Alfa
2345	CP015	2026-06-24	14:00:00	Entrada	4500.00	Venda Lote 63	Vendas	Banco A (Corrente)	Boleto	Compensado	Cliente Tau
2346	CP016	2026-06-25	10:00:00	Saída	-300.00	Compra de Equipamento Pequeno	Despesas Operacionais	Caixa	Dinheiro	Compensado	Loja Elétrica
2347	CR017	2026-06-26	18:00:00	Saída	-180.00	Telefonia (Adicional)	Contas Fixas	Banco A (Corrente)	Débito Automático	Compensado	VIVO
2348	CP018	2026-06-27	10:00:00	Entrada	2500.00	Venda Lote 64	Vendas	Banco A (Corrente)	PIX	Compensado	Cliente Gama
2350	CR020	2026-06-29	11:00:00	Saída	-50.00	Taxa de Saque	Contas Fixas	Banco B (Poupança)	Saque	Compensado	Banco B
2351	CP021	2026-07-01	10:00:00	Saída	-20000.00	Compra de Estoque (Julho)	Fornecedores	Banco A (Corrente)	TED	Compensado	Fornecedor Kappa
2352	CP022	2026-07-02	14:00:00	Entrada	6200.00	Venda Lote 55 (Fatura)	Vendas	Banco A (Corrente)	PIX	Compensado	Cliente Gamma
2353	CR023	2026-07-05	10:30:00	Saída	-3500.00	Aluguel do Escritório	Contas Fixas	Banco A (Corrente)	Boleto	Compensado	Locadora Imóveis
2354	CP024	2026-07-05	11:00:00	Saída	-850.00	Mensalidade de Software ERP (Jul)	Despesas Operacionais	Banco A (Corrente)	Boleto	Compensado	Fornecedor de TI
2355	CP025	2026-07-06	15:00:00	Saída	-150.00	Material de Copa	Despesas Operacionais	Caixa	Dinheiro	Compensado	Supermercado Local
2356	CP026	2026-07-07	11:00:00	Entrada	3600.00	Pagamento de Serviços Recorrentes (Jul)	Serviços Recorrentes	Banco A (Corrente)	TED	Compensado	Empresa Serviços Z
2357	CR027	2026-07-08	13:00:00	Saída	-500.00	Licença de Software Mensal	Contas Fixas	Cartão Crédito	Cartão Crédito	Compensado	Software Service
2358	CP028	2026-07-09	10:00:00	Entrada	1800.00	Renda de Aluguéis Imóvel 1	Renda Extra	Banco B (Poupança)	TED	Compensado	Inquilino A
2359	CP029	2026-07-10	16:00:00	Saída	-1500.00	Manutenção Corretiva	Manutenção	Banco A (Corrente)	TED	Compensado	Serviço L
2360	CP030	2026-07-12	14:00:00	Entrada	8500.00	Venda Lote 65	Vendas	Banco A (Corrente)	PIX	Compensado	Cliente Sigma
2361	CR031	2026-07-14	11:00:00	Saída	-120.00	Combustível	Logística	Cartão Crédito	Cartão Crédito	Compensado	Posto R
2362	CP032	2026-07-15	14:00:00	Entrada	6200.00	Venda Lote 55	Vendas	Banco A (Corrente)	TED	Compensado	Cliente Gamma
2363	CP033	2026-07-16	16:00:00	Saída	-450.00	Contas de Consumo (Jul)	Contas Fixas	Banco A (Corrente)	Débito Automático	Compensado	Concessionária A
2364	CP034	2026-07-17	10:00:00	Entrada	900.00	Reembolso de Despesa	Renda Extra	Caixa	Dinheiro	Compensado	Sócio João
2365	CP035	2026-07-20	15:30:00	Saída	-24500.00	Salários (Julho)	Folha de Pagamento	Banco A (Corrente)	TED	Compensado	RH - Funcionários
2366	CR036	2026-07-21	14:00:00	Entrada	3500.00	Venda Lote 66	Vendas	Banco A (Corrente)	TED	Compensado	Cliente Mu
2367	CP037	2026-07-22	10:00:00	Saída	-400.00	Manutenção de Equipamento	Despesas Operacionais	Caixa	Dinheiro	Compensado	Oficina Geral
2368	CP038	2026-07-23	16:00:00	Entrada	7800.00	Venda Lote 67	Vendas	Banco A (Corrente)	PIX	Compensado	Cliente Beta
2369	CP039	2026-07-26	11:00:00	Saída	-6000.00	Impostos Mensais (Jul)	Contas Fixas	Banco A (Corrente)	Boleto	Compensado	Receita Federal
2370	CR040	2026-07-27	14:00:00	Entrada	1500.00	Venda de Consultoria	Prestação de Serviços	Banco A (Corrente)	TED	Compensado	Empresa K
2372	CP042	2026-07-30	16:00:00	Entrada	400.00	Venda Avulsa	Vendas	Caixa	PIX	Compensado	Cliente Y
2373	CP043	2026-07-01	12:00:00	Entrada	600.00	Renda de Aluguéis Imóvel 2	Renda Extra	Banco B (Poupança)	TED	Compensado	Inquilino B
2374	CR044	2026-07-04	14:30:00	Saída	-200.00	Passagens de Ônibus	Logística	Caixa	Dinheiro	Compensado	Viação Y
2375	CP045	2026-07-07	18:00:00	Saída	-180.00	Telefonia Mensal	Contas Fixas	Banco A (Corrente)	Débito Automático	Compensado	VIVO
2376	CP046	2026-07-10	09:00:00	Saída	-40.00	Tarifa de Extrato	Contas Fixas	Banco A (Corrente)	Débito Automático	Compensado	Banco A
2377	CP047	2026-07-13	15:00:00	Entrada	5000.00	Adiantamento de Cliente	Vendas	Banco A (Corrente)	TED	Compensado	Cliente Delta
2378	CR048	2026-07-18	12:30:00	Saída	-100.00	Almoço de Equipe	Despesas Operacionais	Cartão Crédito	Cartão Crédito	Compensado	Restaurante D
2379	CP049	2026-07-20	10:00:00	Entrada	800.00	Reembolso de Despesa	Renda Extra	Caixa	Dinheiro	Compensado	Sócio Alfa
2380	CP050	2026-07-24	14:00:00	Entrada	4500.00	Venda Lote 68	Vendas	Banco A (Corrente)	Boleto	Compensado	Cliente Tau
2381	CP051	2026-07-25	10:00:00	Saída	-300.00	Compra de Equipamento Pequeno	Despesas Operacionais	Caixa	Dinheiro	Compensado	Loja Elétrica
2382	CR052	2026-07-26	18:00:00	Saída	-180.00	Telefonia (Adicional)	Contas Fixas	Banco A (Corrente)	Débito Automático	Compensado	VIVO
2383	CP053	2026-07-27	10:00:00	Entrada	2500.00	Venda Lote 69	Vendas	Banco A (Corrente)	PIX	Compensado	Cliente Gama
2384	CP054	2026-07-28	14:00:00	Entrada	400.00	Venda Avulsa	Vendas	Caixa	PIX	Compensado	Cliente Y
2385	CP055	2026-07-29	11:00:00	Saída	-50.00	Taxa de Saque	Contas Fixas	Banco B (Poupança)	Saque	Compensado	Banco B
2386	CR001	2026-08-01	10:00:00	Saída	-22000.00	Compra de Estoque (Agosto)	Fornecedores	Banco A (Corrente)	TED	Compensado	Fornecedor Delta
2387	CP001	2026-08-02	14:00:00	Entrada	7500.00	Venda Lote 70	Vendas	Banco A (Corrente)	PIX	Compensado	Cliente Alpha
2388	CP002	2026-08-05	10:30:00	Saída	-3500.00	Aluguel do Escritório	Contas Fixas	Banco A (Corrente)	Boleto	Compensado	Locadora Imóveis
2389	CR003	2026-08-05	11:00:00	Saída	-850.00	Mensalidade de Software ERP (Ago)	Despesas Operacionais	Banco A (Corrente)	Boleto	Compensado	Fornecedor de TI
2390	CP005	2026-08-06	15:00:00	Saída	-150.00	Material de Copa	Despesas Operacionais	Caixa	Dinheiro	Compensado	Supermercado Local
2391	CP006	2026-08-07	11:00:00	Entrada	3600.00	Pagamento de Serviços Recorrentes (Ago)	Serviços Recorrentes	Banco A (Corrente)	TED	Compensado	Empresa Serviços Z
2392	CP007	2026-08-08	13:00:00	Saída	-500.00	Licença de Software Mensal	Contas Fixas	Cartão Crédito	Cartão Crédito	Compensado	Software Service
2393	CP008	2026-08-09	10:00:00	Entrada	1800.00	Renda de Aluguéis Imóvel 1	Renda Extra	Banco B (Poupança)	TED	Compensado	Inquilino A
2394	CR009	2026-08-10	16:00:00	Saída	-7500.00	Marketing (Nova Campanha)	Marketing	Banco A (Corrente)	Boleto	Compensado	Agência Digital
2395	CP010	2026-08-12	14:00:00	Entrada	9000.00	Venda Lote 60 (Fatura)	Vendas	Banco A (Corrente)	PIX	Compensado	Cliente Alpha
2396	CR011	2026-08-14	11:00:00	Saída	-120.00	Combustível	Logística	Cartão Crédito	Cartão Crédito	Compensado	Posto R
2397	CP012	2026-08-15	14:00:00	Entrada	9500.00	Venda Lote 48 (Fatura)	Vendas	Banco A (Corrente)	TED	Compensado	Cliente Tau
2398	CP013	2026-08-16	16:00:00	Saída	-450.00	Contas de Consumo (Ago)	Contas Fixas	Banco A (Corrente)	Débito Automático	Compensado	Concessionária A
2399	CP014	2026-08-17	10:00:00	Entrada	900.00	Reembolso de Despesa	Renda Extra	Caixa	Dinheiro	Compensado	Sócio João
2400	CP015	2026-08-20	15:30:00	Saída	-24500.00	Salários (Agosto)	Folha de Pagamento	Banco A (Corrente)	TED	Compensado	RH - Funcionários
2401	CP016	2026-08-21	14:00:00	Entrada	3500.00	Venda Lote 71	Vendas	Banco A (Corrente)	TED	Compensado	Cliente Zeta
2402	CR017	2026-08-22	10:00:00	Saída	-400.00	Manutenção de Equipamento	Despesas Operacionais	Caixa	Dinheiro	Compensado	Oficina Geral
2403	CP018	2026-08-23	16:00:00	Entrada	6500.00	Venda Lote 72	Vendas	Banco A (Corrente)	PIX	Compensado	Cliente Gamma
2404	CP019	2026-08-26	11:00:00	Saída	-6000.00	Impostos Mensais (Ago)	Contas Fixas	Banco A (Corrente)	Boleto	Compensado	Receita Federal
2405	CR020	2026-08-27	14:00:00	Entrada	1500.00	Venda de Consultoria	Prestação de Serviços	Banco A (Corrente)	TED	Compensado	Empresa K
2406	CP021	2026-08-28	12:00:00	Saída	-50.00	Despesa Cartório	Despesas Operacionais	Caixa	Dinheiro	Compensado	Cartório O
2408	CR023	2026-08-01	12:00:00	Entrada	600.00	Renda de Aluguéis Imóvel 2	Renda Extra	Banco B (Poupança)	TED	Compensado	Inquilino B
2409	CP024	2026-08-04	14:30:00	Saída	-200.00	Passagens de Ônibus	Logística	Caixa	Dinheiro	Compensado	Viação Y
2410	CP025	2026-08-07	18:00:00	Saída	-180.00	Telefonia Mensal	Contas Fixas	Banco A (Corrente)	Débito Automático	Compensado	VIVO
2411	CP026	2026-08-10	09:00:00	Saída	-40.00	Tarifa de Extrato	Contas Fixas	Banco A (Corrente)	Débito Automático	Compensado	Banco A
2412	CR027	2026-08-13	15:00:00	Entrada	5000.00	Adiantamento de Cliente	Vendas	Banco A (Corrente)	TED	Compensado	Cliente Delta
2413	CP028	2026-08-18	12:30:00	Saída	-100.00	Almoço de Equipe	Despesas Operacionais	Cartão Crédito	Cartão Crédito	Compensado	Restaurante D
2414	CP029	2026-08-20	10:00:00	Entrada	800.00	Reembolso de Despesa	Renda Extra	Caixa	Dinheiro	Compensado	Sócio Alfa
2415	CP030	2026-08-24	14:00:00	Entrada	4500.00	Venda Lote 73	Vendas	Banco A (Corrente)	Boleto	Compensado	Cliente Tau
2416	CR031	2026-08-25	10:00:00	Saída	-300.00	Compra de Equipamento Pequeno	Despesas Operacionais	Caixa	Dinheiro	Compensado	Loja Elétrica
2417	CP032	2026-08-26	18:00:00	Saída	-180.00	Telefonia (Adicional)	Contas Fixas	Banco A (Corrente)	Débito Automático	Compensado	VIVO
2418	CP033	2026-08-27	10:00:00	Entrada	2500.00	Venda Lote 74	Vendas	Banco A (Corrente)	PIX	Compensado	Cliente Gama
2419	CP034	2026-08-28	14:00:00	Entrada	400.00	Venda Avulsa	Vendas	Caixa	PIX	Compensado	Cliente Y
2420	CP035	2026-08-29	11:00:00	Saída	-50.00	Taxa de Saque	Contas Fixas	Banco B (Poupança)	Saque	Compensado	Banco B
\.


--
-- TOC entry 4970 (class 0 OID 0)
-- Dependencies: 230
-- Name: ft_fluxo_caixa_sk_transacao_planejamento_seq; Type: SEQUENCE SET; Schema: gold; Owner: postgres
--

SELECT pg_catalog.setval('gold.ft_fluxo_caixa_sk_transacao_planejamento_seq', 2430, true);


--
-- TOC entry 4802 (class 2606 OID 49212)
-- Name: dim_conta dim_conta_pkey; Type: CONSTRAINT; Schema: gold; Owner: postgres
--

ALTER TABLE ONLY gold.dim_conta
    ADD CONSTRAINT dim_conta_pkey PRIMARY KEY (id_conta);


--
-- TOC entry 4800 (class 2606 OID 49203)
-- Name: dim_tempo dim_tempo_pkey; Type: CONSTRAINT; Schema: gold; Owner: postgres
--

ALTER TABLE ONLY gold.dim_tempo
    ADD CONSTRAINT dim_tempo_pkey PRIMARY KEY (data);


--
-- TOC entry 4804 (class 2606 OID 49223)
-- Name: ft_fluxo_caixa ft_fluxo_caixa_pkey; Type: CONSTRAINT; Schema: gold; Owner: postgres
--

ALTER TABLE ONLY gold.ft_fluxo_caixa
    ADD CONSTRAINT ft_fluxo_caixa_pkey PRIMARY KEY (sk_transacao_planejamento);


--
-- TOC entry 4794 (class 2606 OID 41028)
-- Name: contas_planejadas contas_planejadas_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.contas_planejadas
    ADD CONSTRAINT contas_planejadas_pkey PRIMARY KEY (id_conta);


--
-- TOC entry 4792 (class 2606 OID 41017)
-- Name: transacoes_realizadas transacoes_realizadas_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.transacoes_realizadas
    ADD CONSTRAINT transacoes_realizadas_pkey PRIMARY KEY (id_transacao);


--
-- TOC entry 4796 (class 2606 OID 49179)
-- Name: contas_planejadas contas_planejadas_pkey; Type: CONSTRAINT; Schema: silver; Owner: postgres
--

ALTER TABLE ONLY silver.contas_planejadas
    ADD CONSTRAINT contas_planejadas_pkey PRIMARY KEY (id_conta);


--
-- TOC entry 4798 (class 2606 OID 49191)
-- Name: transacoes_realizadas transacoes_realizadas_pkey; Type: CONSTRAINT; Schema: silver; Owner: postgres
--

ALTER TABLE ONLY silver.transacoes_realizadas
    ADD CONSTRAINT transacoes_realizadas_pkey PRIMARY KEY (id_transacao);


--
-- TOC entry 4805 (class 2606 OID 49229)
-- Name: ft_fluxo_caixa ft_fluxo_caixa_data_ref_fkey; Type: FK CONSTRAINT; Schema: gold; Owner: postgres
--

ALTER TABLE ONLY gold.ft_fluxo_caixa
    ADD CONSTRAINT ft_fluxo_caixa_data_ref_fkey FOREIGN KEY (data_ref) REFERENCES gold.dim_tempo(data);


--
-- TOC entry 4806 (class 2606 OID 49224)
-- Name: ft_fluxo_caixa ft_fluxo_caixa_id_conta_fkey; Type: FK CONSTRAINT; Schema: gold; Owner: postgres
--

ALTER TABLE ONLY gold.ft_fluxo_caixa
    ADD CONSTRAINT ft_fluxo_caixa_id_conta_fkey FOREIGN KEY (id_conta) REFERENCES gold.dim_conta(id_conta);


-- Completed on 2025-10-23 14:58:21

--
-- PostgreSQL database dump complete
--

\unrestrict IwVuly9nm92rhNtX4LekIE2cel0SpK23R5qgOnJ1rAtu44Vu34NHAVFHdEnHRBy

