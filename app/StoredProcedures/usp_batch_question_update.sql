CREATE OR REPLACE PROCEDURE app.usp_batch_question_update(p_exam_year INTEGER)
LANGUAGE plpgsql
AS $$
BEGIN
    -- Drop temp table if exists
    DROP TABLE IF EXISTS tmp_es_questions;

    -- Create temp table
    CREATE TEMP TABLE tmp_es_questions AS
    SELECT
      trim(replace(replace(es.source_pdf_path, 'Provas\', ''),'.pdf', '')) AS booklet_name,
      es.exam_source_id,
      es.exam_year,
      replace(es.test_code, 'P', '')::int                           AS prova,
      regexp_replace(es.notebook_code, '^CAD_0?', '')::int          AS notebook_id,
      replace(es.day_code, 'DIA_', '')::int                         AS day_id,
      es.color_name,
      (q.elem->>'number')::smallint                                 AS question_position,
      (q.elem->>'lang_group')::smallint                             AS language_id,
      TRIM(q.elem->>'A') AS alternative_text_a,
      TRIM(q.elem->>'B') AS alternative_text_b,
      TRIM(q.elem->>'C') AS alternative_text_c,
      TRIM(q.elem->>'D') AS alternative_text_d,
      TRIM(q.elem->>'E') AS alternative_text_e,
      TRIM(q.elem->>'stem') AS question_text
    FROM imp.exam_source es
        CROSS JOIN LATERAL jsonb_array_elements(es.payload->'questions') AS q(elem)
    WHERE es.exam_year = p_exam_year
      AND es.test_code = 'P1'
      AND es.notebook_code IN ('CAD_07', 'CAD_01');

    -- Update questions
    UPDATE app.question AS q
    SET
        question_text      = eq.question_text, 
        alternative_text_a = eq.alternative_text_a,
        alternative_text_b = eq.alternative_text_b,
        alternative_text_c = eq.alternative_text_c,
        alternative_text_d = eq.alternative_text_d,
        alternative_text_e = eq.alternative_text_e
    FROM tmp_es_questions AS eq
    WHERE q.question_position = eq.question_position
    AND COALESCE(q.language_id, 0) = COALESCE(eq.language_id, 0)
    AND eq.exam_year = p_exam_year;

    -- Drop temp table after use
    DROP TABLE IF EXISTS tmp_es_questions;
END;
$$;
