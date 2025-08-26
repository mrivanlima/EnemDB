CREATE OR REPLACE PROCEDURE app.usp_api_user_login_add_password (
    IN p_email           TEXT,
    IN p_password_hash   TEXT,
    IN p_modified_by     INTEGER,
    OUT out_message      TEXT,
    OUT out_haserror     BOOLEAN
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_user_login_id     INTEGER;
    v_exists            INTEGER;
    v_command           TEXT;
    v_error_message     TEXT;
    v_error_code        TEXT;
BEGIN
    out_haserror := FALSE;

    -- Validação de entrada
    IF p_email IS NULL OR length(trim(p_email)) = 0 THEN
        out_message := 'O e-mail não pode estar vazio.';
        out_haserror := TRUE;
        RETURN;
    END IF;

    IF p_password_hash IS NULL OR length(trim(p_password_hash)) = 0 THEN
        out_message := 'A senha não pode estar vazia.';
        out_haserror := TRUE;
        RETURN;
    END IF;

    SELECT user_login_id
    INTO v_user_login_id
    FROM app.user_login
    WHERE lower(email) = lower(trim(p_email));

    IF NOT FOUND THEN
        out_message := format('Usuário com e-mail "%s" não encontrado.', p_email);
        out_haserror := TRUE;
        RETURN;
    END IF;

    SELECT 1
    INTO v_exists
    FROM app.user_login
    WHERE user_login_id = v_user_login_id
      AND password_hash IS NOT NULL;

    IF FOUND THEN
        out_message := 'Este usuário já possui senha.';
        out_haserror := TRUE;
        RETURN;
    END IF;

    SELECT 1
    INTO v_exists
    FROM app.user_login
    WHERE user_login_id = v_user_login_id
      AND is_email_verified = TRUE
      AND is_active = TRUE;

    IF NOT FOUND THEN
        out_message := 'Usuário inativo ou com e-mail não verificado.';
        out_haserror := TRUE;
        RETURN;
    END IF;

    BEGIN
        UPDATE app.user_login
        SET
            password_hash = p_password_hash,
            modified_by = p_modified_by,
            modified_on = NOW()
        WHERE user_login_id = v_user_login_id;

        out_message := 'Senha adicionada com sucesso.';
        RETURN;

    EXCEPTION
        WHEN OTHERS THEN
            v_command := format(
                'CALL app.usp_api_user_login_add_password(p_email => %L, p_password_hash => %L, p_modified_by => %s)',
                COALESCE(p_email, 'NULL'),
                COALESCE(p_password_hash, 'NULL'),
                COALESCE(p_modified_by::TEXT, 'NULL')
            );

            v_error_message := SQLERRM;
            v_error_code := SQLSTATE;

            INSERT INTO app.error_log (
                table_name, process, operation, command, error_message, error_code, user_name
            ) VALUES (
                'user_login',
                'app.usp_api_user_login_add_password',
                'UPDATE',
                v_command,
                v_error_message,
                v_error_code,
                p_modified_by
            );

            out_message := format('Erro ao adicionar senha: %s', v_error_message);
            out_haserror := TRUE;
            RETURN;
    END;
END;
$$;
