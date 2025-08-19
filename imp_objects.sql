--Add imp tables
\i './imp/Tables/sisu_data_dictionary.sql'
\i './imp/Tables/sisu_spot_offer.sql'
\i './imp/Tables/region_state.sql'
\i './imp/Tables/brazil_states.sql'
\i './imp/Tables/city.sql'
\i './imp/Tables/degree_mapping.sql'
\i './imp/Tables/university_mapping.sql'
\i './imp/Tables/sisu_spot_cutoff_score.sql'
\i './imp/Tables/enem_question_parameter.sql'
\i './imp/Tables/exam_source.sql'
\i './imp/Tables/sisu_results.sql'
\i './imp/Tables/sisu_past_waitlist.sql'
\i './imp/Tables/sisu_past_results.sql'
\i './imp/Tables/university_mapping.sql'


--A-- Stored Procedures from imp
\i './imp/StoredProcedures/batch_create_years.sql'
\i './imp/StoredProcedures/batch_create_universities.sql'
\i './imp/StoredProcedures/batch_create_academic_organization.sql'
\i './imp/StoredProcedures/batch_create_university_category.sql'
\i './imp/StoredProcedures/batch_create_campus.sql'
\i './imp/StoredProcedures/batch_create_regions.sql'
\i './imp/StoredProcedures/batch_create_states.sql'
\i './imp/StoredProcedures/batch_create_cities.sql'
\i './imp/StoredProcedures/batch_create_degrees.sql'
\i './imp/StoredProcedures/batch_create_degree_levels.sql'
\i './imp/StoredProcedures/batch_create_shift.sql'
\i './imp/StoredProcedures/batch_create_frequency.sql'
\i './imp/StoredProcedures/batch_create_quota_type.sql'
\i './imp/StoredProcedures/batch_create_special_quota.sql'
\i './imp/StoredProcedures/batch_create_university_mapping.sql'
\i './imp/StoredProcedures/batch_create_seats.sql'
\i './imp/StoredProcedures/batch_create_student_result.sql'

-- Add functions
\i './imp/Functions/fix_campus_prefix.sql'

-- Add triggers
\i './imp/Triggers/trg_fix_campus_prefix.sql'
\i './imp/Triggers/trg_fix_campus_prefix_cutoff.sql'