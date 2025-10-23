# 📊 Projeto de Data Warehouse: Análise de Fluxo de Caixa (Realizado vs. Planejado)

## 1\. Visão Geral do Projeto

Este projeto implementa uma solução de Business Intelligence (BI) para medir e comparar o Fluxo de Caixa **Planejado** com o Fluxo de Caixa **Realizado**.

A arquitetura utiliza um Data Warehouse (DW) modelado em **Esquema Estrela** no **PostgreSQL** e o **Power BI** para a camada de visualização e análise de dados.

O objetivo final é capacitar a equipe financeira com uma ferramenta que permite:

1.  Avaliar a precisão das projeções financeiras (*forecasting*).
2.  Identificar desvios orçamentários por categoria e período.
3.  Analisar a tendência histórica de entradas e saídas.

## 2\. Arquitetura da Solução (Data Pipeline)

O fluxo de dados segue a arquitetura moderna de **Camadas de Dados (Bronze, Silver, Gold - Medallion Architecture)**, garantindo qualidade, rastreabilidade e consistência:

| Camada | Ferramenta | Descrição |
| :--- | :--- | :--- |
| **BRONZE** | PostgreSQL (Schema `bronze`) | **Landing Zone.** Recebe dados brutos (CSV, planilhas) diretamente da fonte. Os dados são mantidos no formato original (`VARCHAR`) para garantir que não haja perda de informação durante a importação. |
| **SILVER** | PostgreSQL (Schema `silver`) | **Limpeza e Integração.** Aplica as regras de ETL: tipagem correta (conversão de strings para `DATE` e `NUMERIC`), remoção de caracteres monetários ('R$') e padronização. |
| **GOLD** | PostgreSQL (Schema `gold`) | **Modelo Dimensional.** Os dados limpos são transformados em um **Esquema Estrela** otimizado para leitura. É a fonte final de dados consumida pelo Power BI. |
| **CONSUMO** | Power BI (DAX e Visualização) | **Análise e Dashboard.** Conecta-se à Camada Gold para criar métricas (`DAX`) e gerar o dashboard interativo (Realizado vs. Planejado). |

## 3\. Estrutura do Repositório

O código SQL para construção do DW está organizado por camada dentro da pasta `sql_postgres`. As métricas do Power BI estão documentadas em `power_bi_dax`.

```
/
|-- README.md 
|-- /sql_postgres
|   |-- 1_bronze_schema.sql        
|   |-- 2_silver_etl.sql           
|   |-- 3_gold_model_load.sql      
|
|-- /power_bi_dax
|   |-- measures.dax               (Métricas DAX)
|
|-- /documentacao
    |-- modelo_dimensional.png     (Esquema Estrela)
    |-- dashboard_final.png        (Visualização Final)
```

## 4\. Modelagem de Dados (Camada GOLD)

O modelo é composto por duas Dimensões e uma Tabela Fato:

| Tabela | Tipo | Chave | Uso no BI |
| :--- | :--- | :--- | :--- |
| `dim_tempo` | Dimensão | `data` (PK) | Permite análise por ano/mês e garante ordenação cronológica correta. |
| `dim_conta` | Dimensão | `id_conta` (PK) | Filtra transações por `categoria_financeira` e `tipo_conta` (Pagar/Receber). |
| `ft_fluxo_caixa` | Fato | `sk_fluxo_caixa` (PK) | Contém os valores e as *flags* (`is_planejado`, `is_realizado`) para o cálculo das métricas DAX. |

## 5\. Medidas de Análise Chave (DAX - Power BI)

O coração da análise está nas medidas DAX que filtram e agregam os dados da Tabela Fato.

| Medida DAX | Função Analítica | Código (Exemplo) |
| :--- | :--- | :--- |
| `Valor Líquido Total` | Agregação base de todos os valores na Tabela Fato. | `SUM('ft_fluxo_caixa'[valor_net])` |
| **`Total Planejado`** | Usa a flag `is_planejado` para isolar a projeção de valores. | `CALCULATE([Valor Líquido Total], 'ft_fluxo_caixa'[is_planejado] = TRUE())` |
| **`Total Realizado`** | Usa a flag `is_realizado` para isolar as transações efetivas. | `CALCULATE([Valor Líquido Total], 'ft_fluxo_caixa'[is_realizado] = TRUE())` |

## 6\. Como Executar (Passo a Passo)

1.  **Configuração do PostgreSQL:** Crie o banco de dados e as tabelas Brutas (`contas_planejadas` e `transacoes_realizadas`) no schema `public`.
2.  **Carga BRONZE:** Importe seus arquivos de origem (CSV/Excel) para as tabelas Bronze.
3.  **Execução do ETL:** Execute os scripts SQL em ordem:
      * `1_bronze_schema.sql`
      * `2_silver_etl.sql` (Realiza limpeza de tipos e valores)
      * `3_gold_model_load.sql` (Cria o modelo estrela e carrega dados de Silver)
4.  **Conexão no Power BI:** Crie uma nova conexão ODBC/PostgreSQL apontando para o schema `gold` do seu banco de dados e importe as tabelas `dim_tempo`, `dim_conta` e `ft_fluxo_caixa`.
5.  **Criação DAX:** Crie as medidas DAX listadas acima e desenvolva os visuais de comparação (Gráfico de Linhas Realizado vs. Planejado).
