CREATE OR REPLACE PROCEDURE app.usp_api_account_create (
    IN  p_email             CITEXT,
    IN  p_password_hash     TEXT,
    IN  p_created_by        TEXT,
    OUT out_message         TEXT
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_exists       INTEGER;
    v_account_id   INTEGER;
    v_command      TEXT;
    v_error_message TEXT;
    v_error_code    TEXT;
BEGIN
    -- VALIDATIONS
    IF p_email IS NULL OR length(trim(p_email)) = 0 THEN
        out_message := 'Validation failed: email cannot be empty.';
        RETURN;
    END IF;

    IF p_created_by IS NULL OR length(trim(p_created_by)) = 0 THEN
        out_message := 'Validation failed: created_by cannot be empty.';
        RETURN;
    END IF;

    -- Email format check (duplicate of table CHECK, but for early error)
    IF NOT (p_email ~* '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$') THEN
        out_message := 'Validation failed: email format is invalid.';
        RETURN;
    END IF;

    -- Enforce unique active email (ignore soft-deleted, allow re-use if only soft-deleted exists)
    SELECT account_id INTO v_exists FROM app.account
     WHERE email = p_email AND is_active = TRUE;
    IF FOUND THEN
        out_message := format('Validation failed: An active account with email "%s" already exists.', p_email);
        RETURN;
    END IF;

    -- DML & ERROR LOGGING
    BEGIN
        INSERT INTO app.account (
            email,
            password_hash,
            is_email_verified,
            is_active,
            soft_deleted_at,
            created_by,
            created_on,
            modified_by,
            modified_on
        ) VALUES (
            p_email,
            p_password_hash,
            FALSE,     -- is_email_verified at creation
            TRUE,      -- is_active
            NULL,      -- soft_deleted_at
            p_created_by,
            NOW(),
            NULL,
            NULL
        )
        RETURNING account_id INTO v_account_id;

        out_message := format('OK (account_id=%s)', v_account_id);
        RETURN;

    EXCEPTION
        WHEN OTHERS THEN
            v_command := format(
                'CALL app.usp_api_account_create(%L, %L, %L, out_message)',
                p_email,
                COALESCE(p_password_hash, 'NULL'),
                p_created_by
            );
            v_error_message := SQLERRM;
            v_error_code := SQLSTATE;
            -- Error log pattern matches your example, add table if not present
            INSERT INTO app.error_log (
                table_name,
                process,
                operation,
                command,
                error_message,
                error_code,
                user_name
            ) VALUES (
                'account',
                'app.usp_api_account_create',
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
