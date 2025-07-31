CREATE OR REPLACE PROCEDURE imp.batch_create_degrees()
LANGUAGE plpgsql
AS $$
DECLARE
  rec         RECORD;
  result_msg  TEXT;
BEGIN
  FOR rec IN
    SELECT DISTINCT TRIM(similarity) AS degree_name
    FROM imp.degree_mapping
    WHERE similarity IS NOT NULL AND TRIM(similarity) <> ''
  LOOP
    CALL app.usp_api_degree_create(
      rec.degree_name,
      1,               -- created_by
      result_msg
    );

    RAISE NOTICE 'Grau "%": %', rec.degree_name, result_msg;
  END LOOP;
END;
$$;
