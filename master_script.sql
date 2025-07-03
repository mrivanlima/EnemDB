
\! chcp 65001
\! set PGCLIENTENCODING=UTF8
\! SET client_encoding = 'UTF8'
\! SET client_min_messages TO WARNING;
\! SET client_min_messages TO NOTICE;



-- \i './Config.sql'

--For UTF character in the sql file
-- \! chcp 65001
-- \! set PGCLIENTENCODING=UTF8
-----------------------------------

\c enem



\i './schemas.sql'
\i './extensions.sql'
\i './DropTable.sql'



--Add types

\i './app/Types/account_record.sql'



--Add imp tables
\i './app/Tables/error_log.sql'

\i './imp/Tables/old_chamada_regular.sql'
\i './imp/Tables/chamada_regular.sql'
\i './imp/Tables/chamada_regular_json.sql'
\i './imp/Tables/institutions_json.sql'
\i './imp/Tables/enem_cutoff_scores_2010_2018.sql'
\i './imp/Tables/enem_cutoff_scores_2019_2024.sql'
\i './imp/Tables/sisu_offer_report.sql'
\i './imp/Tables/enem_vagas_ofertadas_2010_2018.sql'
\i './imp/Tables/enem_vagas_ofertadas_2019_2025.sql'

--Add app tables

-- User and basic reference
\i './app/Tables/user_login.sql'
\i './app/Tables/user_auth_provider.sql'
\i './app/Tables/user_role.sql'
\i './app/Tables/email_verification.sql'
\i './app/Tables/password_reset.sql'
\i './app/Tables/terms_acceptance.sql'

\i './app/Tables/language.sql'

-- Geographical/Institutional
\i './app/Tables/region.sql'
\i './app/Tables/state.sql'
\i './app/Tables/city.sql'
\i './app/Tables/academic_organization.sql'
\i './app/Tables/university_category.sql'
\i './app/Tables/university.sql'
\i './app/Tables/university_campus.sql'

-- Academic structure
\i './app/Tables/year.sql'
\i './app/Tables/degree_level.sql'
\i './app/Tables/degree.sql'
\i './app/Tables/frequency.sql'
\i './app/Tables/shift.sql'

-- Quotas & Affirmative Action
\i './app/Tables/quota_type.sql'
\i './app/Tables/special_quota.sql'

-- Exam & Question Structure
\i './app/Tables/area.sql'
\i './app/Tables/exam_day.sql'
\i './app/Tables/exam_year.sql'
\i './app/Tables/subject.sql'
\i './app/Tables/topic.sql'
\i './app/Tables/subtopic.sql'
\i './app/Tables/school_year.sql'
\i './app/Tables/subtopic_school_year.sql'

-- Booklet mapping/versioning
\i './app/Tables/booklet_color.sql'
\i './app/Tables/booklet_mapping.sql'

-- Questions and Alternatives
\i './app/Tables/question.sql'
\i './app/Tables/alternative.sql'

-- Exam attempts and answers
\i './app/Tables/exam_attempt.sql'
\i './app/Tables/answer_key.sql'
\i './app/Tables/answer_submission.sql'
\i './app/Tables/response.sql'

-- Admission and Seats
\i './app/Tables/approved_student.sql'
\i './app/Tables/seats.sql'

\i './app/Tables/exam_question.sql'



-- Optionally, these (uncomment if you have them)
--\i './app/Tables/course.sql'
--\i './app/Tables/institution.sql'






--Add stg Table
\i './stg/Tables/campus.sql'
\i './stg/Tables/cutoff_score.sql'
\i './stg/Tables/organization.sql'
\i './stg/Tables/school.sql'
\i './stg/Tables/category.sql'
\i './stg/Tables/degree.sql'
\i './stg/Tables/shift.sql'
\i './stg/Tables/course.sql'


--Add app functions
\i './app/Functions/set_academic_organization_name_friendly.sql'
\i './app/Functions/set_alternative_friendly_fields.sql'
\i './app/Functions/set_booklet_color_name_friendly.sql'
\i './app/Functions/set_city_name_friendly.sql'
\i './app/Functions/set_degree_level_name_friendly.sql'
\i './app/Functions/set_degree_name_friendly.sql'
\i './app/Functions/set_exam_attempt_friendly_fields.sql'
\i './app/Functions/set_frequency_name_friendly.sql'
\i './app/Functions/set_question_friendly_fields.sql'
\i './app/Functions/set_region_name_friendly.sql'
\i './app/Functions/set_response_friendly_fields.sql'
\i './app/Functions/set_shift_name_friendly.sql'
\i './app/Functions/set_state_name_friendly.sql'
\i './app/Functions/set_university_campus_name_friendly.sql'
\i './app/Functions/set_university_category_name_friendly.sql'
\i './app/Functions/set_university_name_friendly.sql'
\i './app/Functions/set_language_name_friendly.sql'
-- \i './app/Functions/set_year_name_friendly.sql'

--\i './app/Functions/usp_api_account_read_by_id.sql'
\i './app/Functions/usp_api_account_read_by_name.sql'
--\i './app/Functions/usp_api_address_read_by_id.sql'
--\i './app/Functions/usp_api_address_read_by_name.sql'
--\i './app/Functions/usp_api_alternative_read_by_id.sql'
--\i './app/Functions/usp_api_alternative_read_by_name.sql'
--\i './app/Functions/usp_api_answer_key_read_by_id.sql'
--\i './app/Functions/usp_api_answer_key_read_by_name.sql'
-- \i './app/Functions/usp_api_answer_submission_read_by_id.sql'
-- \i './app/Functions/usp_api_answer_submission_read_by_name.sql'
-- \i './app/Functions/usp_api_approved_student_read_by_id.sql'
-- \i './app/Functions/usp_api_approved_student_read_by_name.sql'
-- \i './app/Functions/usp_api_booklet_color_read_by_id.sql'
-- \i './app/Functions/usp_api_booklet_color_read_by_name.sql'
-- \i './app/Functions/usp_api_booklet_mapping_read_by_name.sql'
-- \i './app/Functions/usp_api_city_read_by_id.sql'
-- \i './app/Functions/usp_api_city_read_by_name.sql'
-- \i './app/Functions/usp_api_degree_level_read_by_id.sql'
-- \i './app/Functions/usp_api_degree_level_read_by_name.sql'
-- \i './app/Functions/usp_api_degree_read_by_name.sql'
-- \i './app/Functions/usp_api_exam_attempt_read_by_id.sql'
-- \i './app/Functions/usp_api_exam_attempt_read_by_name.sql'
-- \i './app/Functions/usp_api_frequency_read_by_id.sql'
-- \i './app/Functions/usp_api_frequency_read_by_name.sql'
-- \i './app/Functions/usp_api_question_read_by_id.sql'
-- \i './app/Functions/usp_api_question_read_by_name.sql'
-- \i './app/Functions/usp_api_quota_type_read_by_name.sql'
-- \i './app/Functions/usp_api_region_read_by_name.sql'
-- \i './app/Functions/usp_api_response_read_by_name.sql'
-- \i './app/Functions/usp_api_shift_read_by_name.sql'
-- \i './app/Functions/usp_api_special_quota_read_by_name.sql'
-- \i './app/Functions/usp_api_state_read_by_name.sql'
-- \i './app/Functions/usp_api_submission_deadline_read_by_name.sql'
-- \i './app/Functions/usp_api_university_campus_read_by_name.sql'
-- \i './app/Functions/usp_api_university_category_read_by_name.sql'
-- \i './app/Functions/usp_api_university_read_by_name.sql'
-- \i './app/Functions/usp_api_year_read_by_name.sql'
   


--Add Stored Procedures


-- \i './app/StoredProcedures/usp_api_account_create.sql'
-- \i './app/StoredProcedures/usp_api_address_create.sql'
-- \i './stg/StoredProcedures/usp_transform_campus.sql'
-- \i './stg/StoredProcedures/usp_transform_organization.sql'
-- \i './stg/StoredProcedures/usp_transform_university.sql'
-- \i './stg/StoredProcedures/usp_transform_category.sql'
-- \i './stg/StoredProcedures/usp_transform_degree.sql'
-- \i './stg/StoredProcedures/usp_transform_shift.sql'
-- \i './stg/StoredProcedures/usp_transform_course.sql'

\i './app/StoredProcedures/sp_api_degree_create.sql'
\i './app/StoredProcedures/usp_api_academic_organization_create.sql'
\i './app/StoredProcedures/usp_api_account_create.sql'
\i './app/StoredProcedures/usp_api_address_create.sql'
\i './app/StoredProcedures/usp_api_alternative_create.sql'
\i './app/StoredProcedures/usp_api_answer_key_create.sql'
\i './app/StoredProcedures/usp_api_answer_submission_create.sql'
\i './app/StoredProcedures/usp_api_approved_student_create.sql'
\i './app/StoredProcedures/usp_api_booklet_color_create.sql'
\i './app/StoredProcedures/usp_api_booklet_mapping_create.sql'
\i './app/StoredProcedures/usp_api_city_create.sql'
\i './app/StoredProcedures/usp_api_degree_level_create.sql'
\i './app/StoredProcedures/usp_api_exam_attempt_create.sql'
\i './app/StoredProcedures/usp_api_frequency_create.sql'
\i './app/StoredProcedures/usp_api_question_create.sql'
\i './app/StoredProcedures/usp_api_quota_type_create.sql'
\i './app/StoredProcedures/usp_api_region_create.sql'
\i './app/StoredProcedures/usp_api_response_create.sql'
\i './app/StoredProcedures/usp_api_shift_create.sql'
\i './app/StoredProcedures/usp_api_special_quota_create.sql'
\i './app/StoredProcedures/usp_api_state_create.sql'
\i './app/StoredProcedures/usp_api_submission_deadline_create.sql'
\i './app/StoredProcedures/usp_api_university_campus_create.sql'
\i './app/StoredProcedures/usp_api_university_category_create.sql'
\i './app/StoredProcedures/usp_api_university_create.sql'
\i './app/StoredProcedures/usp_api_year_create.sql'
\i './app/StoredProcedures/usp_exam_questions_import.sql'




--Add app triggers
\i './app/Triggers/trg_set_academic_organization_name_friendly.sql'
\i './app/Triggers/trg_set_alternative_friendly_fields.sql'
\i './app/Triggers/trg_set_booklet_color_name_friendly.sql'
\i './app/Triggers/trg_set_city_name_friendly.sql'
\i './app/Triggers/trg_set_degree_level_name_friendly.sql'
\i './app/Triggers/trg_set_degree_name_friendly.sql'
\i './app/Triggers/trg_set_exam_attempt_friendly_fields.sql'
\i './app/Triggers/trg_set_frequency_name_friendly.sql'
\i './app/Triggers/trg_set_language_name_friendly.sql'
\i './app/Triggers/trg_set_question_friendly_fields.sql'
\i './app/Triggers/trg_set_region_name_friendly.sql'
\i './app/Triggers/trg_set_response_friendly_fields.sql'
\i './app/Triggers/trg_set_shift_name_friendly.sql'
\i './app/Triggers/trg_set_state_name_friendly.sql'
\i './app/Triggers/trg_set_university_campus_name_friendly.sql'
\i './app/Triggers/trg_set_university_category_name_friendly.sql'
\i './app/Triggers/trg_set_university_name_friendly.sql'
\i './app/Triggers/trg_set_year_name_friendly.sql'



--Add Views



--Add Indexes


\i './seed.sql'

-- \echo 'Table "my_table" created.'
-- SELECT COUNT(*) FROM my_table;

\c enem