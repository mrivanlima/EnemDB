CREATE OR REPLACE PROCEDURE app.usp_api_user_login_soft_delete (
    IN p_email           VARCHAR(255),
    IN p_modified_by     INTEGER,
    OUT out_user_login_id INTEGER,
    OUT out_message      TEXT,
    OUT out_haserror     BIT
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_command         TEXT;
    v_error_message   TEXT;
    v_error_code      TEXT;
    v_user_login_id   INTEGER;
BEGIN
    out_haserror := B'0';

    -- Validações
    IF p_email IS NULL OR length(trim(p_email)) = 0 THEN
        out_message := 'O campo e-mail é obrigatório.';
        out_haserror := B'1';
        RETURN;
    END IF;

    -- Verificar existência e status
    SELECT user_login_id INTO v_user_login_id
    FROM app.user_login
    WHERE lower(email) = lower(p_email)
      AND is_active = TRUE
      AND soft_deleted_at IS NULL;

    IF NOT FOUND THEN
        out_message := 'Usuário não encontrado ou já desativado.';
        out_haserror := B'1';
        RETURN;
    END IF;

    -- Atualizar soft delete
    BEGIN
        UPDATE app.user_login
        SET is_active = FALSE,
            soft_deleted_at = NOW(),
            modified_by = p_modified_by,
            modified_on = NOW()
        WHERE user_login_id = v_user_login_id;

        out_user_login_id := v_user_login_id;
        out_message := 'Usuário desativado com sucesso.';
        RETURN;

    EXCEPTION
        WHEN OTHERS THEN
            v_command := format(
                'CALL app.usp_api_user_login_soft_delete(p_email => %L, p_modified_by => %s)',
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
                'app.usp_api_user_login_soft_delete',
                'SOFT DELETE',
                v_command,
                v_error_message,
                v_error_code,
                p_modified_by
            );

            out_message := format('Erro ao desativar usuário: %s', v_error_message);
            out_haserror := B'1';
            RETURN;
    END;
END;
$$;
