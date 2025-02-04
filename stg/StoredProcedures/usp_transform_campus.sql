DROP PROCEDURE IF EXISTS stg.usp_transform_campus;

CREATE OR REPLACE PROCEDURE stg.usp_transform_campus()
AS $$
BEGIN
    -- Step 1: Log start
    RAISE NOTICE 'Starting procedure execution...';

    -- Step 2: Truncate the target table
    TRUNCATE TABLE stg.campus RESTART IDENTITY;
    RAISE NOTICE 'Table truncated successfully.';

    -- Step 3: Insert distinct records
    RAISE NOTICE 'Inserting distinct records...';

    INSERT INTO stg.campus (
    school_code,  -- New column
    campus_name,
    campus_name_ascii,
    campus_municipality_name,
    campus_municipality_name_ascii,
    campus_abrv,
    campus_abrv_ascii,
    campus_region,
    campus_region_ascii
)
SELECT 
    school_code,
    campus_name,
    campus_name_ascii,
    MAX(campus_municipality_name) AS campus_municipality_name,
    MAX(campus_municipality_name_ascii) AS campus_municipality_name_ascii,
    MAX(campus_abrv) AS campus_abrv,
    MAX(campus_abrv_ascii) AS campus_abrv_ascii,
    MAX(campus_region) AS campus_region,
    MAX(campus_region_ascii) AS campus_region_ascii
FROM (
    SELECT DISTINCT
        e.co_ies AS school_code,
        TRIM(UPPER(e.no_campus)) AS campus_name,
        UNACCENT(TRIM(UPPER(e.no_campus))) AS campus_name_ascii,
        TRIM(UPPER(e.no_municipio_campus)) AS campus_municipality_name,
        UNACCENT(TRIM(UPPER(e.no_municipio_campus))) AS campus_municipality_name_ascii,
        TRIM(UPPER(e.sg_uf_campus)) AS campus_abrv,
        UNACCENT(TRIM(UPPER(e.sg_uf_campus))) AS campus_abrv_ascii,
        TRIM(UPPER(e.ds_regiao_campus)) AS campus_region,
        UNACCENT(TRIM(UPPER(e.ds_regiao_campus))) AS campus_region_ascii
    FROM imp.enem_cutoff_scores_2019_2024 e

    UNION

    SELECT DISTINCT
        ec.cod_ies AS school_code,
        TRIM(UPPER(ec.campus)) AS campus_name,
        UNACCENT(TRIM(UPPER(ec.campus))) AS campus_name_ascii,
        NULL AS campus_municipality_name,
        NULL AS campus_municipality_name_ascii,
        NULL AS campus_abrv,
        NULL AS campus_abrv_ascii,
        NULL AS campus_region,
        NULL AS campus_region_ascii
    FROM imp.enem_cutoff_scores_2010_2018 ec
) combined
GROUP BY school_code, campus_name, campus_name_ascii;

    -- Step 4: Log the number of rows inserted
    RAISE NOTICE 'Number of rows inserted: %', (SELECT COUNT(*) FROM stg.campus);

    RAISE NOTICE 'Procedure execution completed successfully.';
END;
$$ LANGUAGE plpgsql;