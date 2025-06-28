CREATE OR REPLACE PROCEDURE app.usp_api_question_create (
    IN  p_exam_year              INTEGER,
    IN  p_booklet_color          TEXT,
    IN  p_question_position      INTEGER,
    IN  p_subject_area           TEXT,
    IN  p_skill_code             TEXT,
    IN  p_difficulty_tri         NUMERIC,
    IN  p_thematic_area          TEXT,
    IN  p_question_text          TEXT,
    IN  p_image_url              TEXT,
    IN  p_notes                  TEXT,
    IN  p_created_by             TEXT,
    IN  p_source_pdf_page        INTEGER,
    IN  p_original_enem_code     TEXT,
    OUT out_message              TEXT
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_exists INTEGER;
    v_command TEXT;
    v_error_message TEXT;
    v_error_code TEXT;
    v_question_id INTEGER;
BEGIN
    -- VALIDATIONS
    IF p_exam_year IS NULL THEN
        out_message := 'Validation failed: exam_year cannot be null.';
        RETURN;
    END IF;

    IF p_booklet_color IS NULL OR length(trim(p_booklet_color)) = 0 THEN
        out_message := 'Validation failed: booklet_color cannot be empty.';
        RETURN;
    END IF;

    IF p_question_position IS NULL THEN
        out_message := 'Validation failed: question_position cannot be null.';
        RETURN;
    END IF;

    IF p_subject_area IS NULL OR length(trim(p_subject_area)) = 0 THEN
        out_message := 'Validation failed: subject_area cannot be empty.';
        RETURN;
    END IF;

    IF p_skill_code IS NULL OR length(trim(p_skill_code)) = 0 THEN
        out_message := 'Validation failed: skill_code cannot be empty.';
        RETURN;
    END IF;

    IF p_question_text IS NULL OR length(trim(p_question_text)) = 0 THEN
        out_message := 'Validation failed: question_text cannot be empty.';
        RETURN;
    END IF;

    IF p_created_by IS NULL OR length(trim(p_created_by)) = 0 THEN
        out_message := 'Validation failed: created_by cannot be empty.';
        RETURN;
    END IF;

    -- Uniqueness: One question per (exam_year, booklet_color, question_position)
    SELECT 1 INTO v_exists
    FROM app.question
    WHERE exam_year = p_exam_year
      AND booklet_color = p_booklet_color
      AND question_position = p_question_position;
    IF FOUND THEN
        out_message := format(
            'Validation failed: Question already exists for year %s, booklet "%s", position %s.',
            p_exam_year, p_booklet_color, p_question_position
        );
        RETURN;
    END IF;

    -- DML & ERROR LOGGING
    BEGIN
        INSERT INTO app.question (
            exam_year,
            booklet_color,
            question_position,
            subject_area,
            skill_code,
            difficulty_tri,
            thematic_area,
            question_text,
            image_url,
            notes,
            created_by,
            source_pdf_page,
            original_enem_code
        )
        VALUES (
            p_exam_year,
            p_booklet_color,
            p_question_position,
            p_subject_area,
            p_skill_code,
            p_difficulty_tri,
            p_thematic_area,
            p_question_text,
            p_image_url,
            p_notes,
            p_created_by,
            p_source_pdf_page,
            p_original_enem_code
        )
        RETURNING question_id INTO v_question_id;

        out_message := format('OK (question_id=%s)', v_question_id);
        RETURN;

    EXCEPTION
        WHEN OTHERS THEN
            v_command := format(
                'CALL app.usp_api_question_create(%s, %L, %s, %L, %L, %s, %L, %L, %L, %L, %L, %s, %L, out_message)',
                COALESCE(p_exam_year::TEXT, 'NULL'),
                COALESCE(p_booklet_color, 'NULL'),
                COALESCE(p_question_position::TEXT, 'NULL'),
                COALESCE(p_subject_area, 'NULL'),
                COALESCE(p_skill_code, 'NULL'),
                COALESCE(p_difficulty_tri::TEXT, 'NULL'),
                COALESCE(p_thematic_area, 'NULL'),
                COALESCE(p_question_text, 'NULL'),
                COALESCE(p_image_url, 'NULL'),
                COALESCE(p_notes, 'NULL'),
                COALESCE(p_created_by, 'NULL'),
                COALESCE(p_source_pdf_page::TEXT, 'NULL'),
                COALESCE(p_original_enem_code, 'NULL')
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
                'question',
                'app.usp_api_question_create',
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
