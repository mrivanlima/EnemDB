CREATE OR REPLACE PROCEDURE app.usp_api_role_create (
    IN  p_role_name     TEXT,
    IN  p_description   TEXT DEFAULT NULL,
    IN  p_created_by    TEXT,
    OUT out_message     TEXT
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_role_id        INTEGER;
    v_exists         INTEGER;
    v_command        TEXT;
    v_error_message  TEXT;
    v_error_code     TEXT;
BEGIN
    -- VALIDATIONS
    IF p_role_name IS NULL OR length(trim(p_role_name)) = 0 THEN
        out_message := 'Validation failed: role_name cannot be empty.';
        RETURN;
    END IF;

    IF p_created_by IS NULL OR length(trim(p_created_by)) = 0 THEN
        out_message := 'Validation failed: created_by cannot be empty.';
        RETURN;
    END IF;

    -- Unique name validation (case-insensitive)
    SELECT 1 INTO v_exists FROM app.role WHERE lower(role_name) = lower(p_role_name) AND is_active = TRUE;
    IF FOUND THEN
        out_message := format('Validation failed: Active role "%s" already exists.', p_role_name);
        RETURN;
    END IF;

    -- DML & ERROR LOGGING
    BEGIN
        INSERT INTO app.role (
            role_name,
            description,
            created_by,
            created_on,
            is_active
        )
        VALUES (
            p_role_name,
            p_description,
            p_created_by,
            NOW(),
            TRUE
        )
        RETURNING role_id INTO v_role_id;

        out_message := format('OK (role_id=%s)', v_role_id);
        RETURN;

    EXCEPTION
        WHEN OTHERS THEN
            v_command := format(
                'CALL app.usp_api_role_create(%L, %L, %L, out_message)',
                p_role_name,
                p_description,
                p_created_by
            );
            v_error_message := SQLERRM;
            v_error_code := SQLSTATE;
            -- Error log pattern
            INSERT INTO app.error_log (
                table_name,
                process,
                operation,
                command,
                error_message,
                error_code,
                user_name
            ) VALUES (
                'role',
                'app.usp_api_role_create',
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
