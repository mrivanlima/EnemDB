CREATE OR REPLACE PROCEDURE imp.batch_create_states()
LANGUAGE plpgsql
AS $$
DECLARE
  rec         RECORD;
  result_msg  TEXT;
BEGIN
  FOR rec IN
    SELECT DISTINCT 
      r.region_id,
      bs.uf AS state_abbr,
      INITCAP(rs.state_name) AS state_name
    FROM imp.region_state rs
    JOIN app.region r
      ON r.region_name = rs.region_name
    JOIN imp.brazil_states bs
      ON TRIM(UPPER(bs.name)) = TRIM(UPPER(rs.state_name))
  LOOP
    BEGIN
      INSERT INTO app.state (
        region_id,
        state_abbr,
        state_name,
        created_by,
        created_on,
        modified_by,
        modified_on
      ) VALUES (
        rec.region_id,
        rec.state_abbr,
        rec.state_name,
        1,                -- created_by
        NOW(),
        1,                -- modified_by
        NOW()
      );
      result_msg := 'OK';
    EXCEPTION WHEN OTHERS THEN
      result_msg := SQLERRM;
    END;

    RAISE NOTICE 'Estado "% (% - %)" -> %',
      rec.state_name, rec.state_abbr, rec.region_id, result_msg;
  END LOOP;
END;
$$;
