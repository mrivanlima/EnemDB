CREATE OR REPLACE PROCEDURE app.usp_api_degree_create (
  IN p_degree_name TEXT,
  IN p_created_by  INT,
  OUT out_message  TEXT
)
LANGUAGE plpgsql
AS $$
DECLARE
  v_exists       INTEGER;
  v_err_msg      TEXT;
  v_err_code     TEXT;
  v_command      TEXT;
BEGIN
  -- Validações obrigatórias
  IF p_degree_name IS NULL OR length(trim(p_degree_name)) = 0 THEN
    out_message := 'Validação falhou: degree_name não pode ser vazio.';
    RETURN;
  END IF;

  IF p_created_by IS NULL THEN
    out_message := 'Validação falhou: created_by não pode ser nulo.';
    RETURN;
  END IF;

  -- Verifica duplicidade ignorando caixa e acentuação
  SELECT 1
  INTO v_exists
  FROM app.degree
  WHERE unaccent(degree_name) ILIKE unaccent(p_degree_name);

  IF FOUND THEN
    out_message := format('Validação falhou: o grau "%s" já existe.', p_degree_name);
    RETURN;
  END IF;

  -- Inserção com tratamento de exceções
  BEGIN
    INSERT INTO app.degree (
      degree_name,
      created_by,
      created_on,
      modified_by,
      modified_on
    ) VALUES (
      INITCAP(TRIM(p_degree_name)),
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
      'CALL app.usp_api_degree_create(p_degree_name => %L, p_created_by => %s)',
      COALESCE(p_degree_name, 'NULL'),
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
      'degree',
      'app.usp_api_degree_create',
      'INSERT',
      v_command,
      v_err_msg,
      v_err_code,
      p_created_by
    );

    out_message := format('Erro ao inserir grau: %s', v_err_msg);
    RETURN;
  END;
END;
$$;
