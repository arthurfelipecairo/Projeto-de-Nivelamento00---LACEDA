
# Pipeline de People Analytics — Análise de Turnover

Projeto desenvolvido a partir do desafio de nivelamento de 2026 do **LACEDA — Grupo de Estudos em Engenharia e Ciência de Dados**. O objetivo é estruturar um pipeline de dados para analisar a evasão de colaboradores (*turnover*) de um escritório de advocacia, aplicando conceitos de Engenharia de Dados e People Analytics.

## Tecnologias

- Python, Pandas e SQLAlchemy
- PostgreSQL
- SQL
- Jupyter Notebook

## Arquitetura de dados

O pipeline segue a Arquitetura Medalhão, separando os dados por nível de tratamento:

1. **Bronze — `01-camada-bronze/`**: arquivos CSV brutos de colaboradores, departamentos e filiais.
2. **Prata — `02-camada-prata/`**: ingestão dos dados no PostgreSQL e limpeza, padronização e integração das fontes.
3. **Ouro — `03-camada-ouro/`**: criação de uma tabela de indicadores para análise de turnover.

```text
CSVs brutos → PostgreSQL (tabelas raw) → camada prata → KPIs na camada ouro → análise exploratória
```

### Camada Bronze

Os arquivos `funcionarios.csv`, `departamentos.csv` e `filiais.csv` são mantidos como fonte bruta em `01-camada-bronze/`.

### Camada Prata

O script `02-camada-prata/import.py` carrega os arquivos CSV em tabelas brutas no PostgreSQL. Em seguida, `02-camada-prata/transformacao_prata.sql` realiza os seguintes tratamentos:

- padronização de nomes, gênero, departamentos e cidades;
- conversão de datas e valores monetários;
- tratamento de valores ausentes em satisfação;
- integração de colaboradores, departamentos e filiais;
- criação de indicadores como promoção e remuneração total estimada.

### Camada Ouro

O script `03-camada-ouro/transformacao_ouro.sql` cria a tabela `tb_kpi_rh_ouro`, com indicadores agregados por departamento, cidade e nível:

- total de colaboradores, promovidos e desligados;
- taxa de evasão;
- média de horas extras;
- média de satisfação;
- média salarial.

## Como executar localmente

### 1. Clone o repositório

```bash
git clone <URL_DO_REPOSITORIO>
cd <NOME_DO_REPOSITORIO>
```

### 2. Instale as dependências

```bash
pip install pandas sqlalchemy psycopg2-binary python-dotenv jupyter
```

### 3. Configure o banco de dados

Crie um arquivo `.env` na raiz do repositório com as credenciais do PostgreSQL local:

```env
USUARIO_BANCO=postgres
SENHA_BANCO=sua_senha
NOME_BANCO=laceda_db
```

### 4. Carregue a camada Bronze no PostgreSQL

Na raiz do repositório, execute:

```bash
python 02-camada-prata/import.py
```

O script cria ou substitui as tabelas `raw_funcionarios`, `raw_departamentos` e `raw_filiais`.

### 5. Execute as transformações SQL

No pgAdmin, DBeaver ou outro cliente PostgreSQL, execute nesta ordem:

1. `02-camada-prata/transformacao_prata.sql`
2. `03-camada-ouro/transformacao_ouro.sql`

### 6. Explore os dados

Abra `02-camada-prata/data_view.ipynb` no Jupyter Notebook:

```bash
jupyter notebook 02-camada-prata/data_view.ipynb
```

## Resultados da análise

A análise exploratória investiga padrões de turnover associados a horas extras, progressão de carreira, nível profissional, departamento e filial. Os indicadores da camada ouro apoiam a identificação de grupos prioritários para ações de retenção.

## Origem

Este repositório é um fork e uma implementação do projeto de nivelamento do LACEDA. As transformações, documentação e análises presentes neste repositório representam a evolução realizada neste fork.

