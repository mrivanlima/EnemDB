CREATE OR REPLACE PROCEDURE imp.batch_create_university_mapping()
LANGUAGE plpgsql
AS $$
DECLARE
  rec RECORD;
BEGIN
  FOR rec IN
    SELECT DISTINCT
      TRIM(UPPER(no_ies)) AS university_original_name,
      TRIM(
        CASE
          WHEN no_ies ILIKE '%AFRO‑BRASILEIRA%' THEN UPPER(no_ies)
          WHEN no_ies ILIKE '%SEMI‑ÁRIDO%'       THEN UPPER(no_ies)
          ELSE UPPER(regexp_replace(no_ies, '\s*-\s*.*$', '', 'g'))
        END
      ) AS university_mapped_name
    FROM imp.sisu_spot_offer
    WHERE no_ies IS NOT NULL
    ORDER BY 1
  LOOP
    IF NOT EXISTS (
      SELECT 1
        FROM imp.university_mapping um
       WHERE um.university_original_name = rec.university_original_name
    ) THEN
      INSERT INTO imp.university_mapping (
        university_original_name,
        university_mapped_name
      ) VALUES (
        rec.university_original_name,
        rec.university_mapped_name
      );
      RAISE NOTICE 'Inserido: % → %', rec.university_original_name, rec.university_mapped_name;
    ELSE
      RAISE NOTICE 'Ignorado (já existe): %', rec.university_original_name;
    END IF;
  END LOOP;
END;
$$;
