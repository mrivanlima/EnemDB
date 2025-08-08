CREATE OR REPLACE PROCEDURE app.usp_api_area_create (
    IN p_area_name TEXT,
    IN p_area_code TEXT,
    IN p_created_by INTEGER,
    OUT out_message TEXT
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
    IF p_area_name IS NULL OR length(trim(p_area_name)) = 0 THEN
        out_message := 'Validação falhou: area_name não pode ser vazio.';
        RETURN;
    END IF;

    IF p_area_code IS NULL OR length(trim(p_area_code)) = 0 THEN
        out_message := 'Validação falhou: area_code não pode ser vazio.';
        RETURN;
    END IF;

    IF p_created_by IS NULL THEN
        out_message := 'Validação falhou: created_by não pode ser nulo.';
        RETURN;
    END IF;

    -- Unicidade: area_name
    SELECT 1 INTO v_exists
    FROM app.area
    WHERE area_name = p_area_name
       OR area_code = p_area_code;

    IF FOUND THEN
        out_message := format('Validação falhou: área "%s" ou código "%s" já existe.', p_area_name, p_area_code);
        RETURN;
    END IF;

    -- INSERÇÃO
    BEGIN
        INSERT INTO app.area (
            area_name,
            area_code,
            created_by,
            created_on
        )
        VALUES (
            p_area_name,
            p_area_code,
            p_created_by,
            NOW()
        );

        out_message := 'OK';
        RETURN;

    EXCEPTION WHEN OTHERS THEN
        v_command := format(
            'CALL app.usp_api_area_create(%L, %L, %s)',
            COALESCE(p_area_name, 'NULL'),
            COALESCE(p_area_code, 'NULL'),
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
            'area',
            'usp_api_area_create',
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
