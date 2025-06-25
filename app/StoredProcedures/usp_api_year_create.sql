CREATE OR REPLACE PROCEDURE app.usp_api_year_create (
    IN p_year         SMALLINT,
	IN p_created_by   TEXT,
    OUT out_message   TEXT,
    IN p_year_name    TEXT DEFAULT ''
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
    IF p_year IS NULL OR p_year < 1000 OR p_year > 9999 THEN
        out_message := 'Validation failed: Invalid year (must be a 4-digit number between 1000 and 9999).';
        RETURN;
    END IF;

    IF p_year_name IS NULL OR length(trim(p_year_name)) = 0 THEN
        out_message := 'Validation failed: year_name cannot be empty.';
        RETURN;
    END IF;

    IF p_created_by IS NULL OR length(trim(p_created_by)) = 0 THEN
        out_message := 'Validation failed: created_by cannot be empty.';
        RETURN;
    END IF;

    -- Uniqueness: year
    SELECT 1 INTO v_exists FROM app.year WHERE year = p_year;
    IF FOUND THEN
        out_message := format('Validation failed: year %s already exists.', p_year);
        RETURN;
    END IF;

    -- Uniqueness: year_name
    SELECT 1 INTO v_exists FROM app.year WHERE year_name = p_year_name;
    IF FOUND THEN
        out_message := format('Validation failed: year_name "%s" already exists.', p_year_name);
        RETURN;
    END IF;

    -- DML & ERROR LOGGING
    BEGIN
        INSERT INTO app.year 
        (
            year, 
            year_name, 
            created_by, 
            created_on
        ) 
        VALUES 
        (
            p_year, 
            p_year_name, 
            p_created_by, 
            NOW()
        );

        out_message := 'OK';
        RETURN;

    EXCEPTION
        WHEN OTHERS THEN
            -- Only build the command string here
            v_command := format(
                'CALL app.usp_api_year_create(p_year => %s, p_year_name => %L, p_created_by => %L)',
                COALESCE(p_year::TEXT, 'NULL'),
                COALESCE(p_year_name, 'NULL'),
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
                'year',
                'app.usp_api_year_create',
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
