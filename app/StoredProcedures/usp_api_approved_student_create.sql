CREATE OR REPLACE PROCEDURE app.usp_api_approved_student_create(
    IN p_enem_registration VARCHAR,
    IN p_student_name TEXT,
    IN p_year SMALLINT,
    IN p_institution_id INTEGER,
    IN p_institution_name TEXT,
    IN p_institution_abbr TEXT,
    IN p_institution_state_abbr TEXT,
    IN p_campus_name TEXT,
    IN p_course_id INTEGER,
    IN p_course_code TEXT,
    IN p_course_name TEXT,
    IN p_shift TEXT,
    IN p_degree_type TEXT,
    IN p_vagas_concorrencia INTEGER,
    IN p_no_inscricao_enem TEXT,
    IN p_no_modalidade_concorrencia TEXT,
    IN p_st_bonus_perc TEXT,
    IN p_qt_bonus_perc TEXT,
    IN p_no_acao_afirmativa_bonus TEXT,
    IN p_enem_score NUMERIC,
    IN p_cutoff_score NUMERIC,
    IN p_classification INTEGER,
    IN p_high_school_type TEXT,
    IN p_quilombola TEXT,
    IN p_disabled TEXT,
    IN p_tipo_concorrencia TEXT,
    IN p_user_id INTEGER,
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
    -- BASIC VALIDATIONS (add more as needed)
    IF p_enem_registration IS NULL OR length(trim(p_enem_registration)) = 0 THEN
        out_message := 'Validation failed: enem_registration cannot be empty.';
        RETURN;
    END IF;
    IF p_student_name IS NULL OR length(trim(p_student_name)) = 0 THEN
        out_message := 'Validation failed: student_name cannot be empty.';
        RETURN;
    END IF;
    IF p_year IS NULL THEN
        out_message := 'Validation failed: year cannot be null.';
        RETURN;
    END IF;
    IF p_institution_id IS NULL THEN
        out_message := 'Validation failed: institution_id cannot be null.';
        RETURN;
    END IF;
    IF p_course_code IS NULL OR length(trim(p_course_code)) = 0 THEN
        out_message := 'Validation failed: course_code cannot be empty.';
        RETURN;
    END IF;
    IF p_created_by IS NULL OR length(trim(p_created_by)) = 0 THEN
        out_message := 'Validation failed: created_by cannot be empty.';
        RETURN;
    END IF;

    -- Uniqueness check
    SELECT 1 INTO v_exists FROM app.approved_student
    WHERE enem_registration = p_enem_registration
      AND year = p_year
      AND institution_id = p_institution_id
      AND course_code = p_course_code;
    IF FOUND THEN
        out_message := format(
            'Validation failed: Record already exists for registration=%s, year=%s, institution_id=%s, course_code=%s.',
            p_enem_registration, p_year, p_institution_id, p_course_code
        );
        RETURN;
    END IF;

    -- DML & ERROR LOGGING
    BEGIN
        INSERT INTO app.approved_student (
            enem_registration,
            student_name,
            year,
            institution_id,
            institution_name,
            institution_abbr,
            institution_state_abbr,
            campus_name,
            course_id,
            course_code,
            course_name,
            shift,
            degree_type,
            vagas_concorrencia,
            no_inscricao_enem,
            no_modalidade_concorrencia,
            st_bonus_perc,
            qt_bonus_perc,
            no_acao_afirmativa_bonus,
            enem_score,
            cutoff_score,
            classification,
            high_school_type,
            quilombola,
            disabled,
            tipo_concorrencia,
            user_id,
            created_by,
            created_on
        ) VALUES (
            p_enem_registration,
            p_student_name,
            p_year,
            p_institution_id,
            p_institution_name,
            p_institution_abbr,
            p_institution_state_abbr,
            p_campus_name,
            p_course_id,
            p_course_code,
            p_course_name,
            p_shift,
            p_degree_type,
            p_vagas_concorrencia,
            p_no_inscricao_enem,
            p_no_modalidade_concorrencia,
            p_st_bonus_perc,
            p_qt_bonus_perc,
            p_no_acao_afirmativa_bonus,
            p_enem_score,
            p_cutoff_score,
            p_classification,
            p_high_school_type,
            p_quilombola,
            p_disabled,
            p_tipo_concorrencia,
            p_user_id,
            p_created_by,
            NOW()
        );
        out_message := 'OK';
        RETURN;

    EXCEPTION
        WHEN OTHERS THEN
            v_command := format(
                'CALL app.usp_api_approved_student_create(...) -- truncated for brevity'
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
                'approved_student',
                'app.usp_api_approved_student_create',
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
