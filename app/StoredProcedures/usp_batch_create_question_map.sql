CREATE OR REPLACE PROCEDURE app.usp_batch_create_question_map (
  IN  p_exam_year   SMALLINT,   -- e.g., 2024
  IN  p_test_code   TEXT,       -- e.g., 'P1'
  IN  p_created_by  INT,
  OUT out_message   TEXT
)
LANGUAGE plpgsql
AS $$
DECLARE
  v_year_id          INT;
  v_test_version_id  INT;
  v_rows_inserted    BIGINT := 0;
BEGIN
  -- Resolve year_id and test_version_id
  SELECT y.year_id INTO v_year_id
  FROM app.year y
  WHERE y.year = p_exam_year;
  IF NOT FOUND THEN
    out_message := format('Validação falhou: ano %s não existe em app.year.', p_exam_year);
    RETURN;
  END IF;

  SELECT tv.test_version_id INTO v_test_version_id
  FROM app.test_version tv
  WHERE trim(upper(tv.test_code)) = trim(upper(p_test_code));
  IF NOT FOUND THEN
    out_message := format('Validação falhou: test_code "%s" não existe em app.test_version.', p_test_code);
    RETURN;
  END IF;

  -- Build temp mapping exactly like your query (base = AZUL)
  DROP TABLE IF EXISTS tmp_color_map;

  CREATE TEMP TABLE tmp_color_map AS
  WITH base AS (
    SELECT
      es.exam_source_id,
      COALESCE((q->>'lang_group')::smallint, 0) AS language_id,
      (q->>'number')::smallint                   AS base_number,
      regexp_replace(lower(trim(q->>'stem')), '\s+', ' ', 'g') AS stem_n
    FROM imp.exam_source es
    CROSS JOIN LATERAL jsonb_array_elements(es.payload->'questions') q
    WHERE es.exam_year = p_exam_year
      AND es.test_code = p_test_code
      AND es.color_name = 'AZUL'
  ),
  amarelo AS (
    SELECT
      es.exam_source_id,
      COALESCE((q->>'lang_group')::smallint, 0) AS language_id,
      (q->>'number')::smallint                   AS amarelo_number,
      regexp_replace(lower(trim(q->>'stem')), '\s+', ' ', 'g') AS stem_n
    FROM imp.exam_source es
    CROSS JOIN LATERAL jsonb_array_elements(es.payload->'questions') q
    WHERE es.exam_year = p_exam_year
      AND es.test_code = p_test_code
      AND es.color_name = 'AMARELO'
  ),
  branco AS (
    SELECT
      es.exam_source_id,
      COALESCE((q->>'lang_group')::smallint, 0) AS language_id,
      (q->>'number')::smallint                   AS branco_number,
      regexp_replace(lower(trim(q->>'stem')), '\s+', ' ', 'g') AS stem_n
    FROM imp.exam_source es
    CROSS JOIN LATERAL jsonb_array_elements(es.payload->'questions') q
    WHERE es.exam_year = p_exam_year
      AND es.test_code = p_test_code
      AND es.color_name = 'BRANCO'
  ),
  verde AS (
    SELECT
      es.exam_source_id,
      COALESCE((q->>'lang_group')::smallint, 0) AS language_id,
      (q->>'number')::smallint                   AS verde_number,
      regexp_replace(lower(trim(q->>'stem')), '\s+', ' ', 'g') AS stem_n
    FROM imp.exam_source es
    CROSS JOIN LATERAL jsonb_array_elements(es.payload->'questions') q
    WHERE es.exam_year = p_exam_year
      AND es.test_code = p_test_code
      AND es.color_name = 'VERDE'
  ),
  cinza AS (
    SELECT
      es.exam_source_id,
      COALESCE((q->>'lang_group')::smallint, 0) AS language_id,
      (q->>'number')::smallint                   AS cinza_number,
      regexp_replace(lower(trim(q->>'stem')), '\s+', ' ', 'g') AS stem_n
    FROM imp.exam_source es
    CROSS JOIN LATERAL jsonb_array_elements(es.payload->'questions') q
    WHERE es.exam_year = p_exam_year
      AND es.test_code = p_test_code
      AND es.color_name = 'CINZA'
  )
  -- Final mapping query
  SELECT
    'AMARELO'         AS color_name,
    az.base_number    AS number_in_base,
    am.amarelo_number AS number_in_variant,
    az.language_id
  FROM base az
  JOIN amarelo am ON TRIM(LEFT(am.stem_n, 40)) = TRIM(LEFT(az.stem_n, 40))

  UNION ALL
  SELECT
    'BRANCO',
    az.base_number,
    br.branco_number,
    az.language_id
  FROM base az
  JOIN branco br ON TRIM(LEFT(br.stem_n, 40)) = TRIM(LEFT(az.stem_n, 40))

  UNION ALL
  SELECT
    'VERDE',
    az.base_number,
    ve.verde_number,
    az.language_id
  FROM base az
  JOIN verde ve ON TRIM(LEFT(ve.stem_n, 40)) = TRIM(LEFT(az.stem_n, 40))

  UNION ALL
  SELECT
    'CINZA',
    az.base_number,
    cz.cinza_number,
    az.language_id
  FROM base az
  JOIN cinza cz ON TRIM(LEFT(cz.stem_n, 40)) = TRIM(LEFT(az.stem_n, 40));

  -- Single INSERT…SELECT using your bottom join
  INSERT INTO app.question_map (
    booklet_color_id,
    number_in_base,
    number_in_variant,
    language_id,
    year_id,
    test_version_id,
    created_by,
    created_on,
    modified_by,
    modified_on
  )
  SELECT
    bc.booklet_color_id,
    cm.number_in_base,
    cm.number_in_variant,
    NULLIF(cm.language_id, 0) AS language_id,
    v_year_id                 AS year_id,
    v_test_version_id         AS test_version_id,
    p_created_by              AS created_by,
    NOW(),                    -- created_on
    p_created_by,             -- modified_by
    NOW()                     -- modified_on
  FROM tmp_color_map cm
  JOIN app.booklet_color bc
    ON trim(upper(bc.booklet_color_name)) = trim(upper(cm.color_name));
  -- year/test already resolved above
  -- ON CONFLICT ON CONSTRAINT uq_question_map DO NOTHING;

  DROP TABLE IF EXISTS tmp_color_map;

  GET DIAGNOSTICS v_rows_inserted = ROW_COUNT;
  out_message := format('OK: %s registro(s) inserido(s) para ano=%s e versão=%s.',
                        v_rows_inserted, p_exam_year, p_test_code);
  RETURN;

EXCEPTION WHEN OTHERS THEN
  out_message := format('Erro: %s', SQLERRM);
  -- Keep it simple per your request; add error_log insert if you want.
  RETURN;
END;
$$;