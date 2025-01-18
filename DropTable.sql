drop table if exists app.error_log cascade;
drop table if exists app.state cascade;
drop table if exists app.city cascade;
drop table if exists app.neighborhood cascade;
drop table if exists app.street cascade;
drop table if exists app.address cascade;
drop table if exists app.address_type cascade;
drop table if exists app.user cascade;
drop table if exists app.user_login cascade;
drop table if exists app.user_token cascade;
drop table if exists app.user_address cascade;
drop table if exists app.quote cascade;
drop table if exists app.product cascade;
drop table if exists app.role cascade;
drop table if exists app.user_role cascade;
drop table if exists app.group cascade;
drop table if exists app.user_group cascade;
drop table if exists app.product_version cascade;
drop table if exists app.quote_response cascade;
drop table if exists app.quote_product_response cascade;
drop table if exists app.contact_type cascade;
drop table if exists app.user_password_reset cascade;




DROP FUNCTION IF EXISTS app.usp_api_state_read_by_id;
DROP FUNCTION IF EXISTS app.usp_api_state_read_all();
