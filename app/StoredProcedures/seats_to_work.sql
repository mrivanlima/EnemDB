select distinct
	y.year_id,
	u.university_id,
	ao.academic_organization_id,
	uc.university_category_id,
	s.state_id,
	ci.city_id,
	r.region_id,
	d.degree_id,
	dl.degree_level_id,
	sh.shift_id,
	f.frequency_id,
	sso.qt_semestre as semester_number,
	sso.nu_vagas_autorizadas as seats_authorized,
	sso.qt_vagas_ofertadas as seats_offered,
	sso.nu_percentual_bonus as score_bonus_percent,
	qt.quota_type_id,
	sq.special_quota_id,
	sso.peso_redacao,
	sso.nota_minima_redacao,
	sso.peso_linguagens,
	sso.nota_minima_linguagens,
	sso.peso_matematica,
	sso.nota_minima_matematica,
	sso.peso_ciencias_humanas,
	sso.nota_minima_ciencias_humanas,
	sso.peso_ciencias_natureza,
	sso.nota_minima_ciencias_natureza,
	sso.nu_media_minima_enem,
	sso.perc_uf_ibge_ppi,
	sso.perc_uf_ibge_pp,
	sso.perc_uf_ibge_i,
	sso.perc_uf_ibge_q,
	sso.perc_uf_ibge_pcd,
	sso.nu_perc_lei,
	sso.nu_perc_ppi,
	sso.nu_perc_pp,
	sso.nu_perc_i,
	sso.nu_perc_q,
	sso.nu_perc_pcd

from  imp.sisu_spot_offer sso
	join app.year y
		on y.year = sso.edicao::smallint
	join imp.university_mapping um
		on trim(upper(um.university_original_name)) = trim(upper(sso.no_ies))
	join app.university u
		on trim(upper(u.university_name)) = trim(upper(um.university_mapped_name))
	join app.academic_organization ao
		on trim(upper(ao.academic_organization_name)) = trim(upper(sso.ds_organizacao_academica))
	join app.university_category uc
		on trim(upper(uc.university_category_name)) = trim(upper(sso.ds_categoria_adm))
	join app.campus c
		on trim(upper(c.campus_name)) = trim(upper(sso.no_campus))
	join app.state s
		on trim(upper(s.state_abbr)) = trim(upper(sso.sg_uf_campus))
	join app.city ci
		on trim(upper(ci.city_name)) = trim(upper(sso.no_municipio_campus))
		and ci.state_id = s.state_id
	join app.region r
		on trim(upper(r.region_name)) = replace(trim(upper(sso.ds_regiao)), '_', '-')
	join imp.degree_mapping dm
		on trim(upper(dm.published_degree)) = trim(upper(no_curso))
	join app.degree d
		on trim(upper(d.degree_name)) = trim(upper(dm.similarity))
	join app.degree_level dl
		on trim(upper(dl.degree_level_name)) = trim(upper(sso.ds_grau))
	join app.shift sh
		on trim(upper(sh.shift_name)) = trim(upper(sso.ds_turno))
	join app.frequency f
		on trim(upper(f.frequency_name)) = trim(upper(sso.ds_periodicidade))
	left join app.quota_type qt
		on trim(upper(qt.quota_type_code)) = trim(upper(sso.tp_cota))
	left join app.special_quota sq
		on sq.quota_type_id = qt.quota_type_id
		and (
				trim(upper(qt.quota_type_desc_pt)) = trim(upper(sso.ds_mod_concorrencia))
					or 
				trim(upper(sq.special_quota_desc_pt)) = trim(upper(sso.ds_mod_concorrencia))
			)