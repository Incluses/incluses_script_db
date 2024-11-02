## Análise Exploratória de Dados

## 1. Análise de Desligamento de Funcionários

### Objetivo da Análise
O principal objetivo desta análise é identificar e entender os fatores que levam os funcionários a deixarem a empresa. Através de dados como idade, satisfação no trabalho e outros fatores, podemos propor medidas para reduzir a rotatividade.

### Descrição da Base de Dados
A base de dados utilizada contém as seguintes colunas:

- **Age**: Idade do funcionário.
- **Attrition**: Indica se o funcionário deixou a empresa (Yes) ou não (No).
- **Department**: Departamento em que o funcionário trabalha (Vendas, Pesquisa e Desenvolvimento, etc.).
- **DistanceFromHome**: Distância, em milhas, da casa do funcionário até o trabalho.
- **Education**: Nível de educação do funcionário (1 = Ensino Médio, 2 = Graduação, etc.).
- **EducationField**: Campo de estudo em que o funcionário se formou.
- **EnvironmentSatisfaction**: Grau de satisfação com o ambiente de trabalho (1 = Baixa, 4 = Alta).
- **JobSatisfaction**: Nível de satisfação com o trabalho (1 = Baixa, 4 = Alta).
- **MaritalStatus**: Estado civil do funcionário.
- **MonthlyIncome**: Renda mensal do funcionário.
- **NumCompaniesWorked**: Número de empresas em que o funcionário trabalhou anteriormente.
- **WorkLifeBalance**: Equilíbrio entre vida pessoal e trabalho (1 = Pobre, 4 = Excelente).
- **YearsAtCompany**: Anos que o funcionário trabalhou na empresa.

### Análise
#### 1. Matriz de Correlação
Observou-se que:
- Há correlação entre idade e renda mensal, onde funcionários mais velhos geralmente ganham mais.
- Funcionários casados tendem a buscar estabilidade, o que pode impactar a rotatividade.
- A pressão nos departamentos de vendas pode levar a uma maior rotatividade.

#### 2. Distância do Trabalho
Embora longas distâncias possam gerar cansaço, não se observou uma correlação significativa com desligamentos, uma vez que a maioria dos funcionários mora perto do trabalho.

#### 3. Análise por Departamento
- O departamento de Pesquisa e Desenvolvimento apresenta alta rotatividade, embora tenha bons índices de satisfação.
- Satisfação no trabalho e no ambiente não são os principais fatores que levam ao desligamento.

#### 4. Educação e Salário
Funcionários mais educados têm expectativas de valorização. Departamentos que não atendem essas expectativas podem ter maior rotatividade.

### Conclusão
A análise revelou que a idade e a experiência estão correlacionadas à permanência, enquanto a insatisfação com a remuneração e a pressão de trabalho são fatores relevantes. O deslocamento não é um fator determinante.

## 2. Análise do formulario do app Incluses

### Objetivo
O objetivo deste projeto é realizar uma análise exploratória da base de dados obtida através do formulário Incluses, com foco na população LGBTQIA+. O projeto envolve a limpeza e tratamento dos dados, bem como a geração de insights relevantes a partir das informações coletadas.

### Datasets
- `Incluses.xlsx`: Contém as respostas dos participantes do formulário.

### Conteúdo do Notebook
O notebook realiza as seguintes etapas:

1. **Imports**: Importação das bibliotecas necessárias.
2. **Leitura da Planilha**: Carregamento dos dados do arquivo `Incluses.xlsx`.
3. **Correções da Base**: Ajustes nos valores de colunas específicas para garantir a consistência dos dados.
   - Correções na coluna 'Gênero'
   - Correções na coluna 'Nível de Escolaridade'
   - Correções na coluna 'Preferência por Cursos'
   - Correções na coluna 'Qual é a sua situação diante ao mercado de trabalho?'
   - Inclusão de uma pergunta sobre a comunidade LGBTQIA+.
4. **Remoção de Colunas**: Exclusão de colunas que não serão utilizadas na análise.
5. **Renomeação de Colunas**: Renomeação das colunas para facilitar o uso nas análises.
6. **Filtragem de Dados**: Filtragem para manter apenas as respostas "Sim" para a participação na comunidade LGBTQIA+.
7. **Descrição do DataFrame**: Análise inicial do DataFrame utilizando `.describe()`.
8. **Pré-processamento de Dados**: Transformação de colunas categóricas em numéricas utilizando `ColumnTransformer`.
9. **Análise de Correlação**: Geração de um gráfico de correlação para visualizar relações entre variáveis.
10. **Análise de Relações Específicas**:
    - Relação entre 'Faixa Etária' e 'Situação no Mercado de Trabalho'.
    - Relação entre 'Faixa Etária' e 'Escolaridade'.
    - Relação entre 'Identidade de Gênero' e 'Escolaridade'.
    - Relação entre 'Usa Redes Sociais?' e 'Escolaridade'.
11. **Relatório de Perfil**: Geração de um relatório detalhado sobre o DataFrame utilizando a biblioteca `ydata_profiling`.
12. **Exportação dos Dados Tratados**: Geração do arquivo `incluses_tratado.xlsx` com os dados tratados.

### Detalhes da Análise
### 1. Correções na Base
- **Gênero**: Os valores foram padronizados para refletir as categorias corretas.
- **Nível de Escolaridade**: Ajustes para agrupar níveis equivalentes.
- **Preferência por Cursos**: Correção de terminologias.
- **Situação no Mercado de Trabalho**: Uniformização das descrições.

### 2. Filtragem de Dados
A análise focou em participantes que se identificam como parte da comunidade LGBTQIA+.

### 3. Análise de Correlação
Utilizamos um heatmap para visualizar a matriz de correlação, permitindo identificar relações entre diferentes variáveis da pesquisa.

### 4. Relatório de Perfil
Um relatório abrangente foi gerado, fornecendo estatísticas descritivas e insights visuais sobre a base de dados, facilitando a interpretação dos resultados.

### Resultados e Conclusões
Os resultados da análise proporcionaram uma visão clara sobre as características e desafios enfrentados pela comunidade LGBTQIA+ em relação ao mercado de trabalho, escolaridade e uso de redes sociais.

### Exportação de Dados
Os dados tratados foram salvos no arquivo `incluses_tratado.xlsx` para ser usado em modelo de classificação do usuario.

### Tecnologias Utilizadas
- Python
- Pandas
- Matplotlib
- Seaborn
- Scikit-learn
- ydata_profiling


### Feito por

[Luca Almeida Lucareli](https://github.com/LucaLucareli)

[Olivia Farias Domingues](https://github.com/oliviaworks)
