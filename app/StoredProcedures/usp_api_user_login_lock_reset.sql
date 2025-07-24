CREATE OR REPLACE PROCEDURE app.usp_api_user_login_lock_reset (
    IN p_email         VARCHAR(255),
    IN p_modified_by   INTEGER,
    OUT out_message    TEXT,
    OUT out_haserror   BOOLEAN
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_user_login_id     INTEGER;
    v_command           TEXT;
    v_error_message     TEXT;
    v_error_code        TEXT;
BEGIN
    -- VALIDAÇÕES
    IF p_email IS NULL OR length(trim(p_email)) = 0 THEN
        out_message := 'O e-mail não pode estar vazio.';
        out_haserror := TRUE;
        RETURN;
    END IF;

    IF p_modified_by IS NULL THEN
        out_message := 'O identificador de modificação (modified_by) é obrigatório.';
        out_haserror := TRUE;
        RETURN;
    END IF;

    -- VERIFICA SE O USUÁRIO EXISTE E ESTÁ BLOQUEADO
    SELECT user_login_id INTO v_user_login_id
    FROM app.user_login
    WHERE email = p_email AND login_attempts >= 5;

    IF NOT FOUND THEN
        out_message := 'Nenhum usuário bloqueado encontrado com este e-mail.';
        out_haserror := TRUE;
        RETURN;
    END IF;

    -- EXECUTA O RESET DE BLOQUEIO
    BEGIN
        UPDATE app.user_login
        SET
            login_attempts = 0,
            modified_by = p_modified_by,
            modified_on = NOW()
        WHERE user_login_id = v_user_login_id;

        out_message := 'Bloqueio resetado com sucesso.';
        out_haserror := FALSE;
        RETURN;

    EXCEPTION
        WHEN OTHERS THEN
            v_command := format(
                'CALL app.usp_api_user_login_lock_reset(p_email => %L, p_modified_by => %s)',
                COALESCE(p_email, 'NULL'),
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
                'app.usp_api_user_login_lock_reset',
                'UPDATE',
                v_command,
                v_error_message,
                v_error_code,
                p_modified_by
            );

            out_message := format('Erro ao resetar bloqueio: %s', v_error_message);
            out_haserror := TRUE;
            RETURN;
    END;
END;
$$;
