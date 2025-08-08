CREATE OR REPLACE PROCEDURE app.usp_api_booklet_create (
    IN p_booklet_name      TEXT,
    IN p_booklet_code      INTEGER,
    IN p_year_id           INTEGER,
    IN p_area_id           INTEGER,
    IN p_exam_day_id       INTEGER,
    IN p_booklet_color_id  SMALLINT,
    IN p_created_by        INTEGER,
    OUT out_message        TEXT
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_command TEXT;
    v_error_message TEXT;
    v_error_code TEXT;
BEGIN
    -- VALIDATIONS
    IF p_booklet_name IS NULL OR length(trim(p_booklet_name)) = 0 THEN
        out_message := 'Validação falhou: o nome do caderno não pode ser vazio.';
        RETURN;
    END IF;

    IF p_booklet_code IS NULL THEN
        out_message := 'Validação falhou: o código do caderno não pode ser nulo.';
        RETURN;
    END IF;

    IF p_created_by IS NULL THEN
        out_message := 'Validação falhou: o campo criado_por não pode ser nulo.';
        RETURN;
    END IF;

    -- INSERT
    BEGIN
        INSERT INTO app.booklet (
            booklet_name,
            booklet_code,
            year_id,
            area_id,
            exam_day_id,
            booklet_color_id,
            created_by,
            created_on
        )
        VALUES (
            p_booklet_name,
            p_booklet_code,
            p_year_id,
            p_area_id,
            p_exam_day_id,
            p_booklet_color_id,
            p_created_by,
            NOW()
        );

        out_message := 'OK';
        RETURN;

    EXCEPTION WHEN OTHERS THEN
        v_command := format(
            'CALL app.usp_api_booklet_create(%L, %s, %s, %s, %s, %s, %s)',
            p_booklet_name,
            p_booklet_code,
            p_year_id,
            p_area_id,
            p_exam_day_id,
            p_booklet_color_id,
            p_created_by
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
            'booklet',
            'app.usp_api_booklet_create',
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
