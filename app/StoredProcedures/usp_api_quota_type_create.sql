CREATE OR REPLACE PROCEDURE app.usp_api_quota_type_create (
    IN p_quota_type_code          TEXT,
    IN p_quota_type_desc_pt       TEXT,
    IN p_quota_type_desc_short_pt TEXT,
    IN p_quota_explain            TEXT,
    IN p_created_by               TEXT,
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
    -- VALIDATIONS
    IF p_quota_type_code IS NULL OR length(trim(p_quota_type_code)) = 0 THEN
        out_message := 'Validation failed: quota_type_code cannot be empty.';
        RETURN;
    END IF;
    IF p_quota_type_desc_pt IS NULL OR length(trim(p_quota_type_desc_pt)) = 0 THEN
        out_message := 'Validation failed: quota_type_desc_pt cannot be empty.';
        RETURN;
    END IF;
    IF p_quota_type_desc_short_pt IS NULL OR length(trim(p_quota_type_desc_short_pt)) = 0 THEN
        out_message := 'Validation failed: quota_type_desc_short_pt cannot be empty.';
        RETURN;
    END IF;
    IF p_quota_explain IS NULL OR length(trim(p_quota_explain)) = 0 THEN
        out_message := 'Validation failed: quota_explain cannot be empty.';
        RETURN;
    END IF;
    IF p_created_by IS NULL OR length(trim(p_created_by)) = 0 THEN
        out_message := 'Validation failed: created_by cannot be empty.';
        RETURN;
    END IF;

    -- Uniqueness
    SELECT 1 INTO v_exists FROM app.quota_type WHERE quota_type_code = p_quota_type_code;
    IF FOUND THEN
        out_message := format('Validation failed: quota_type_code "%s" already exists.', p_quota_type_code);
        RETURN;
    END IF;

    -- DML & ERROR LOGGING
    BEGIN
        INSERT INTO app.quota_type (
            quota_type_code,
            quota_type_desc_pt,
            quota_type_desc_short_pt,
            quota_explain,
            created_by,
            created_on
        )
        VALUES (
            p_quota_type_code,
            p_quota_type_desc_pt,
            p_quota_type_desc_short_pt,
            p_quota_explain,
            p_created_by,
            NOW()
        );

        out_message := 'OK';
        RETURN;

    EXCEPTION
        WHEN OTHERS THEN
            v_command := format(
                'CALL app.usp_api_quota_type_create(%L, %L, %L, %L, %L, out_message)',
                COALESCE(p_quota_type_code, 'NULL'),
                COALESCE(p_quota_type_desc_pt, 'NULL'),
                COALESCE(p_quota_type_desc_short_pt, 'NULL'),
                COALESCE(p_quota_explain, 'NULL'),
                COALESCE(p_created_by, 'NULL')
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
                'quota_type',
                'app.usp_api_quota_type_create',
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
