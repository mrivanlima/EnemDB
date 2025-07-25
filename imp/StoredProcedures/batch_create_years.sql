CREATE OR REPLACE PROCEDURE imp.batch_create_years()
LANGUAGE plpgsql
AS $$
DECLARE
  rec        RECORD;
  result_msg TEXT;
BEGIN
  FOR rec IN
    SELECT DISTINCT edicao
    FROM imp.sisu_spot_offer
    WHERE edicao IS NOT NULL
  LOOP
    CALL app.usp_api_year_create(
      rec.edicao::SMALLINT,
      1,
      result_msg
    );
    RAISE NOTICE 'Year % processed: %', rec.edicao, result_msg;
  END LOOP;
END;
$$;
