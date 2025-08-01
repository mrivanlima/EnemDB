CREATE OR REPLACE PROCEDURE app.usp_api_frequency_create (
    IN p_frequency_name   TEXT,
    IN p_created_by       INT,
    OUT out_message       TEXT,
    OUT out_haserror      BOOLEAN
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_command TEXT;
    v_error_message TEXT;
    v_error_code TEXT;
BEGIN
    out_haserror := FALSE;
    out_message := NULL;

    -- Validação
    IF trim(p_frequency_name) IS NULL OR length(trim(p_frequency_name)) = 0 THEN
        out_message := 'O nome da frequência não pode ser vazio.';
        out_haserror := TRUE;
        RETURN;
    END IF;

    IF p_created_by IS NULL THEN
        out_message := 'O campo created_by é obrigatório.';
        out_haserror := TRUE;
        RETURN;
    END IF;

    -- Unicidade
    IF EXISTS (
        SELECT 1 FROM app.frequency WHERE frequency_name = trim(p_frequency_name)
    ) THEN
        out_message := format('A frequência "%s" já está cadastrada.', p_frequency_name);
        out_haserror := TRUE;
        RETURN;
    END IF;

    -- DML
    BEGIN
        INSERT INTO app.frequency (
            frequency_name,
            created_by
        )
        VALUES (
            trim(p_frequency_name),
            p_created_by
        );

        out_message := 'Frequência criada com sucesso.';
        out_haserror := FALSE;

    EXCEPTION WHEN OTHERS THEN
        v_command := format(
            'CALL app.usp_api_frequency_create(p_frequency_name := %L, p_created_by := %s)',
            COALESCE(p_frequency_name, 'NULL'),
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
            'frequency',
            'app.usp_api_frequency_create',
            'INSERT',
            v_command,
            v_error_message,
            v_error_code,
            p_created_by
        );

        out_message := format('Erro ao inserir frequência: %s', v_error_message);
        out_haserror := TRUE;
        RETURN;
    END;
END;
$$;
