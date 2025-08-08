CREATE OR REPLACE PROCEDURE app.usp_api_booklet_color_create (
    IN p_booklet_color_name TEXT,
    IN p_is_accessible BOOLEAN,
    IN p_sort_order SMALLINT,
    IN p_active BOOLEAN,
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
    IF p_booklet_color_name IS NULL OR length(trim(p_booklet_color_name)) = 0 THEN
        out_message := 'Validação falhou: o nome da cor do caderno não pode ser vazio.';
        RETURN;
    END IF;

    IF p_created_by IS NULL THEN
        out_message := 'Validação falhou: o campo criado_por não pode ser nulo.';
        RETURN;
    END IF;

    -- Verifica se já existe
    SELECT 1 INTO v_exists
    FROM app.booklet_color
    WHERE booklet_color_name = p_booklet_color_name;

    IF FOUND THEN
        out_message := format('Validação falhou: a cor "%s" já existe.', p_booklet_color_name);
        RETURN;
    END IF;

    -- INSERÇÃO + LOG DE ERRO
    BEGIN
        INSERT INTO app.booklet_color (
            booklet_color_name,
            is_accessible,
            sort_order,
            active,
            created_by,
            created_on
        )
        VALUES (
            p_booklet_color_name,
            COALESCE(p_is_accessible, FALSE),
            COALESCE(p_sort_order, 0),
            COALESCE(p_active, TRUE),
            p_created_by,
            NOW()
        );

        out_message := 'OK';
        RETURN;

    EXCEPTION WHEN OTHERS THEN
        v_command := format(
            'CALL app.usp_api_booklet_color_create(%L, %s, %s, %s, %s)',
            COALESCE(p_booklet_color_name, 'NULL'),
            COALESCE(p_is_accessible::TEXT, 'NULL'),
            COALESCE(p_sort_order::TEXT, 'NULL'),
            COALESCE(p_active::TEXT, 'NULL'),
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
            'booklet_color',
            'app.usp_api_booklet_color_create',
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
