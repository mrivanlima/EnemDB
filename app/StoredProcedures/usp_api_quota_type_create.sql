CREATE OR REPLACE PROCEDURE app.usp_api_special_quota_create (
    IN p_quota_type_id         INTEGER,
    IN p_special_quota_desc_pt TEXT,
    IN p_created_by            INTEGER,
    OUT out_message            TEXT
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_exists        INTEGER;
    v_command       TEXT;
    v_error_message TEXT;
    v_error_code    TEXT;
BEGIN
    -- validações obrigatórias
    IF p_quota_type_id IS NULL THEN
        out_message := 'Falha de validação: quota_type_id não pode ser nulo.';
        RETURN;
    END IF;
    IF p_special_quota_desc_pt IS NULL OR length(trim(p_special_quota_desc_pt)) = 0 THEN
        out_message := 'Falha de validação: descrição completa não pode estar vazia.';
        RETURN;
    END IF;
    IF p_created_by IS NULL THEN
        out_message := 'Falha de validação: created_by não pode ser nulo.';
        RETURN;
    END IF;

    -- insere registro (não verificando especial_curta nem quota_explain)
    BEGIN
        INSERT INTO app.special_quota (
            quota_type_id,
            special_quota_desc_pt,
            created_by,
            created_on
        ) VALUES (
            p_quota_type_id,
            p_special_quota_desc_pt,
            p_created_by,
            NOW()
        );

        out_message := 'OK';
        RETURN;
    EXCEPTION WHEN OTHERS THEN
        v_error_message := SQLERRM;
        v_error_code := SQLSTATE;
        v_command := format(
            'CALL app.usp_api_special_quota_create(%s, %L, %s, out_message)',
            p_quota_type_id::TEXT,
            COALESCE(p_special_quota_desc_pt, 'NULL'),
            p_created_by::TEXT
        );

        INSERT INTO app.error_log (
            table_name, process, operation,
            command, error_message, error_code, user_name
        ) VALUES (
            'special_quota',
            'app.usp_api_special_quota_create',
            'INSERT',
            v_command,
            v_error_message,
            v_error_code,
            p_created_by::TEXT
        );

        out_message := format('Erro na inserção: %s', v_error_message);
        RETURN;
    END;
END;
$$;
