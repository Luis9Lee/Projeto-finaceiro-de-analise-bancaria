# Dashboard de Análise Financeira - Estrutura e Funcionalidades

## Visão Geral do Dashboard

O dashboard no Databricks SQL é composto por **8 widgets principais** organizados em um layout estratégico que permite análise financeira completa e monitoramento em tempo real.

## Componentes do Dashboard

### 1. KPIs Principais (Big Numbers)
**O que é**: 8 indicadores-chave de performance financeira
**Funcionalidade**: 
- Total de Transações: Volume total de operações
- Receitas Totais: Soma de todas as entradas financeiras
- Despesas Totais: Soma de todas as saídas financeiras  
- Saldo Líquido: Diferença entre receitas e despesas
- Margem Líquida: Percentual de lucro sobre receitas
- Incoerências Detectadas: Transações fora do padrão
- Taxa de Incoerência: Percentual de transações suspeitas
- Ticket Médio: Valor médio por transação

### 2. Evolução Mensal (Gráfico de Linha)
**O que é**: Análise temporal das receitas e despesas
**Funcionalidade**:
- Mostra tendências mensais
- Compara receitas vs despesas ao longo do tempo
- Identifica sazonalidades e padrões

### 3. Saldo Mensal (Gráfico de Barras)
**O que é**: Visualização do resultado financeiro por mês
**Funcionalidade**:
- Barras verdes para meses positivos
- Barras vermelhas para meses negativos
- Análise rápida da saúde financeira mensal

### 4. Top Categorias (Barras Horizontais)
**O que é**: Ranking das categorias com maior volume financeiro
**Funcionalidade**:
- Ordena categorias por volume total
- Separa entradas (azul) e saídas (laranja)
- Identifica principais fontes de receita e despesa

### 5. Alertas de Incoerências (Tabela)
**O que é**: Sistema de detecção de transações suspeitas
**Funcionalidade**:
- Lista estabelecimentos com transações fora do horário comercial
- Classifica por gravidade (Crítico, Alto, Moderado)
- Mostra taxa de incoerência por estabelecimento

### 6. Meios de Pagamento (Gráfico de Pizza)
**O que é**: Distribuição dos canais de pagamento utilizados
**Funcionalidade**:
- Mostra participação percentual de cada meio
- Identifica preferências de pagamento
- Auxilia na estratégia de canais

### 7. Análise Horária (Gráfico de Barras Agrupadas)
**O que é**: Comportamento das transações por faixa horária
**Funcionalidade**:
- Madrugada, Manhã, Tarde, Noite
- Compara volume de entradas vs saídas por período
- Identifica picos de atividade

### 8. Contas em Atraso (Barras Empilhadas)
**O que é**: Situação de contas a pagar e receber
**Funcionalidade**:
- Mostra valor total por status (Atrasado, Vencido, Vence em Breve)
- Separa contas a pagar vs a receber
- Auxilia na gestão de fluxo de caixa

## Como Funciona o Dashboard

### Filtros Globais
- **Período**: Filtra todos os widgets por data
- **Tipo de Transação**: Foca em Entradas, Saídas ou ambas
- **Categoria**: Filtra por categoria específica

### Interatividade
- Todos os widgets respondem aos filtros aplicados
- Atualização automática a cada 15 minutos
- Layout responsivo que se adapta ao tamanho da tela

### Navegação
- **Visualização Hierárquica**: Do macro (KPIs) para o micro (detalhes)
- **Análise Drill-down**: Do resultado final para as causas
- **Monitoramento Contínuo**: Detecção proativa de problemas

## Propósito de Cada Seção

**Linha 1 (KPIs)**: Visão executiva rápida-
**Linha 2 (Gráficos Temporais)**: Análise de tendências - 
**Linha 3 (Categorias)**: Composição da receita/despesa-
**Linha 4 (Monitoramento)**: Gestão de riscos e anomalias-
**Linha 5 (Situação)**: Saúde financeira operacional

O dashboard fornece uma visão completa do negócio, desde indicadores de alto nível até detalhes operacionais, permitindo tomada de decisão baseada em dados em tempo real.


<img width="1335" height="347" alt="image" src="https://github.com/user-attachments/assets/05bedc4d-d463-4f4a-af2a-732467fcc109" />
<img width="1329" height="251" alt="image" src="https://github.com/user-attachments/assets/c3da1a6d-7ed1-4358-8b1a-aefb6d38ca4e" />
<img width="1332" height="257" alt="image" src="https://github.com/user-attachments/assets/5c2df6f1-8464-4849-92a6-8c9c8993733c" />
<img width="1323" height="253" alt="image" src="https://github.com/user-attachments/assets/09ab8c11-e351-4f93-8bc9-f69b05b5aa8b" />


[Dashboard Financeiro Databricks.pdf](https://github.com/user-attachments/files/23109678/Dashboard.Financeiro.Databricks.pdf)

