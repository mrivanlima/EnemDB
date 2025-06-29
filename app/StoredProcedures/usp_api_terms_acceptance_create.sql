CREATE OR REPLACE PROCEDURE app.usp_api_terms_acceptance_create (
    IN  p_account_id    INTEGER,
    IN  p_terms_version TEXT,
    IN  p_accepted_by   TEXT,
    IN  p_created_by    TEXT,
    OUT out_message     TEXT
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_terms_acceptance_id INTEGER;
    v_exists              INTEGER;
    v_command             TEXT;
    v_error_message       TEXT;
    v_error_code          TEXT;
BEGIN
    -- VALIDATIONS
    IF p_account_id IS NULL THEN
        out_message := 'Validation failed: account_id cannot be null.';
        RETURN;
    END IF;

    IF p_terms_version IS NULL OR length(trim(p_terms_version)) = 0 THEN
        out_message := 'Validation failed: terms_version cannot be empty.';
        RETURN;
    END IF;

    IF p_accepted_by IS NULL OR length(trim(p_accepted_by)) = 0 THEN
        out_message := 'Validation failed: accepted_by cannot be empty.';
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

    -- DML & ERROR LOGGING
    BEGIN
        INSERT INTO app.terms_acceptance (
            account_id,
            terms_version,
            accepted_on,
            accepted_by,
            is_active,
            created_by,
            created_on
        )
        VALUES (
            p_account_id,
            p_terms_version,
            NOW(),
            p_accepted_by,
            TRUE,
            p_created_by,
            NOW()
        )
        RETURNING terms_acceptance_id INTO v_terms_acceptance_id;

        out_message := format('OK (terms_acceptance_id=%s)', v_terms_acceptance_id);
        RETURN;

    EXCEPTION
        WHEN OTHERS THEN
            v_command := format(
                'CALL app.usp_api_terms_acceptance_create(%s, %L, %L, %L, out_message)',
                COALESCE(p_account_id::TEXT, 'NULL'),
                COALESCE(p_terms_version, 'NULL'),
                COALESCE(p_accepted_by, 'NULL'),
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
                'terms_acceptance',
                'app.usp_api_terms_acceptance_create',
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
