create table if not exists imp.sisu_offer_report
(
    edicao smallint,
    cod_ies int,
    ies text,
	cod_campus int,
	campus text,
	cod_ies_curso int,
	curso text,
	turno text,
    vagas_1_semestre smallint,
    vagas_2_semestre smallint,
	total_vagas smallint
);