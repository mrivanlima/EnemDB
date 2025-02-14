DROP PROCEDURE IF EXISTS stg.usp_transform_category;

CREATE OR REPLACE PROCEDURE stg.usp_transform_category()
AS $$
BEGIN
    -- Step 1: Log start
    RAISE NOTICE 'Starting procedure execution...';

    -- Step 2: Truncate the target table
    TRUNCATE TABLE stg.category RESTART IDENTITY;
    RAISE NOTICE 'Table truncated successfully.';

    -- Step 3: Insert distinct records
    RAISE NOTICE 'Inserting distinct records...';

    INSERT INTO stg.category (
        category_name,
        category_name_ascii
    )
    SELECT DISTINCT
        UPPER(combined.category_name),
        UNACCENT(UPPER(combined.category_name_ascii))
    FROM (
        -- Data from 2019-2025
        SELECT
            TRIM(e.ds_categoria_adm) AS category_name,
            TRIM(UNACCENT(e.ds_categoria_adm)) AS category_name_ascii
        FROM imp.enem_vagas_ofertadas_2019_2025 e

        UNION

        -- Data from 2010-2018
        SELECT
            TRIM(ec.categoria_administrativa) AS category_name,
            TRIM(UNACCENT(ec.categoria_administrativa)) AS category_name_ascii
        FROM imp.enem_vagas_ofertadas_2010_2018 ec
    ) combined;

    -- Step 4: Log the number of rows inserted
    RAISE NOTICE 'Number of rows inserted: %', (SELECT COUNT(*) FROM stg.category);

    RAISE NOTICE 'Procedure execution completed successfully.';
END;
$$ LANGUAGE plpgsql;
