CREATE OR REPLACE PROCEDURE app.usp_api_shift_create (
    IN  p_shift_name    TEXT,
    IN  p_created_by    INTEGER,
    OUT out_message     TEXT,
    OUT out_haserror    BOOLEAN
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_exists         INTEGER;
    v_command        TEXT;
    v_error_message  TEXT;
    v_error_code     TEXT;
BEGIN
    -- Inicializa saída
    out_haserror := FALSE;

    -- VALIDAÇÕES
    IF p_shift_name IS NULL OR length(trim(p_shift_name)) = 0 THEN
        out_message := 'Validação: shift_name é obrigatório.';
        out_haserror := TRUE;
        RETURN;
    END IF;

    IF p_created_by IS NULL THEN
        out_message := 'Validação: created_by é obrigatório.';
        out_haserror := TRUE;
        RETURN;
    END IF;

    -- Unicidade
    SELECT 1 INTO v_exists FROM app.shift WHERE shift_name = p_shift_name;
    IF FOUND THEN
        out_message := format('Validação: shift_name "%s" já existe.', p_shift_name);
        out_haserror := TRUE;
        RETURN;
    END IF;

    -- INSERÇÃO
    BEGIN
        INSERT INTO app.shift (
            shift_name,
            created_by,
            created_on
        ) VALUES (
            p_shift_name,
            p_created_by,
            NOW()
        );

        out_message := 'OK';
    EXCEPTION
        WHEN OTHERS THEN
            v_command := format(
                'CALL app.usp_api_shift_create(p_shift_name => %L, p_created_by => %s)',
                COALESCE(p_shift_name, 'NULL'),
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
            ) VALUES (
                'shift',
                'app.usp_api_shift_create',
                'INSERT',
                v_command,
                v_error_message,
                v_error_code,
                p_created_by
            );

            out_message := format('Erro ao inserir shift: %s', v_error_message);
            out_haserror := TRUE;
    END;
END;
$$;
