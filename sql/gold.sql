
DROP VIEW IF EXISTS gold.leads_analytics;
CREATE VIEW gold.leads_analytics AS
SELECT 
	leads.id_lead,
	leads.data_entrada,
	leads.unidade_interesse,
	leads.serie_curso_interesse,
	leads.origem,
	leads.status_atual,
	leads.idade_responsavel,
	leads.faixa_renda,

	engajamento.emails_enviados,
	engajamento.emails_abertos,
	engajamento.cliques_email,
	engajamento.interagiu_whatsapp,
	engajamento.participou_evento,
	engajamento.acessou_conteudo,
	engajamento.materiais_baixados,
	engajamento.visitas_site,
	engajamento.data_ultima_interacao,

	atendimento.tentativas_contato,
	atendimento.tempo_primeiro_contato_horas,
	atendimento.visita_agendada,
	atendimento.visita_realizada,
	atendimento.proposta_enviada,
	atendimento.motivo_perda,
	atendimento.canal_preferencial_contato

FROM silver.leads_interessados AS leads
LEFT JOIN silver.engajamento_jornada as engajamento
	ON leads.id_lead = engajamento.id_lead
LEFT JOIN silver.relacionamento_atendimento as atendimento
	ON leads.id_lead = atendimento.id_lead;


/*
SELECT
	SUM(gold.leads_analytics.emails_abertos) as abertos,
	SUM(gold.leads_analytics.emails_enviados) AS enviados
FROM gold.leads_analytics
HAVING COUNT(*) > 1
*/