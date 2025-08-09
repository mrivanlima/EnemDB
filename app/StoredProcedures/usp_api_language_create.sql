CREATE OR REPLACE PROCEDURE app.usp_api_language_create (
    IN p_language_name TEXT,
    IN p_created_by    INTEGER,
    OUT out_message    TEXT
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_exists        INTEGER;
    v_command       TEXT;
    v_error_message TEXT;
    v_error_code    TEXT;
BEGIN
    -- VALIDATIONS
    IF p_language_name IS NULL OR LENGTH(TRIM(p_language_name)) = 0 THEN
        out_message := 'Validação falhou: o nome do idioma não pode ser vazio.';
        RETURN;
    END IF;

    -- (Opcional) validação de tamanho pelo VARCHAR(20)
    IF LENGTH(TRIM(p_language_name)) > 20 THEN
        out_message := format('Validação falhou: o nome do idioma excede 20 caracteres (len=%s).', LENGTH(TRIM(p_language_name)));
        RETURN;
    END IF;

    IF p_created_by IS NULL THEN
        out_message := 'Validação falhou: o campo criado_por não pode ser nulo.';
        RETURN;
    END IF;

    -- Uniqueness check (language_name)
    SELECT 1 INTO v_exists
      FROM app.language
     WHERE language_name = TRIM(p_language_name);

    IF FOUND THEN
        out_message := format('Validação falhou: o idioma "%s" já existe.', TRIM(p_language_name));
        RETURN;
    END IF;

    -- INSERT with error handling
    BEGIN
        INSERT INTO app.language (
            language_name,
            created_by,
            created_on
        )
        VALUES (
            TRIM(p_language_name),
            p_created_by,
            NOW()
        );

        -- language_name_friendly será preenchido por trigger
        out_message := 'OK';
        RETURN;

    EXCEPTION WHEN OTHERS THEN
        v_command := format(
            'CALL app.usp_api_language_create(%L, %s)',
            COALESCE(p_language_name, 'NULL'),
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
            'language',
            'app.usp_api_language_create',
            'INSERÇÃO',
            v_command,
            v_error_message,
            v_error_code,
            p_created_by::TEXT
        );

        out_message := format('Erro durante a inserção: %s', v_error_message);
        RETURN;
    END;
END;
$$;
