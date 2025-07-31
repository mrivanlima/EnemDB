CREATE OR REPLACE PROCEDURE app.usp_api_degree_level_create (
  IN p_degree_level_name TEXT,
  IN p_created_by        INT,
  OUT out_message        TEXT
)
LANGUAGE plpgsql
AS $$
DECLARE
  v_exists     INTEGER;
  v_err_msg    TEXT;
  v_err_code   TEXT;
  v_command    TEXT;
BEGIN
  -- Validação obrigatória
  IF p_degree_level_name IS NULL OR length(trim(p_degree_level_name)) = 0 THEN
    out_message := 'Validação falhou: degree_level_name não pode ser vazio.';
    RETURN;
  END IF;

  IF p_created_by IS NULL THEN
    out_message := 'Validação falhou: created_by não pode ser nulo.';
    RETURN;
  END IF;

  -- Verifica duplicidade (ignora caixa e acentos)
  SELECT 1
  INTO v_exists
  FROM app.degree_level
  WHERE unaccent(degree_level_name) ILIKE unaccent(p_degree_level_name);

  IF FOUND THEN
    out_message := format('Validação falhou: o nível "%s" já existe.', p_degree_level_name);
    RETURN;
  END IF;

  -- Inserção segura com tratamento de erro
  BEGIN
    INSERT INTO app.degree_level (
      degree_level_name,
      created_by,
      created_on,
      modified_by,
      modified_on
    ) VALUES (
      INITCAP(TRIM(p_degree_level_name)),
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
      'CALL app.usp_api_degree_level_create(p_degree_level_name => %L, p_created_by => %s)',
      COALESCE(p_degree_level_name, 'NULL'),
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
      'degree_level',
      'app.usp_api_degree_level_create',
      'INSERT',
      v_command,
      v_err_msg,
      v_err_code,
      p_created_by
    );

    out_message := format('Erro ao inserir nível: %s', v_err_msg);
    RETURN;
  END;
END;
$$;
