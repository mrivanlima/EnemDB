CREATE OR REPLACE PROCEDURE imp.batch_create_universities()
LANGUAGE plpgsql
AS $$
DECLARE
    v_inserted INT;
    v_created_by INT := 1;
BEGIN
    INSERT INTO app.university (
        university_code,
        university_name,
        university_abbr,
        created_by,
        created_on,
        modified_by,
        modified_on
    )
    SELECT DISTINCT
        TRIM(UPPER(sso.co_ies))::INT,
        TRIM(UPPER(um.university_mapped_name)),
        TRIM(UPPER(sso.sg_ies)),
        v_created_by,
        NOW(),
        v_created_by,
        NOW()
    FROM imp.sisu_spot_offer sso
    JOIN imp.university_mapping um
      ON TRIM(UPPER(um.university_original_name)) = TRIM(UPPER(sso.no_ies))
    WHERE sso.co_ies ~ '^\s*\d+\s*$'
      AND NOT EXISTS (
        SELECT 1
        FROM app.university u
        WHERE u.university_code = TRIM(UPPER(sso.co_ies))::INT
          AND u.university_name = TRIM(UPPER(um.university_mapped_name))
    );

    GET DIAGNOSTICS v_inserted = ROW_COUNT;
    RAISE NOTICE 'Inserted % universities.', v_inserted;
END $$;
