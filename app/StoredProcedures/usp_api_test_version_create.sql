CREATE OR REPLACE PROCEDURE app.usp_api_test_version_create (
  IN p_test_code   TEXT,
  IN p_created_by  INT,
  OUT out_message  TEXT
)
LANGUAGE plpgsql
AS $$
DECLARE
  v_exists    INTEGER;
  v_err_msg   TEXT;
  v_err_code  TEXT;
  v_command   TEXT;
BEGIN
  -- Validations
  -- Required: test_code
  IF p_test_code IS NULL OR btrim(p_test_code) = '' THEN
    out_message := 'Validação falhou: o código da prova (test_code) é obrigatório.';
    RETURN;
  END IF;

  -- Uniqueness: test_code (case-insensitive)
  SELECT 1 INTO v_exists
  FROM app.test_version
  WHERE trim(upper(test_code)) = trim(upper(p_test_code));
  IF FOUND THEN
    out_message := format('Validação falhou: o código de prova "%s" já existe.', p_test_code);
    RETURN;
  END IF;

  -- Insert with error handling
  BEGIN
    INSERT INTO app.test_version (
      test_code,
      created_by,
      created_on,
      modified_by,
      modified_on
    ) VALUES (
      trim(p_test_code),
      p_created_by::INTEGER,
      NOW(),
      p_created_by::INTEGER,
      NOW()
    );

    out_message := 'OK';
    RETURN;

  EXCEPTION WHEN OTHERS THEN
    GET STACKED DIAGNOSTICS
      v_err_msg  = MESSAGE_TEXT,
      v_err_code = RETURNED_SQLSTATE;

    v_command := format(
      'CALL app.usp_api_test_version_create(p_test_code => %L, p_created_by => %L)',
      COALESCE(p_test_code, 'NULL'),
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
      'test_version',
      'app.usp_api_test_version_create',
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
