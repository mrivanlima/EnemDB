CREATE OR REPLACE PROCEDURE app.usp_api_user_login_attempts_update (
    IN  p_user_login_id    INTEGER,
    IN  p_max_attempts     INTEGER DEFAULT 5,   -- limite de tentativas
    OUT out_login_attempts INTEGER,
    OUT out_is_locked      BOOLEAN,
    OUT out_message        TEXT,
    OUT out_haserror       BOOLEAN
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_command        TEXT;
    v_error_message  TEXT;
    v_error_code     TEXT;
BEGIN
    out_haserror := FALSE;

    -- =========================
    -- Validação de entrada
    -- =========================
    IF p_user_login_id IS NULL OR p_user_login_id <= 0 THEN
        out_message := 'Validação falhou: user_login_id inválido.';
        out_haserror := TRUE;
        RETURN;
    END IF;

    -- =========================
    -- Atualizar tentativas
    -- =========================
    UPDATE app.user_login
       SET login_attempts = COALESCE(login_attempts, 0) + 1,
           modified_on    = NOW()
     WHERE user_login_id = p_user_login_id
     RETURNING login_attempts INTO out_login_attempts;

    IF NOT FOUND THEN
        out_message := 'Usuário não encontrado.';
        out_haserror := TRUE;
        RETURN;
    END IF;

    -- =========================
    -- Validar bloqueio
    -- =========================
    out_is_locked := (out_login_attempts >= p_max_attempts);

    IF out_is_locked THEN
        out_message := format(
            'Conta bloqueada por excesso de tentativas (%s/%s). Redefina a senha para desbloquear.',
            out_login_attempts, p_max_attempts
        );
    ELSE
        out_message := format(
            'Tentativa de login registrada (%s/%s).',
            out_login_attempts, p_max_attempts
        );
    END IF;

    RETURN;

EXCEPTION
    WHEN OTHERS THEN
        v_command := format(
            'CALL app.usp_api_user_login_attempts_update(p_user_login_id => %s, p_max_attempts => %s)',
            COALESCE(p_user_login_id::TEXT, 'NULL'),
            COALESCE(p_max_attempts::TEXT, 'NULL')
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
            'user_login',
            'app.usp_api_user_login_attempts_update',
            'UPDATE',
            v_command,
            v_error_message,
            v_error_code,
            p_user_login_id::TEXT
        );

        out_message := format('Erro ao atualizar tentativas de login: %s', v_error_message);
        out_haserror := TRUE;
        RETURN;
END;
$$;
