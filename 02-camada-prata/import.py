import pandas as pd
from sqlalchemy import create_engine
import urllib.parse
import os
from dotenv import load_dotenv

# 1. Carrega as variáveis do arquivo .env que está na mesma pasta
load_dotenv()

# 2. Puxa as credenciais de forma invisível
usuario = os.getenv("USUARIO_BANCO")
senha = os.getenv("SENHA_BANCO")
banco = os.getenv("NOME_BANCO")

# Trava de segurança (evita aquele erro de "bytes" caso o .env falhe)
if senha is None:
    print("ERRO: O arquivo .env não foi encontrado ou a SENHA_BANCO está faltando!")
else:
    # 3. Mascara a senha para a URL (caso tenha caracteres especiais)
    senha_segura = urllib.parse.quote_plus(senha)

    # 4. Montando a string correta usando as variáveis dinâmicas
    url_banco = f"postgresql://{usuario}:{senha_segura}@localhost:5432/{banco}"

    # 5. Criando o motor de conexão
    engine = create_engine(url_banco)

    # Lendo os CSVs originais
    df_func = pd.read_csv('01-camada-bronze/funcionarios.csv')
    df_depto = pd.read_csv('01-camada-bronze/departamentos.csv')
    df_filial = pd.read_csv('01-camada-bronze/filiais.csv')

    # Subindo para o PostgreSQL como tabelas "raw" (brutas)
    df_func.to_sql('raw_funcionarios', engine, if_exists='replace', index=False)
    df_depto.to_sql('raw_departamentos', engine, if_exists='replace', index=False)
    df_filial.to_sql('raw_filiais', engine, if_exists='replace', index=False)

    print("01-camada-bronze carregada no PostgreSQL")