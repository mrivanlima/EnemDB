CREATE OR REPLACE PROCEDURE app.usp_api_university_category_create (
    IN p_university_category_name  TEXT,
    IN p_created_by                TEXT,
    OUT out_message                TEXT
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
    IF p_university_category_name IS NULL OR length(trim(p_university_category_name)) = 0 THEN
        out_message := 'Validation failed: university_category_name cannot be empty.';
        RETURN;
    END IF;

    IF p_created_by IS NULL OR length(trim(p_created_by)) = 0 THEN
        out_message := 'Validation failed: created_by cannot be empty.';
        RETURN;
    END IF;

    -- Uniqueness
    SELECT 1 INTO v_exists FROM app.university_category WHERE university_category_name = p_university_category_name;
    IF FOUND THEN
        out_message := format('Validation failed: university_category_name "%s" already exists.', p_university_category_name);
        RETURN;
    END IF;

    -- DML & ERROR LOGGING
    BEGIN
        INSERT INTO app.university_category
        (
            university_category_name,
            created_by,
            created_on
        )
        VALUES
        (
            p_university_category_name,
            p_created_by,
            NOW()
        );

        out_message := 'OK';
        RETURN;

    EXCEPTION
        WHEN OTHERS THEN
            v_command := format(
                'CALL app.usp_api_university_category_create(p_university_category_name => %L, p_created_by => %L)',
                COALESCE(p_university_category_name, 'NULL'),
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
                'university_category',
                'app.usp_api_university_category_create',
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
