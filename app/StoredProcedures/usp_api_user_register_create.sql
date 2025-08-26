CREATE OR REPLACE PROCEDURE app.usp_api_user_register_create (
    IN  p_email           VARCHAR(255),
    IN  p_password_hash   VARCHAR(255),
    IN  p_user_login_unique UUID,
    IN  p_created_by      INTEGER,
    OUT out_user_login_id INTEGER,
    OUT out_message       VARCHAR(100),
    OUT out_haserror      BOOLEAN
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_exists           INTEGER;
    v_command          TEXT;
    v_error_message    VARCHAR(100);
    v_error_code       VARCHAR(100);

    -- Valores padrão
    is_email_verified  BOOLEAN := FALSE;
    is_active          BOOLEAN := TRUE;
    login_attempts     INTEGER := 0;
    created_on         TIMESTAMPTZ := NOW();
BEGIN
    -- Inicializa out_user_login_id
    out_user_login_id := NULL;

    -- VALIDAÇÕES
    IF p_email IS NULL OR length(trim(p_email)) = 0 THEN
        out_message := 'Validação falhou: o campo e-mail não pode ser vazio.';
        out_haserror := TRUE;
        RETURN;
    END IF;

    IF p_password_hash IS NULL OR length(trim(p_password_hash)) = 0 THEN
        out_message := 'Validação falhou: a senha não pode ser vazia.';
        out_haserror := TRUE;
        RETURN;
    END IF;

    IF p_created_by IS NULL THEN
        out_message := 'Validação falhou: o campo created_by é obrigatório.';
        out_haserror := TRUE;
        RETURN;
    END IF;

    -- Verificação de unicidade: email
    SELECT 1 INTO v_exists
    FROM app.user_login
    WHERE LOWER(email) = LOWER(p_email);

    IF FOUND THEN
        out_message := format('Validação falhou: o e-mail "%s" já está em uso.', p_email);
        out_haserror := TRUE;
        RETURN;
    END IF;

    -- INSERÇÃO E RETORNO DO ID
    BEGIN
        INSERT INTO app.user_login (
            user_login_unique,
            email,
            password_hash,
            is_email_verified,
            is_active,
            login_attempts,
            created_by,
            created_on
        )
        VALUES (
            p_user_login_unique,
            LOWER(p_email),
            p_password_hash,
            is_email_verified,
            is_active,
            login_attempts,
            p_created_by,
            created_on
        )
        RETURNING user_login_id INTO out_user_login_id;

        out_message := 'OK';
        out_haserror := FALSE;
        RETURN;

    EXCEPTION
        WHEN OTHERS THEN
            v_command := format(
                'CALL app.usp_api_user_register_create(p_email => %L, p_password_hash => %L, p_created_by => %s)',
                p_email, p_password_hash, COALESCE(p_created_by::TEXT, 'NULL')
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
                'app.usp_api_user_register_create',
                'INSERT',
                v_command,
                v_error_message,
                v_error_code,
                p_created_by::TEXT
            );

            out_message := format('Erro durante o cadastro: %s', v_error_message);
            out_haserror := TRUE;
            out_user_login_id := NULL;
            RETURN;
    END;
END;
$$;
