CREATE OR REPLACE PROCEDURE app.usp_api_state_create (
    IN p_region_id   INT,
    IN p_state_abbr  TEXT,
    IN p_state_name  TEXT,
    IN p_created_by  TEXT,
    OUT out_message  TEXT
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
    IF p_region_id IS NULL THEN
        out_message := 'Validation failed: region_id cannot be null.';
        RETURN;
    END IF;

    IF p_state_abbr IS NULL OR length(trim(p_state_abbr)) = 0 THEN
        out_message := 'Validation failed: state_abbr cannot be empty.';
        RETURN;
    END IF;

    IF p_state_name IS NULL OR length(trim(p_state_name)) = 0 THEN
        out_message := 'Validation failed: state_name cannot be empty.';
        RETURN;
    END IF;

    IF p_created_by IS NULL OR length(trim(p_created_by)) = 0 THEN
        out_message := 'Validation failed: created_by cannot be empty.';
        RETURN;
    END IF;

    -- Validate region_id exists
    SELECT 1 INTO v_exists FROM app.region WHERE region_id = p_region_id;
    IF NOT FOUND THEN
        out_message := format('Validation failed: region_id %s does not exist.', p_region_id);
        RETURN;
    END IF;

    -- Uniqueness: state_abbr
    SELECT 1 INTO v_exists FROM app.state WHERE state_abbr = p_state_abbr;
    IF FOUND THEN
        out_message := format('Validation failed: state_abbr "%s" already exists.', p_state_abbr);
        RETURN;
    END IF;

    -- Uniqueness: state_name
    SELECT 1 INTO v_exists FROM app.state WHERE state_name = p_state_name;
    IF FOUND THEN
        out_message := format('Validation failed: state_name "%s" already exists.', p_state_name);
        RETURN;
    END IF;

    -- DML & ERROR LOGGING
    BEGIN
        INSERT INTO app.state
        (
            region_id,
            state_abbr,
            state_name,
            created_by,
            created_on
        )
        VALUES
        (
            p_region_id,
            p_state_abbr,
            p_state_name,
            p_created_by,
            NOW()
        );

        out_message := 'OK';
        RETURN;

    EXCEPTION
        WHEN OTHERS THEN
            v_command := format(
                'CALL app.usp_api_state_create(p_region_id => %s, p_state_abbr => %L, p_state_name => %L, p_created_by => %L)',
                COALESCE(p_region_id::TEXT, 'NULL'),
                COALESCE(p_state_abbr, 'NULL'),
                COALESCE(p_state_name, 'NULL'),
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
                'state',
                'app.usp_api_state_create',
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
