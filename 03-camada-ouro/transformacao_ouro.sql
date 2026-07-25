DROP TABLE IF EXISTS tb_kpi_rh_ouro;

CREATE TABLE tb_kpi_rh_ouro AS
SELECT 
    nome_departamento,
    cidade_filial,
    nivel,
    COUNT(id_colaborador) AS total_colaboradores,
    SUM(flg_foi_promovido) AS total_promovidos, 
    SUM(CASE WHEN status_atual = 'Desligado' THEN 1 ELSE 0 END) AS total_desligados,
    
    ROUND(CAST(SUM(CASE WHEN status_atual = 'Desligado' THEN 1 ELSE 0 END) AS NUMERIC) / COUNT(id_colaborador) * 100, 2) AS taxa_evasao_percentual,
    ROUND(CAST(AVG(horas_extras_mes) AS NUMERIC), 1) AS media_horas_extras,
    ROUND(CAST(AVG(score_satisfacao) AS NUMERIC), 2) AS media_score_satisfacao,
    ROUND(CAST(AVG(salario_base) AS NUMERIC), 2) AS media_salario_base
FROM tb_funcionarios_prata
GROUP BY nome_departamento, cidade_filial, nivel;

SELECT * FROM tb_kpi_rh_ouro;
