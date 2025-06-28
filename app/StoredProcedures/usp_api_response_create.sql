CREATE OR REPLACE PROCEDURE app.usp_api_response_create (
    IN  p_exam_attempt_id       INTEGER,
    IN  p_account_id            INTEGER,
    IN  p_question_id           INTEGER,
    IN  p_alternative_id        INTEGER,
    IN  p_is_correct            BOOLEAN,
    IN  p_flag_for_review       BOOLEAN DEFAULT FALSE,
    IN  p_notes                 TEXT DEFAULT NULL,
    IN  p_created_by            TEXT,
    OUT out_message             TEXT
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_exists INTEGER;
    v_command TEXT;
    v_error_message TEXT;
    v_error_code TEXT;
    v_response_id INTEGER;
BEGIN
    -- VALIDATIONS
    IF p_exam_attempt_id IS NULL THEN
        out_message := 'Validation failed: exam_attempt_id cannot be null.';
        RETURN;
    END IF;

    IF p_account_id IS NULL THEN
        out_message := 'Validation failed: account_id cannot be null.';
        RETURN;
    END IF;

    IF p_question_id IS NULL THEN
        out_message := 'Validation failed: question_id cannot be null.';
        RETURN;
    END IF;

    IF p_alternative_id IS NULL THEN
        out_message := 'Validation failed: alternative_id cannot be null.';
        RETURN;
    END IF;

    IF p_is_correct IS NULL THEN
        out_message := 'Validation failed: is_correct cannot be null.';
        RETURN;
    END IF;

    IF p_created_by IS NULL OR length(trim(p_created_by)) = 0 THEN
        out_message := 'Validation failed: created_by cannot be empty.';
        RETURN;
    END IF;

    -- Check that exam_attempt_id exists
    SELECT 1 INTO v_exists FROM app.exam_attempt WHERE exam_attempt_id = p_exam_attempt_id;
    IF NOT FOUND THEN
        out_message := format('Validation failed: exam_attempt_id %s does not exist.', p_exam_attempt_id);
        RETURN;
    END IF;

    -- Check that account_id exists
    SELECT 1 INTO v_exists FROM app.account WHERE account_id = p_account_id;
    IF NOT FOUND THEN
        out_message := format('Validation failed: account_id %s does not exist.', p_account_id);
        RETURN;
    END IF;

    -- Check that question_id exists
    SELECT 1 INTO v_exists FROM app.question WHERE question_id = p_question_id;
    IF NOT FOUND THEN
        out_message := format('Validation failed: question_id %s does not exist.', p_question_id);
        RETURN;
    END IF;

    -- Check that alternative_id exists
    SELECT 1 INTO v_exists FROM app.alternative WHERE alternative_id = p_alternative_id;
    IF NOT FOUND THEN
        out_message := format('Validation failed: alternative_id %s does not exist.', p_alternative_id);
        RETURN;
    END IF;

    -- Uniqueness: Only one response per (exam_attempt_id, question_id)
    SELECT 1 INTO v_exists FROM app.response WHERE exam_attempt_id = p_exam_attempt_id AND question_id = p_question_id;
    IF FOUND THEN
        out_message := format('Validation failed: response already exists for this attempt/question (exam_attempt_id=%s, question_id=%s).', p_exam_attempt_id, p_question_id);
        RETURN;
    END IF;

    -- DML & ERROR LOGGING
    BEGIN
        INSERT INTO app.response (
            exam_attempt_id,
            account_id,
            question_id,
            alternative_id,
            is_correct,
            flag_for_review,
            notes,
            created_by
        )
        VALUES (
            p_exam_attempt_id,
            p_account_id,
            p_question_id,
            p_alternative_id,
            p_is_correct,
            COALESCE(p_flag_for_review, FALSE),
            p_notes,
            p_created_by
        )
        RETURNING response_id INTO v_response_id;

        out_message := format('OK (response_id=%s)', v_response_id);
        RETURN;

    EXCEPTION
        WHEN OTHERS THEN
            v_command := format(
                'CALL app.usp_api_response_create(%s, %s, %s, %s, %s, %s, %L, %L, out_message)',
                COALESCE(p_exam_attempt_id::TEXT, 'NULL'),
                COALESCE(p_account_id::TEXT, 'NULL'),
                COALESCE(p_question_id::TEXT, 'NULL'),
                COALESCE(p_alternative_id::TEXT, 'NULL'),
                COALESCE(p_is_correct::TEXT, 'NULL'),
                COALESCE(p_flag_for_review::TEXT, 'NULL'),
                COALESCE(p_notes, 'NULL'),
                COALESCE(p_created_by, 'NULL')
            );
            v_error_message := SQLERRM;
            v_error_code := SQLSTATE;
            INSERT INTO app.error_log (
                table_name,
                process,
                operation,
                command,
                error_message,
                error_code,
                user_name
            ) VALUES (
                'response',
                'app.usp_api_response_create',
                'INSERT',
                v_command,
                v_error_message,
                v_error_code,
                p_created_by
            );
            out_message := format('Error during insert: %s', v_error_message);
            RETURN;
    END;
END;
$$;
