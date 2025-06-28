CREATE OR REPLACE PROCEDURE app.usp_api_submission_deadline_create(
    IN p_year_id INTEGER,
    IN p_exam_day SMALLINT,
    IN p_deadline TIMESTAMPTZ,
    IN p_created_by TEXT,
    OUT out_message TEXT
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_exists INTEGER;
    v_command TEXT;
    v_error_message TEXT;
    v_error_code TEXT;
BEGIN
    -- VALIDATIONS
    IF p_year_id IS NULL THEN
        out_message := 'Validation failed: year_id cannot be null.';
        RETURN;
    END IF;
    IF p_exam_day IS NULL THEN
        out_message := 'Validation failed: exam_day cannot be null.';
        RETURN;
    END IF;
    IF p_deadline IS NULL THEN
        out_message := 'Validation failed: deadline cannot be null.';
        RETURN;
    END IF;
    IF p_created_by IS NULL OR length(trim(p_created_by)) = 0 THEN
        out_message := 'Validation failed: created_by cannot be empty.';
        RETURN;
    END IF;

    -- Uniqueness: year and day
    SELECT 1 INTO v_exists FROM app.submission_deadline
    WHERE year_id = p_year_id
      AND exam_day = p_exam_day;
    IF FOUND THEN
        out_message := format(
            'Validation failed: Deadline already exists for year_id=%s, exam_day=%s.',
            p_year_id, p_exam_day
        );
        RETURN;
    END IF;

    -- DML & ERROR LOGGING
    BEGIN
        INSERT INTO app.submission_deadline (
            year_id,
            exam_day,
            deadline,
            created_by,
            created_on
        ) VALUES (
            p_year_id,
            p_exam_day,
            p_deadline,
            p_created_by,
            NOW()
        );

        out_message := 'OK';
        RETURN;

    EXCEPTION
        WHEN OTHERS THEN
            v_command := format(
                'CALL app.usp_api_submission_deadline_create(%s, %s, %L, %L, NULL)',
                COALESCE(p_year_id::TEXT, 'NULL'),
                COALESCE(p_exam_day::TEXT, 'NULL'),
                COALESCE(p_deadline::TEXT, 'NULL'),
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
                'submission_deadline',
                'app.usp_api_submission_deadline_create',
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
