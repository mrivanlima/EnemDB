CREATE OR REPLACE PROCEDURE app.usp_api_city_create (
    IN p_state_id    INT,
    IN p_city_name   TEXT,
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
    IF p_state_id IS NULL THEN
        out_message := 'Validation failed: state_id cannot be null.';
        RETURN;
    END IF;

    IF p_city_name IS NULL OR length(trim(p_city_name)) = 0 THEN
        out_message := 'Validation failed: city_name cannot be empty.';
        RETURN;
    END IF;

    IF p_created_by IS NULL OR length(trim(p_created_by)) = 0 THEN
        out_message := 'Validation failed: created_by cannot be empty.';
        RETURN;
    END IF;

    -- Validate state_id exists
    SELECT 1 INTO v_exists FROM app.state WHERE state_id = p_state_id;
    IF NOT FOUND THEN
        out_message := format('Validation failed: state_id %s does not exist.', p_state_id);
        RETURN;
    END IF;

    -- Uniqueness: city_name within state
    SELECT 1 INTO v_exists FROM app.city WHERE state_id = p_state_id AND city_name = p_city_name;
    IF FOUND THEN
        out_message := format('Validation failed: city "%s" already exists for this state.', p_city_name);
        RETURN;
    END IF;

    -- DML & ERROR LOGGING
    BEGIN
        INSERT INTO app.city
        (
            state_id,
            city_name,
            created_by,
            created_on
        )
        VALUES
        (
            p_state_id,
            p_city_name,
            p_created_by,
            NOW()
        );

        out_message := 'OK';
        RETURN;

    EXCEPTION
        WHEN OTHERS THEN
            v_command := format(
                'CALL app.usp_api_city_create(p_state_id => %s, p_city_name => %L, p_created_by => %L)',
                COALESCE(p_state_id::TEXT, 'NULL'),
                COALESCE(p_city_name, 'NULL'),
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
                'city',
                'app.usp_api_city_create',
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
