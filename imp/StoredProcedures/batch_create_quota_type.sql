CREATE OR REPLACE PROCEDURE imp.batch_create_quota_type()
LANGUAGE plpgsql
AS $$
DECLARE
  rec RECORD;
  v_exists INTEGER;
BEGIN
  FOR rec IN
    SELECT DISTINCT
      TRIM(tp_cota) AS quota_type_code,
      CASE
        WHEN TRIM(tp_cota) IN ('V','B') THEN 'Cotas aleatórias'
        ELSE ds_mod_concorrencia
      END AS desc_full
    FROM imp.sisu_spot_offer
    ORDER BY 1
  LOOP
    -- skip if already exists
    SELECT 1 INTO v_exists
      FROM app.quota_type
     WHERE quota_type_code = rec.quota_type_code;
    IF NOT FOUND THEN
      INSERT INTO app.quota_type (
        quota_type_code,
        quota_type_desc_pt,
        quota_type_desc_short_pt,
        quota_explain,
        created_by,
        created_on
      ) VALUES (
        rec.quota_type_code,
        rec.desc_full,
        LEFT(rec.desc_full, 50),
        rec.desc_full,
        1,
        NOW()
      );
    END IF;
  END LOOP;
END;
$$;
