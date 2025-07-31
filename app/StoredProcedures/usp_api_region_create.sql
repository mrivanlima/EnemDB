CREATE OR REPLACE PROCEDURE app.usp_api_region_create (
  IN p_region_name TEXT,
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
  -- Verifica se já existe a região (ignorando acentuação e caixa)
  SELECT 1
  INTO v_exists
  FROM app.region
  WHERE unaccent(region_name) ILIKE unaccent(p_region_name);

  IF FOUND THEN
    out_message := format('Validação falhou: a região "%s" já existe.', p_region_name);
    RETURN;
  END IF;

  -- Tentativa de inserção com tratamento de erro
  BEGIN
    INSERT INTO app.region (
      region_name,
      created_by,
      created_on,
      modified_by,
      modified_on
    ) VALUES (
      p_region_name,
      p_created_by,
      NOW(),
      p_created_by,
      NOW()
    );

    out_message := 'OK';
    RETURN;

  EXCEPTION WHEN OTHERS THEN
    GET STACKED DIAGNOSTICS
      v_err_msg = MESSAGE_TEXT,
      v_err_code = RETURNED_SQLSTATE;

    v_command := format(
      'CALL app.usp_api_region_create(p_region_name => %L, p_created_by => %s)',
      COALESCE(p_region_name, 'NULL'),
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
      'region',
      'app.usp_api_region_create',
      'INSERT',
      v_command,
      v_err_msg,
      v_err_code,
      p_created_by
    );

    out_message := format('Erro ao inserir região: %s', v_err_msg);
    RETURN;
  END;
END;
$$;
