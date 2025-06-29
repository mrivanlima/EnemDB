CREATE OR REPLACE PROCEDURE app.usp_api_password_reset_create (
    IN  p_account_id     INTEGER,
    IN  p_reset_token    TEXT,
    IN  p_created_by     TEXT,
    OUT out_message      TEXT
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_exists            INTEGER;
    v_password_reset_id INTEGER;
    v_command           TEXT;
    v_error_message     TEXT;
    v_error_code        TEXT;
BEGIN
    -- VALIDATIONS
    IF p_account_id IS NULL THEN
        out_message := 'Validation failed: account_id cannot be null.';
        RETURN;
    END IF;

    IF p_reset_token IS NULL OR length(trim(p_reset_token)) = 0 THEN
        out_message := 'Validation failed: reset_token cannot be empty.';
        RETURN;
    END IF;

    IF p_created_by IS NULL OR length(trim(p_created_by)) = 0 THEN
        out_message := 'Validation failed: created_by cannot be empty.';
        RETURN;
    END IF;

    -- Ensure account exists and is active
    SELECT 1 INTO v_exists FROM app.account WHERE account_id = p_account_id AND is_active = TRUE;
    IF NOT FOUND THEN
        out_message := format('Validation failed: account_id %s does not exist or is not active.', p_account_id);
        RETURN;
    END IF;

    -- Prevent duplicate active token
    SELECT 1 INTO v_exists FROM app.password_reset
     WHERE reset_token = p_reset_token AND is_active = TRUE;
    IF FOUND THEN
        out_message := format('Validation failed: Reset token "%s" is already in use.', p_reset_token);
        RETURN;
    END IF;

    -- DML & ERROR LOGGING
    BEGIN
        INSERT INTO app.password_reset (
            account_id,
            reset_token,
            is_used,
            is_active,
            requested_on,
            created_by,
            created_on
        )
        VALUES (
            p_account_id,
            p_reset_token,
            FALSE,
            TRUE,
            NOW(),
            p_created_by,
            NOW()
        )
        RETURNING password_reset_id INTO v_password_reset_id;

        out_message := format('OK (password_reset_id=%s)', v_password_reset_id);
        RETURN;

    EXCEPTION
        WHEN OTHERS THEN
            v_command := format(
                'CALL app.usp_api_password_reset_create(%s, %L, %L, out_message)',
                COALESCE(p_account_id::TEXT, 'NULL'),
                COALESCE(p_reset_token, 'NULL'),
                COALESCE(p_created_by, 'NULL')
            );
            v_error_message := SQLERRM;
            v_error_code := SQLSTATE;
            -- Error log
            INSERT INTO app.error_log (
                table_name,
                process,
                operation,
                command,
                error_message,
                error_code,
                user_name
            ) VALUES (
                'password_reset',
                'app.usp_api_password_reset_create',
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
