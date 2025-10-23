# 📊 Documentação do Projeto de Análise de Dados Bancários em PySpark

## Visão Geral do Projeto

### Objetivo
Implementar um pipeline completo de dados bancários para análise financeira, detecção de incoerências e geração de insights estratégicos através de dashboards interativos.

### Arquitetura
```
Bronze (Raw) → Silver (Cleaned) → Gold (Aggregated) → Dashboard (Visualization)
```

### Tecnologias Utilizadas
- **Databricks** (Plataforma principal)
- **PySpark** (Processamento de dados)
- **Delta Lake** (Armazenamento)
- **SQL** (Análise e queries)
- **Matplotlib/Seaborn** (Visualizações)

## Estrutura de Camadas

## Camada Bronze - Dados Brutos

### Objetivo
Armazenar os dados originais sem transformações, mantendo a fidelidade dos dados de origem para auditoria e reprocessamento.

### Código Implementado

```python
# Configuração inicial do Spark
from pyspark.sql import SparkSession
from pyspark.sql.functions import *
from pyspark.sql.types import *

spark = SparkSession.builder \
    .appName("BankDataAnalysis") \
    .config("spark.sql.adaptive.enabled", "true") \
    .getOrCreate()

# Schemas para validação de dados
transactions_schema = StructType([
    StructField("ID_Transacao", StringType(), True),
    StructField("Data", StringType(), True),
    StructField("Hora", StringType(), True),
    StructField("Tipo", StringType(), True),
    StructField("Valor_RS", StringType(), True),
    StructField("Descricao", StringType(), True),
    StructField("Categoria", StringType(), True),
    StructField("Conta", StringType(), True),
    StructField("Meio_Pgto", StringType(), True),
    StructField("Status", StringType(), True),
    StructField("Estabelecimento", StringType(), True),
    StructField("ID_Conta", StringType(), True)
])
```

### Funções PySpark Utilizadas

#### SparkSession.builder
- **Propósito**: Configurar e criar a sessão do Spark
- **Por que usar**: Interface principal para trabalhar com Spark no Databricks
- **Configurações importantes**:
  - adaptive.enabled: Otimiza execução de queries
  - coalescePartitions.enabled: Melhora performance em joins

#### StructType e StructField
- **Propósito**: Definir schema explícito para validação de dados
- **Por que usar**: Evita inferência incorreta de tipos e melhora performance
- **Benefícios**: Validação early-stage e melhor compressão

### Processo de Ingestão

```python
def load_bronze_data():
    df_transactions_bronze = spark.read \
        .option("delimiter", ";") \
        .option("header", "true") \
        .option("encoding", "UTF-8") \
        .schema(transactions_schema) \
        .csv("/Volumes/workspace/bronze/data/bank/dados de tracições.csv")
    
    # Metadados para data lineage
    df_transactions_bronze = df_transactions_bronze \
        .withColumn("data_ingestao_bronze", current_timestamp()) \
        .withColumn("fonte", lit("transacoes_csv")) \
        .withColumn("lote_ingestao", lit("bronze_v1"))
```

#### current_timestamp()
- **Propósito**: Registrar momento exato da ingestão
- **Por que usar**: Para data lineage e debugging de processos

#### lit()
- **Propósito**: Criar colunas com valores constantes
- **Por que usar**: Para metadados e flags consistentes

## Camada Silver - Dados Limpos e Enriquecidos

### Objetivo
Transformar dados brutos em dados confiáveis e estruturados, aplicando limpeza, validação e enriquecimento.

### Transformações Principais

#### 1. Limpeza de Valores Monetários

```python
df_transactions_silver = df_transactions \
    .withColumn("Valor_RS_clean", 
               regexp_replace(regexp_replace(col("Valor_RS"), "\\.", ""), ",", ".")) \
    .withColumn("Valor_RS_decimal", 
               when(col("Valor_RS_clean").rlike("^-?\\d+(\\.\\d+)?$"), 
                    col("Valor_RS_clean").cast("decimal(15,2)"))
               .otherwise(lit(0))) \
    .withColumn("Valor_RS_final", 
               when(col("Tipo") == "Saída", -abs(col("Valor_RS_decimal")))
               .otherwise(abs(col("Valor_RS_decimal"))))
```

#### regexp_replace()
- **Propósito**: Limpar formatação de strings (R$ 1.500,50 → 1500.50)
- **Por que usar**: Dados financeiros frequentemente vêm formatados
- **Processo**: Remove pontos milhar, substitui vírgula decimal por ponto

#### when().otherwise()
- **Propósito**: Aplicar lógica condicional tipo SQL CASE WHEN
- **Por que usar**: Para tratar valores negativos/positivos baseado no tipo

#### 2. Transformações de Data/Hora

```python
.withColumn("Data_formatada", to_date(col("Data"), "dd/MM/yyyy")) \
.withColumn("Timestamp_completo", 
           to_timestamp(concat(col("Data"), lit(" "), col("Hora")), 
                       "dd/MM/yyyy HH:mm:ss")) \
.withColumn("Ano", year(col("Data_formatada"))) \
.withColumn("Mes", month(col("Data_formatada"))) \
.withColumn("AnoMes", date_format(col("Data_formatada"), "yyyy-MM")) \
.withColumn("DiaSemana", date_format(col("Data_formatada"), "EEEE")) \
.withColumn("NumeroDiaSemana", dayofweek(col("Data_formatada")))
```

#### to_date() e to_timestamp()
- **Propósito**: Converter strings para tipos temporais
- **Por que usar**: Operações temporais são muito mais eficientes com tipos corretos

#### year(), month(), dayofweek()
- **Propósito**: Extrair componentes temporais para agregação
- **Por que usar**: Facilitar análises por período

#### 3. Detecção de Incoerências

```python
.withColumn("Hora_numero", split(col("Hora"), ":").getItem(0).cast("int")) \
.withColumn("Fora_Horario_Comercial",
           when(
               (col("Hora_numero") < 8) | 
               (col("Hora_numero") >= 18) |
               (col("Is_Fim_de_Semana") == 1), 
               1
           ).otherwise(0)) \
.withColumn("Incoerencia_Horario",
           when(
               (col("Fora_Horario_Comercial") == 1) & 
               (~col("Descricao_Limpa").contains("noturna") & 
                ~col("Descricao_Limpa").contains("fim de semana")),
               1
           ).otherwise(0))
```

#### split().getItem()
- **Propósito**: Extrair hora de string "HH:mm:ss"
- **Por que usar**: Para análise temporal granular

#### Operadores Lógicos (&, |, ~)
- **Propósito**: Combinar condições complexas
- **Por que usar**: Lógica de negócio para detecção de anomalias

#### 4. Categorização Inteligente

```python
.withColumn("Categoria_Agrupada",
           when(col("Categoria").contains("Venda"), "Vendas")
           .when(col("Categoria").contains("Prestação"), "Serviços")
           .when(col("Categoria").contains("Aluguéis"), "Renda Aluguel")
           .when(col("Categoria").contains("Despesa"), "Despesas Operacionais")
           .otherwise("Outros")) \
.withColumn("Faixa_Horaria",
           when(col("Hora_numero").between(6, 11), "Manhã")
           .when(col("Hora_numero").between(12, 17), "Tarde")
           .when(col("Hora_numero").between(18, 23), "Noite")
           .otherwise("Madrugada"))
```

#### contains()
- **Propósito**: Buscar padrões em strings para categorização
- **Por que usar**: Automatizar classificação baseada em keywords

#### between()
- **Propósito**: Definir ranges para categorização
- **Por que usar**: Para agrupar horários em faixas significativas

## Camada Gold - Dados Agregados para Business Intelligence

### Objetivo
Criar métricas de negócio, KPIs e agregados otimizados para consumo em dashboards e relatórios.

### Agregações Principais

#### 1. Resumo Mensal Financeiro

```python
gold_resumo_mensal = df_transactions \
    .groupBy("Ano", "Mes", "AnoMes") \
    .agg(
        # Métricas de Volume
        count("*").alias("total_transacoes"),
        countDistinct("Estabelecimento").alias("total_estabelecimentos"),
        
        # Métricas Financeiras
        sum("Valor_RS_final").alias("saldo_liquido_mensal"),
        sum(when(col("Is_Entrada") == 1, col("Valor_RS_final")).otherwise(0)).alias("total_receitas"),
        sum(when(col("Is_Saida") == 1, col("Valor_RS_final")).otherwise(0)).alias("total_despesas"),
        
        # Métricas de Qualidade
        sum("Incoerencia_Horario").alias("total_incoerencias_horario"),
        
        # KPIs Calculados
        round((col("total_incoerencias_horario") / col("total_transacoes")) * 100, 2).alias("percentual_incoerencias"),
        round((col("saldo_liquido_mensal") / col("total_receitas")) * 100, 2).alias("margem_liquida")
    )
```

#### countDistinct()
- **Propósito**: Contar valores únicos em agregações
- **Por que usar**: Para métricas como "estabelecimentos únicos ativos"

#### sum(when().otherwise())
- **Propósito**: Somas condicionais
- **Por que usar**: Para separar receitas/despesas na mesma agregação

#### Window Functions
```python
.withColumn("participacao_percentual", 
           round((col("valor_absoluto") / 
                 sum("valor_absoluto").over(Window.partitionBy("AnoMes", "Tipo"))) * 100, 2))
```

#### Window.partitionBy()
- **Propósito**: Calcular percentuais dentro de partições
- **Por que usar**: Para análise de participação relativa

## Dashboard no Databricks SQL

### Arquitetura do Dashboard

O dashboard foi implementado no Databricks SQL com 8 queries principais organizadas em um layout estratégico para análise financeira completa.

#### 1. KPIs Principais - Big Numbers

```sql
SELECT 'Total Transações' as metric_name, total_transacoes as metric_value FROM analytics_kpis
UNION ALL SELECT 'Receitas Totais', total_receitas FROM analytics_kpis
UNION ALL SELECT 'Despesas Totais', total_despesas FROM analytics_kpis
UNION ALL SELECT 'Saldo Líquido', saldo_liquido FROM analytics_kpis
UNION ALL SELECT 'Margem Líquida', margem_liquida FROM analytics_kpis
UNION ALL SELECT 'Incoerências Detectadas', total_incoerencias FROM analytics_kpis
UNION ALL SELECT 'Taxa de Incoerência', taxa_incoerencia FROM analytics_kpis
UNION ALL SELECT 'Ticket Médio', ticket_medio_geral FROM analytics_kpis;
```

**Configuração**: Visualization "Value" com Big Numbers, agrupado por metric_name
**Propósito**: Visão rápida dos principais indicadores de performance

#### 2. Evolução Mensal - Line Chart

```sql
SELECT 
    AnoMes,
    receitas,
    despesas,
    saldo_liquido
FROM analytics_evolucao
ORDER BY AnoMes;
```

**Configuração**: Line Chart com AnoMes no eixo X e múltiplas séries (receitas, despesas)
**Propósito**: Análise temporal da performance financeira

#### 3. Saldo Mensal - Bar Chart

```sql
SELECT 
    AnoMes,
    saldo_liquido,
    CASE 
        WHEN saldo_liquido >= 0 THEN 'Positivo' 
        ELSE 'Negativo' 
    END as tipo_saldo
FROM analytics_evolucao
ORDER BY AnoMes;
```

**Configuração**: Bar Chart agrupado por tipo_saldo com cores condicionais
**Propósito**: Visualização clara dos meses com resultado positivo/negativo

#### 4. Top Categorias - Horizontal Bar Chart

```sql
SELECT 
    Categoria_Agrupada,
    Tipo,
    volume_total
FROM analytics_categorias
ORDER BY volume_total DESC
LIMIT 10;
```

**Configuração**: Bar Chart horizontal, agrupado por Tipo
**Propósito**: Identificar categorias com maior volume financeiro

#### 5. Alertas de Incoerências - Table

```sql
SELECT 
    Estabelecimento,
    Categoria_Agrupada as Categoria,
    COUNT(*) as Total_Transacoes,
    SUM(Incoerencia_Horario) as Incoerencias,
    ROUND((SUM(Incoerencia_Horario) / COUNT(*)) * 100, 1) as Taxa_Incoerencia,
    SUM(Valor_Absoluto) as Volume_Total,
    CASE 
        WHEN (SUM(Incoerencia_Horario) / COUNT(*)) * 100 > 30 THEN 'Crítico'
        WHEN (SUM(Incoerencia_Horario) / COUNT(*)) * 100 > 15 THEN 'Alto' 
        ELSE 'Moderado'
    END as Gravidade
FROM silver.transacoes
GROUP BY Estabelecimento, Categoria_Agrupada
HAVING SUM(Incoerencia_Horario) > 0
ORDER BY Incoerencias DESC
LIMIT 15;
```

**Configuração**: Table com paginação e formatação condicional
**Propósito**: Monitoramento proativo de transações suspeitas

#### 6. Meios de Pagamento - Pie Chart

```sql
SELECT 
    Meio_Pgto_Categoria as meio_pagamento,
    SUM(Valor_Absoluto) as volume_total
FROM silver.transacoes
GROUP BY Meio_Pgto_Categoria
ORDER BY volume_total DESC;
```

**Configuração**: Pie Chart com percentuais e legenda
**Propósito**: Análise da distribuição por canais de pagamento

#### 7. Análise Horária - Bar Chart

```sql
SELECT 
    Faixa_Horaria,
    Tipo,
    SUM(Valor_Absoluto) as volume_total
FROM silver.transacoes
GROUP BY Faixa_Horaria, Tipo
ORDER BY 
    CASE Faixa_Horaria
        WHEN 'Madrugada' THEN 1
        WHEN 'Manhã' THEN 2
        WHEN 'Tarde' THEN 3
        WHEN 'Noite' THEN 4
    END;
```

**Configuração**: Bar Chart agrupado por Tipo, ordenado cronologicamente
**Propósito**: Identificar padrões de comportamento por horário

#### 8. Contas em Atraso - Stacked Bar Chart

```sql
SELECT 
    Status_Vencimento,
    Tipo_Fluxo,
    COUNT(*) as quantidade_contas,
    SUM(Valor_Previsto_decimal) as valor_total
FROM silver.contas
WHERE Status_Vencimento IN ('Atrasado', 'Vencido', 'Vence em Breve')
GROUP BY Status_Vencimento, Tipo_Fluxo
ORDER BY valor_total DESC;
```

**Configuração**: Stacked Bar Chart para visualização cumulativa
**Propósito**: Gestão de risco e fluxo de caixa

### Layout do Dashboard

**Linha 1**: KPIs Principais (8 Big Numbers)
- Total Transações, Receitas Totais, Despesas Totais, Saldo Líquido
- Margem Líquida, Incoerências Detectadas, Taxa de Incoerência, Ticket Médio

**Linha 2**: Análise Temporal
- Evolução Mensal (Line Chart)
- Saldo Mensal (Bar Chart)

**Linha 3**: Análise de Categorias
- Top Categorias (Horizontal Bar Chart)
- Meios de Pagamento (Pie Chart)

**Linha 4**: Detecção e Monitoramento
- Alertas de Incoerências (Table)
- Análise Horária (Bar Chart)

**Linha 5**: Situação Financeira
- Contas em Atraso (Stacked Bar Chart)

### Filtros Globais Implementados

1. **Filtro de Período**: Date range baseado em Data_formatada
2. **Filtro de Tipo**: Dropdown para Entrada/Saída/Todos
3. **Filtro de Categoria**: Dropdown com todas as categorias disponíveis

### Funcionalidades do Dashboard

- **Refresh Automático**: Configurado para atualizar a cada 15 minutos
- **Interatividade**: Todos os gráficos respondem aos filtros globais
- **Responsividade**: Layout adaptável para diferentes tamanhos de tela
- **Exportação**: Capacidade de exportar dados e visualizações

## Detecção de Incoerências - Lógica de Negócio

### Algoritmo de Detecção
```python
Incoerência = (
    (Transação fora do horário comercial) 
    AND 
    (NÃO contém indicadores de transação noturna)
)
```

### Horário Comercial Definido
- **Dias úteis**: 8h às 18h
- **Finais de semana**: Totalmente fora do comercial
- **Indicadores de exceção**: "noturna", "fim de semana", "sábado", "domingo"

### Classificação de Gravidade
```python
Gravidade = 
    "Crítico" se Taxa > 30%
    "Alto" se Taxa > 15% 
    "Moderado" caso contrário
```

## Estratégia de Armazenamento

### Delta Lake Benefits
```python
df.write \
    .mode("overwrite") \
    .format("delta") \
    .option("delta.autoOptimize.optimizeWrite", "true") \
    .option("mergeSchema", "true") \
    .saveAsTable("silver.transacoes")
```

#### mergeSchema=true
- **Propósito**: Evolução segura de schemas
- **Por que usar**: Permite adicionar colunas sem quebrar pipelines

#### autoOptimize.optimizeWrite=true
- **Propósito**: Otimização automática de arquivos
- **Por que usar**: Melhor performance de leitura

## Métricas de Performance Implementadas

### KPIs de Data Quality
1. **Taxa de Incoerências**: (incoerências / total_transacoes) * 100
2. **Completude**: Verificação de nulos em campos críticos
3. **Consistência**: Validação de formatos temporais e monetários

### KPIs Financeiros
1. **Margem Líquida**: (saldo_líquido / receitas) * 100
2. **Ticket Médio**: volume_total / total_transacoes
3. **Diversificação**: Número de categorias/estabelecimentos únicos

## Resumo de Funções PySpark Utilizadas

| Função | Camada | Propósito | Benefício |
|--------|---------|-----------|-----------|
| withColumn() | Todas | Transformação de dados | Pipeline funcional |
| when().otherwise() | Silver | Lógica condicional | Limpeza inteligente |
| regexp_replace() | Silver | Limpeza de strings | Padronização |
| groupBy().agg() | Gold | Agregação | KPIs de negócio |
| Window functions | Gold | Cálculos relativos | Análise comparativa |
| countDistinct() | Gold | Métricas de diversidade | Insights de negócio |

Este projeto demonstra um pipeline de dados completo desde ingestão até visualização, aplicando best practices de engenharia de dados e criando valor de negócio através de análises acionáveis. O dashboard implementado fornece uma visão abrangente da saúde financeira com capacidade de detecção proativa de anomalias.
