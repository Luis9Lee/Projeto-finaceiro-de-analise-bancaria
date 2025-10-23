# Documentação do Projeto de Business Intelligence (Power BI)

## 1. Objetivo da Análise

O projeto visa fornecer uma visão completa e comparativa do **Fluxo de Caixa**, confrontando o **Valor Planejado** (projeções) com o **Valor Realizado** (transações efetivas). O objetivo é medir a precisão do *forecasting* financeiro e identificar rapidamente as maiores variações por categoria ou período.

---

## 2. Modelagem de Dados no Power BI (Esquema Estrela)

O modelo foi desenhado para maximizar a performance analítica e a facilidade de uso, seguindo o padrão de Esquema Estrela, que separa fatos (valores) de dimensões (contexto).

* **Tabela Fato Central:** Contém todas as transações, unindo dados de planejamento e realização. É a única tabela que possui as medidas de valor, como `valor_net`, e as flags booleanas (`is_planejado`, `is_realizado`) para controle das métricas.
* **Dimensão Tempo:** Conectada à Tabela Fato pela coluna de data. Permite a filtragem e a visualização correta da tendência por ano, mês ou dia, garantindo a ordem cronológica correta dos dados.
* **Dimensão Conta:** Conectada à Tabela Fato pelo ID da conta. Usada para classificar e filtrar o fluxo de caixa por atributos descritivos, como a **Categoria Financeira** e o **Tipo de Conta** (Pagar/Receber).

---

## 3. Medidas Chave (DAX - Data Analysis Expressions)

As métricas calculadas em DAX transformam os dados modelados em Indicadores-Chave de Desempenho (KPIs).

| Medida DAX | Função Analítica | Código |
| :--- | :--- | :--- |
| **Valor Líquido Total** | A medida base do modelo. Agrega o valor total de todas as transações, sendo Planejado ou Realizado. Serve como o ponto de partida para todos os outros cálculos. | `SUM('gold_ft_fluxo_caixa'[valor_net])` |
| **Total Planejado** | Filtra o `Valor Líquido Total` para incluir apenas os registros definidos como planejamento. Usado para definir a *baseline*. | `CALCULATE([Valor Líquido Total], 'gold_ft_fluxo_caixa'[is_planejado] = TRUE())` |
| **Total Realizado** | Filtra o `Valor Líquido Total` para incluir apenas as transações que realmente ocorreram. | `CALCULATE([Valor Líquido Total], 'gold_ft_fluxo_caixa'[is_realizado] = TRUE())` |

---

## 4. Análise e Visualização (Gráficos e Componentes)

O dashboard é composto por elementos que fornecem uma visão hierárquica do desempenho financeiro.

### A. Cartões KPI (Cards)

* **Função:** Proporcionar uma visão imediata e consolidada dos valores mais importantes.
* **Uso:** Exibem o **Total Planejado** e o **Total Realizado** como números absolutos no topo do relatório, permitindo a comparação instantânea para o período selecionado.

### B. Gráfico de Tendência (Gráfico de Linhas)

* **Função:** Mostrar a evolução e a performance da previsão ao longo do tempo.
* **Análise:** Compara duas séries de dados (uma linha para o Planejado e outra para o Realizado) no eixo do tempo (Mês/Ano). Isso revela se o Realizado está constantemente superando ou ficando aquém do Planejado, destacando meses de maior desvio ou sazonalidade.

### C. Gráfico de Distribuição (Barras/Colunas)

* **Função:** Detalhar a composição dos valores por categorias contextuais.
* **Análise:** Geralmente exibe o valor total (Realizado ou Líquido) segmentado por **Categoria Financeira** (ex: Aluguel, Salários, Vendas). Isso ajuda a identificar os maiores *drivers* de custo ou receita e focar a investigação em áreas específicas.

### D. Segmentadores de Dados (Filtros Interativos)

* **Função:** Oferecer interatividade ao usuário para focar a análise.
* **Uso:** Permitem que o usuário filtre o dashboard inteiro por dimensões cruciais, como **Ano**, **Mês**, **Categoria Financeira** ou **Tipo de Conta** (Receber/Pagar), isolando rapidamente o contexto de interesse.


<img width="891" height="500" alt="dashboard finaceiro BI" src="https://github.com/user-attachments/assets/3d220f92-1c45-472e-a027-b11124cab0c0" />

