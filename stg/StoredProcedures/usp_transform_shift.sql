DROP PROCEDURE IF EXISTS stg.usp_transform_shift;

CREATE OR REPLACE PROCEDURE stg.usp_transform_shift()
AS $$
BEGIN
    -- Step 1: Log start
    RAISE NOTICE 'Starting procedure execution...';

    -- Step 2: Truncate the target table
    TRUNCATE TABLE stg.shift RESTART IDENTITY;
    RAISE NOTICE 'Table truncated successfully.';

    -- Step 3: Insert distinct records
    RAISE NOTICE 'Inserting distinct records...';

    INSERT INTO stg.shift (
        shift_name,
        shift_name_ascii
    )
    SELECT DISTINCT
        UPPER(combined.shift_name),
        UNACCENT(UPPER(combined.shift_name_ascii))
    FROM (
        -- Data from 2019-2025
        SELECT
            TRIM(e.ds_turno) AS shift_name,
            TRIM(e.ds_turno) AS shift_name_ascii
        FROM imp.enem_vagas_ofertadas_2019_2025 e

        UNION

        -- Data from 2010-2018
        SELECT
            TRIM(ec.turno) AS shift_name,
            TRIM(ec.turno) AS shift_name_ascii
        FROM imp.enem_vagas_ofertadas_2010_2018 ec
    ) combined;

    -- Step 4: Log the number of rows inserted
    RAISE NOTICE 'Number of rows inserted: %', (SELECT COUNT(*) FROM stg.shift);

    RAISE NOTICE 'Procedure execution completed successfully.';
END;
$$ LANGUAGE plpgsql;
