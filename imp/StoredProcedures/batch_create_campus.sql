CREATE OR REPLACE PROCEDURE imp.batch_create_campus()
LANGUAGE plpgsql
AS $$
DECLARE
  rec         RECORD;
  result_msg  TEXT;
BEGIN
  FOR rec IN
    SELECT DISTINCT no_campus
    FROM imp.sisu_spot_offer
    WHERE no_campus IS NOT NULL
  LOOP
    CALL app.usp_api_campus_create(
      rec.no_campus,
      1,                -- created_by (ajustar conforme necessário)
      result_msg
    );
    RAISE NOTICE 'Campus "%": %', rec.no_campus, result_msg;
  END LOOP;
END;
$$;
