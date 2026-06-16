
USE TesteBernoulli;
GO

-- engajamento_jornada --------------------------------------------

SELECT TOP 50 *
FROM bronze.engajamento_jornada;

DROP TABLE IF EXISTS silver.engajamento_jornada;
CREATE TABLE silver.engajamento_jornada (
	id_lead INT PRIMARY KEY,
	emails_enviados INT,
	emails_abertos INT,
	cliques_email INT,
	interagiu_whatsapp VARCHAR(10),
	participou_evento VARCHAR(10),
	acessou_conteudo VARCHAR(10),
	materiais_baixados INT,
	visitas_site INT,
	data_ultima_interacao DATE
	);

INSERT INTO silver.engajamento_jornada (
	id_lead,
	emails_enviados,
	emails_abertos,
	cliques_email,
	interagiu_whatsapp,
	participou_evento,
	acessou_conteudo,
	materiais_baixados,
	visitas_site,
	data_ultima_interacao
)
SELECT
	TRY_CAST(id_lead AS INT),
	TRY_CAST(emails_enviados AS INT),
	TRY_CAST(emails_abertos AS INT),
	TRY_CAST(cliques_email AS INT),
	COALESCE(interagiu_whatsapp, 'Sem dados'), -- se for nulo, coloca como Sem dados
	COALESCE(participou_evento, 'Sem dados'), -- se for nulo, coloca como Sem dados
	COALESCE(acessou_conteudo, 'Sem dados'), -- se for nulo, coloca como Sem dados
	TRY_CAST(materiais_baixados AS INT),
	TRY_CAST(visitas_site AS INT),
	TRY_CONVERT(DATE, data_ultima_interacao, 103) -- arrumando datas vindas como string, para o formato BR com o 103
FROM bronze.engajamento_jornada;

SELECT TOP 50 *
FROM silver.engajamento_jornada;


-- eventos_acoes --------------------------------------------


SELECT TOP 50 *
FROM bronze.eventos_acoes

DROP TABLE IF EXISTS silver.eventos_acoes;
CREATE TABLE silver.eventos_acoes (
	id_evento VARCHAR(10) PRIMARY KEY,
	data_evento DATE,
	nome_evento VARCHAR(100),
	unidade VARCHAR(50),
	serie_curso_foco VARCHAR(50),
	inscritos INT,
	presentes INT,
	leads_gerados INT,
	matriculas_pos_evento INT,
	investimento_estimado DECIMAL(19,2),
	local VARCHAR(50)
)
INSERT INTO silver.eventos_acoes (
	id_evento,
	data_evento,
	nome_evento,
	unidade,
	serie_curso_foco,
	inscritos,
	presentes,
	leads_gerados,
	matriculas_pos_evento,
	investimento_estimado,
	local
)
SELECT
	TRY_CAST(id_evento AS VARCHAR),
	TRY_CONVERT(DATE, data_evento, 103),
	COALESCE(nome_evento, 'Sem dados'),
	COALESCE(unidade, 'Sem dados'),
	COALESCE(serie_curso_foco, 'Sem dados'),
	TRY_CAST(inscritos AS INT),
	TRY_CAST(presentes AS INT),
	TRY_CAST(leads_gerados AS INT),
	TRY_CAST(matriculas_pos_evento AS INT),
	TRY_CAST(investimento_estimado AS DECIMAL(19,2)),
	COALESCE(local, 'Sem dados')
FROM bronze.eventos_acoes;

SELECT *
FROM silver.eventos_acoes;



-- leads_interessados --------------------------------------------
/*
SELECT
	COUNT(*) AS total_leads,
	COUNT(origem) AS origemdolead,
	COUNT(*) - COUNT(origem) AS origem_faltando,
	ROUND(100.0 * (COUNT(*) - COUNT(origem)) / COUNT(*), 2)
	AS pct_faltando_origem,
	COUNT(idade_responsavel) AS total_idade_responsavel,
	COUNT(*) - COUNT(idade_responsavel) as idade_responsavel_faltando,
	ROUND(100.0 * (COUNT(*) - COUNT(idade_responsavel)) / COUNT(*), 2)
	AS pct_faltando_idade_responsavel,
	COUNT(faixa_renda) AS total_faixa_renda,
	COUNT(*) - COUNT(faixa_renda) AS faixa_renda_faltando,
	ROUND(100.0 * (COUNT(*) - COUNT(faixa_renda)) / COUNT(*), 2)
	AS pct_faixa_renda_faltando
FROM bronze.leads_interessados;

*/

SELECT TOP 50 *
FROM bronze.leads_interessados;


DROP TABLE IF EXISTS silver.leads_interessados;
CREATE TABLE silver.leads_interessados (
	id_lead INT PRIMARY KEY,
	data_entrada DATE,
	unidade_interesse VARCHAR(50),
	serie_curso_interesse VARCHAR(50),
	origem VARCHAR(50),
	status_atual VARCHAR(50),
	matricula VARCHAR(10),
	idade_responsavel INT,
	faixa_renda VARCHAR(30)
	);

WITH remove_dup AS (
	SELECT
		TRY_CAST(id_lead AS INT) AS id_lead,
		TRY_CONVERT(DATE, data_entrada, 103) AS data_entrada,
		COALESCE(unidade_interesse, 'Sem dados') AS unidade_interesse,
		COALESCE(serie_curso_interesse, 'Sem dados') AS serie_curso_interesse,
		COALESCE(CASE 
				WHEN LOWER(origem) IN ('site', 'website') THEN 'Site'
				WHEN LOWER(origem) IN ('evento', 'eventos', 'Evento') THEN 'Evento'
				WHEN LOWER(origem) IN ('whatsapp', 'whats app') THEN 'WhatsApp'
				WHEN LOWER(origem) IN ('indicação', 'indicacao', 'indicação') THEN 'Indicação'
				WHEN LOWER(origem) IN ('redes sociais', 'social', 'instagram') THEN 'Redes Sociais'
				WHEN LOWER(origem) = 'busca orgânica' THEN 'Busca Orgânica'
				WHEN LOWER(origem) = 'visita espontânea' THEN 'Visita Espontânea'
				WHEN LOWER(origem) = 'parceiro' THEN 'Parceiro'
				ELSE origem
				END, 'Sem Dados') AS origem,
		COALESCE(CASE WHEN status_atual IN ('Matricula', 'Matrícula realizada', 'Matriculado')
				THEN 'Matriculado'
				ELSE status_atual
				END, 'N/A') AS status_atual,
		COALESCE(matricula, 'Sem dados') AS matricula,
		TRY_CAST(idade_responsavel AS INT) AS idade_responsavel,
		COALESCE(faixa_renda, 'Sem dados') faixa_renda,
		ROW_NUMBER() OVER(PARTITION BY id_lead 
		ORDER BY CASE status_atual
			WHEN 'Lead recebido' THEN 1
			WHEN 'Contato realizado' THEN 2
			WHEN 'Sem retorno' THEN 3
			WHEN 'Em negociação' THEN 4
			WHEN 'Visita agendada' THEN 5
			WHEN 'Visita realizada' THEN 6
			WHEN 'Proposta enviada' THEN 7
			WHEN 'Matriculado' THEN 8
			WHEN 'Perdido' THEN 9
			ELSE 10
			END 
		DESC) as rn
	FROM bronze.leads_interessados
)

INSERT INTO silver.leads_interessados (
	id_lead,
	data_entrada,
	unidade_interesse,
	serie_curso_interesse,
	origem,
	status_atual,
	matricula,
	idade_responsavel,
	faixa_renda
)

SELECT 
	id_lead,
	data_entrada,
	unidade_interesse,
	serie_curso_interesse,
	origem,
	status_atual,
	matricula,
	idade_responsavel,
	faixa_renda
FROM remove_dup
WHERE rn = 1;

SELECT *
FROM silver.leads_interessados;

/*
SELECT
	id_lead,
	COUNT(*) AS qtd
FROM bronze.leads_interessados
GROUP BY id_lead
HAVING COUNT(*) > 1;

SELECT *
FROM bronze.leads_interessados
WHERE id_lead = 10038 
	OR id_lead = 10031 
	OR id_lead = 10147
	OR id_lead = 10159
	OR id_lead = 10174
	OR id_lead = 10194
	OR id_lead = 10205
	OR id_lead = 10244
ORDER BY id_lead
*/

-- relacionamento_atendimento --------------------------------------------

SELECT *
FROM bronze.relacionamento_atendimento;

DROP TABLE IF EXISTS silver.relacionamento_atendimento;
CREATE TABLE silver.relacionamento_atendimento (
	id_lead INT PRIMARY KEY,
	unidade VARCHAR(50),
	tentativas_contato INT,
	tempo_primeiro_contato_horas DECIMAL(5, 2),
	visita_agendada VARCHAR(10),
	visita_realizada VARCHAR(10),
	proposta_enviada VARCHAR(10),
	motivo_perda VARCHAR(50),
	canal_preferencial_contato VARCHAR(20)
);
INSERT INTO silver.relacionamento_atendimento (
	id_lead,
	unidade,
	tentativas_contato,
	tempo_primeiro_contato_horas,
	visita_agendada,
	visita_realizada,
	proposta_enviada,
	motivo_perda,
	canal_preferencial_contato
)
SELECT 
	TRY_CAST(id_lead AS INT),
	COALESCE(unidade, 'Sem dados'),
	TRY_CAST(tentativas_contato AS INT),
	TRY_CAST(tempo_primeiro_contato_horas AS DECIMAL(5, 2)),
	COALESCE(visita_agendada, 'Sem dados'),
	COALESCE(visita_realizada, 'Sem dados'),
	COALESCE(proposta_enviada, 'Sem dados'),
	COALESCE(motivo_perda, 'Sem dados'),
	COALESCE(canal_preferencial_contato, 'Sem dados')
FROM bronze.relacionamento_atendimento;

SELECT *
FROM silver.relacionamento_atendimento