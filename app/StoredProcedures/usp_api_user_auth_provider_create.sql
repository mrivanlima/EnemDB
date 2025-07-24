CREATE OR REPLACE PROCEDURE app.usp_api_user_auth_provider_create (
    IN  p_user_login_id     INTEGER,
    IN  p_provider_type_id  INTEGER,
    IN  p_provider_user_id  VARCHAR(100),
    IN  p_created_by        INTEGER,
    OUT out_message         TEXT,
    OUT out_haserror        BIT
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_exists INTEGER;
    v_command TEXT;
    v_error_message TEXT;
    v_error_code TEXT;
    v_created_on TIMESTAMPTZ := NOW();
BEGIN
    out_haserror := 0;

    -- VALIDAÇÕES
    IF p_user_login_id IS NULL THEN
        out_message := 'Validação falhou: user_login_id não pode ser nulo.';
        out_haserror := 1;
        RETURN;
    END IF;

    IF p_provider_type_id IS NULL THEN
        out_message := 'Validação falhou: provider_type_id não pode ser nulo.';
        out_haserror := 1;
        RETURN;
    END IF;

    IF p_provider_user_id IS NULL OR length(trim(p_provider_user_id)) = 0 THEN
        out_message := 'Validação falhou: provider_user_id não pode ser vazio.';
        out_haserror := 1;
        RETURN;
    END IF;

    IF p_created_by IS NULL THEN
        out_message := 'Validação falhou: created_by não pode ser nulo.';
        out_haserror := 1;
        RETURN;
    END IF;

    -- VERIFICA DUPLICIDADE
    SELECT 1 INTO v_exists
    FROM app.user_auth_provider
    WHERE user_login_id = p_user_login_id
      AND provider_type_id = p_provider_type_id
      AND provider_user_id = p_provider_user_id;

    IF FOUND THEN
        out_message := 'Já existe um vínculo com este provedor para o usuário.';
        RETURN;
    END IF;

    -- INSERÇÃO
    BEGIN
        INSERT INTO app.user_auth_provider (
            user_login_id,
            provider_type_id,
            provider_user_id,
            created_by,
            created_on
        )
        VALUES (
            p_user_login_id,
            p_provider_type_id,
            p_provider_user_id,
            p_created_by,
            v_created_on
        );

        out_message := 'Vínculo com provedor criado com sucesso.';
        RETURN;

    EXCEPTION
        WHEN OTHERS THEN
            v_command := format(
                'CALL app.usp_api_user_auth_provider_create(%s, %s, %L, %s)',
                p_user_login_id,
                p_provider_type_id,
                p_provider_user_id,
                p_created_by
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
                'user_auth_provider',
                'app.usp_api_user_auth_provider_create',
                'INSERT',
                v_command,
                v_error_message,
                v_error_code,
                p_created_by
            );

            out_message := format('Erro ao inserir provedor: %s', v_error_message);
            out_haserror := 1;
            RETURN;
    END;
END;
$$;
