DROP FUNCTION IF EXISTS app.usp_api_account_read_by_name(VARCHAR(100));
CREATE OR REPLACE FUNCTION app.usp_api_account_read_by_name(p_username VARCHAR(100))
RETURNS SETOF app.account_record
AS $$
BEGIN
    RETURN QUERY
    SELECT 
        user_id,
        user_unique_id,
        username,
        email,
        password_hash,
        password_salt,
        is_verified,
        is_active,
        is_locked,
        password_attempts,
        changed_initial_password
    FROM app.account
    WHERE username = p_username
    --AND is_active = TRUE
    LIMIT 1;
END; 
$$ LANGUAGE plpgsql;