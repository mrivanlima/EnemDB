CREATE OR REPLACE PROCEDURE app.usp_api_booklet_color_create (
    IN p_booklet_color_name TEXT,
    IN p_is_accessible BOOLEAN,
    IN p_sort_order SMALLINT,
    IN p_active BOOLEAN,
    IN p_created_by TEXT,
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
    IF p_booklet_color_name IS NULL OR length(trim(p_booklet_color_name)) = 0 THEN
        out_message := 'Validation failed: booklet_color_name cannot be empty.';
        RETURN;
    END IF;

    IF p_created_by IS NULL OR length(trim(p_created_by)) = 0 THEN
        out_message := 'Validation failed: created_by cannot be empty.';
        RETURN;
    END IF;

    -- Uniqueness: booklet_color_name
    SELECT 1 INTO v_exists FROM app.booklet_color WHERE booklet_color_name = p_booklet_color_name;
    IF FOUND THEN
        out_message := format('Validation failed: booklet_color_name "%s" already exists.', p_booklet_color_name);
        RETURN;
    END IF;

    -- DML & ERROR LOGGING
    BEGIN
        INSERT INTO app.booklet_color
        (
            booklet_color_name,
            is_accessible,
            sort_order,
            active,
            created_by,
            created_on
        )
        VALUES
        (
            p_booklet_color_name,
            COALESCE(p_is_accessible, FALSE),
            COALESCE(p_sort_order, 0),
            COALESCE(p_active, TRUE),
            p_created_by,
            NOW()
        );

        out_message := 'OK';
        RETURN;

    EXCEPTION
        WHEN OTHERS THEN
            v_command := format(
                'CALL app.usp_api_booklet_color_create(p_booklet_color_name => %L, p_is_accessible => %s, p_sort_order => %s, p_active => %s, p_created_by => %L)',
                COALESCE(p_booklet_color_name, 'NULL'),
                COALESCE(p_is_accessible::TEXT, 'NULL'),
                COALESCE(p_sort_order::TEXT, 'NULL'),
                COALESCE(p_active::TEXT, 'NULL'),
                COALESCE(p_created_by, 'NULL')
            );
            v_error_message := SQLERRM;
            v_error_code := SQLSTATE;
            INSERT INTO app.error_log
            (
                table_name,
                process,
                operation,
                command,
                error_message,
                error_code,
                user_name
            )
            VALUES
            (
                'booklet_color',
                'app.usp_api_booklet_color_create',
                'INSERT',
                v_command,
                v_error_message,
                v_error_code,
                p_created_by
            );
            out_message := format('Error during insert: %s', v_error_message);
            RETURN;
    END;
END;
$$;
