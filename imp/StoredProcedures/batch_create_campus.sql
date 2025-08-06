CREATE OR REPLACE PROCEDURE imp.batch_create_campus()
LANGUAGE plpgsql AS $$
DECLARE
  rec RECORD;
  result_msg TEXT;
BEGIN
  FOR rec IN
    SELECT DISTINCT UPPER(TRIM(no_campus)) COLLATE "C" AS no_campus
    FROM imp.sisu_spot_offer
  LOOP
    CALL app.usp_api_campus_create(
      rec.no_campus,
      1, -- created_by
      result_msg
    );
    RAISE NOTICE 'Campus "%": %', rec.no_campus, result_msg;
  END LOOP;
END;
$$;
