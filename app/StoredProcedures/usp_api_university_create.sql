CREATE OR REPLACE PROCEDURE app.usp_api_university_create (
    IN p_university_code   INT,
    IN p_university_name   TEXT,
    IN p_university_abbr   TEXT,
    IN p_created_by        TEXT,
    IN p_modified_by       TEXT,
    OUT out_message        TEXT
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_exists INTEGER;
    v_command TEXT;
    v_error_message TEXT;
    v_error_code TEXT;
BEGIN
    -- VALIDAÇÕES
    IF p_university_code IS NULL THEN
        out_message := 'Validação falhou: o código da universidade não pode ser nulo.';
        RETURN;
    END IF;

    IF p_university_name IS NULL OR length(trim(p_university_name)) = 0 THEN
        out_message := 'Validação falhou: o nome da universidade não pode estar em branco.';
        RETURN;
    END IF;

    IF p_university_abbr IS NULL OR length(trim(p_university_abbr)) = 0 THEN
        out_message := 'Validação falhou: a sigla da universidade não pode estar em branco.';
        RETURN;
    END IF;

    IF p_created_by IS NULL OR length(trim(p_created_by)) = 0 THEN
        out_message := 'Validação falhou: o campo criado_por não pode estar em branco.';
        RETURN;
    END IF;

    IF p_modified_by IS NULL OR length(trim(p_modified_by)) = 0 THEN
        out_message := 'Validação falhou: o campo modificado_por não pode estar em branco.';
        RETURN;
    END IF;

    -- Verificação de unicidade: sigla (case-insensitive)
    SELECT 1 INTO v_exists
    FROM app.university
    WHERE UPPER(university_abbr) = UPPER(p_university_abbr)
    AND university_code = p_university_code;
    
    IF FOUND THEN
        out_message := format('Validação falhou: a sigla "%s" já está cadastrada.', p_university_abbr);
        RETURN;
    END IF;

    -- Verificação de unicidade: nome
    SELECT 1 INTO v_exists
    FROM app.university
    WHERE university_name = p_university_name
    AND university_code = p_university_code;  -- permite atualização do mesmo nome

    IF FOUND THEN
        out_message := format('Validação falhou: o nome "%s" já está cadastrado.', p_university_name);
        RETURN;
    END IF;

    -- INSERÇÃO E LOG DE ERRO
    BEGIN
        INSERT INTO app.university (
            university_code,
            university_name,
            university_abbr,
            created_by,
            created_on,
            modified_by,
            modified_on
        )
        VALUES (
            p_university_code,
            p_university_name,
            p_university_abbr,
            p_created_by::INT,
            NOW(),
            p_modified_by::INT,
            NOW()
        );

        out_message := 'OK';
        RETURN;

    EXCEPTION
        WHEN OTHERS THEN
            v_command := format(
                'CALL app.usp_api_university_create(%s, %L, %L, %L, %L)',
                COALESCE(p_university_code::TEXT, 'NULL'),
                COALESCE(p_university_name, 'NULL'),
                COALESCE(p_university_abbr, 'NULL'),
                COALESCE(p_created_by, 'NULL'),
                COALESCE(p_modified_by, 'NULL')
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
                'university',
                'app.usp_api_university_create',
                'INSERT',
                v_command,
                v_error_message,
                v_error_code,
                p_created_by
            );

            out_message := format('Erro durante a inserção: %s', v_error_message);
            RETURN;
    END;
END;
$$;
