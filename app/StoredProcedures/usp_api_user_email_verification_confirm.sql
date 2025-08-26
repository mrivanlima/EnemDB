CREATE OR REPLACE PROCEDURE app.usp_api_user_email_verification_confirm (
    IN p_verification_token TEXT,
    IN p_modified_by        INTEGER,
    OUT out_message         TEXT,
    OUT out_haserror        BOOLEAN
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_user_login_id     INTEGER;
    v_verification_id   INTEGER;
    v_expires_at        TIMESTAMPTZ;
    v_confirmed_at      TIMESTAMPTZ;
    v_now               TIMESTAMPTZ := NOW();
    v_command           TEXT;
    v_error_message     TEXT;
    v_error_code        TEXT;
BEGIN
    out_haserror := FALSE;

    -- Validação de entrada
    IF p_verification_token IS NULL OR length(trim(p_verification_token)) = 0 THEN
        out_message := 'Token de verificação não pode ser vazio.';
        out_haserror := TRUE;
        RETURN;
    END IF;

    IF p_modified_by IS NULL THEN
        out_message := 'Campo modified_by é obrigatório.';
        out_haserror := TRUE;
        RETURN;
    END IF;

    -- Buscar dados do token
    SELECT user_email_verification_id, user_login_id, expires_at, used_on
    INTO v_verification_id, v_user_login_id, v_expires_at, v_confirmed_at
    FROM app.user_email_verification
    WHERE verification_token = p_verification_token;

    IF NOT FOUND THEN
        out_message := 'Token de verificação inválido.';
        out_haserror := TRUE;
        RETURN;
    END IF;

    -- Verifica se já foi usado
    IF v_confirmed_at IS NOT NULL THEN
        out_message := 'Token de verificação já foi utilizado.';
        out_haserror := TRUE;
        RETURN;
    END IF;

    -- Verifica expiração
    IF v_expires_at < v_now THEN
        out_message := 'Token de verificação expirado.';
        out_haserror := TRUE;
        RETURN;
    END IF;

    -- Atualiza registro
    BEGIN
        UPDATE app.user_login
        SET is_email_verified = TRUE,
            modified_by = p_modified_by,
            modified_on = v_now
        WHERE user_login_id = v_user_login_id;

        UPDATE app.user_email_verification
        SET is_used = TRUE,
            used_on = v_now
        WHERE user_email_verification_id = v_verification_id;


        out_message := 'E-mail confirmado com sucesso.';
        RETURN;

    EXCEPTION
        WHEN OTHERS THEN
            v_command := format(
                'CALL app.usp_api_user_email_verification_confirm(p_verification_token => %L, p_modified_by => %s)',
                COALESCE(p_verification_token, 'NULL'),
                COALESCE(p_modified_by::TEXT, 'NULL')
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
                'app.usp_api_user_email_verification_confirm',
                'UPDATE',
                v_command,
                v_error_message,
                v_error_code,
                p_modified_by
            );

            out_message := format('Erro ao confirmar e-mail: %s', v_error_message);
            out_haserror := TRUE;
            RETURN;
    END;
END;
$$;
