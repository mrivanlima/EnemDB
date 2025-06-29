CREATE OR REPLACE PROCEDURE app.usp_api_account_auth_provider_create (
    IN  p_account_id       INTEGER,
    IN  p_provider_name    TEXT,
    IN  p_provider_uid     TEXT,
    IN  p_created_by       TEXT,
    OUT out_message        TEXT
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_exists               INTEGER;
    v_account_auth_provider_id INTEGER;
    v_command              TEXT;
    v_error_message        TEXT;
    v_error_code           TEXT;
BEGIN
    -- VALIDATIONS
    IF p_account_id IS NULL THEN
        out_message := 'Validation failed: account_id cannot be null.';
        RETURN;
    END IF;

    IF p_provider_name IS NULL OR length(trim(p_provider_name)) = 0 THEN
        out_message := 'Validation failed: provider_name cannot be empty.';
        RETURN;
    END IF;

    IF p_provider_uid IS NULL OR length(trim(p_provider_uid)) = 0 THEN
        out_message := 'Validation failed: provider_uid cannot be empty.';
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

    -- Prevent duplicate (active) provider link for the same provider_name + provider_uid
    SELECT 1 INTO v_exists FROM app.account_auth_provider
     WHERE provider_name = p_provider_name AND provider_uid = p_provider_uid AND is_active = TRUE;
    IF FOUND THEN
        out_message := format('Validation failed: Provider "%s" with UID "%s" already linked.', p_provider_name, p_provider_uid);
        RETURN;
    END IF;

    -- DML & ERROR LOGGING
    BEGIN
        INSERT INTO app.account_auth_provider (
            account_id,
            provider_name,
            provider_uid,
            created_by,
            created_on,
            is_active,
            linked_on
        )
        VALUES (
            p_account_id,
            p_provider_name,
            p_provider_uid,
            p_created_by,
            NOW(),
            TRUE,
            NOW()
        )
        RETURNING account_auth_provider_id INTO v_account_auth_provider_id;

        out_message := format('OK (account_auth_provider_id=%s)', v_account_auth_provider_id);
        RETURN;

    EXCEPTION
        WHEN OTHERS THEN
            v_command := format(
                'CALL app.usp_api_account_auth_provider_create(%s, %L, %L, %L, out_message)',
                COALESCE(p_account_id::TEXT, 'NULL'),
                COALESCE(p_provider_name, 'NULL'),
                COALESCE(p_provider_uid, 'NULL'),
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
                'account_auth_provider',
                'app.usp_api_account_auth_provider_create',
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
