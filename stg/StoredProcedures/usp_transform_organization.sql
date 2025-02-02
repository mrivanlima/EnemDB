DROP PROCEDURE IF EXISTS stg.usp_transform_organization;

CREATE OR REPLACE PROCEDURE stg.usp_transform_organization()
AS $$
BEGIN
    -- Step 1: Log start
    RAISE NOTICE 'Starting procedure execution...';

    -- Step 2: Truncate the target table
    TRUNCATE TABLE stg.organization RESTART IDENTITY;
    RAISE NOTICE 'Table truncated successfully.';

    -- Step 3: Insert distinct records
    RAISE NOTICE 'Inserting distinct records...';

    INSERT INTO stg.organization (
        academic_organization_description,
        academic_organization_description_ascii
    )
    SELECT DISTINCT
        e.ds_organizacao_academica AS academic_organization_description,
        UNACCENT(e.ds_organizacao_academica) AS academic_organization_description_ascii
    FROM imp.enem_cutoff_scores_2019_2024 e;

    -- Step 4: Log the number of rows inserted
    RAISE NOTICE 'Number of rows inserted: %', (SELECT COUNT(*) FROM stg.organization);

    RAISE NOTICE 'Procedure execution completed successfully.';
END;
$$ LANGUAGE plpgsql;