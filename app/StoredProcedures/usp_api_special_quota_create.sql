CREATE OR REPLACE PROCEDURE app.usp_api_special_quota_create (
  IN p_quota_type_id         INTEGER,
  IN p_special_quota_desc_pt TEXT,
  IN p_created_by            INTEGER,
  OUT out_message            TEXT
)
LANGUAGE plpgsql
AS $$
DECLARE
  v_exists        INTEGER;
  v_command       TEXT;
  v_error_message TEXT;
  v_error_code    TEXT;
BEGIN
  -- Validações obrigatórias
  IF p_quota_type_id IS NULL THEN
    out_message := 'Falha: quota_type_id não pode ser nulo.';
    RETURN;
  END IF;

  IF p_special_quota_desc_pt IS NULL OR length(trim(p_special_quota_desc_pt)) = 0 THEN
    out_message := 'Falha: descrição da cota especial não pode estar vazia.';
    RETURN;
  END IF;

  IF p_created_by IS NULL THEN
    out_message := 'Falha: created_by não pode ser nulo.';
    RETURN;
  END IF;

  -- Checa duplicidade da combinação quota_type_id + descrição
  SELECT 1
    INTO v_exists
    FROM app.special_quota sq
   WHERE sq.quota_type_id = p_quota_type_id
     AND trim(sq.special_quota_desc_pt) = trim(p_special_quota_desc_pt);

  IF FOUND THEN
    out_message := format(
      'Falha: cota especial "%s" já existe para quota_type_id %s.',
      trim(p_special_quota_desc_pt),
      p_quota_type_id::text
    );
    RETURN;
  END IF;

  -- Inserção com controle de erros
  BEGIN
    INSERT INTO app.special_quota (
      quota_type_id,
      special_quota_desc_pt,
      created_by,
      created_on
    ) VALUES (
      p_quota_type_id,
      trim(p_special_quota_desc_pt),
      p_created_by,
      NOW()
    );

    out_message := 'OK';
    RETURN;

  EXCEPTION WHEN OTHERS THEN
    v_error_message := SQLERRM;
    v_error_code    := SQLSTATE;
    v_command := format(
      'CALL app.usp_api_special_quota_create(%s, %L, %s, out_message)',
      p_quota_type_id::text,
      COALESCE(trim(p_special_quota_desc_pt), 'NULL'),
      p_created_by::text
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
      'special_quota',
      'usp_api_special_quota_create',
      'INSERT',
      v_command,
      v_error_message,
      v_error_code,
      p_created_by::text
    );

    out_message := format('Erro durante inserção: %s', v_error_message);
    RETURN;
  END;
END;
$$;
