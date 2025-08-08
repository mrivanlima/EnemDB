CREATE OR REPLACE PROCEDURE app.usp_seats_cutoff_update()
LANGUAGE plpgsql
AS $$
BEGIN
    -- 1. Remove a tabela temporária se existir
    DROP TABLE IF EXISTS cutoff_temp;

    -- 2. Cria a tabela temporária
    CREATE TEMP TABLE cutoff_temp AS
    SELECT 
        NULL::INT AS seats_id,
        y.year_id,
        u.university_id,
        ao.academic_organization_id,
        uc.university_category_id,
        c.campus_id,
        s.state_id,
        ci.city_id,
        r.region_id,
        d.degree_id,
        dl.degree_level_id,
        sh.shift_id,
        sso.qt_vagas_ofertadas AS seats_offered,
        sso.nu_percentual_bonus AS score_bonus_percent,
        qt.quota_type_id,
        sso.NU_NOTACORTE::NUMERIC(8,2),
        sso.QT_INSCRICAO::INTEGER,
        NULL::SMALLINT AS special_quota_id,
        sso.sisu_spot_cutoff_id,
        sso.CO_IES_CURSO::INTEGER AS course_no
    FROM imp.sisu_spot_cutoff_score sso
    JOIN app.year y 
        ON y.year = sso.edicao::SMALLINT
    JOIN imp.university_mapping um 
        ON trim(upper(um.university_original_name)) = trim(upper(sso.no_ies))
    JOIN app.university u 
        ON trim(upper(u.university_name)) = trim(upper(um.university_mapped_name))
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
        ON trim(upper(r.region_name)) = replace(trim(upper(sso.ds_regiao_campus)), '_', '-')
    JOIN imp.degree_mapping dm 
        ON trim(upper(dm.published_degree)) = trim(upper(no_curso))
    JOIN app.degree d 
        ON trim(upper(d.degree_name)) = trim(upper(dm.similarity))
    JOIN app.degree_level dl 
        ON trim(upper(dl.degree_level_name)) = trim(upper(sso.ds_grau))
    JOIN app.shift sh 
        ON trim(upper(sh.shift_name)) = trim(upper(sso.ds_turno))
    JOIN app.quota_type qt 
        ON trim(upper(qt.quota_type_code)) = trim(upper(sso.tipo_concorrencia));

    -- 3. Atualiza a coluna special_quota_id
    UPDATE cutoff_temp ot
    SET special_quota_id = sub.special_quota_id
    FROM (
        SELECT 
            sso.sisu_spot_cutoff_id,
            sq.quota_type_id,
            sq.special_quota_id,
            sso.CO_IES_CURSO::INTEGER AS course_no
        FROM imp.sisu_spot_cutoff_score sso
        JOIN app.special_quota sq
            ON trim(upper(sq.special_quota_desc_pt)) = trim(upper(sso.ds_mod_concorrencia))
        JOIN app.quota_type qt
            ON sq.quota_type_id = qt.quota_type_id
        WHERE trim(upper(sso.TIPO_CONCORRENCIA)) IN ('V', 'B')
    ) sub
    WHERE ot.sisu_spot_cutoff_id = sub.sisu_spot_cutoff_id
      AND ot.quota_type_id = sub.quota_type_id
      AND ot.course_no = sub.course_no;

    -- 4. Atualiza os dados na tabela app.seats
    UPDATE app.seats s
    SET cutoff_score = ct.NU_NOTACORTE,
        num_students = ct.QT_INSCRICAO
    FROM cutoff_temp ct
    WHERE s.year_id = ct.year_id
      AND s.university_id = ct.university_id
      AND s.academic_organization_id = ct.academic_organization_id
      AND s.university_category_id = ct.university_category_id
      AND s.campus_id = ct.campus_id
      AND s.state_id = ct.state_id
      AND s.city_id = ct.city_id
      AND s.region_id = ct.region_id
      AND s.degree_id = ct.degree_id
      AND s.degree_level_id = ct.degree_level_id
      AND s.shift_id = ct.shift_id
      AND s.quota_type_id = ct.quota_type_id
      AND coalesce(s.special_quota_id, 0) = coalesce(ct.special_quota_id, 0)
      AND s.course_no = ct.course_no;
END;
$$;
