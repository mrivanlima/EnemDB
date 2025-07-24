CREATE OR REPLACE PROCEDURE app.usp_api_user_email_verification_regenerate (
    IN p_user_login_id INTEGER,
    IN p_created_by    INTEGER,
    OUT out_token      TEXT,
    OUT out_message    TEXT,
    OUT out_haserror   BIT
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_command        TEXT;
    v_error_message  TEXT;
    v_error_code     TEXT;
    v_token          TEXT;
    v_expires_at     TIMESTAMPTZ := NOW() + INTERVAL '24 hours';
BEGIN
    out_haserror := B'0';

    -- Validações
    IF p_user_login_id IS NULL THEN
        out_message := 'O ID do usuário é obrigatório.';
        out_haserror := B'1';
        RETURN;
    END IF;

    IF p_created_by IS NULL THEN
        out_message := 'O campo created_by é obrigatório.';
        out_haserror := B'1';
        RETURN;
    END IF;

    -- Verifica se o user_login existe
    IF NOT EXISTS (SELECT 1 FROM app.user_login WHERE user_login_id = p_user_login_id) THEN
        out_message := format('Usuário com ID %s não encontrado.', p_user_login_id);
        out_haserror := B'1';
        RETURN;
    END IF;

    -- Expira tokens antigos ainda válidos
    UPDATE app.user_email_verification
    SET expires_at = NOW()
    WHERE user_login_id = p_user_login_id
      AND confirmed_at IS NULL
      AND expires_at > NOW();

    -- Geração de novo token (UUIDv4 + segurança extra)
    v_token := encode(gen_random_bytes(32), 'hex');

    -- Criação do novo token
    INSERT INTO app.user_email_verification (
        user_login_id,
        verification_token,
        expires_at,
        created_by,
        created_on
    ) VALUES (
        p_user_login_id,
        v_token,
        v_expires_at,
        p_created_by,
        NOW()
    );

    out_token := v_token;
    out_message := 'Novo token gerado com sucesso.';
    RETURN;

EXCEPTION
    WHEN OTHERS THEN
        v_command := format(
            'CALL app.usp_api_user_email_verification_regenerate(p_user_login_id => %s, p_created_by => %s)',
            COALESCE(p_user_login_id::TEXT, 'NULL'),
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
            'app.usp_api_user_email_verification_regenerate',
            'INSERT',
            v_command,
            v_error_message,
            v_error_code,
            p_created_by
        );

        out_message := format('Erro ao gerar novo token: %s', v_error_message);
        out_haserror := B'1';
        RETURN;
END;
$$;
