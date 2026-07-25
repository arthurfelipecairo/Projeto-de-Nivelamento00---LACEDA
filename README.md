
#  Projeto de Nivelamento LACEDA 2026 - Eixo de Ciência e Engenharia de Dados

Repositório do desafio de análise de evasão de colaboradores (Turnover) de um grande escritório de advocacia, aplicando conceitos de **Engenharia de Dados (Arquitetura Medalhão)** e **People Analytics**.

---

##  Arquitetura de Dados (Medallion Architecture)

O pipeline do projeto foi estruturado em três camadas bem definidas:

1. **🥉 Camada Bronze (`camada bronze/`):** Ingestão dos arquivos brutos originais (`funcionarios.csv`, `departamentos.csv`, `filiais.csv`) sem modificações estruturais.
2. **🥈 Camada Prata (`transformacao_prata.sql`):** Tratamento de valores nulos, padronização de textos e gênero, conversão de tipos monetários e de datas, além da criação de colunas derivadas (`flag_desligado`, `tempo_casa_anos`). Persistido em banco relacional PostgreSQL.
3. **🥇 Camada Ouro (`transformacao_ouro.sql`):** Tabelas agregadas de negócio prontas para visualização analítica, relatórios gerenciais e tomada de decisão estratégica.

---

##  Principais Insights da Análise Exploratória (EDA)

Através do Jupyter Notebook (`data_view.ipynb`), identificamos que o Turnover não ocorre de forma aleatória, sendo ditado por três pilares críticos:

* **Esgotamento (Burnout):** Correlação direta e clara entre o volume excessivo de horas extras e os pedidos de demissão.
* **Estagnação de Carreira:** Pico de evasão concentrado em profissionais de nível Pleno, situados entre o 4º e o 8º ano de casa sem histórico de promoção.
* **Gargalo Regional:** Alerta vermelho na filial do Rio de Janeiro, com destaque negativo para o departamento Trabalhista (taxa de evasão superior a 50%).

---

##  Como Executar o Projeto em sua Máquina

Siga os passos abaixo para rodar o pipeline completo em ambiente local:

### 1. Clone o repositório
```bash
git clone <url-do-seu-fork>
cd <nome-da-pasta>


```
### 2. Configure o ambiente seguro (`.env`)

Crie um arquivo chamado `.env` na raiz do diretório contendo as suas credenciais locais do PostgreSQL:

```
USUARIO_BANCO=postgres
SENHA_BANCO=sua_senha
NOME_BANCO=laceda_db

```

### 3. Execute a ingestão (Bronze para o Banco)

Execute o script em Python para ler os arquivos CSV brutos e carregá-los para o banco relacional:

```bash
python import.py

```

### 4. Execute as transformações SQL (Camada Prata e Ouro)

Rode os scripts de transformação (`transformacao_prata.sql` e `transformacao_ouro.sql`) no seu SGBD de preferência (pgAdmin ou DBeaver) para gerar as tabelas tratadas e agregadas.

### 5. Abra o Dashboard Analítico

Inicie o Jupyter Notebook e abra o arquivo `data_view.ipynb` para visualizar os gráficos estatísticos e as conclusões executivas:

```bash
jupyter notebook data_view.ipynb

```

---

## Conclusão e Recomendações Executivas

Com base nos dados explorados, propõe-se o seguinte plano de ação para a diretoria e o RH do escritório:

* **Intervenção Imediata:** Auditoria e reestruturação na liderança e na distribuição de processos do setor Trabalhista na filial do Rio de Janeiro.
* **Prevenção de Burnout:** Estabelecimento de um teto preventivo para a quantidade de horas extras mensais permitidas por colaborador.
* **Plano de Retenção:** Criação de ciclos estruturados de revisão de carreira para reter profissionais plenos antes do "ponto de quebra" de tempo de casa.

