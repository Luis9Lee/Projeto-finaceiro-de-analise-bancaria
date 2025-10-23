# 📊 Sistema de Análise Financeira - Realizado vs. Planejado

## 🎯 Sobre o Projeto

Este projeto oferece **duas implementações complementares** de um sistema completo de análise financeira, permitindo comparar o **Fluxo de Caixa Realizado** com o **Fluxo de Caixa Planejado**. 

### 🚀 Para que serve este sistema?

Imagine que sua empresa faz projeções financeiras mensais - estima quanto vai entrar e sair de dinheiro. Este sistema responde a perguntas críticas como:

- **"Nossas projeções estão sendo precisas?"**
- **"Onde estamos gastando mais do que planejamos?"** 
- **"Quais categorias têm os maiores desvios orçamentários?"**
- **"Como evolui nossa capacidade de prever o fluxo de caixa?"**

## 💡 Duas Abordagens, Um Objetivo

### 1. 🐍 Versão PySpark (Databricks)
**Ideal para:** Empresas com grandes volumes de dados e necessidade de processamento escalável

**O que oferece:**
- Processamento de milhares de transações em segundos
- Detecção automática de transações fora do padrão
- Análise comportamental por horário e dia da semana
- Dashboards interativos com filtros em tempo real

**Casos de uso:**
- Empresas com mais de 10.000 transações mensais
- Necessidade de detectar fraudes ou incoerências
- Análise de padrões de comportamento dos clientes

### 2. 🗃️ Versão SQL (PostgreSQL + Power BI)
**Ideal para:** Empresas que já utilizam Power BI e preferem soluções SQL tradicionais

**O que oferece:**
- Integração direta com ferramentas Microsoft
- Modelo dimensional consolidado (Esquema Estrela)
- Fácil manutenção por equipes de BI
- Relatórios corporativos padronizados

**Casos de uso:**
- Empresas com infraestrutura Microsoft consolidada
- Equipes habituadas com SQL e Power BI
- Necessidade de relatórios executivos padronizados

## 🎪 Como as Versões se Complementam

| Cenário | Solução Recomendada | Benefício |
|---------|---------------------|-----------|
| **Análise Executiva** | SQL + Power BI | Relatórios padronizados para diretoria |
| **Detecção de Anomalias** | PySpark | Identifica transações suspeitas automaticamente |
| **Processamento em Lote** | PySpark | Lida com grandes volumes eficientemente |
| **Integração Microsoft** | SQL + Power BI | Conecta com Excel, SharePoint, Teams |
| **Análise em Tempo Real** | PySpark | Dashboards que atualizam automaticamente |

## 📈 Benefícios para o Negócio

### Para o Controller Financeiro:
- **Visibilidade completa** do desempenho das projeções
- **Alertas proativos** sobre desvios orçamentários
- **Base factual** para ajustes no planejamento
- **Redução de surpresas** no fluxo de caixa

### Para o Diretor Financeiro:
- **Dashboard executivo** com os principais indicadores
- **Análise de tendências** da precisão do forecasting
- **Identificação de categorias** problemáticas
- **Suporte à tomada de decisão** estratégica

### Para a Equipe de BI:
- **Modelo consolidado** pronto para análise
- **Flexibilidade** de escolher a abordagem técnica
- **Documentação completa** de ambos os approaches
- **Escalabilidade** para crescer com a empresa

## 🎯 Quem deve usar este sistema?

- **Startups em crescimento** que precisam de previsibilidade financeira
- **Empresas estabelecidas** que querem melhorar seu forecasting
- **Equipes financeiras** que gastam muito tempo consolidando planilhas
- **Gestores** que precisam de visibilidade sobre o desempenho orçamentário

## 💼 Casos de Sucesso Esperados

Uma empresa que implemente este sistema pode esperar:

- **Redução de 30%** no tempo de consolidação de relatórios
- **Melhoria de 25%** na precisão das projeções financeiras
- **Identificação rápida** de categorias com desvios superiores a 15%
- **Decisões mais assertivas** sobre cortes de custos e investimentos

---

