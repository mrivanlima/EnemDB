--Add imp tables
\i './imp/Tables/sisu_data_dictionary.sql'
\i './imp/Tables/sisu_spot_offer.sql'



--A-- Stored Procedures from imp
\i './imp/StoredProcedures/batch_create_years.sql'
\i './imp/StoredProcedures/batch_create_universities.sql'
\i './imp/StoredProcedures/batch_create_academic_organization.sql'
\i './imp/StoredProcedures/batch_create_university_category.sql'

