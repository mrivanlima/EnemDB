CREATE OR REPLACE PROCEDURE app.usp_api_answer_submission_create(
    IN p_user_id INTEGER,
    IN p_year_id INTEGER,
    IN p_exam_day SMALLINT,
    IN p_booklet_color_id INTEGER,
    IN p_foreign_language TEXT,
    IN p_raw_answers TEXT,
    IN p_mapped_answers TEXT,
    IN p_created_by TEXT,
    OUT out_message TEXT
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_command TEXT;
    v_error_message TEXT;
    v_error_code TEXT;
BEGIN
    -- VALIDATIONS
    IF p_user_id IS NULL THEN
        out_message := 'Validation failed: user_id cannot be null.';
        RETURN;
    END IF;
    IF p_year_id IS NULL THEN
        out_message := 'Validation failed: year_id cannot be null.';
        RETURN;
    END IF;
    IF p_exam_day IS NULL THEN
        out_message := 'Validation failed: exam_day cannot be null.';
        RETURN;
    END IF;
    IF p_booklet_color_id IS NULL THEN
        out_message := 'Validation failed: booklet_color_id cannot be null.';
        RETURN;
    END IF;
    IF p_foreign_language IS NULL OR length(trim(p_foreign_language)) = 0 THEN
        out_message := 'Validation failed: foreign_language cannot be empty.';
        RETURN;
    END IF;
    IF p_raw_answers IS NULL OR length(trim(p_raw_answers)) = 0 THEN
        out_message := 'Validation failed: raw_answers cannot be empty.';
        RETURN;
    END IF;
    IF p_created_by IS NULL OR length(trim(p_created_by)) = 0 THEN
        out_message := 'Validation failed: created_by cannot be empty.';
        RETURN;
    END IF;

    -- DML & ERROR LOGGING
    BEGIN
        INSERT INTO app.answer_submission (
            user_id,
            year_id,
            exam_day,
            booklet_color_id,
            foreign_language,
            raw_answers,
            mapped_answers,
            created_by,
            created_on
        ) VALUES (
            p_user_id,
            p_year_id,
            p_exam_day,
            p_booklet_color_id,
            p_foreign_language,
            p_raw_answers,
            p_mapped_answers,
            p_created_by,
            NOW()
        );

        out_message := 'OK';
        RETURN;

    EXCEPTION
        WHEN OTHERS THEN
            v_command := format(
                'CALL app.usp_api_answer_submission_insert(%s, %s, %s, %s, %L, %L, %L, %L, NULL)',
                COALESCE(p_user_id::TEXT, 'NULL'),
                COALESCE(p_year_id::TEXT, 'NULL'),
                COALESCE(p_exam_day::TEXT, 'NULL'),
                COALESCE(p_booklet_color_id::TEXT, 'NULL'),
                COALESCE(p_foreign_language, 'NULL'),
                COALESCE(p_raw_answers, 'NULL'),
                COALESCE(p_mapped_answers, 'NULL'),
                COALESCE(p_created_by, 'NULL')
            );
            v_error_message := SQLERRM;
            v_error_code := SQLSTATE;
            INSERT INTO app.error_log
            (
                table_name,
                process,
                operation,
                command,
                error_message,
                error_code,
                user_name
            )
            VALUES
            (
                'answer_submission',
                'app.usp_api_answer_submission_insert',
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
