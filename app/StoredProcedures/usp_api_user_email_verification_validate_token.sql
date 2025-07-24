CREATE OR REPLACE PROCEDURE app.usp_api_user_email_verification_validate_token (
    IN p_verification_token TEXT,
    OUT out_user_login_id   INTEGER,
    OUT out_message         TEXT,
    OUT out_haserror        BIT
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_command        TEXT;
    v_error_message  TEXT;
    v_error_code     TEXT;
BEGIN
    out_haserror := B'0';
    out_user_login_id := NULL;

    -- Validação do parâmetro
    IF p_verification_token IS NULL OR length(trim(p_verification_token)) = 0 THEN
        out_message := 'O token de verificação é obrigatório.';
        out_haserror := B'1';
        RETURN;
    END IF;

    -- Busca do token válido
    SELECT user_login_id
    INTO out_user_login_id
    FROM app.user_email_verification
    WHERE verification_token = p_verification_token
      AND confirmed_at IS NULL
      AND expires_at > NOW()
    LIMIT 1;

    IF NOT FOUND THEN
        out_message := 'Token inválido ou expirado.';
        out_haserror := B'1';
        RETURN;
    END IF;

    out_message := 'Token válido.';
    RETURN;

EXCEPTION
    WHEN OTHERS THEN
        v_command := format(
            'CALL app.usp_api_user_email_verification_validate_token(p_verification_token => %L)',
            COALESCE(p_verification_token, 'NULL')
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
            'app.usp_api_user_email_verification_validate_token',
            'SELECT',
            v_command,
            v_error_message,
            v_error_code,
            NULL
        );

        out_message := format('Erro ao validar token: %s', v_error_message);
        out_haserror := B'1';
        RETURN;
END;
$$;
