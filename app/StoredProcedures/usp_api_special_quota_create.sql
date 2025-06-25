CREATE OR REPLACE PROCEDURE app.usp_api_special_quota_create (
    IN p_quota_type_id            INTEGER,
    IN p_special_quota_desc_pt    TEXT,
    IN p_special_quota_desc_short TEXT,
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
    IF p_quota_type_id IS NULL THEN
        out_message := 'Validation failed: quota_type_id cannot be empty.';
        RETURN;
    END IF;
    IF p_special_quota_desc_pt IS NULL OR length(trim(p_special_quota_desc_pt)) = 0 THEN
        out_message := 'Validation failed: special_quota_desc_pt cannot be empty.';
        RETURN;
    END IF;
    IF p_special_quota_desc_short IS NULL OR length(trim(p_special_quota_desc_short)) = 0 THEN
        out_message := 'Validation failed: special_quota_desc_short cannot be empty.';
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

    -- Uniqueness: short description
    SELECT 1 INTO v_exists FROM app.special_quota WHERE special_quota_desc_short = p_special_quota_desc_short;
    IF FOUND THEN
        out_message := format('Validation failed: special_quota_desc_short "%s" already exists.', p_special_quota_desc_short);
        RETURN;
    END IF;

    -- DML & ERROR LOGGING
    BEGIN
        INSERT INTO app.special_quota (
            quota_type_id,
            special_quota_desc_pt,
            special_quota_desc_short,
            quota_explain,
            created_by,
            created_on
        )
        VALUES (
            p_quota_type_id,
            p_special_quota_desc_pt,
            p_special_quota_desc_short,
            p_quota_explain,
            p_created_by,
            NOW()
        );

        out_message := 'OK';
        RETURN;

    EXCEPTION
        WHEN OTHERS THEN
            v_command := format(
                'CALL app.usp_api_special_quota_create(%s, %L, %L, %L, %L, out_message)',
                COALESCE(p_quota_type_id::TEXT, 'NULL'),
                COALESCE(p_special_quota_desc_pt, 'NULL'),
                COALESCE(p_special_quota_desc_short, 'NULL'),
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
                'special_quota',
                'app.usp_api_special_quota_create',
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
