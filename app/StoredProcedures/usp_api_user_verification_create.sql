CREATE OR REPLACE PROCEDURE app.usp_api_user_verification_create (
    IN  p_email                  TEXT,
    IN  p_purpose                TEXT,          -- e.g. 'Registro' or 'Esqueceu Senha'
    IN  p_created_by             INTEGER,
    OUT out_user_verification_id INTEGER,
    OUT out_token                TEXT,
    OUT out_message              TEXT,
    OUT out_haserror             BOOLEAN
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_user_login_id          INTEGER;
    v_verification_purpose_id INTEGER;
    v_now                    TIMESTAMPTZ := NOW();
    v_try                    INT := 0;
    v_max_tries              INT := 5;
    v_command                TEXT;
    v_error_message          TEXT;
    v_error_code             TEXT;
BEGIN
    out_haserror := FALSE;
    out_user_verification_id := NULL;
    out_token := NULL;

    -- =====================
    -- Validations
    -- =====================
    IF p_email IS NULL OR length(trim(p_email)) = 0 THEN
        out_message := 'O e-mail é obrigatório.';
        out_haserror := TRUE;
        RETURN;
    END IF;

    IF p_purpose IS NULL OR length(trim(p_purpose)) = 0 THEN
        out_message := 'O propósito (purpose) é obrigatório.';
        out_haserror := TRUE;
        RETURN;
    END IF;

    IF p_created_by IS NULL THEN
        out_message := 'O campo created_by é obrigatório.';
        out_haserror := TRUE;
        RETURN;
    END IF;

    -- Resolve user_login_id
    SELECT ul.user_login_id
      INTO v_user_login_id
      FROM app.user_login ul
     WHERE ul.email = p_email
       AND ul.soft_deleted_at IS NULL;

    IF NOT FOUND THEN
        out_message := format('Usuário com e-mail "%s" não encontrado.', p_email);
        out_haserror := TRUE;
        RETURN;
    END IF;

    -- Resolve verification_purpose_id from purpose text
    SELECT vp.verification_purpose_id
      INTO v_verification_purpose_id
      FROM app.verification_purpose vp
     WHERE TRIM(UPPER(vp.purpose)) = TRIM(UPPER(p_purpose));

    IF NOT FOUND THEN
        out_message := format('Propósito de verificação "%s" não encontrado.', p_purpose);
        out_haserror := TRUE;
        RETURN;
    END IF;

    -- =====================
    -- Generate a unique token (retry a few times)
    -- =====================
    WHILE v_try < v_max_tries LOOP
        v_try := v_try + 1;
        out_token := encode(digest(gen_random_uuid()::text, 'sha256'), 'hex');

        -- If this token already exists, try again
        PERFORM 1
          FROM app.user_verification uv
         WHERE uv.verification_token = out_token;

        EXIT WHEN NOT FOUND;
    END LOOP;

    IF FOUND THEN
        out_message := 'Não foi possível gerar um token único. Tente novamente.';
        out_haserror := TRUE;
        RETURN;
    END IF;

    -- =====================
    -- Insert
    -- =====================
    BEGIN
        INSERT INTO app.user_verification (
            verification_purpose_id,
            user_login_id,
            verification_token,
            expires_at,
            is_used,
            created_by,
            created_on
        )
        VALUES (
            v_verification_purpose_id,
            v_user_login_id,
            out_token,
            v_now + interval '30 minutes',
            FALSE,
            p_created_by,
            v_now
        )
        RETURNING user_verification_id
           INTO out_user_verification_id;

        out_message := 'Token de verificação criado com sucesso.';
        RETURN;

    EXCEPTION
        WHEN OTHERS THEN
            v_command := format(
                'CALL app.usp_api_user_verification_create(p_email => %L, p_purpose => %L, p_created_by => %s)',
                COALESCE(p_email, 'NULL'),
                COALESCE(p_purpose, 'NULL'),
                COALESCE(p_created_by::TEXT, 'NULL')
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
                'app.usp_api_user_verification_create',
                'INSERT',
                v_command,
                v_error_message,
                v_error_code,
                p_created_by
            );

            out_message := format('Erro ao criar token: %s', v_error_message);
            out_haserror := TRUE;
            RETURN;
    END;
END;
$$;
