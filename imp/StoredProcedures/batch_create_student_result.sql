CREATE OR REPLACE PROCEDURE imp.batch_create_student_result(
    IN p_year     INT DEFAULT EXTRACT(YEAR FROM CURRENT_DATE)::INT,
    IN p_user_id  INT DEFAULT 1
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_year_id INT;
    v_exists  BOOLEAN;
BEGIN
    -- 0) Skip if target year already loaded
    SELECT EXISTS (
        SELECT 1 FROM app.student_result WHERE year = p_year LIMIT 1
    ) INTO v_exists;

    IF v_exists THEN
        RAISE NOTICE 'Year % already present in app.student_result; skipping load.', p_year;
        RETURN;
    END IF;

    -- 1) Ensure the year exists in the dimension
    SELECT y.year_id
      INTO v_year_id
      FROM app.year y
     WHERE y.year = p_year
     LIMIT 1;

    IF v_year_id IS NULL THEN
        RAISE EXCEPTION 'Year % not found in app.year(year_id)', p_year;
    END IF;

    -- 2) Load (first-time load only)
    INSERT INTO app.student_result (
        university_id,
        campus_id,
        shift_id,
        published_degree,
        degree_id,
        quota_type_id,
        special_quota_id,
        subscription_no,
        student_name,
        quota,
        student_score,
        cutoff_score,
        classification,
        year_id,
        year,
        created_by,
        created_on
    )
    SELECT 
        u.university_id,
        ca.campus_id,
        s.shift_id,
        dm.published_degree,
        d.degree_id,
        qt.quota_type_id,
        sq.special_quota_id,
        TRIM(UPPER(sr.co_inscricao_enem)) AS subscription_no,
        TRIM(UPPER(sr.no_inscrito))       AS student_name,
        sr.tipo_concorrencia              AS quota,
        NULLIF(REPLACE(REPLACE(sr.nu_nota_candidato_raw,       '.', ''), ',', '.'), '')::NUMERIC(10,2) AS student_score,
        NULLIF(REPLACE(REPLACE(sr.nu_notacorte_concorrida_raw, '.', ''), ',', '.'), '')::NUMERIC(10,2) AS cutoff_score,
        sr.nu_classificacao::INT          AS classification,
        v_year_id                          AS year_id,
        p_year                             AS year,
        p_user_id                          AS created_by,
        NOW()                              AS created_on
    FROM imp.sisu_results sr
    JOIN imp.degree_mapping dm
      ON TRIM(UPPER(dm.published_degree)) = TRIM(UPPER(sr.no_curso))
    JOIN app.degree d
      ON TRIM(UPPER(d.degree_name)) = TRIM(UPPER(dm.similarity))
    JOIN app.university u
      ON u.university_code = sr.co_ies
    JOIN app.campus ca
      ON TRIM(UPPER(unaccent(ca.campus_name))) = TRIM(UPPER(unaccent(sr.no_campus)))
    JOIN app.shift s
      ON TRIM(UPPER(s.shift_name)) = TRIM(UPPER(sr.ds_turno))
    JOIN app.degree_level dl
      ON TRIM(UPPER(dl.degree_level_name)) = TRIM(UPPER(sr.ds_formacao))
    JOIN app.quota_type qt
      ON TRIM(UPPER(qt.quota_type_code)) = TRIM(UPPER(sr.tipo_concorrencia))
    LEFT JOIN app.special_quota sq
      ON sq.quota_type_id = qt.quota_type_id
     AND sq.special_quota_desc_pt = sr.no_modalidade_concorrencia;

    RAISE NOTICE 'student_result load complete for year %', p_year;
END;
$$;
