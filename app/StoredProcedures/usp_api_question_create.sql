CREATE OR REPLACE PROCEDURE app.usp_api_question_create(
	IN p_booklet_id integer,
	IN p_language_id smallint,
	IN p_question_position smallint,
	IN p_question_text text,
	IN p_alternative_text_a text,
	IN p_alternative_text_b text,
	IN p_alternative_text_c text,
	IN p_alternative_text_d text,
	IN p_alternative_text_e text,
	IN p_correct_answer character,
	IN p_param_a numeric,
	IN p_param_b numeric,
	IN p_param_c numeric,
	IN p_notes text,
	IN p_created_by integer,
	OUT out_question_id integer,
	OUT out_message text,
	OUT out_haserror boolean)
LANGUAGE 'plpgsql'
AS $$

DECLARE
    v_exists         INTEGER;
    v_command        TEXT;
    v_error_message  TEXT;
    v_error_code     TEXT;
BEGIN
    out_haserror := FALSE;
    out_message  := NULL;
    out_question_id := NULL;

    -- Validações obrigatórias
    IF p_booklet_id IS NULL THEN
        out_haserror := TRUE; out_message := 'Validação falhou: booklet_id é obrigatório.'; RETURN;
    END IF;

    IF p_question_position IS NULL THEN
        out_haserror := TRUE; out_message := 'Validação falhou: question_position é obrigatório.'; RETURN;
    END IF;

    IF p_created_by IS NULL THEN
        out_haserror := TRUE; out_message := 'Validação falhou: created_by é obrigatório.'; RETURN;
    END IF;

    -- A, B, C, D, E ou X
    IF p_correct_answer IS NOT NULL AND upper(p_correct_answer) NOT IN ('A','B','C','D','E','X') THEN
        out_haserror := TRUE; out_message := 'Validação falhou: correct_answer deve ser A, B, C, D, E ou X.'; RETURN;
    END IF;

    -- Unicidade: (booklet_id, question_position, language_id)
    SELECT 1 INTO v_exists
    FROM app.question
    WHERE booklet_id = p_booklet_id
      AND question_position = p_question_position
      AND coalesce(language_id, 0) = coalesce(p_language_id, 0);

    IF FOUND THEN
        out_haserror := TRUE;
        out_message := format(
            'Validação falhou: já existe questão para booklet_id=%s, position=%s, language_id=%s.',
            p_booklet_id, p_question_position, p_language_id
        );
        RETURN;
    END IF;

    -- Inserção (sem topic_id)
    INSERT INTO app.question (
        booklet_id,
        language_id,
        question_position,
        question_text,
        alternative_text_a,
        alternative_text_b,
        alternative_text_c,
        alternative_text_d,
        alternative_text_e,
        correct_answer,
        param_a,
        param_b,
        param_c,
        notes,
        created_by
    )
    VALUES (
        p_booklet_id,
        p_language_id,
        p_question_position,
        p_question_text,
        p_alternative_text_a,
        p_alternative_text_b,
        p_alternative_text_c,
        p_alternative_text_d,
        p_alternative_text_e,
        CASE WHEN p_correct_answer IS NULL THEN NULL ELSE upper(p_correct_answer) END,
        p_param_a,
        p_param_b,
        p_param_c,
        p_notes,
        p_created_by
    )
    RETURNING question_id INTO out_question_id;

    out_message := 'Questão criada com sucesso.';
    RETURN;

EXCEPTION
    WHEN OTHERS THEN
        -- Comando reproduzível para auditoria
        v_command := format(
            'CALL app.usp_api_question_create(%s, %s, %s, %L, %L, %L, %L, %L, %L, %L, %s, %s, %s, %L, %s, NULL, NULL, NULL)',
            COALESCE(p_booklet_id::TEXT, 'NULL'),
            COALESCE(p_language_id::TEXT, 'NULL'),
            COALESCE(p_question_position::TEXT, 'NULL'),
            COALESCE(p_question_text, 'NULL'),
            COALESCE(p_alternative_text_a, 'NULL'),
            COALESCE(p_alternative_text_b, 'NULL'),
            COALESCE(p_alternative_text_c, 'NULL'),
            COALESCE(p_alternative_text_d, 'NULL'),
            COALESCE(p_alternative_text_e, 'NULL'),
            COALESCE(p_correct_answer::TEXT, 'NULL'),
            COALESCE(p_param_a::TEXT, 'NULL'),
            COALESCE(p_param_b::TEXT, 'NULL'),
            COALESCE(p_param_c::TEXT, 'NULL'),
            COALESCE(p_notes, 'NULL'),
            COALESCE(p_created_by::TEXT, 'NULL')
        );

        v_error_message := SQLERRM;
        v_error_code    := SQLSTATE;

        INSERT INTO app.error_log (
            table_name, process, operation, command, error_message, error_code, user_name
        )
        VALUES (
            'question', 'app.usp_api_question_create', 'INSERÇÃO',
            v_command, v_error_message, v_error_code, COALESCE(p_created_by::TEXT, 'NULL')
        );

        out_haserror    := TRUE;
        out_question_id := NULL;
        out_message     := format('Erro durante a inserção: %s', v_error_message);
        RETURN;
END;
$$;
