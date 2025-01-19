
\! chcp 65001
\! set PGCLIENTENCODING=UTF8
\! SET client_encoding = 'UTF8'



\i 'C:/Development/EnemDB/EnemDB/Config.sql'

--For UTF character in the sql file
-- \! chcp 65001
-- \! set PGCLIENTENCODING=UTF8
-----------------------------------

\c enem



\i 'C:/Development/EnemDB/EnemDB/schemas.sql'
\i 'C:/Development/EnemDB/EnemDB/extensions.sql'
\i 'C:/Development/EnemDB/EnemDB/DropTable.sql'

--Add types
-- \i 'C:/Development/EnemDB/EnemDB/app/Types/user_login_record.sql'
-- \i 'C:/Development/EnemDB/EnemDB/app/Types/state_record.sql'
-- \i 'C:/Development/EnemDB/EnemDB/app/Types/user_record.sql'

--Add imp tables
-- \i 'C:/Development/EnemDB/EnemDB/imp/zip_info.sql'
-- \i 'C:/Development/EnemDB/EnemDB/imp/conformity.sql'
-- \i 'C:/Development/EnemDB/EnemDB/imp/presentation.sql'


--Add app tables

\i 'C:/Development/EnemDB/EnemDB/app/Tables/account.sql'
-- \i 'C:/Development/EnemDB/EnemDB/app/Tables/user_login.sql'
-- \i 'C:/Development/EnemDB/EnemDB/app/Tables/profession.sql'
-- \i 'C:/Development/EnemDB/EnemDB/app/Tables/professional.sql'
-- \i 'C:/Development/EnemDB/EnemDB/app/Tables/error_log.sql'
-- \i 'C:/Development/EnemDB/EnemDB/app/Tables/state.sql'
-- \i 'C:/Development/EnemDB/EnemDB/app/Tables/city.sql'
-- \i 'C:/Development/EnemDB/EnemDB/app/Tables/neighborhood.sql'
-- \i 'C:/Development/EnemDB/EnemDB/app/Tables/street.sql'
-- \i 'C:/Development/EnemDB/EnemDB/app/Tables/address.sql'
-- \i 'C:/Development/EnemDB/EnemDB/app/Tables/facility.sql'
-- \i 'C:/Development/EnemDB/EnemDB/app/Tables/user.sql'
-- \i 'C:/Development/EnemDB/EnemDB/app/Tables/user_token.sql'
-- \i 'C:/Development/EnemDB/EnemDB/app/Tables/user_address.sql'
-- \i 'C:/Development/EnemDB/EnemDB/app/Tables/drugstore.sql'
-- \i 'C:/Development/EnemDB/EnemDB/app/Tables/drugstore_neighborhood_subscription.sql'
-- \i 'C:/Development/EnemDB/EnemDB/app/Tables/prescription.sql'
-- \i 'C:/Development/EnemDB/EnemDB/app/Tables/quote.sql'
-- \i 'C:/Development/EnemDB/EnemDB/app/Tables/product.sql'
-- \i 'C:/Development/EnemDB/EnemDB/app/Tables/quote_product.sql'
-- \i 'C:/Development/EnemDB/EnemDB/app/Tables/role.sql'
-- \i 'C:/Development/EnemDB/EnemDB/app/Tables/user_role.sql'
-- \i 'C:/Development/EnemDB/EnemDB/app/Tables/group.sql'
-- \i 'C:/Development/EnemDB/EnemDB/app/Tables/user_group.sql'
-- \i 'C:/Development/EnemDB/EnemDB/app/Tables/product_version.sql'
-- \i 'C:/Development/EnemDB/EnemDB/app/Tables/quote_response.sql'
-- \i 'C:/Development/EnemDB/EnemDB/app/Tables/quote_product_response.sql'
-- \i 'C:/Development/EnemDB/EnemDB/app/Tables/contact_type.sql'
-- \i 'C:/Development/EnemDB/EnemDB/app/Tables/user_password_reset.sql'
-- \i 'C:/Development/EnemDB/EnemDB/app/Tables/quote_prescription.sql'



--Add app functions

-- \i 'C:/Development/EnemDB/EnemDB/app/Functions/drop_all_foreign_keys.sql'
-- \i 'C:/Development/EnemDB/EnemDB/app/Functions/usp_api_group_read_all.sql'
-- \i 'C:/Development/EnemDB/EnemDB/app/Functions/usp_api_profession_read_all.sql'
-- \i 'C:/Development/EnemDB/EnemDB/app/Functions/usp_api_state_read_all.sql'
-- \i 'C:/Development/EnemDB/EnemDB/app/Functions/usp_api_state_read_by_id.sql'
-- \i 'C:/Development/EnemDB/EnemDB/app/Functions/usp_api_user_read_all.sql'
-- \i 'C:/Development/EnemDB/EnemDB/app/Functions/usp_api_user_login_read_all.sql'
-- \i 'C:/Development/EnemDB/EnemDB/app/Functions/usp_api_user_login_read.sql'
-- \i 'C:/Development/EnemDB/EnemDB/app/Functions/usp_api_user_login_read_by_id.sql'
-- \i 'C:/Development/EnemDB/EnemDB/app/Functions/usp_api_user_role_read.sql'
-- \i 'C:/Development/EnemDB/EnemDB/app/Functions/usp_api_user_read_by_id.sql'



--Add Stored Procedures


\i 'C:/Development/EnemDB/EnemDB/app/StoredProcedures/usp_api_account_create.sql'
-- \i 'C:/Development/EnemDB/EnemDB/app/StoredProcedures/drop_foreign_keys.sql'
-- \i 'C:/Development/EnemDB/EnemDB/app/StoredProcedures/usp_api_user_login_create.sql'
-- \i 'C:/Development/EnemDB/EnemDB/app/StoredProcedures/usp_api_user_create.sql'
-- \i 'C:/Development/EnemDB/EnemDB/app/StoredProcedures/usp_api_address_create.sql'
-- \i 'C:/Development/EnemDB/EnemDB/app/StoredProcedures/usp_api_city_create.sql'
-- \i 'C:/Development/EnemDB/EnemDB/app/StoredProcedures/usp_api_drugstore_create.sql'
-- \i 'C:/Development/EnemDB/EnemDB/app/StoredProcedures/usp_api_group_create.sql'
-- \i 'C:/Development/EnemDB/EnemDB/app/StoredProcedures/usp_api_neighborhood_create.sql'
-- \i 'C:/Development/EnemDB/EnemDB/app/StoredProcedures/usp_api_state_create.sql'
-- \i 'C:/Development/EnemDB/EnemDB/app/StoredProcedures/usp_api_state_update_by_id.sql'
-- \i 'C:/Development/EnemDB/EnemDB/app/StoredProcedures/usp_api_street_create.sql'
-- \i 'C:/Development/EnemDB/EnemDB/app/StoredProcedures/usp_api_quote_create.sql'
-- \i 'C:/Development/EnemDB/EnemDB/app/StoredProcedures/usp_api_user_address_create.sql'
-- \i 'C:/Development/EnemDB/EnemDB/app/StoredProcedures/usp_api_user_role_create.sql'
-- \i 'C:/Development/EnemDB/EnemDB/app/StoredProcedures/usp_api_user_setup.sql'
-- \i 'C:/Development/EnemDB/EnemDB/app/StoredProcedures/usp_city_import.sql'
-- \i 'C:/Development/EnemDB/EnemDB/app/StoredProcedures/usp_neighborhood_import.sql'
-- \i 'C:/Development/EnemDB/EnemDB/app/StoredProcedures/usp_api_profession_create.sql'
-- \i 'C:/Development/EnemDB/EnemDB/app/StoredProcedures/usp_seed.sql'
-- \i 'C:/Development/EnemDB/EnemDB/app/StoredProcedures/usp_state_import.sql'
-- \i 'C:/Development/EnemDB/EnemDB/app/StoredProcedures/usp_street_import.sql'
-- \i 'C:/Development/EnemDB/EnemDB/app/StoredProcedures/usp_api_role_create.sql'
-- \i 'C:/Development/EnemDB/EnemDB/app/StoredProcedures/usp_api_facility_create.sql'
-- \i 'C:/Development/EnemDB/EnemDB/app/StoredProcedures/usp_api_prescription_create.sql'
-- \i 'C:/Development/EnemDB/EnemDB/app/StoredProcedures/usp_api_quote_prescription_create.sql'
-- \i 'C:/Development/EnemDB/EnemDB/app/StoredProcedures/usp_api_product_version_create.sql'
-- \i 'C:/Development/EnemDB/EnemDB/app/StoredProcedures/usp_api_product_create.sql'

-- \i 'C:/Development/EnemDB/EnemDB/app/StoredProcedures/usp_api_user_login_update_by_uuid.sql'
-- \i 'C:/Development/EnemDB/EnemDB/app/StoredProcedures/usp_api_user_login_update_by_username_for_lock.sql'
-- \i 'C:/Development/EnemDB/EnemDB/app/StoredProcedures/usp_api_user_login_update_password.sql'
-- \i 'C:/Development/EnemDB/EnemDB/app/StoredProcedures/usp_api_user_login_confirm_update.sql'


--Add Views

-- \i 'C:/Development/EnemDB/EnemDB/app/Views/v_street_details.sql'
-- \i 'C:/Development/EnemDB/EnemDB/app/Views/v_user_address.sql'
-- \i 'C:/Development/EnemDB/EnemDB/app/Views/v_user_login_details.sql'

--Add Indexes
-- \i 'C:/Development/EnemDB/EnemDB/app/Indexes/idx_street_zipcode.sql'
-- \i 'C:/Development/EnemDB/EnemDB/app/Indexes/ix_userlogin_username.sql'



\i 'C:/Development/EnemDB/EnemDB/seed.sql'

\c enem