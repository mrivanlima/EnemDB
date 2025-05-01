-- ALTER SEQUENCE app.user_login_user_id_seq MINVALUE 0;
-- ALTER SEQUENCE app.user_login_user_id_seq RESTART WITH 0;

INSERT INTO app.account (
    user_unique_id, 
    username, 
    email,
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
) VALUES (
    uuid_generate_v4(),  -- Generate a new UUID
    'System', 
    'system@email.com',
    'System', 
    'System', 
    true,  -- is_verified
    true,  -- is_active
    false,  -- is_locked
    0,  -- password_attempts
    true,  -- changed_initial_password
    NULL,  -- locked_time
    0,  -- created_by
    current_timestamp,  -- created_on
    0,  -- modified_by
    current_timestamp  -- modified_on
);

CALL app.usp_seed();