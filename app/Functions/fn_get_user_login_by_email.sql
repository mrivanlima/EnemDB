CREATE OR REPLACE FUNCTION app.fn_get_user_login_by_email(p_email VARCHAR)
RETURNS TABLE (
    user_login_id     INT,
    user_login_unique UUID,
    email             VARCHAR,
    password_hash     VARCHAR,
    is_email_verified BOOLEAN,
    is_active         BOOLEAN,
    soft_deleted_at   TIMESTAMPTZ,
    last_login_at     TIMESTAMPTZ,
    login_attempts    INT,
    email_verified_at TIMESTAMPTZ,
    created_by        INT,
    created_on        TIMESTAMPTZ,
    modified_by       INT,
    modified_on       TIMESTAMPTZ
)
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY
    SELECT
        ul.user_login_id,
        ul.user_login_unique,
        ul.email,
        ul.password_hash,
        ul.is_email_verified,
        ul.is_active,
        ul.soft_deleted_at,
        ul.last_login_at,
        ul.login_attempts,
        ul.email_verified_at,
        ul.created_by,
        ul.created_on,
        ul.modified_by,
        ul.modified_on
    FROM app.user_login ul
    WHERE LOWER(ul.email) = LOWER(TRIM(p_email));
END;
$$;
