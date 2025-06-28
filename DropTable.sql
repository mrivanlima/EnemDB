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

drop table if exists app.academic_organization cascade;
drop table if exists app.account cascade;
drop table if exists app.address cascade;
drop table if exists app.alternative cascade;
drop table if exists app.answer_key cascade;
drop table if exists app.answer_submission cascade;
drop table if exists app.approved_student cascade;
drop table if exists app.booklet_color cascade;
drop table if exists app.booklet_mapping cascade;
drop table if exists app.city cascade;
drop table if exists app.degree_level cascade;
drop table if exists app.degree cascade;
drop table if exists app.error_log cascade;
drop table if exists app.exam_attempt cascade;
drop table if exists app.frequency cascade;
drop table if exists app.item_statistics cascade;
drop table if exists app.question cascade;
drop table if exists app.quota_type cascade;
drop table if exists app.region cascade;
drop table if exists app.response cascade;
drop table if exists app.seats cascade;
drop table if exists app.shift cascade;
drop table if exists app.special_quota cascade;
drop table if exists app.state cascade;
drop table if exists app.student_ability_estimation cascade;
drop table if exists app.submission_deadline cascade;
drop table if exists app.university_campus cascade;
drop table if exists app.university_category cascade;
drop table if exists app.university.sql cascade;
drop table if exists app.year cascade;



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
