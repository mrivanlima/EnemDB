-- drop table if exists app.account cascade;
-- drop table if exists app.address cascade;
-- drop table if exists app.error_log cascade;

-- drop table if exists imp.old_chamada_regular cascade;
-- drop table if exists imp.chamada_regular cascade;
-- drop table if exists imp.chamada_regular_json cascade;
-- drop table if exists imp.institutions_json cascade;
-- drop table if exists imp.enem_dictionary cascade;
-- drop table if exists imp.enem_cutoff_scores_2010_2018 cascade;
-- drop table if exists imp.enem_cutoff_scores_2019_2024 cascade;

-- DROP ORDER: child tables first, then parents (safe for FKs)

DO $$
BEGIN
    RAISE NOTICE 'Process started...';
    -- Your code here
END;
$$;
-- M:N relationship tables and audit/auxiliary first if any (not in previous list, but if you use, drop here)
DROP TABLE IF EXISTS app.academic_organization CASCADE;
DROP TABLE IF EXISTS app.address CASCADE;
DROP TABLE IF EXISTS app.alternative CASCADE;
DROP TABLE IF EXISTS app.answer_key CASCADE;
DROP TABLE IF EXISTS app.answer_submission CASCADE;
DROP TABLE IF EXISTS app.approved_student CASCADE;
DROP TABLE IF EXISTS app.area CASCADE;
DROP TABLE IF EXISTS app.booklet_color CASCADE;
DROP TABLE IF EXISTS app.booklet_mapping CASCADE;
DROP TABLE IF EXISTS app.city CASCADE;
DROP TABLE IF EXISTS app.degree_level CASCADE;
DROP TABLE IF EXISTS app.degree CASCADE;
DROP TABLE IF EXISTS app.email_verification CASCADE;
DROP TABLE IF EXISTS app.error_log CASCADE;
DROP TABLE IF EXISTS app.exam_attempt CASCADE;
DROP TABLE IF EXISTS app.exam_day CASCADE;
DROP TABLE IF EXISTS app.exam_question CASCADE;
DROP TABLE IF EXISTS app.exam_year CASCADE;
DROP TABLE IF EXISTS app.frequency CASCADE;
DROP TABLE IF EXISTS app.item_statistics CASCADE;
DROP TABLE IF EXISTS app.language CASCADE;
DROP TABLE IF EXISTS app.password_reset CASCADE;
DROP TABLE IF EXISTS app.question CASCADE;
DROP TABLE IF EXISTS app.quota_type CASCADE;
DROP TABLE IF EXISTS app.region CASCADE;
DROP TABLE IF EXISTS app.response CASCADE;
DROP TABLE IF EXISTS app.role CASCADE;
DROP TABLE IF EXISTS app.school_year CASCADE;
DROP TABLE IF EXISTS app.seats CASCADE;
DROP TABLE IF EXISTS app.shift CASCADE;
DROP TABLE IF EXISTS app.special_quota CASCADE;
DROP TABLE IF EXISTS app.state CASCADE;
DROP TABLE IF EXISTS app.student_ability_estimation CASCADE;
DROP TABLE IF EXISTS app.subject CASCADE;
DROP TABLE IF EXISTS app.submission_deadline CASCADE;
DROP TABLE IF EXISTS app.subtopic_school_year CASCADE;
DROP TABLE IF EXISTS app.subtopic CASCADE;
DROP TABLE IF EXISTS app.terms_acceptance CASCADE;
DROP TABLE IF EXISTS app.topic CASCADE;
DROP TABLE IF EXISTS app.university_campus CASCADE;
DROP TABLE IF EXISTS app.university_category CASCADE;
DROP TABLE IF EXISTS app.university CASCADE;
DROP TABLE IF EXISTS app.user_auth_provider CASCADE;
DROP TABLE IF EXISTS app.user_login CASCADE;
DROP TABLE IF EXISTS app.user_role CASCADE;
DROP TABLE IF EXISTS app.year CASCADE;
DROP TABLE IF EXISTS app.neighborhood CASCADE;
DROP TABLE IF EXISTS app.street CASCADE;
DROP TABLE IF EXISTS app.user_info CASCADE;
DROP TABLE IF EXISTS app.provider_type CASCADE;
DROP TABLE IF EXISTS app.auth_provider CASCADE;
DROP TABLE IF EXISTS app.campus CASCADE;
DROP TABLE IF EXISTS app.quota_type CASCADE;
DROP TABLE IF EXISTS app.test_version CASCADE;
DROP TABLE IF EXISTS app.question_map CASCADE;
DROP TABLE IF EXISTS app.student_answer CASCADE;
DROP TABLE IF EXISTS app.question_current CASCADE;




--DROP TABLE IF EXISTS imp.sisu_data_dictionary CASCADE;
--DROP TABLE IF EXISTS imp.sisu_spot_offer CASCADE;


-- If you have any views/materialized views/functions, drop those last.




/*
drop function if exists app.set_academic_organization_name_friendly() cascade;
drop function if exists app.set_alternative_friendly_fields() cascade;
drop function if exists app.set_booklet_color_name_friendly() cascade;
drop function if exists app.set_city_name_friendly() cascade;
drop function if exists app.set_degree_level_name_friendly() cascade;
drop function if exists app.set_degree_name_friendly() cascade;
drop function if exists app.set_exam_attempt_friendly_fields() cascade;
drop function if exists app.set_frequency_name_friendly() cascade;
drop function if exists app.set_question_friendly_fields() cascade;
drop function if exists app.set_region_name_friendly() cascade;
drop function if exists app.set_response_friendly_fields() cascade;
drop function if exists app.set_shift_name_friendly() cascade;
drop function if exists app.set_state_name_friendly() cascade;
drop function if exists app.set_university_campus_name_friendly() cascade;
drop function if exists app.set_university_category_name_friendly() cascade;
drop function if exists app.set_university_name_friendly() cascade;
drop function if exists app.usp_api_account_read_by_name() cascade;


drop procedure if exists app.usp_api_degree_create() cascade;
drop procedure if exists app.usp_api_academic_organization_create() cascade;
drop procedure if exists app.usp_api_account_create() cascade;
drop procedure if exists app.usp_api_address_create() cascade;
drop procedure if exists app.usp_api_alternative_create() cascade;
drop procedure if exists app.usp_api_answer_key_create() cascade;
drop procedure if exists app.usp_api_answer_submission_create() cascade;
drop procedure if exists app.usp_api_approved_student_create() cascade;
drop procedure if exists app.usp_api_booklet_color_create() cascade;
drop procedure if exists app.usp_api_booklet_mapping_create() cascade;
drop procedure if exists app.usp_api_city_create() cascade;
drop procedure if exists app.usp_api_degree_level_create() cascade;
drop procedure if exists app.usp_api_exam_attempt_create() cascade;
drop procedure if exists app.usp_api_frequency_create() cascade;
drop procedure if exists app.usp_api_question_create() cascade;
drop procedure if exists app.usp_api_quota_type_create() cascade;
drop procedure if exists app.usp_api_region_create() cascade;
drop procedure if exists app.usp_api_response_create() cascade;
drop procedure if exists app.usp_api_shift_create() cascade;
drop procedure if exists app.usp_api_special_quota_create() cascade;
drop procedure if exists app.usp_api_state_create() cascade;
drop procedure if exists app.usp_api_submission_deadline_create() cascade;
drop procedure if exists app.usp_api_university_campus_create() cascade;
drop procedure if exists app.usp_api_university_category_create() cascade;
drop procedure if exists app.usp_api_university_create() cascade;
drop procedure if exists app.usp_api_year_create() cascade;





DROP FUNCTION IF EXISTS app.usp_api_state_read_by_id;
DROP FUNCTION IF EXISTS app.usp_api_state_read_all();

*/


DO $$
BEGIN
    RAISE NOTICE 'Process ended...';
    -- Your code here
END;
$$;
