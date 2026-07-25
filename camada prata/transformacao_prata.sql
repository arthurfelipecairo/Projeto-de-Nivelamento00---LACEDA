-- 1. Apaga a tabela antiga caso ela já exista no banco
DROP TABLE IF EXISTS tb_funcionarios_prata;

-- 2. Recria tabela para correções 
CREATE TABLE tb_funcionarios_prata AS
WITH dados_limpos AS (
    SELECT 
        -- Identificador
        f.id_colaborador,

        -- Limpeza do Nome (Remove números residuais)
        TRIM(INITCAP(REGEXP_REPLACE(f.nome, '[0-9]', '', 'g'))) AS nome_colaborador,
        
        -- Padronização de Gênero (Corrige "Fem", "M", etc.)
        CASE 
            WHEN LOWER(TRIM(f.genero)) LIKE 'f%' THEN 'Feminino'
            WHEN LOWER(TRIM(f.genero)) LIKE 'm%' THEN 'Masculino'
            WHEN LOWER(TRIM(f.genero)) LIKE 'n%' THEN 'Não-binário'
            ELSE 'Não Informado'
        END AS genero,
        
        f.nivel,
        
        -- Tratamento de Datas
        CASE 
            WHEN f.data_admissao IS NULL OR f.data_admissao IN ('[null]', 'null', '') THEN NULL
            WHEN f.data_admissao LIKE '%/%' THEN TO_DATE(f.data_admissao, 'DD/MM/YYYY')
            WHEN f.data_admissao LIKE '%-%' THEN TO_DATE(f.data_admissao, 'YYYY-MM-DD')
            ELSE NULL
        END AS data_admissao,

        CASE 
            WHEN f.data_promocao IS NULL OR f.data_promocao IN ('[null]', 'null', '') THEN NULL
            WHEN f.data_promocao LIKE '%/%' THEN TO_DATE(f.data_promocao, 'DD/MM/YYYY')
            WHEN f.data_promocao LIKE '%-%' THEN TO_DATE(f.data_promocao, 'YYYY-MM-DD')
            ELSE NULL
        END AS data_promocao,

        CASE 
            WHEN f.data_promocao IS NULL OR f.data_promocao IN ('[null]', 'null', '') THEN 0 
            ELSE 1 
        END AS flg_foi_promovido,
        
        -- Limpeza Financeira
        CASE 
            WHEN f.salario_base LIKE '%R$%' OR f.salario_base LIKE '%,%' THEN
                CAST(REPLACE(REPLACE(REPLACE(REPLACE(f.salario_base, 'R$', ''), ' ', ''), '.', ''), ',', '.') AS NUMERIC)
            ELSE
                CAST(f.salario_base AS NUMERIC)
        END AS salario_base,
        
        -- Outras Variáveis
        CAST(f.horas_extras_mes AS SMALLINT) AS horas_extras_mes,
        COALESCE(f.score_satisfacao, 3.0) AS score_satisfacao, 
        CAST(f.percentual_bonus AS SMALLINT) AS percentual_bonus,
        
        -- Junções
        d.nome_departamento,
        TRIM(INITCAP(fi.cidade)) AS cidade_filial,
        UPPER(fi.estado)::CHAR(2) AS estado_filial,
        
        -- Variável Alvo
        TRIM(INITCAP(f.status_atual)) AS status_atual

    FROM raw_funcionarios f
    LEFT JOIN raw_departamentos d 
        ON f.id_departamento = d.id_departamento
    LEFT JOIN raw_filiais fi 
        ON f.id_filial = fi.id_filial
)
SELECT 
    *,
    -- Arredonda a remuneração para 2 casas decimais
    ROUND((salario_base + (salario_base * (percentual_bonus / 100.0))), 2) AS remuneracao_total_estimada
FROM dados_limpos;

SELECT * FROM tb_funcionarios_prata;
