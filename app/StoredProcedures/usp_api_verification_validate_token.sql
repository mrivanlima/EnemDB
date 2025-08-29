CREATE OR REPLACE PROCEDURE app.usp_api_verification_validate_token (
    IN  p_user_login_id       INTEGER,
    IN  p_verification_token  TEXT,
    OUT out_user_login_id     INTEGER,
    OUT out_message           TEXT,
    OUT out_haserror          BOOLEAN
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_uv_id          INTEGER;
    v_token_stored   TEXT;
    v_is_used        BOOLEAN;
    v_used_on        TIMESTAMPTZ;
    v_expires_at     TIMESTAMPTZ;
    v_command        TEXT;
    v_error_message  TEXT;
    v_error_code     TEXT;
BEGIN
    out_haserror := FALSE;
    out_user_login_id := NULL;

    -- Validations
    IF p_user_login_id IS NULL THEN
        out_message := 'O user_login_id é obrigatório.';
        out_haserror := TRUE;
        RETURN;
    END IF;

    IF p_verification_token IS NULL OR length(trim(p_verification_token)) = 0 THEN
        out_message := 'O token de verificação é obrigatório.';
        out_haserror := TRUE;
        RETURN;
    END IF;

    -- Pick the most recent token for this user
    SELECT uv.user_verification_id,
           uv.verification_token,
           uv.is_used,
           uv.used_on,
           uv.expires_at
      INTO v_uv_id, v_token_stored, v_is_used, v_used_on, v_expires_at
      FROM app.user_verification uv
     WHERE uv.user_login_id = p_user_login_id
     AND uv.verification_token = p_verification_token;

    IF NOT FOUND THEN
        out_message := 'Token não encontrado para este usuário.';
        out_haserror := TRUE;
        RETURN;
    END IF;

    -- Check used
    IF v_is_used OR v_used_on IS NOT NULL THEN
        out_message := COALESCE(
            format('Click já utilizado em %s.', to_char(v_used_on, 'YYYY-MM-DD HH24:MI:SS TZ')),
            'Click já utilizado.'
        );
        out_haserror := TRUE;
        RETURN;
    END IF;

    -- Check expired (expires_at <= now() means expired)
    IF v_expires_at <= NOW() THEN
        out_message := format('Click expirado em %s.', to_char(v_expires_at, 'YYYY-MM-DD HH24:MI:SS TZ'));
        out_haserror := TRUE;
        RETURN;
    END IF;

    UPDATE app.user_verification
    SET is_used = TRUE,
        used_on = NOW(),
        modified_by = p_user_login_id,
        modified_on = NOW()
    WHERE user_verification_id = v_uv_id
    AND is_used = FALSE;


    -- Valid
    out_user_login_id := p_user_login_id;
    out_message := 'Click válido.';
    RETURN;

EXCEPTION
    WHEN OTHERS THEN
        v_command := format(
            'CALL app.verification_validate_token(p_user_login_id => %s, p_verification_token => %L)',
            COALESCE(p_user_login_id::TEXT, 'NULL'),
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
            'user_verification',
            'app.verification_validate_token',
            'SELECT',
            v_command,
            v_error_message,
            v_error_code,
            p_user_login_id
        );

        out_message := format('Erro ao validar token: %s', v_error_message);
        out_haserror := TRUE;
        RETURN;
END;
$$;
