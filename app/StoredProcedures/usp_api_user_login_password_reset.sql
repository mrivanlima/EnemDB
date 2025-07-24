CREATE OR REPLACE PROCEDURE app.usp_api_user_login_password_reset (
    IN p_email           TEXT,
    IN p_new_hash        TEXT,
    IN p_modified_by     INTEGER,
    OUT out_message      TEXT,
    OUT out_haserror     BIT
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_user_login_id      INTEGER;
    v_is_verified        BOOLEAN;
    v_is_active          BOOLEAN;
    v_command            TEXT;
    v_error_message      TEXT;
    v_error_code         TEXT;
BEGIN
    -- Inicializa a flag de erro
    out_haserror := B'0';

    -- Validações básicas
    IF p_email IS NULL OR length(trim(p_email)) = 0 THEN
        out_message := 'E-mail é obrigatório.';
        out_haserror := B'1';
        RETURN;
    END IF;

    IF p_new_hash IS NULL OR length(trim(p_new_hash)) = 0 THEN
        out_message := 'A nova senha (hash) é obrigatória.';
        out_haserror := B'1';
        RETURN;
    END IF;

    IF p_modified_by IS NULL THEN
        out_message := 'Usuário responsável pela alteração é obrigatório.';
        out_haserror := B'1';
        RETURN;
    END IF;

    -- Busca o usuário
    SELECT user_login_id, is_email_verified, is_active
      INTO v_user_login_id, v_is_verified, v_is_active
      FROM app.user_login
     WHERE LOWER(email) = LOWER(p_email);

    IF NOT FOUND THEN
        out_message := 'Usuário não encontrado.';
        out_haserror := B'1';
        RETURN;
    END IF;

    -- Valida se email está verificado
    IF NOT v_is_verified THEN
        out_message := 'E-mail ainda não foi verificado.';
        out_haserror := B'1';
        RETURN;
    END IF;

    -- Valida se conta está ativa
    IF NOT v_is_active THEN
        out_message := 'Conta está inativa.';
        out_haserror := B'1';
        RETURN;
    END IF;

    -- Atualiza a senha
    BEGIN
        UPDATE app.user_login
           SET password_hash = p_new_hash,
               login_attempts = 0,
               modified_by = p_modified_by,
               modified_on = NOW()
         WHERE user_login_id = v_user_login_id;

        out_message := 'Senha redefinida com sucesso.';
        RETURN;

    EXCEPTION
        WHEN OTHERS THEN
            v_command := format(
                'CALL app.usp_api_user_login_password_reset(p_email => %L, p_new_hash => %L, p_modified_by => %s)',
                COALESCE(p_email, 'NULL'),
                COALESCE(p_new_hash, 'NULL'),
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
                'user_login',
                'app.usp_api_user_login_password_reset',
                'UPDATE',
                v_command,
                v_error_message,
                v_error_code,
                p_modified_by
            );

            out_message := format('Erro ao redefinir a senha: %s', v_error_message);
            out_haserror := B'1';
            RETURN;
    END;
END;
$$;
