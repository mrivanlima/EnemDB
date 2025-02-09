create table if not exists imp.enem_vagas_ofertadas_2010_2018
(
    edicao text,
	cod_ies int,
	nome_ies text,
	sigla_ies text,
    categoria_administrativa text,
    organizacao_academica text,
	campus text,
    regiao_campus text,
    sigla_uf_campus text,
    municipio_campus text,
	cod_curso int,
	nome_curso text,
	grau text,
	turno text,
    tipo_modalidade text,
	modalidade_concorrencia text,
    percentual_de_bonus smallint,
    qt_vagas smallint
);