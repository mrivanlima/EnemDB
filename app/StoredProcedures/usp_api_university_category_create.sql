CREATE OR REPLACE PROCEDURE app.usp_api_university_category_create (
    IN p_university_category_name TEXT,
    IN p_created_by               INT,
    IN p_modified_by              INT,
    OUT out_message               TEXT
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
    IF p_university_category_name IS NULL OR length(trim(p_university_category_name)) = 0 THEN
        out_message := 'Validação falhou: o nome da categoria não pode estar em branco.';
        RETURN;
    END IF;

    IF p_created_by IS NULL THEN
        out_message := 'Validação falhou: o campo criado_por não pode ser nulo.';
        RETURN;
    END IF;

    IF p_modified_by IS NULL THEN
        out_message := 'Validação falhou: o campo modificado_por não pode ser nulo.';
        RETURN;
    END IF;

    -- VERIFICA DUPLICIDADE (case-insensitive)
    SELECT 1 INTO v_exists
    FROM app.university_category
    WHERE UPPER(university_category_name) = UPPER(p_university_category_name);

    IF FOUND THEN
        out_message := format('Validação falhou: a categoria "%s" já existe.', p_university_category_name);
        RETURN;
    END IF;

    -- INSERÇÃO COM LOG DE ERRO
    BEGIN
        INSERT INTO app.university_category (
            university_category_name,
            created_by,
            created_on,
            modified_by,
            modified_on
        )
        VALUES (
            trim(p_university_category_name),
            p_created_by,
            NOW(),
            p_modified_by,
            NOW()
        );

        out_message := 'OK';
        RETURN;

    EXCEPTION
        WHEN OTHERS THEN
            v_command := format(
                'CALL app.usp_api_university_category_create(%L, %s, %s)',
                COALESCE(p_university_category_name, 'NULL'),
                COALESCE(p_created_by::TEXT, 'NULL'),
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
                'university_category',
                'app.usp_api_university_category_create',
                'INSERT',
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
