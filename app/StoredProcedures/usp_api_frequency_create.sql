CREATE OR REPLACE PROCEDURE app.usp_api_frequency_create (
    IN p_frequency_name   TEXT,
    IN p_created_by       TEXT,
    OUT out_message       TEXT
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
    IF p_frequency_name IS NULL OR length(trim(p_frequency_name)) = 0 THEN
        out_message := 'Validation failed: frequency_name cannot be empty.';
        RETURN;
    END IF;

    IF p_created_by IS NULL OR length(trim(p_created_by)) = 0 THEN
        out_message := 'Validation failed: created_by cannot be empty.';
        RETURN;
    END IF;

    -- Uniqueness: frequency_name
    SELECT 1 INTO v_exists FROM app.frequency WHERE frequency_name = p_frequency_name;
    IF FOUND THEN
        out_message := format('Validation failed: frequency_name "%s" already exists.', p_frequency_name);
        RETURN;
    END IF;

    -- DML & ERROR LOGGING
    BEGIN
        INSERT INTO app.frequency
        (
            frequency_name,
            created_by,
            created_on
        )
        VALUES
        (
            p_frequency_name,
            p_created_by,
            NOW()
        );

        out_message := 'OK';
        RETURN;

    EXCEPTION
        WHEN OTHERS THEN
            v_command := format(
                'CALL app.usp_api_frequency_create(p_frequency_name => %L, p_created_by => %L)',
                COALESCE(p_frequency_name, 'NULL'),
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
                'frequency',
                'app.usp_api_frequency_create',
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
