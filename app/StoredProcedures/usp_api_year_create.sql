CREATE OR REPLACE PROCEDURE app.usp_api_year_create (
  IN p_year         SMALLINT,
  IN p_created_by   INT,
  OUT out_message   TEXT
)
LANGUAGE plpgsql
AS $$
DECLARE
  v_exists   INTEGER;
  v_err_msg  TEXT;
  v_err_code TEXT;
  v_command  TEXT;
  v_year_text TEXT;
BEGIN
  -- Validations
  -- Uniqueness: year
  SELECT 1 INTO v_exists FROM app.year WHERE year = p_year;
  IF FOUND THEN
    out_message := format('Validação falhou: o ano %s já existe.', p_year);
    RETURN;
  END IF;

  -- Insert with error handling
  BEGIN
    INSERT INTO app.year (
      year,
      year_name,
      created_by,
      created_on,
      modified_by,
      modified_on
    ) VALUES (
      p_year,
      app.fn_number_to_words_ptbr(p_year),
      p_created_by::INTEGER,
      NOW(),
      p_created_by::INTEGER,
      NOW()
    );
    -- assign to INOUT param if needed
    out_message := 'OK';
    RETURN;

  EXCEPTION WHEN OTHERS THEN
    GET STACKED DIAGNOSTICS
      v_err_msg = MESSAGE_TEXT,
      v_err_code = RETURNED_SQLSTATE;

    v_command := format(
      'CALL app.usp_api_year_create(p_year => %s, p_created_by => %L)',
      COALESCE(p_year::TEXT,'NULL'),
      COALESCE(p_created_by::TEXT, 'NULL')

    );

    INSERT INTO app.error_log (
      table_name, 
      process, 
      operation, 
      command,
      error_message, 
      error_code, 
      user_name
    ) VALUES (
      'year',
      'app.usp_api_year_create',
      'INSERT',
      v_command,
      v_err_msg,
      v_err_code,
      p_created_by
    );

    out_message := format('Erro ao inserir: %s', v_err_msg);
    RETURN;
  END;
END;
$$;