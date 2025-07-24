CREATE OR REPLACE PROCEDURE app.usp_api_user_email_verification_confirm_token (
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

    -- Confirmação do token
    BEGIN
        UPDATE app.user_email_verification
        SET confirmed_at = NOW()
        WHERE verification_token = p_verification_token
          AND confirmed_at IS NULL
          AND expires_at > NOW()
        RETURNING user_login_id INTO out_user_login_id;

        IF NOT FOUND THEN
            out_message := 'Token inválido, expirado ou já confirmado.';
            out_haserror := B'1';
            RETURN;
        END IF;

        -- Atualiza user_login para marcar e-mail como verificado
        UPDATE app.user_login
        SET is_email_verified = TRUE,
            modified_on = NOW()
        WHERE user_login_id = out_user_login_id;

        out_message := 'E-mail confirmado com sucesso.';
        RETURN;

    EXCEPTION
        WHEN OTHERS THEN
            v_command := format(
                'CALL app.usp_api_user_email_verification_confirm_token(p_verification_token => %L)',
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
                'app.usp_api_user_email_verification_confirm_token',
                'UPDATE',
                v_command,
                v_error_message,
                v_error_code,
                NULL
            );

            out_message := format('Erro ao confirmar e-mail: %s', v_error_message);
            out_haserror := B'1';
            RETURN;
    END;
END;
$$;
