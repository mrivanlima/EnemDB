CREATE OR REPLACE PROCEDURE app.usp_api_booklet_mapping_create(
    IN p_year_id INTEGER,
    IN p_exam_day SMALLINT,
    IN p_booklet_color_id INTEGER,
    IN p_base_question_no INTEGER,
    IN p_booklet_question_no INTEGER,
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
    IF p_booklet_color_id IS NULL THEN
        out_message := 'Validation failed: booklet_color_id cannot be null.';
        RETURN;
    END IF;
    IF p_base_question_no IS NULL THEN
        out_message := 'Validation failed: base_question_no cannot be null.';
        RETURN;
    END IF;
    IF p_booklet_question_no IS NULL THEN
        out_message := 'Validation failed: booklet_question_no cannot be null.';
        RETURN;
    END IF;
    IF p_created_by IS NULL OR length(trim(p_created_by)) = 0 THEN
        out_message := 'Validation failed: created_by cannot be empty.';
        RETURN;
    END IF;

    -- Uniqueness: mapping for this base question
    SELECT 1 INTO v_exists FROM app.booklet_mapping
    WHERE year_id = p_year_id
      AND exam_day = p_exam_day
      AND booklet_color_id = p_booklet_color_id
      AND base_question_no = p_base_question_no;
    IF FOUND THEN
        out_message := format(
            'Validation failed: Mapping already exists for year_id=%s, exam_day=%s, booklet_color_id=%s, base_question_no=%s.',
            p_year_id, p_exam_day, p_booklet_color_id, p_base_question_no
        );
        RETURN;
    END IF;

    -- DML & ERROR LOGGING
    BEGIN
        INSERT INTO app.booklet_mapping (
            year_id,
            exam_day,
            booklet_color_id,
            base_question_no,
            booklet_question_no,
            created_by,
            created_on
        ) VALUES (
            p_year_id,
            p_exam_day,
            p_booklet_color_id,
            p_base_question_no,
            p_booklet_question_no,
            p_created_by,
            NOW()
        );

        out_message := 'OK';
        RETURN;

    EXCEPTION
        WHEN OTHERS THEN
            v_command := format(
                'CALL app.usp_api_booklet_mapping_create(%s, %s, %s, %s, %s, %L, NULL)',
                COALESCE(p_year_id::TEXT, 'NULL'),
                COALESCE(p_exam_day::TEXT, 'NULL'),
                COALESCE(p_booklet_color_id::TEXT, 'NULL'),
                COALESCE(p_base_question_no::TEXT, 'NULL'),
                COALESCE(p_booklet_question_no::TEXT, 'NULL'),
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
                'booklet_mapping',
                'app.usp_api_booklet_mapping_create',
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
