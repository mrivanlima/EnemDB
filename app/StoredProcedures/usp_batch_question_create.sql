CREATE OR REPLACE PROCEDURE app.usp_batch_question_create (
    IN p_created_by INTEGER
)
LANGUAGE plpgsql
AS $$
DECLARE
    rec         RECORD;
    v_question_id INTEGER;
    v_message     TEXT;
    v_haserror    BOOLEAN;
BEGIN
    IF p_created_by IS NULL THEN
        RAISE EXCEPTION 'Validação falhou: created_by não pode ser nulo.';
    END IF;

    FOR rec IN
        SELECT
            b.booklet_id::integer AS booklet_id,
            CASE 
                WHEN eqp.language_type = 0 
                    THEN (SELECT MAX(language_id)::smallint FROM app.language WHERE language_name_friendly = 'Ingles')
                WHEN eqp.language_type = 1 
                    THEN (SELECT MAX(language_id)::smallint FROM app.language WHERE language_name_friendly = 'Espanhol')
                ELSE NULL::smallint
            END AS language_id,
            eqp.question_position::smallint AS question_position,
            NULL::text  AS question_text,
            NULL::text  AS alternative_text_a,
            NULL::text  AS alternative_text_b,
            NULL::text  AS alternative_text_c,
            NULL::text  AS alternative_text_d,
            NULL::text  AS alternative_text_e,
            SUBSTRING(TRIM(UPPER(eqp.answer_key)) FROM 1 FOR 1)::char(1) AS correct_answer,
            eqp.param_a::numeric(10,5) AS param_a,
            eqp.param_b::numeric(10,5) AS param_b,
            eqp.param_c::numeric(10,5) AS param_c
        FROM imp.enem_question_parameter eqp
        JOIN app.booklet b
          ON b.booklet_code = eqp.exam_code
        ORDER BY eqp.question_position, language_id
    LOOP
        CALL app.usp_api_question_create(
            rec.booklet_id,
            rec.language_id,
            rec.question_position,
            rec.question_text,
            rec.alternative_text_a,
            rec.alternative_text_b,
            rec.alternative_text_c,
            rec.alternative_text_d,
            rec.alternative_text_e,
            rec.correct_answer,     -- CHAR(1)
            rec.param_a,
            rec.param_b,
            rec.param_c,
            NULL::text,             -- notes
            p_created_by,
            v_question_id,          -- OUT
            v_message,              -- OUT
            v_haserror              -- OUT
        );

        -- Optional debug:
       RAISE NOTICE 'qid=%, err=%, msg=%', v_question_id, v_haserror, v_message;
    END LOOP;
END;
$$;