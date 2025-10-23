# Documentação das 3 Camadas - Projeto de Análise de Dados Bancários

## Arquitetura em Camadas

```
Bronze (Dados Crus) → Silver (Dados Limpos) → Gold (Dados de Negócio)
```

---

## 🥉 Camada Bronze - Dados Brutos

### Objetivo
Armazenar dados originais sem transformações para preservar a fidelidade dos dados de origem.

### Funcionalidades
- **Ingestão segura** de arquivos CSV
- **Preservação integral** dos dados originais  
- **Metadados** para rastreabilidade (timestamp, fonte)
- **Validação de schema** com estrutura definida

### Estrutura
- **Formato**: Delta Lake
- **Schema**: Estrito com tipos explícitos
- **Tabelas**: bronze.transacoes, bronze.contas
- **Metadados**: data_ingestao_bronze, fonte, lote_ingestao

### Código Bronze
```python


    # Configuração inicial
    from pyspark.sql import SparkSession
    from pyspark.sql.functions import *
    from pyspark.sql.types import *
    from delta.tables import *
    
    # Inicializar Spark Session
    spark = SparkSession.builder \
        .appName("BankDataAnalysis") \
        .config("spark.sql.adaptive.enabled", "true") \
        .config("spark.sql.adaptive.coalescePartitions.enabled", "true") \
        .getOrCreate()
    
    # Definir schemas completos
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
    
    accounts_schema = StructType([
        StructField("ID_Conta", StringType(), True),
        StructField("Tipo_Conta", StringType(), True),
        StructField("Descricao_Detalhada", StringType(), True),
        StructField("Valor_Previsto_RS", StringType(), True),
        StructField("Data_Vencimento", StringType(), True),
        StructField("Categoria_Financeira", StringType(), True),
        StructField("Status_Cobranca", StringType(), True),
        StructField("Parceiro", StringType(), True),
        StructField("Condicao_Pgto", StringType(), True)
    ])
    
    # Função para carregar dados Bronze
    def load_bronze_data():
        try:
            # Ler arquivo de transações
            df_transactions_bronze = spark.read \
                .option("delimiter", ";") \
                .option("header", "true") \
                .option("encoding", "UTF-8") \
                .option("quote", "\"") \
                .option("escape", "\"") \
                .schema(transactions_schema) \
                .csv("/Volumes/workspace/bronze/data/bank/dados de tracições.csv")
        
        # Ler arquivo de contas
        df_accounts_bronze = spark.read \
            .option("delimiter", ";") \
            .option("header", "true") \
            .option("encoding", "UTF-8") \
            .option("quote", "\"") \
            .option("escape", "\"") \
            .schema(accounts_schema) \
            .csv("/Volumes/workspace/bronze/data/bank/dados de contas.csv")
        
        # Adicionar metadados Bronze
        df_transactions_bronze = df_transactions_bronze \
            .withColumn("data_ingestao_bronze", current_timestamp()) \
            .withColumn("fonte", lit("transacoes_csv")) \
            .withColumn("lote_ingestao", lit("bronze_v1"))
        
        df_accounts_bronze = df_accounts_bronze \
            .withColumn("data_ingestao_bronze", current_timestamp()) \
            .withColumn("fonte", lit("contas_csv")) \
            .withColumn("lote_ingestao", lit("bronze_v1"))
        
        return df_transactions_bronze, df_accounts_bronze
        
    except Exception as e:
        print(f"Erro ao carregar dados Bronze: {str(e)}")
        raise e

    # Carregar e salvar dados Bronze
    print("=== INICIANDO CARREGAMENTO BRONZE ===")
    df_transactions_bronze, df_accounts_bronze = load_bronze_data()
    
    # Salvar como tabelas Delta Bronze
    df_transactions_bronze.write \
        .mode("overwrite") \
        .format("delta") \
        .option("delta.autoOptimize.optimizeWrite", "true") \
        .saveAsTable("bronze.transacoes")
    
    df_accounts_bronze.write \
        .mode("overwrite") \
        .format("delta") \
        .option("delta.autoOptimize.optimizeWrite", "true") \
        .saveAsTable("bronze.contas")
    
    print("✅ Camada Bronze criada com sucesso!")
    print(f"Transações Bronze: {df_transactions_bronze.count()} registros")
    print(f"Contas Bronze: {df_accounts_bronze.count()} registros")
---
```
  ## 🥈 Camada Silver - Dados Limpos
  
  ### Objetivo
  Transformar dados brutos em dados confiáveis através de limpeza, enriquecimento e aplicação de regras de qualidade.
  
  ### Transformações Principais
  - **Limpeza monetária**: Padronização de valores R$
  - **Conversão temporal**: Datas e horas formatadas
  - **Categorização**: Agrupamento inteligente por regras
  - **Detecção de incoerências**: Transações fora do padrão
  - **Enriquecimento**: Metadados e classificações
  
  ### Estrutura
  - **Formato**: Delta Lake otimizado
  - **Tabelas**: silver.transacoes, silver.contas
  - **Novas colunas**: Categorias, flags de qualidade, metadados
  
  ### Código Silver
  ```python
  
  
    # Camada Silver - Transformações Completa 
    from pyspark.sql.functions import col, current_timestamp, current_date, regexp_replace, when, lit, to_date, to_timestamp, year, month, dayofmonth, date_format, quarter, dayofweek, split, abs, lower, trim, count, countDistinct, sum, avg, min, max, datediff, first, concat
    from pyspark.sql.window import Window
    
    def create_silver_layer():
    
    # Ler dados da Bronze
    df_transactions = spark.table("bronze.transacoes")
    df_accounts = spark.table("bronze.contas")
    
    print("=== PROCESSANDO CAMADA SILVER ===")
    
    # SILVER - TRANSFORMAÇÕES PARA TRANSAÇÕES
    df_transactions_silver = df_transactions \
        .filter(col("ID_Transacao").isNotNull()) \
        .filter(~col("ID_Transacao").startswith(";")) \
        .withColumn("Valor_RS_clean", 
                   regexp_replace(regexp_replace(col("Valor_RS"), "\\.", ""), ",", ".")) \
        .withColumn("Valor_RS_decimal", 
                   when(col("Valor_RS_clean").rlike("^-?\\d+(\\.\\d+)?$"), 
                        col("Valor_RS_clean").cast("decimal(15,2)"))
                   .otherwise(lit(0))) \
        .withColumn("Valor_RS_final", 
                   when(col("Tipo") == "Saída", -abs(col("Valor_RS_decimal")))
                   .otherwise(abs(col("Valor_RS_decimal")))) \
        .withColumn("Data_formatada", 
                   to_date(col("Data"), "dd/MM/yyyy")) \
        .withColumn("Timestamp_completo", 
                   to_timestamp(concat(col("Data"), lit(" "), col("Hora")), 
                               "dd/MM/yyyy HH:mm:ss")) \
        .withColumn("Ano", year(col("Data_formatada"))) \
        .withColumn("Mes", month(col("Data_formatada"))) \
        .withColumn("Dia", dayofmonth(col("Data_formatada"))) \
        .withColumn("AnoMes", date_format(col("Data_formatada"), "yyyy-MM")) \
        .withColumn("Trimestre", quarter(col("Data_formatada"))) \
        .withColumn("DiaSemana", date_format(col("Data_formatada"), "EEEE")) \
        .withColumn("NumeroDiaSemana", dayofweek(col("Data_formatada"))) \
        .withColumn("Hora_numero", 
                   split(col("Hora"), ":").getItem(0).cast("int")) \
        .withColumn("Minuto_numero", 
                   split(col("Hora"), ":").getItem(1).cast("int")) \
        .withColumn("Is_Fim_de_Semana", 
                   when(dayofweek(col("Data_formatada")).isin(1, 7), 1).otherwise(0)) \
        .withColumn("Is_Entrada", when(col("Tipo") == "Entrada", 1).otherwise(0)) \
        .withColumn("Is_Saida", when(col("Tipo") == "Saída", 1).otherwise(0)) \
        .withColumn("Valor_Absoluto", abs(col("Valor_RS_final"))) \
        .withColumn("Faixa_Horaria",
                   when(col("Hora_numero").between(6, 11), "Manhã")
                   .when(col("Hora_numero").between(12, 17), "Tarde")
                   .when(col("Hora_numero").between(18, 23), "Noite")
                   .otherwise("Madrugada")) \
        .withColumn("Fora_Horario_Comercial",
                   when(
                       (col("Hora_numero") < 8) | 
                       (col("Hora_numero") >= 18) |
                       (col("Is_Fim_de_Semana") == 1), 
                       1
                   ).otherwise(0)) \
        .withColumn("Descricao_Limpa", 
                   lower(trim(col("Descricao")))) \
        .withColumn("Incoerencia_Horario",
                   when(
                       (col("Fora_Horario_Comercial") == 1) & 
                       (~col("Descricao_Limpa").contains("noturna") & 
                        ~col("Descricao_Limpa").contains("fim de semana") &
                        ~col("Descricao_Limpa").contains("sábado") &
                        ~col("Descricao_Limpa").contains("domingo") &
                        ~col("Descricao_Limpa").contains("noturno")),
                       1
                   ).otherwise(0)) \
        .withColumn("Categoria_Agrupada",
                   when(col("Categoria").contains("Venda"), "Vendas")
                   .when(col("Categoria").contains("Prestação"), "Serviços")
                   .when(col("Categoria").contains("Aluguéis"), "Renda Aluguel")
                   .when(col("Categoria").contains("Despesa"), "Despesas Operacionais")
                   .when(col("Categoria").contains("Marketing"), "Marketing")
                   .when(col("Categoria").contains("Folha"), "Folha Pagamento")
                   .when(col("Categoria").contains("Fornecedor"), "Fornecedores")
                   .when(col("Categoria").contains("Conta"), "Contas Fixas")
                   .when(col("Categoria").contains("Multa"), "Multas/Juros")
                   .when(col("Categoria").contains("Investimento"), "Investimentos")
                   .otherwise("Outros")) \
        .withColumn("Meio_Pgto_Categoria",
                   when(col("Meio_Pgto").isin("PIX", "TED", "Débito Automático"), "Eletrônico")
                   .when(col("Meio_Pgto").isin("Boleto", "Cartão Crédito"), "Bancário")
                   .when(col("Meio_Pgto") == "Dinheiro", "Dinheiro")
                   .otherwise("Outros")) \
        .withColumn("Estabelecimento_Categoria",
                   when(col("Estabelecimento").contains("Cliente"), "Clientes")
                   .when(col("Estabelecimento").contains("Fornecedor"), "Fornecedores")
                   .when(col("Estabelecimento").contains("Empresa"), "Empresas Parceiras")
                   .when(col("Estabelecimento").contains("Banco"), "Instituições Financeiras")
                   .when(col("Estabelecimento").contains("RH"), "Recursos Humanos")
                   .when(col("Estabelecimento").contains("Agência"), "Agências")
                   .otherwise("Outros")) \
        .withColumn("data_processamento_silver", current_timestamp()) \
        .drop("Valor_RS_clean", "Valor_RS_decimal", "Descricao_Limpa")
    
    # SILVER - TRANSFORMAÇÕES PARA CONTAS
    df_accounts_silver = df_accounts \
        .filter(col("ID_Conta").isNotNull()) \
        .withColumn("Valor_Previsto_clean", 
                   regexp_replace(regexp_replace(col("Valor_Previsto_RS"), "\\.", ""), ",", ".")) \
        .withColumn("Valor_Previsto_decimal", 
                   when(col("Valor_Previsto_clean").rlike("^-?\\d+(\\.\\d+)?$"), 
                        col("Valor_Previsto_clean").cast("decimal(15,2)"))
                   .otherwise(lit(0))) \
        .withColumn("Data_Vencimento_formatada", 
                   to_date(col("Data_Vencimento"), "dd/MM/yyyy")) \
        .withColumn("Ano_Vencimento", year(col("Data_Vencimento_formatada"))) \
        .withColumn("Mes_Vencimento", month(col("Data_Vencimento_formatada"))) \
        .withColumn("AnoMes_Vencimento", date_format(col("Data_Vencimento_formatada"), "yyyy-MM")) \
        .withColumn("Dias_para_Vencimento", 
                   datediff(col("Data_Vencimento_formatada"), current_date())) \
        .withColumn("Status_Vencimento",
                   when(col("Status_Cobranca") == "Atrasado", "Atrasado")
                   .when(col("Dias_para_Vencimento") < 0, "Vencido")
                   .when(col("Dias_para_Vencimento").between(0, 7), "Vence em Breve")
                   .when(col("Dias_para_Vencimento").between(8, 30), "Vence no Mês")
                   .otherwise("Futuro")) \
        .withColumn("Dias_Atraso", 
                   when(col("Status_Cobranca") == "Atrasado",
                       datediff(current_date(), col("Data_Vencimento_formatada")))
                   .otherwise(lit(0))) \
        .withColumn("Categoria_Financeira_Agrupada",
                   when(col("Categoria_Financeira").contains("Venda"), "Receita Vendas")
                   .when(col("Categoria_Financeira").contains("Serviço"), "Receita Serviços")
                   .when(col("Categoria_Financeira").contains("Renda"), "Renda Extra")
                   .when(col("Categoria_Financeira").contains("Despesa"), "Despesas Operacionais")
                   .when(col("Categoria_Financeira").contains("Marketing"), "Marketing")
                   .when(col("Categoria_Financeira").contains("Folha"), "Folha Pagamento")
                   .when(col("Categoria_Financeira").contains("Fornecedor"), "Fornecedores")
                   .when(col("Categoria_Financeira").contains("Imposto"), "Impostos")
                   .otherwise("Outros")) \
        .withColumn("Tipo_Fluxo",
                   when(col("Tipo_Conta") == "Receber", "Entrada")
                   .when(col("Tipo_Conta") == "Pagar", "Saída")
                   .otherwise("Indefinido")) \
        .withColumn("Condicao_Pgto_Categoria",
                   when(col("Condicao_Pgto").contains("DDL"), "Prazo")
                   .when(col("Condicao_Pgto").contains("Mensal"), "Recorrente")
                   .when(col("Condicao_Pgto").contains("À Vista"), "À Vista")
                   .when(col("Condicao_Pgto").contains("x"), "Parcelado")
                   .otherwise("Outros")) \
        .withColumn("Parceiro_Categoria",
                   when(col("Parceiro").contains("Cliente"), "Clientes")
                   .when(col("Parceiro").contains("Fornecedor"), "Fornecedores")
                   .when(col("Parceiro").contains("Empresa"), "Empresas Parceiras")
                   .when(col("Parceiro").contains("RH"), "Recursos Humanos")
                   .when(col("Parceiro").contains("Governo"), "Governo")
                   .otherwise("Outros")) \
        .withColumn("data_processamento_silver", current_timestamp()) \
        .drop("Valor_Previsto_clean")
    
    return df_transactions_silver, df_accounts_silver

    # Processar e salvar dados Silver
    df_transactions_silver, df_accounts_silver = create_silver_layer()
    
    # Salvar como tabelas Delta Silver
    df_transactions_silver.write \
        .mode("overwrite") \
        .format("delta") \
        .option("delta.autoOptimize.optimizeWrite", "true") \
        .option("mergeSchema", "true") \
        .saveAsTable("silver.transacoes")
    
    df_accounts_silver.write \
        .mode("overwrite") \
        .format("delta") \
        .option("delta.autoOptimize.optimizeWrite", "true") \
        .option("mergeSchema", "true") \
        .saveAsTable("silver.contas")
    
    print("✅ Camada Silver criada com sucesso!")
    print(f"Transações Silver: {df_transactions_silver.count()} registros")
    print(f"Contas Silver: {df_accounts_silver.count()} registros")
    
    # Mostrar amostra dos dados Silver
    print("\n=== AMOSTRA TRANSAÇÕES SILVER ===")
    df_transactions_silver.select("ID_Transacao", "Data_formatada", "Hora", "Tipo", "Valor_RS_final", "Categoria_Agrupada", "Incoerencia_Horario").show(10)
    
    print("\n=== AMOSTRA CONTAS SILVER ===")
    df_accounts_silver.select("ID_Conta", "Tipo_Conta", "Data_Vencimento_formatada", "Status_Vencimento", "Dias_Atraso").show(10)
---
```
## 🥇 Camada Gold - Dados de Negócio

### Objetivo
Criar métricas agregadas e KPIs otimizados para análise business intelligence e dashboards.

### Agregações Principais
- **Métricas financeiras**: Receitas, despesas, margens
- **Indicadores operacionais**: Volume, ticket médio, frequência
- **KPIs de qualidade**: Taxas de incoerência, completude
- **Análises temporais**: Evolução mensal, sazonalidade
- **Rankings**: Top categorias, estabelecimentos

### Estrutura
- **Formato**: Delta Lake para performance
- **Tabelas**: Múltiplas tabelas especializadas
- **Esquema**: Otimizado para consultas analíticas

### Código Gold
```python


    # Camada Gold - Agregações e Métricas de Negócio
    from pyspark.sql.functions import col, current_timestamp, regexp_replace, when, lit, to_date, to_timestamp, year, month, dayofmonth, date_format, quarter, dayofweek, split, abs, lower, trim, count, countDistinct, sum, avg, min, max, datediff, first, concat, round, current_date
    from pyspark.sql.window import Window
    
    def create_gold_layer():
    
    # Ler dados da Silver
    df_transactions = spark.table("silver.transacoes")
    df_accounts = spark.table("silver.contas")
    
    print("=== PROCESSANDO CAMADA GOLD ===")
    
    # GOLD - RESUMO MENSAL FINANCEIRO
    gold_resumo_mensal = df_transactions \
        .groupBy("Ano", "Mes", "AnoMes") \
        .agg(
            # Métricas de Volume
            count("*").alias("total_transacoes"),
            countDistinct("Estabelecimento").alias("total_estabelecimentos"),
            countDistinct("Categoria").alias("total_categorias"),
            
            # Métricas Financeiras
            sum("Valor_RS_final").alias("saldo_liquido_mensal"),
            sum(when(col("Is_Entrada") == 1, col("Valor_RS_final")).otherwise(0)).alias("total_receitas"),
            sum(when(col("Is_Saida") == 1, col("Valor_RS_final")).otherwise(0)).alias("total_despesas"),
            sum("Valor_Absoluto").alias("volume_total"),
            
            # Métricas de Valor Médio
            avg(when(col("Is_Entrada") == 1, col("Valor_Absoluto")).otherwise(0)).alias("valor_medio_entrada"),
            avg(when(col("Is_Saida") == 1, col("Valor_Absoluto")).otherwise(0)).alias("valor_medio_saida"),
            avg("Valor_Absoluto").alias("valor_medio_transacao"),
            
            # Métricas de Incoerência
            sum("Incoerencia_Horario").alias("total_incoerencias_horario"),
            sum("Fora_Horario_Comercial").alias("total_fora_horario_comercial"),
            
            # Métricas Temporais
            count(when(col("Is_Fim_de_Semana") == 1, 1)).alias("transacoes_fim_semana"),
            count(when(col("Faixa_Horaria") == "Madrugada", 1)).alias("transacoes_madrugada")
        ) \
        .withColumn("percentual_incoerencias", 
                   round((col("total_incoerencias_horario") / col("total_transacoes")) * 100, 2)) \
        .withColumn("margem_liquida", 
                   round((col("saldo_liquido_mensal") / col("total_receitas")) * 100, 2)) \
        .withColumn("razao_despesas_receitas", 
                   round(abs(col("total_despesas")) / col("total_receitas"), 2)) \
        .withColumn("data_processamento_gold", current_timestamp())
    
    # GOLD - ANÁLISE POR CATEGORIA
    gold_analise_categoria = df_transactions \
        .groupBy("AnoMes", "Categoria_Agrupada", "Tipo") \
        .agg(
            count("*").alias("quantidade_transacoes"),
            sum("Valor_RS_final").alias("valor_liquido"),
            sum("Valor_Absoluto").alias("valor_absoluto"),
            avg("Valor_Absoluto").alias("valor_medio"),
            min("Valor_Absoluto").alias("valor_minimo"),
            max("Valor_Absoluto").alias("valor_maximo"),
            countDistinct("Estabelecimento").alias("estabelecimentos_unicos"),
            sum("Incoerencia_Horario").alias("incoerencias_horario")
        ) \
        .withColumn("participacao_percentual", 
                   round((col("valor_absoluto") / 
                         sum("valor_absoluto").over(Window.partitionBy("AnoMes", "Tipo"))) * 100, 2)) \
        .withColumn("data_processamento_gold", current_timestamp())
    
    # GOLD - ANÁLISE DE INCOERÊNCIAS DETALHADA
    gold_incoerencias_detalhada = df_transactions \
        .filter(col("Incoerencia_Horario") == 1) \
        .groupBy("AnoMes", "Estabelecimento", "Categoria_Agrupada", "Faixa_Horaria") \
        .agg(
            count("*").alias("quantidade_incoerencias"),
            sum("Valor_Absoluto").alias("valor_total_incoerente"),
            avg("Valor_Absoluto").alias("valor_medio_incoerente"),
            countDistinct("Data_formatada").alias("dias_com_incoerencias"),
            first("Meio_Pgto").alias("meio_pagamento_mais_comum")
        ) \
        .withColumn("gravidade_incoerencia",
                   when(col("quantidade_incoerencias") > 10, "Alta")
                   .when(col("quantidade_incoerencias") > 5, "Média")
                   .otherwise("Baixa")) \
        .withColumn("data_processamento_gold", current_timestamp())
    
    # GOLD - ANÁLISE DE FLUXO DE CAIXA
    gold_fluxo_caixa = df_transactions \
        .groupBy("AnoMes", "Meio_Pgto_Categoria", "Tipo") \
        .agg(
            count("*").alias("quantidade_transacoes"),
            sum("Valor_RS_final").alias("valor_liquido"),
            sum("Valor_Absoluto").alias("volume_total"),
            avg("Valor_Absoluto").alias("valor_medio"),
            countDistinct("Estabelecimento").alias("estabelecimentos_unicos")
        ) \
        .withColumn("participacao_meio_pagamento",
                   round((col("volume_total") / 
                         sum("volume_total").over(Window.partitionBy("AnoMes"))) * 100, 2)) \
        .withColumn("data_processamento_gold", current_timestamp())
    
    # GOLD - ANÁLISE DE CONTAS A PAGAR/RECEBER
    gold_contas_analise = df_accounts \
        .groupBy("AnoMes_Vencimento", "Categoria_Financeira_Agrupada", "Tipo_Fluxo", "Status_Vencimento") \
        .agg(
            count("*").alias("quantidade_contas"),
            sum("Valor_Previsto_decimal").alias("valor_total_previsto"),
            avg("Valor_Previsto_decimal").alias("valor_medio_previsto"),
            sum(when(col("Status_Cobranca") == "Pago", col("Valor_Previsto_decimal")).otherwise(0)).alias("valor_total_pago"),
            sum(when(col("Status_Cobranca").isin("Aberto", "Atrasado"), col("Valor_Previsto_decimal")).otherwise(0)).alias("valor_total_pendente"),
            avg("Dias_Atraso").alias("dias_atraso_medio"),
            countDistinct("Parceiro").alias("parceiros_unicos")
        ) \
        .withColumn("percentual_pago", 
                   round((col("valor_total_pago") / col("valor_total_previsto")) * 100, 2)) \
        .withColumn("data_processamento_gold", current_timestamp())
    
    # GOLD - ANÁLISE COMPORTAMENTAL POR HORÁRIO
    gold_analise_horaria = df_transactions \
        .groupBy("AnoMes", "Faixa_Horaria", "Is_Fim_de_Semana", "Tipo") \
        .agg(
            count("*").alias("quantidade_transacoes"),
            sum("Valor_RS_final").alias("valor_liquido"),
            sum("Valor_Absoluto").alias("volume_total"),
            avg("Valor_Absoluto").alias("valor_medio"),
            sum("Incoerencia_Horario").alias("incoerencias_detectadas"),
            countDistinct("Estabelecimento").alias("estabelecimentos_unicos")
        ) \
        .withColumn("taxa_incoerencia", 
                   round((col("incoerencias_detectadas") / col("quantidade_transacoes")) * 100, 2)) \
        .withColumn("data_processamento_gold", current_timestamp())
    
    return (gold_resumo_mensal, gold_analise_categoria, gold_incoerencias_detalhada,
            gold_fluxo_caixa, gold_contas_analise, gold_analise_horaria)

    # Processar e salvar dados Gold
    (gold_resumo_mensal, gold_analise_categoria, gold_incoerencias_detalhada,
     gold_fluxo_caixa, gold_contas_analise, gold_analise_horaria) = create_gold_layer()
    
    # Salvar todas as tabelas Gold
    gold_resumo_mensal.write.mode("overwrite").saveAsTable("gold.resumo_mensal_financeiro")
    gold_analise_categoria.write.mode("overwrite").saveAsTable("gold.analise_categoria")
    gold_incoerencias_detalhada.write.mode("overwrite").saveAsTable("gold.incoerencias_detalhada")
    gold_fluxo_caixa.write.mode("overwrite").saveAsTable("gold.fluxo_caixa_meios_pagamento")
    gold_contas_analise.write.mode("overwrite").saveAsTable("gold.contas_pagar_receber")
    gold_analise_horaria.write.mode("overwrite").saveAsTable("gold.analise_comportamental_horaria")
    
    print("✅ Camada Gold criada com sucesso!")
---

## Fluxo de Processamento

1. **Bronze**: Recebe dados crus → Armazena com metadados
2. **Silver**: Limpa e enriquece → Aplica regras de negócio  
3. **Gold**: Agrega e calcula KPIs → Prepara para análise

Cada camada adiciona valor progressivamente, transformando dados brutos em insights acionáveis para tomada de decisão.
