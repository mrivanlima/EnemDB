CREATE OR REPLACE PROCEDURE app.usp_api_exam_day_create (
    IN p_day_name   TEXT,
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
    -- VALIDATIONS
    IF p_day_name IS NULL OR LENGTH(TRIM(p_day_name)) = 0 THEN
        out_message := 'Validação falhou: o nome do dia não pode ser vazio.';
        RETURN;
    END IF;

    IF p_created_by IS NULL THEN
        out_message := 'Validação falhou: o campo criado_por não pode ser nulo.';
        RETURN;
    END IF;

    -- Uniqueness check
    SELECT 1 INTO v_exists
    FROM app.exam_day
    WHERE day_name = p_day_name;

    IF FOUND THEN
        out_message := format('Validação falhou: o nome do dia "%s" já existe.', p_day_name);
        RETURN;
    END IF;

    -- INSERT with error handling
    BEGIN
        INSERT INTO app.exam_day (
            day_name,
            created_by,
            created_on
        )
        VALUES (
            p_day_name,
            p_created_by,
            NOW()
        );

        out_message := 'OK';
        RETURN;

    EXCEPTION WHEN OTHERS THEN
        v_command := format(
            'CALL app.usp_api_exam_day_create(%L, %s)',
            COALESCE(p_day_name, 'NULL'),
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
            'exam_day',
            'app.usp_api_exam_day_create',
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
