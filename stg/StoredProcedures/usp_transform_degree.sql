DROP PROCEDURE IF EXISTS stg.usp_transform_degree;

CREATE OR REPLACE PROCEDURE stg.usp_transform_degree()
AS $$
BEGIN
    -- Step 1: Log start
    RAISE NOTICE 'Starting procedure execution...';

    -- Step 2: Truncate the target table
    TRUNCATE TABLE stg.degree RESTART IDENTITY;
    RAISE NOTICE 'Table truncated successfully.';

    -- Step 3: Insert distinct records
    RAISE NOTICE 'Inserting distinct records...';

    INSERT INTO stg.degree (
        degree_type,
        degree_type_ascii
    )
    SELECT DISTINCT
        combined.degree_type,
        combined.degree_type_ascii
    FROM (
        -- Data from 2019-2025
        SELECT
            e.ds_grau AS degree_type,
            UNACCENT(e.ds_grau) AS degree_type_ascii
        FROM imp.enem_vagas_ofertadas_2019_2025 e

        UNION

        -- Data from 2010-2018
        SELECT
            ec.grau AS degree_type,
            UNACCENT(ec.grau) AS degree_type_ascii
        FROM imp.enem_vagas_ofertadas_2010_2018 ec
    ) combined;

    -- Step 4: Log the number of rows inserted
    RAISE NOTICE 'Number of rows inserted: %', (SELECT COUNT(*) FROM stg.degree);

    RAISE NOTICE 'Procedure execution completed successfully.';
END;
$$ LANGUAGE plpgsql;
