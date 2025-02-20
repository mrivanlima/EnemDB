DROP PROCEDURE IF EXISTS stg.usp_transform_course;

CREATE OR REPLACE PROCEDURE stg.usp_transform_course()
AS $$
BEGIN
    -- Step 1: Log start
    RAISE NOTICE 'Starting procedure execution...';

    -- Step 2: Truncate the target table
    TRUNCATE TABLE stg.course RESTART IDENTITY;
    RAISE NOTICE 'Table truncated successfully.';

    -- Step 3: Insert distinct records
    RAISE NOTICE 'Inserting distinct records...';

    INSERT INTO stg.course (
    school_code,
    course_code,
    course_name,
    course_name_ascii
    )
SELECT DISTINCT
    combined.school_code,
    combined.course_code,
    UPPER(combined.course_name),
    UNACCENT(UPPER(combined.course_name_ascii))
FROM (
    -- Dados de 2019-2025
    SELECT
        e.co_ies AS school_code,
        e.co_ies_curso AS course_code,
        TRIM(e.no_curso) AS course_name,
        TRIM(UNACCENT(e.no_curso)) AS course_name_ascii
    FROM imp.enem_vagas_ofertadas_2019_2025 e

    UNION

    -- Dados de 2010-2018
    SELECT
        ec.cod_ies AS school_code,
        ec.cod_curso AS course_code,
        TRIM(ec.nome_curso) AS course_name,
        TRIM(UNACCENT(ec.nome_curso)) AS course_name_ascii
    FROM imp.enem_vagas_ofertadas_2010_2018 ec
    ) combined;

    -- Step 4: Log the number of rows inserted
    RAISE NOTICE 'Number of rows inserted: %', (SELECT COUNT(*) FROM stg.course);

    RAISE NOTICE 'Procedure execution completed successfully.';
END;
$$ LANGUAGE plpgsql;
