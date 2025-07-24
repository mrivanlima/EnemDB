CREATE OR REPLACE PROCEDURE app.usp_api_user_login_authenticate (
    IN  p_email            VARCHAR(255),
    OUT out_user_login_id  INTEGER,
    OUT out_password_hash  VARCHAR(255),
    OUT out_is_verified    BOOLEAN,
    OUT out_is_active      BOOLEAN,
    OUT out_is_locked      BOOLEAN,
    OUT out_message        VARCHAR(255),
    OUT out_haserror       BOOLEAN
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_login_attempts       INTEGER;
    v_command              TEXT;
    v_error_message        TEXT;
    v_error_code           TEXT;
BEGIN
    out_haserror := FALSE;

    -- Validação
    IF p_email IS NULL OR length(trim(p_email)) = 0 THEN
        out_message := 'Validação falhou: email não pode ser vazio.';
        out_haserror := TRUE;
        RETURN;
    END IF;

    -- Buscar dados do usuário
    SELECT 
        user_login_id,
        password_hash,
        is_email_verified,
        is_active,
        login_attempts
    INTO 
        out_user_login_id,
        out_password_hash,
        out_is_verified,
        out_is_active,
        v_login_attempts
    FROM app.user_login
    WHERE LOWER(email) = LOWER(p_email);

    IF NOT FOUND THEN
        out_message := 'Usuário não encontrado.';
        out_haserror := TRUE;
        RETURN;
    END IF;

    out_is_locked := v_login_attempts >= 5;
    out_message := 'Dados do login carregados com sucesso.';
    RETURN;

EXCEPTION
    WHEN OTHERS THEN
        v_command := format(
            'CALL app.usp_api_user_login_authenticate(p_email => %L)',
            COALESCE(p_email, 'NULL')
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
            'app.usp_api_user_login_authenticate',
            'SELECT',
            v_command,
            v_error_message,
            v_error_code,
            p_email
        );

        out_message := format('Erro ao autenticar: %s', v_error_message);
        out_haserror := TRUE;
        RETURN;
END;
$$;
