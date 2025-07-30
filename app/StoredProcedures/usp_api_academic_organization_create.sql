CREATE OR REPLACE PROCEDURE app.usp_api_academic_organization_create (
    IN p_academic_organization_name  TEXT,
    IN p_created_by                  INT,
    OUT out_message                  TEXT
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
    IF p_academic_organization_name IS NULL OR length(trim(p_academic_organization_name)) = 0 THEN
        out_message := 'Validação falhou: o nome da organização acadêmica não pode estar em branco.';
        RETURN;
    END IF;

    IF p_created_by IS NULL THEN
        out_message := 'Validação falhou: o campo criado_por não pode ser nulo.';
        RETURN;
    END IF;

    -- Verificação de unicidade
    SELECT 1 INTO v_exists
    FROM app.academic_organization
    WHERE academic_organization_name = p_academic_organization_name;

    IF FOUND THEN
        out_message := format('Validação falhou: a organização acadêmica "%s" já existe.', p_academic_organization_name);
        RETURN;
    END IF;

    -- INSERÇÃO COM TRATAMENTO DE ERRO
    BEGIN
        INSERT INTO app.academic_organization (
            academic_organization_name,
            academic_organization_name_friendly,
            created_by,
            created_on
        )
        VALUES (
            p_academic_organization_name,
            p_academic_organization_name, -- pode customizar depois
            p_created_by,
            NOW()
        );

        out_message := 'OK';
        RETURN;

    EXCEPTION
        WHEN OTHERS THEN
            v_command := format(
                'CALL app.usp_api_academic_organization_create(p_academic_organization_name => %L, p_created_by => %s)',
                COALESCE(p_academic_organization_name, 'NULL'),
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
                'academic_organization',
                'app.usp_api_academic_organization_create',
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
