
\! chcp 65001
\! set PGCLIENTENCODING=UTF8
\! SET client_encoding = 'UTF8'



\i './Config.sql'

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

\i './app/Tables/account.sql'
\i './app/Tables/address.sql'
\i './app/Tables/error_log.sql'
\i './stg/Tables/campus.sql'
\i './stg/Tables/cutoff_score.sql'
\i './stg/Tables/organization.sql'
\i './stg/Tables/school.sql'
\i './stg/Tables/category.sql'
\i './stg/Tables/degree.sql'
\i './stg/Tables/shift.sql'
\i './stg/Tables/course.sql'

--Add app functions



--Add Stored Procedures


\i './app/StoredProcedures/usp_api_account_create.sql'
\i './app/StoredProcedures/usp_api_address_create.sql'
\i './stg/StoredProcedures/usp_transform_campus.sql'
\i './stg/StoredProcedures/usp_transform_organization.sql'
\i './stg/StoredProcedures/usp_transform_university.sql'
\i './stg/StoredProcedures/usp_transform_category.sql'
\i './stg/StoredProcedures/usp_transform_degree.sql'
\i './stg/StoredProcedures/usp_transform_shift.sql'
\i './stg/StoredProcedures/usp_transform_course.sql'

--Add Views



--Add Indexes


\i './seed.sql'

\c enem