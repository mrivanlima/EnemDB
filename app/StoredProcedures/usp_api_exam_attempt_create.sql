CREATE OR REPLACE PROCEDURE app.usp_api_exam_attempt_create (
    IN  p_account_id             INTEGER,
    IN  p_exam_year              INTEGER,
    IN  p_booklet_color          TEXT,
    IN  p_test_day_number        INTEGER,
    IN  p_started_on             TIMESTAMPTZ DEFAULT NOW(),
    IN  p_finished_on            TIMESTAMPTZ DEFAULT NULL,
    IN  p_score                  NUMERIC DEFAULT NULL,
    IN  p_is_simulation          BOOLEAN DEFAULT FALSE,
    IN  p_notes                  TEXT DEFAULT NULL,
    IN  p_created_by             TEXT,
    OUT out_message              TEXT
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_exists INTEGER;
    v_command TEXT;
    v_error_message TEXT;
    v_error_code TEXT;
    v_exam_attempt_id INTEGER;
BEGIN
    -- VALIDATIONS
    IF p_account_id IS NULL THEN
        out_message := 'Validation failed: account_id cannot be null.';
        RETURN;
    END IF;

    IF p_exam_year IS NULL THEN
        out_message := 'Validation failed: exam_year cannot be null.';
        RETURN;
    END IF;

    IF p_booklet_color IS NULL OR length(trim(p_booklet_color)) = 0 THEN
        out_message := 'Validation failed: booklet_color cannot be empty.';
        RETURN;
    END IF;

    IF p_test_day_number IS NULL THEN
        out_message := 'Validation failed: test_day_number cannot be null.';
        RETURN;
    END IF;

    IF p_created_by IS NULL OR length(trim(p_created_by)) = 0 THEN
        out_message := 'Validation failed: created_by cannot be empty.';
        RETURN;
    END IF;

    -- Check that account_id exists
    SELECT 1 INTO v_exists FROM app.account WHERE account_id = p_account_id;
    IF NOT FOUND THEN
        out_message := format('Validation failed: account_id %s does not exist.', p_account_id);
        RETURN;
    END IF;

    -- Uniqueness: One attempt per user, per exam, per day, per booklet (enforced if needed, comment/uncomment)
    -- SELECT 1 INTO v_exists FROM app.exam_attempt WHERE account_id = p_account_id AND exam_year = p_exam_year AND booklet_color = p_booklet_color AND test_day_number = p_test_day_number;
    -- IF FOUND THEN
    --     out_message := format('Validation failed: Exam attempt already exists for user %s, year %s, booklet "%s", day %s.', p_account_id, p_exam_year, p_booklet_color, p_test_day_number);
    --     RETURN;
    -- END IF;

    -- DML & ERROR LOGGING
    BEGIN
        INSERT INTO app.exam_attempt (
            account_id,
            exam_year,
            booklet_color,
            test_day_number,
            started_on,
            finished_on,
            score,
            is_simulation,
            notes,
            created_by
        )
        VALUES (
            p_account_id,
            p_exam_year,
            p_booklet_color,
            p_test_day_number,
            COALESCE(p_started_on, NOW()),
            p_finished_on,
            p_score,
            COALESCE(p_is_simulation, FALSE),
            p_notes,
            p_created_by
        )
        RETURNING exam_attempt_id INTO v_exam_attempt_id;

        out_message := format('OK (exam_attempt_id=%s)', v_exam_attempt_id);
        RETURN;

    EXCEPTION
        WHEN OTHERS THEN
            v_command := format(
                'CALL app.usp_api_exam_attempt_create(%s, %s, %L, %s, %L, %L, %s, %s, %L, %L, out_message)',
                COALESCE(p_account_id::TEXT, 'NULL'),
                COALESCE(p_exam_year::TEXT, 'NULL'),
                COALESCE(p_booklet_color, 'NULL'),
                COALESCE(p_test_day_number::TEXT, 'NULL'),
                COALESCE(p_started_on::TEXT, 'NULL'),
                COALESCE(p_finished_on::TEXT, 'NULL'),
                COALESCE(p_score::TEXT, 'NULL'),
                COALESCE(p_is_simulation::TEXT, 'NULL'),
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
                'exam_attempt',
                'app.usp_api_exam_attempt_create',
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
