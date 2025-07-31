CREATE OR REPLACE PROCEDURE imp.batch_create_regions()
LANGUAGE plpgsql
AS $$
DECLARE
  rec         RECORD;
  result_msg  TEXT;
BEGIN
  FOR rec IN
    SELECT DISTINCT TRIM(region_name) AS region_name
    FROM imp.region_state
    WHERE region_name IS NOT NULL
  LOOP
    CALL app.usp_api_region_create(
      rec.region_name,
      1,                -- created_by (ajustar conforme necessário)
      result_msg
    );
    RAISE NOTICE 'Região "%": %', rec.region_name, result_msg;
  END LOOP;
END;
$$;
