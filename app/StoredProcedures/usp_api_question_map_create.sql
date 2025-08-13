CREATE OR REPLACE PROCEDURE app.usp_api_question_map_create (
  IN p_booklet_color_id   INT,
  IN p_number_in_base     SMALLINT,
  IN p_number_in_variant  SMALLINT,
  IN p_language_id        SMALLINT,
  IN p_year_id            INT,
  IN p_test_version_id    INT,
  IN p_created_by         INT,
  OUT out_message         TEXT
)
LANGUAGE plpgsql
AS $$
DECLARE
  v_exists    INTEGER;
  v_err_msg   TEXT;
  v_err_code  TEXT;
  v_command   TEXT;
BEGIN
  -- Validation: required fields
  IF p_booklet_color_id IS NULL
     OR p_number_in_base IS NULL
     OR p_number_in_variant IS NULL
     OR p_year_id IS NULL
     OR p_test_version_id IS NULL
     OR p_created_by IS NULL THEN
    out_message := 'Validação falhou: todos os campos obrigatórios devem ser informados.';
    RETURN;
  END IF;

  -- Uniqueness check
  SELECT 1 INTO v_exists
  FROM app.question_map
  WHERE booklet_color_id   = p_booklet_color_id
    AND number_in_base     = p_number_in_base
    AND number_in_variant  = p_number_in_variant
    AND COALESCE(language_id, -1) = COALESCE(p_language_id, -1)
    AND year_id            = p_year_id
    AND test_version_id    = p_test_version_id;

  IF FOUND THEN
    out_message := format(
      'Validação falhou: o mapeamento já existe para cor=%s, base=%s, variante=%s, idioma=%s, ano=%s, versão=%s.',
      p_booklet_color_id, p_number_in_base, p_number_in_variant, p_language_id, p_year_id, p_test_version_id
    );
    RETURN;
  END IF;

  -- Insert with error handling
  BEGIN
    INSERT INTO app.question_map (
      booklet_color_id,
      number_in_base,
      number_in_variant,
      language_id,
      year_id,
      test_version_id,
      created_by,
      created_on,
      modified_by,
      modified_on
    ) VALUES (
      p_booklet_color_id,
      p_number_in_base,
      p_number_in_variant,
      p_language_id,
      p_year_id,
      p_test_version_id,
      p_created_by,
      NOW(),
      p_created_by,
      NOW()
    );

    out_message := 'OK';
    RETURN;

  EXCEPTION WHEN OTHERS THEN
    GET STACKED DIAGNOSTICS
      v_err_msg  = MESSAGE_TEXT,
      v_err_code = RETURNED_SQLSTATE;

    v_command := format(
      'CALL app.usp_api_question_map_create(%s, %s, %s, %s, %s, %s, %s, out_message)',
      COALESCE(p_booklet_color_id::TEXT,'NULL'),
      COALESCE(p_number_in_base::TEXT,'NULL'),
      COALESCE(p_number_in_variant::TEXT,'NULL'),
      COALESCE(p_language_id::TEXT,'NULL'),
      COALESCE(p_year_id::TEXT,'NULL'),
      COALESCE(p_test_version_id::TEXT,'NULL'),
      COALESCE(p_created_by::TEXT,'NULL')
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
      'question_map',
      'app.usp_api_question_map_create',
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
