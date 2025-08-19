CREATE OR REPLACE PROCEDURE imp.batch_create_seats(p_created_by INTEGER)
LANGUAGE plpgsql
AS $$
BEGIN
    -- Step 1: Create temp table
    DROP TABLE IF EXISTS offer_temp;

    CREATE TEMP TABLE offer_temp AS
    SELECT 
        y.year_id,
        u.university_id,
        ao.academic_organization_id,
        uc.university_category_id,
        c.campus_id,
        s.state_id,
        ci.city_id,
        r.region_id,
        sso.co_ies_curso::integer AS course_no,
        d.degree_id,
        dl.degree_level_id,
        sh.shift_id,
        f.frequency_id,
        sso.qt_semestre::numeric AS semester_number,
        sso.nu_vagas_autorizadas::integer AS seats_authorized,
        sso.qt_vagas_ofertadas::integer AS seats_offered,
        sso.nu_percentual_bonus::numeric AS score_bonus_percent,
        qt.quota_type_id,
        NULL::INTEGER AS special_quota_id,
        REPLACE(sso.peso_redacao, '%', '')::NUMERIC AS peso_redacao,
		REPLACE(sso.nota_minima_redacao, '%', '')::NUMERIC AS nota_minima_redacao,
		REPLACE(sso.peso_linguagens, '%', '')::NUMERIC AS peso_linguagens,
		REPLACE(sso.nota_minima_linguagens, '%', '')::NUMERIC AS nota_minima_linguagens,
		REPLACE(sso.peso_matematica, '%', '')::NUMERIC AS peso_matematica,
		REPLACE(sso.nota_minima_matematica, '%', '')::NUMERIC AS nota_minima_matematica,
		REPLACE(sso.peso_ciencias_humanas, '%', '')::NUMERIC AS peso_ciencias_humanas,
		REPLACE(sso.nota_minima_ciencias_humanas, '%', '')::NUMERIC AS nota_minima_ciencias_humanas,
		REPLACE(sso.peso_ciencias_natureza, '%', '')::NUMERIC AS peso_ciencias_natureza,
		REPLACE(sso.nota_minima_ciencias_natureza, '%', '')::NUMERIC AS nota_minima_ciencias_natureza,
		REPLACE(sso.nu_media_minima_enem, '%', '')::NUMERIC AS nu_media_minima_enem,
		REPLACE(sso.perc_uf_ibge_ppi, '%', '')::NUMERIC AS perc_uf_ibge_ppi,
		REPLACE(sso.perc_uf_ibge_pp, '%', '')::NUMERIC AS perc_uf_ibge_pp,
		REPLACE(sso.perc_uf_ibge_i, '%', '')::NUMERIC AS perc_uf_ibge_i,
		REPLACE(sso.perc_uf_ibge_q, '%', '')::NUMERIC AS perc_uf_ibge_q,
		REPLACE(sso.perc_uf_ibge_pcd, '%', '')::NUMERIC AS perc_uf_ibge_pcd,
		REPLACE(sso.nu_perc_lei, '%', '')::NUMERIC AS nu_perc_lei,
		REPLACE(sso.nu_perc_ppi, '%', '')::NUMERIC AS nu_perc_ppi,
		REPLACE(sso.nu_perc_pp, '%', '')::NUMERIC AS nu_perc_pp,
		REPLACE(sso.nu_perc_i, '%', '')::NUMERIC AS nu_perc_i,
		REPLACE(sso.nu_perc_q, '%', '')::NUMERIC AS nu_perc_q,
		REPLACE(sso.nu_perc_pcd, '%', '')::NUMERIC AS nu_perc_pcd,

        sso.sisu_spot_offer_id		
    FROM imp.sisu_spot_offer sso
    JOIN app.year y 
		ON y.year = sso.edicao::SMALLINT
    JOIN imp.university_mapping um 
		ON trim(upper(um.university_original_name)) = trim(upper(sso.no_ies))
    JOIN app.university u 
		ON  u.university_code = sso.co_ies::int
    JOIN app.academic_organization ao 
		ON trim(upper(ao.academic_organization_name)) = trim(upper(sso.ds_organizacao_academica))
    JOIN app.university_category uc 
		ON trim(upper(uc.university_category_name)) = trim(upper(sso.ds_categoria_adm))
    JOIN app.campus c 
		ON trim(upper(c.campus_name)) = trim(upper(sso.no_campus))
    JOIN app.state s 
		ON trim(upper(s.state_abbr)) = trim(upper(sso.sg_uf_campus))
    JOIN app.city ci 
		ON trim(upper(ci.city_name)) = trim(upper(sso.no_municipio_campus)) 
		AND ci.state_id = s.state_id
    JOIN app.region r 
		ON trim(upper(r.region_name)) = replace(trim(upper(sso.ds_regiao)), '_', '-')
    JOIN imp.degree_mapping dm 
		ON trim(upper(dm.published_degree)) = trim(upper(no_curso))
    JOIN app.degree d 
		ON trim(upper(d.degree_name)) = trim(upper(dm.similarity))
    JOIN app.degree_level dl 
		ON trim(upper(dl.degree_level_name)) = trim(upper(sso.ds_grau))
    JOIN app.shift sh 
		ON trim(upper(sh.shift_name)) = trim(upper(sso.ds_turno))
    JOIN app.frequency f 
		ON trim(upper(f.frequency_name)) = trim(upper(sso.ds_periodicidade))
    JOIN app.quota_type qt 
		ON trim(upper(qt.quota_type_code)) = trim(upper(sso.tp_cota));

    -- Step 2: Update special_quota_id
    UPDATE offer_temp ot
    SET special_quota_id = sub.special_quota_id
    FROM (
        SELECT 
            sso.sisu_spot_offer_id,
            sq.quota_type_id,
            sq.special_quota_id,
            sso.CO_IES_CURSO::INTEGER AS course_no
        FROM imp.sisu_spot_offer sso
        JOIN app.special_quota sq
          ON trim(upper(sq.special_quota_desc_pt)) = trim(upper(sso.ds_mod_concorrencia))
        JOIN app.quota_type qt
          ON sq.quota_type_id = qt.quota_type_id
        WHERE trim(upper(sso.tp_cota)) IN ('V', 'B')
    ) sub
    WHERE ot.sisu_spot_offer_id = sub.sisu_spot_offer_id
      AND ot.quota_type_id = sub.quota_type_id
      AND ot.course_no = sub.course_no;

    -- Step 3: Insert only if it doesn't already exist
    INSERT INTO app.seats (
        year_id,
        university_id,
        academic_organization_id,
        university_category_id,
        campus_id,
        state_id,
        city_id,
        region_id,
        course_no,
        degree_id,
        degree_level_id,
        shift_id,
        frequency_id,
        semester_number,
        seats_authorized,
        seats_offered,
        score_bonus_percent,
        quota_type_id,
        special_quota_id,
        weight_essay,
        min_score_essay,
        weight_language,
        min_score_language,
        weight_math,
        min_score_math,
        weight_humanities,
        min_score_humanities,
        weight_nature_science,
        min_score_nature_science,
        min_enem_score,
        pct_state_ppi_ibge,
        pct_state_pp_ibge,
        pct_state_indigenous_ibge,
        pct_state_quilombola_ibge,
        pct_state_pcd_ibge,
        pct_quota_law,
        pct_quota_ppi,
        pct_quota_pp,
        pct_quota_indigenous,
        pct_quota_quilombola,
        pct_quota_pcd,
        created_by
    )
    SELECT
        t.year_id,
        t.university_id,
        t.academic_organization_id,
        t.university_category_id,
        t.campus_id,
        t.state_id,
        t.city_id,
        t.region_id,
        t.course_no,
        t.degree_id,
        t.degree_level_id,
        t.shift_id,
        t.frequency_id,
        t.semester_number,
        t.seats_authorized,
        t.seats_offered,
        t.score_bonus_percent,
        t.quota_type_id,
        t.special_quota_id::INTEGER,
        t.peso_redacao,
        t.nota_minima_redacao,
        t.peso_linguagens,
        t.nota_minima_linguagens,
        t.peso_matematica,
        t.nota_minima_matematica,
        t.peso_ciencias_humanas,
        t.nota_minima_ciencias_humanas,
        t.peso_ciencias_natureza,
        t.nota_minima_ciencias_natureza,
        t.nu_media_minima_enem,
        t.perc_uf_ibge_ppi,
        t.perc_uf_ibge_pp,
        t.perc_uf_ibge_i,
        t.perc_uf_ibge_q,
        t.perc_uf_ibge_pcd,
        t.nu_perc_lei,
        t.nu_perc_ppi,
        t.nu_perc_pp,
        t.nu_perc_i,
        t.nu_perc_q,
        t.nu_perc_pcd,
        p_created_by
    FROM offer_temp t
    WHERE NOT EXISTS (
        SELECT 1
        FROM app.seats s
        WHERE s.year_id = t.year_id
          AND s.university_id = t.university_id
          AND s.academic_organization_id = t.academic_organization_id
          AND s.university_category_id = t.university_category_id
          AND s.campus_id = t.campus_id
          AND s.degree_id = t.degree_id
          and s.course_no = t.course_no
          AND s.degree_level_id = t.degree_level_id
          AND s.shift_id = t.shift_id
          AND s.frequency_id = t.frequency_id
          AND s.semester_number = t.semester_number
          AND s.quota_type_id = t.quota_type_id
          AND s.special_quota_id IS NOT DISTINCT FROM t.special_quota_id::INTEGER
    );
    DROP TABLE IF EXISTS offer_temp;

END;
$$;