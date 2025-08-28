DROP FUNCTION IF EXISTS app.fn_number_to_words_ptbr(integer);
-- Drop procedures related to usp_api_user_email
DROP PROCEDURE IF EXISTS app.usp_api_user_email_verification_regenerate;
DROP PROCEDURE IF EXISTS app.usp_api_user_email_verification_validate_token;
DROP PROCEDURE IF EXISTS app.usp_api_user_email_verification_create;
DROP PROCEDURE IF EXISTS app.usp_api_user_email_verification_confirm_token;
DROP PROCEDURE IF EXISTS app.usp_api_user_email_verification_confirm;

-- Drop procedures related to usp_api_user_login
DROP PROCEDURE IF EXISTS app.usp_api_user_login_authenticate;
DROP PROCEDURE IF EXISTS app.usp_api_user_login_soft_delete;
DROP PROCEDURE IF EXISTS app.usp_api_user_login_password_reset;
DROP PROCEDURE IF EXISTS app.usp_api_user_login_lock_reset;
DROP PROCEDURE IF EXISTS app.usp_api_user_login_external_create;
DROP PROCEDURE IF EXISTS app.usp_api_user_login_add_password;
DROP PROCEDURE IF EXISTS app.usp_user_register_create;
DROP PROCEDURE IF EXISTS app.usp_api_user_login_attempts_update;
DROP PROCEDURE IF EXISTS app.usp_api_user_auth_provider_create;
