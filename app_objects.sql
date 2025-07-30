-- User and basic reference
\i './app/Tables/user_login.sql'
\i './app/Tables/provider_type.sql'
\i './app/Tables/auth_provider.sql'
\i './app/Tables/user_auth_provider.sql'
\i './app/Tables/role.sql'
\i './app/Tables/user_role.sql'
\i './app/Tables/region.sql'
\i './app/Tables/state.sql'
\i './app/Tables/city.sql'
\i './app/Tables/neighborhood.sql'
\i './app/Tables/street.sql'
\i './app/Tables/address.sql'
\i './app/Tables/user_info.sql'
\i './app/Tables/error_log.sql'

\i './app/Tables/year.sql'
\i './app/Tables/university.sql'
\i './app/Tables/academic_organization.sql'



-- Stored Procedures
\i './app/StoredProcedures/usp_api_user_auth_provider_create.sql'
\i './app/StoredProcedures/usp_api_user_email_verification_confirm_token.sql'
\i './app/StoredProcedures/usp_api_user_email_verification_confirm.sql'
\i './app/StoredProcedures/usp_api_user_email_verification_create.sql'
\i './app/StoredProcedures/usp_api_user_email_verification_regenerate.sql'
\i './app/StoredProcedures/usp_api_user_email_verification_validate_token.sql'
\i './app/StoredProcedures/usp_api_user_login_add_password.sql'
\i './app/StoredProcedures/usp_api_user_login_authenticate.sql'
\i './app/StoredProcedures/usp_api_user_login_external_create.sql'
\i './app/StoredProcedures/usp_api_user_login_lock_reset.sql'
\i './app/StoredProcedures/usp_api_user_login_password_reset.sql'
\i './app/StoredProcedures/usp_api_user_login_soft_delete.sql'
\i './app/StoredProcedures/usp_api_user_register_create.sql'
\i './app/StoredProcedures/usp_api_year_create.sql'
\i './app/StoredProcedures/usp_api_academic_organization_create.sql'



--Functions
\i './app/Functions/fn_number_to_words_ptbr.sql'
\i './app/Functions/set_year_name_friendly.sql'
\i './app/Functions/set_university_name_friendly.sql'
\i './app/Functions/set_academic_organization_name_friendly.sql'

--Triggers
\i './app/Triggers/trg_set_year_name_friendly.sql'
\i './app/Triggers/trg_set_university_name_friendly.sql'
\i './app/Triggers/trg_set_academic_organization_name_friendly.sql'