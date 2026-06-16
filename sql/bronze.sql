

DROP TABLE IF EXISTS bronze.engajamento_jornada;
CREATE TABLE bronze.engajamento_jornada (
	id_lead VARCHAR(50),
	emails_enviados VARCHAR(50),
	emails_abertos VARCHAR(50),
	cliques_email VARCHAR(50),
	interagiu_whatsapp VARCHAR(50),
	participou_evento VARCHAR(50),
	acessou_conteudo VARCHAR(50),
	materiais_baixados VARCHAR(50),
	visitas_site VARCHAR(50),
	data_ultima_interacao VARCHAR(50)
	);

BULK INSERT bronze.engajamento_jornada
FROM 'C:\Users\mathe\Downloads\Teste Bernoulli\engajamento_jornada.csv'
WITH (
	FIRSTROW = 2,
	FIELDTERMINATOR = ',',
	ROWTERMINATOR = '\n',
	CODEPAGE = '65001',
	TABLOCK
);

SELECT *
FROM bronze.engajamento_jornada;


DROP TABLE IF EXISTS bronze.eventos_acoes;
CREATE TABLE bronze.eventos_acoes (
	id_evento VARCHAR(50),
	data_evento VARCHAR(50),
	nome_evento VARCHAR(50),
	unidade VARCHAR(50),
	serie_curso_foco VARCHAR(50),
	inscritos VARCHAR(50),
	presentes VARCHAR(50),
	leads_gerados VARCHAR(50),
	matriculas_pos_evento VARCHAR(50),
	investimento_estimado VARCHAR(50),
	local VARCHAR(50)
	);

BULK INSERT bronze.eventos_acoes
FROM 'C:\Users\mathe\Downloads\Teste Bernoulli\eventos_acoes.csv'
WITH (
	FIRSTROW = 2,
	FIELDTERMINATOR = ',',
	ROWTERMINATOR = '\n',
	CODEPAGE = '65001',
	TABLOCK
);

SELECT *
FROM bronze.eventos_acoes;

DROP TABLE IF EXISTS bronze.leads_interessados;
CREATE TABLE bronze.leads_interessados (
	id_lead VARCHAR(50),
	data_entrada VARCHAR(50),
	unidade_interesse VARCHAR(50),
	serie_curso_interesse VARCHAR(50),
	origem VARCHAR(50),
	status_atual VARCHAR(50),
	matricula VARCHAR(50),
	idade_responsavel VARCHAR(50),
	faixa_renda VARCHAR(50)
	);

BULK INSERT bronze.leads_interessados
FROM 'C:\Users\mathe\Downloads\Teste Bernoulli\leads_interessados.csv'
WITH (
	FIRSTROW = 2,
	FIELDTERMINATOR = ',',
	ROWTERMINATOR = '\n',
	CODEPAGE = '65001',
	TABLOCK
);

SELECT *
FROM bronze.leads_interessados;

DROP TABLE IF EXISTS bronze.relacionamento_atendimento;
CREATE TABLE bronze.relacionamento_atendimento (
	id_lead VARCHAR(50),
	unidade VARCHAR(50),
	tentativas_contato VARCHAR(50),
	tempo_primeiro_contato_horas VARCHAR(50),
	visita_agendada VARCHAR(50),
	visita_realizada VARCHAR(50),
	proposta_enviada VARCHAR(50),
	motivo_perda VARCHAR(50),
	canal_preferencial_contato VARCHAR(50)
	);

BULK INSERT bronze.relacionamento_atendimento
FROM 'C:\Users\mathe\Downloads\Teste Bernoulli\relacionamento_atendimento.csv'
WITH (
	FIRSTROW = 2,
	FIELDTERMINATOR = ',',
	ROWTERMINATOR = '\n',
	CODEPAGE = '65001',
	TABLOCK
);

SELECT *
FROM bronze.relacionamento_atendimento;