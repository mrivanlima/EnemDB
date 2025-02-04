
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



--Add imp tables

\i './imp/Tables/enem_cutoff_scores_2010_2018.sql'
\i './imp/Tables/enem_cutoff_scores_2019_2024.sql'
\i './imp/Tables/sisu_offer_report.sql'

--Add app tables

\i './app/Tables/account.sql'
\i './app/Tables/address.sql'
\i './app/Tables/error_log.sql'

--Add app functions



--Add Stored Procedures


\i './app/StoredProcedures/usp_api_account_create.sql'
\i './app/StoredProcedures/usp_api_address_create.sql'

--Add Views



--Add Indexes


\i './seed.sql'

\c enem