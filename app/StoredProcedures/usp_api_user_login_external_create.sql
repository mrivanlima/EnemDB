CREATE OR REPLACE PROCEDURE app.usp_api_user_login_external_create (
    IN  p_email              VARCHAR(255),
    IN  p_provider_type_id   INTEGER,
    IN  p_provider_user_id   VARCHAR(100),
    IN  p_created_by         INTEGER,
    OUT out_user_login_id    INTEGER,
    OUT out_message          VARCHAR(255),
    OUT out_haserror         BOOLEAN
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_exists_user_login_id INTEGER;
    v_command TEXT;
    v_error_message TEXT;
    v_error_code TEXT;
    v_is_email_verified BOOLEAN := TRUE;
    v_is_active BOOLEAN := TRUE;
    v_login_attempts INTEGER := 0;
    v_created_on TIMESTAMPTZ := NOW();
BEGIN
    out_haserror := false;
    out_user_login_id := NULL;

    -- VALIDAÇÕES
    IF p_email IS NULL OR length(trim(p_email)) = 0 THEN
        out_message := 'Validação falhou: e-mail não pode ser vazio.';
        out_haserror := true;
        RETURN;
    END IF;

    IF p_provider_type_id IS NULL THEN
        out_message := 'Validação falhou: tipo de provedor não pode ser nulo.';
        out_haserror := true;
        RETURN;
    END IF;

    IF p_provider_user_id IS NULL OR length(trim(p_provider_user_id)) = 0 THEN
        out_message := 'Validação falhou: ID do usuário do provedor não pode ser vazio.';
        out_haserror := true;
        RETURN;
    END IF;

    IF p_created_by IS NULL THEN
        out_message := 'Validação falhou: created_by não pode ser nulo.';
        out_haserror := true;
        RETURN;
    END IF;

    -- VERIFICA SE USUÁRIO JÁ EXISTE
    SELECT ul.user_login_id INTO v_exists_user_login_id
    FROM app.user_login ul
    WHERE LOWER(ul.email) = LOWER(p_email)
    LIMIT 1;

    IF FOUND THEN
        -- USUÁRIO EXISTENTE — retorna ID
        out_user_login_id := v_exists_user_login_id;
        out_message := 'Usuário já existente.';
        RETURN;
    END IF;

    -- INSERE NOVO USER_LOGIN
    BEGIN
        INSERT INTO app.user_login (
            email,
            password_hash,
            is_email_verified,
            is_active,
            login_attempts,
            created_by,
            created_on
        )
        VALUES (
            p_email,
            NULL,
            v_is_email_verified,
            v_is_active,
            v_login_attempts,
            p_created_by,
            v_created_on
        )
        RETURNING user_login_id INTO out_user_login_id;

        -- CHAMA PROCEDURE PARA INSERIR PROVIDER
        CALL app.usp_api_user_auth_provider_create(
            p_user_login_id     => out_user_login_id,
            p_provider_type_id  => p_provider_type_id,
            p_provider_user_id  => p_provider_user_id,
            p_created_by        => p_created_by,
            out_message         => out_message,
            out_haserror        => out_haserror
        );

        IF out_haserror = true THEN
            RETURN;
        END IF;

        out_message := 'Usuário externo criado com sucesso.';
        RETURN;

    EXCEPTION
        WHEN OTHERS THEN
            v_command := format(
                'CALL app.usp_api_user_login_external_create(%L, %s, %L, %s)',
                p_email, p_provider_type_id, p_provider_user_id, p_created_by
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
                'app.usp_api_user_login_external_create',
                'INSERT',
                v_command,
                v_error_message,
                v_error_code,
                p_created_by
            );

            out_message := format('Erro ao criar usuário: %s', v_error_message);
            out_haserror := true;
            RETURN;
    END;
END;
$$;
