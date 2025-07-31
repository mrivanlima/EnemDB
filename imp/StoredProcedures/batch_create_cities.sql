CREATE OR REPLACE PROCEDURE imp.batch_create_cities()
LANGUAGE plpgsql
AS $$
DECLARE
  rec         RECORD;
  result_msg  TEXT;
BEGIN
  FOR rec IN
    SELECT 
      s.state_id::INT AS state_id,
      TRIM(INITCAP(c.name)) AS city_name
    FROM imp.city c
    JOIN imp.brazil_states bs
      ON c.state_code = bs.ibge_code
    JOIN app.state s
      ON TRIM(UPPER(s.state_name)) = TRIM(UPPER(bs.name))
    
    UNION
    
    SELECT DISTINCT
      s.state_id,
      TRIM(INITCAP(no_municipio_campus)) AS city_name
    FROM imp.sisu_spot_offer sso
      JOIN app.state s
        ON TRIM(UPPER(s.state_abbr)) = TRIM(UPPER(sso.sg_uf_campus))
  LOOP
    BEGIN
      INSERT INTO app.city (
        state_id,
        city_name,
        created_by,
        created_on,
        modified_by,
        modified_on
      ) VALUES (
        rec.state_id,
        rec.city_name,
        1,  -- created_by
        NOW(),
        1,  -- modified_by
        NOW()
      );

      result_msg := 'OK';
    EXCEPTION WHEN OTHERS THEN
      result_msg := SQLERRM;
    END;

    RAISE NOTICE 'Cidade "%" (state_id %): %', rec.city_name, rec.state_id, result_msg;
  END LOOP;
END;
$$;
