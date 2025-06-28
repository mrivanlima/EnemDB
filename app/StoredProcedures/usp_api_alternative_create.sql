CREATE OR REPLACE PROCEDURE app.usp_api_alternative_create (
    IN  p_question_id          INTEGER,
    IN  p_option_letter        TEXT,
    IN  p_option_text          TEXT,
    IN  p_is_correct           BOOLEAN,
    IN  p_image_url            TEXT,
    IN  p_notes                TEXT,
    IN  p_created_by           TEXT,
    OUT out_message            TEXT
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_exists INTEGER;
    v_command TEXT;
    v_error_message TEXT;
    v_error_code TEXT;
    v_alternative_id INTEGER;
BEGIN
    -- VALIDATIONS
    IF p_question_id IS NULL THEN
        out_message := 'Validation failed: question_id cannot be null.';
        RETURN;
    END IF;

    IF p_option_letter IS NULL OR length(trim(p_option_letter)) = 0 THEN
        out_message := 'Validation failed: option_letter cannot be empty.';
        RETURN;
    END IF;

    IF NOT (p_option_letter IN ('A', 'B', 'C', 'D', 'E')) THEN
        out_message := format('Validation failed: option_letter "%s" must be A, B, C, D, or E.', p_option_letter);
        RETURN;
    END IF;

    IF p_option_text IS NULL OR length(trim(p_option_text)) = 0 THEN
        out_message := 'Validation failed: option_text cannot be empty.';
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

    -- Check that question_id exists
    SELECT 1 INTO v_exists FROM app.question WHERE question_id = p_question_id;
    IF NOT FOUND THEN
        out_message := format('Validation failed: question_id %s does not exist.', p_question_id);
        RETURN;
    END IF;

    -- Ensure only one alternative per (question_id, option_letter)
    SELECT 1 INTO v_exists FROM app.alternative WHERE question_id = p_question_id AND option_letter = p_option_letter;
    IF FOUND THEN
        out_message := format(
            'Validation failed: alternative "%s" already exists for question_id %s.',
            p_option_letter, p_question_id
        );
        RETURN;
    END IF;

    -- DML & ERROR LOGGING
    BEGIN
        INSERT INTO app.alternative (
            question_id,
            option_letter,
            option_text,
            is_correct,
            image_url,
            notes,
            created_by
        ) VALUES (
            p_question_id,
            p_option_letter,
            p_option_text,
            p_is_correct,
            p_image_url,
            p_notes,
            p_created_by
        )
        RETURNING alternative_id INTO v_alternative_id;

        out_message := format('OK (alternative_id=%s)', v_alternative_id);
        RETURN;

    EXCEPTION
        WHEN OTHERS THEN
            v_command := format(
                'CALL app.usp_api_alternative_create(%s, %L, %L, %s, %L, %L, %L, out_message)',
                COALESCE(p_question_id::TEXT, 'NULL'),
                COALESCE(p_option_letter, 'NULL'),
                COALESCE(p_option_text, 'NULL'),
                COALESCE(p_is_correct::TEXT, 'NULL'),
                COALESCE(p_image_url, 'NULL'),
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
                'alternative',
                'app.usp_api_alternative_create',
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
