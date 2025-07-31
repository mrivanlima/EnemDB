CREATE OR REPLACE PROCEDURE imp.batch_create_degree_levels()
LANGUAGE plpgsql
AS $$
DECLARE
  rec         RECORD;
  result_msg  TEXT;
BEGIN
  FOR rec IN
    SELECT DISTINCT TRIM(ds_grau) AS degree_level_name
    FROM imp.sisu_spot_offer
    WHERE ds_grau IS NOT NULL AND TRIM(ds_grau) <> ''
  LOOP
    CALL app.usp_api_degree_level_create(
      rec.degree_level_name,
      1,               -- created_by
      result_msg
    );

    RAISE NOTICE 'Nível "%": %', rec.degree_level_name, result_msg;
  END LOOP;
END;
$$;
