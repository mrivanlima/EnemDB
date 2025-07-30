
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
\i './DropFunctions.sql'


\i './app_objects.sql'
\i './imp_objects.sql'

\i './seed.sql'

-- \echo 'Table "my_table" created.'
-- SELECT COUNT(*) FROM my_table;

\c enem