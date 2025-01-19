-----------------------------------------------------------------
--Create procedure to add new user login
-----------------------------------------------------------------
DROP PROCEDURE IF EXISTS app.usp_api_account_create;
CREATE OR REPLACE PROCEDURE app.usp_api_account_create(
    OUT p_out_user_id INTEGER,
	OUT p_out_message VARCHAR(100),
    IN p_user_unique_id uuid,
    IN p_username VARCHAR(100),
    IN p_password_hash VARCHAR(100),
    IN p_password_salt VARCHAR(100),
    IN p_is_verified BOOLEAN DEFAULT FALSE,
    IN p_is_active BOOLEAN DEFAULT TRUE,
    IN p_is_locked BOOLEAN DEFAULT FALSE,
    IN p_password_attempts SMALLINT DEFAULT 0,
    IN p_changed_initial_password BOOLEAN DEFAULT TRUE,
    IN p_locked_time TIMESTAMPTZ DEFAULT NULL,
    IN p_created_by INTEGER DEFAULT NULL,
    IN p_modified_by INTEGER DEFAULT NULL,
    INOUT p_error BOOLEAN DEFAULT FALSE
)
AS $$
DECLARE
    l_context TEXT;
BEGIN
    BEGIN
        p_username := TRIM(p_username);

		IF EXISTS (SELECT 1 FROM app.account WHERE username = p_username) THEN
	        p_out_message := 'Usuario ja registrado!';
            p_error = TRUE;
            RETURN;
	        -- RAISE EXCEPTION USING MESSAGE = p_out_message;
    	END IF;

        -- Insert the new user login record into the app.account table
        INSERT INTO app.account (
            user_unique_id,
            username,
            password_hash,
            password_salt,
            is_verified,
            is_active,
            is_locked,
            password_attempts,
            changed_initial_password,
            locked_time,
            created_by,
            created_on,
            modified_by,
            modified_on
        )
        VALUES 
        (
            p_user_unique_id,
            p_username,
            p_password_hash,
            p_password_salt,
            COALESCE(p_is_verified, FALSE),
            COALESCE(p_is_active, FALSE),
            COALESCE(p_is_locked, FALSE),
            COALESCE(p_password_attempts, 0),
            p_changed_initial_password,
            p_locked_time,
            p_created_by,
            DEFAULT,  -- Use default for created_on
            p_modified_by,
            DEFAULT   -- Use default for modified_on
        ) RETURNING user_id INTO p_out_user_id;

        EXCEPTION
        WHEN OTHERS THEN
            p_error := TRUE;
            GET STACKED DIAGNOSTICS l_context = PG_EXCEPTION_CONTEXT;
            INSERT INTO app.error_log 
            (
                error_message, 
                error_code, 
                error_line
            )
            VALUES 
            (
                SQLERRM, 
                SQLSTATE, 
                l_context
            );
    END;
END;
$$ LANGUAGE plpgsql;
