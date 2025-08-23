CREATE OR REPLACE PROCEDURE app.usp_api_user_email_verification_create (
    IN  p_email   TEXT,
    IN  p_created_by INTEGER,
    OUT out_user_email_verification_id INTEGER,
    OUT out_token TEXT,
    OUT out_message TEXT,
    OUT out_haserror BOOLEAN
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_user_login_id INTEGER;
    v_exists INTEGER;
    v_command TEXT;
    v_error_message TEXT;
    v_error_code TEXT;
    v_now TIMESTAMPTZ := NOW();
BEGIN
    out_haserror := FALSE;

    -- Validations
    IF p_email IS NULL OR length(trim(p_email)) = 0 THEN
        out_message := 'O e-mail é obrigatório.';
        out_haserror := TRUE;
        RETURN;
    END IF;

    IF p_created_by IS NULL THEN
        out_message := 'O campo created_by é obrigatório.';
        out_haserror := TRUE;
        RETURN;
    END IF;

    -- Get user_login_id
    SELECT user_login_id INTO v_user_login_id
    FROM app.user_login
    WHERE email = p_email
      AND soft_deleted_at IS NULL;

    IF NOT FOUND THEN
        out_message := format('Usuário com e-mail "%s" não encontrado.', p_email);
        out_haserror := TRUE;
        RETURN;
    END IF;

    -- Generate token
    out_token := encode(digest(gen_random_uuid()::text, 'sha256'), 'hex');

    -- Ensure uniqueness
    SELECT 1 INTO v_exists
    FROM app.user_email_verification
    WHERE verification_token = out_token;

    IF FOUND THEN
        out_message := 'Token de verificação já gerado. Tente novamente.';
        out_haserror := TRUE;
        RETURN;
    END IF;

    -- Insert
    BEGIN
        INSERT INTO app.user_email_verification (
            user_login_id,
            verification_token,
            expires_at,
            created_by,
            created_on
        )
        VALUES (
            v_user_login_id,
            out_token,
            v_now + interval '24 hours',
            p_created_by,
            v_now
        )
        RETURNING user_email_verification_id INTO out_user_email_verification_id;

        out_message := 'Token de verificação criado com sucesso.';
        RETURN;

    EXCEPTION
        WHEN OTHERS THEN
            v_command := format(
                'CALL app.usp_api_user_email_verification_create(p_email => %L, p_created_by => %s)',
                COALESCE(p_email, 'NULL'),
                COALESCE(p_created_by::TEXT, 'NULL')
            );
            v_error_message := SQLERRM;
            v_error_code := SQLSTATE;

            INSERT INTO app.error_log (
                table_name,
                process,
                operation,
                command,
                error_message,
                error_code,
                user_name
            )
            VALUES (
                'user_email_verification',
                'app.usp_api_user_email_verification_create',
                'INSERT',
                v_command,
                v_error_message,
                v_error_code,
                p_created_by
            );

            out_message := format('Erro ao criar token: %s', v_error_message);
            out_haserror := TRUE;
            RETURN;
    END;
END;
$$;
