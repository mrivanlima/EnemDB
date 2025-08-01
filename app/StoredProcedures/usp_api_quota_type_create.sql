CREATE OR REPLACE PROCEDURE app.usp_api_quota_type_create (
    OUT out_message               TEXT,
    IN p_quota_type_code          TEXT,
    IN p_quota_type_desc_pt       TEXT,
    IN p_created_by               INTEGER,
    IN p_quota_type_desc_short_pt TEXT DEFAULT NULL,
    IN p_quota_explain            TEXT DEFAULT NULL
)
LANGUAGE plpgsql
AS $$
DECLARE
  v_exists INTEGER;
BEGIN
  -- validações obrigatórias
  IF p_quota_type_code IS NULL OR length(trim(p_quota_type_code)) = 0 THEN
    out_message := 'Falha: “quota_type_code” não pode ficar em branco.';
    RETURN;
  END IF;

  IF p_quota_type_desc_pt IS NULL OR length(trim(p_quota_type_desc_pt)) = 0 THEN
    out_message := 'Falha: “quota_type_desc_pt” não pode ficar em branco.';
    RETURN;
  END IF;

  IF p_created_by IS NULL THEN
    out_message := 'Falha: “created_by” não pode ser nulo.';
    RETURN;
  END IF;

  -- verifica duplicação
  SELECT 1 INTO v_exists FROM app.quota_type
   WHERE quota_type_code = p_quota_type_code;
  IF FOUND THEN
    out_message := format('Falha: quota_type_code "%" já existe.', p_quota_type_code);
    RETURN;
  END IF;

  -- tentativa de inserir
  BEGIN
    INSERT INTO app.quota_type (
      quota_type_code,
      quota_type_desc_pt,
      quota_type_desc_short_pt,
      quota_explain,
      created_by,
      created_on
    ) VALUES (
      p_quota_type_code,
      p_quota_type_desc_pt,
      p_quota_type_desc_short_pt,
      p_quota_explain,
      p_created_by,
      NOW()
    );

    out_message := 'OK';
    RETURN;

  EXCEPTION WHEN OTHERS THEN
    INSERT INTO app.error_log (
      table_name, process, operation,
      command, error_message, error_code, user_name
    ) VALUES (
      'quota_type',
      'usp_api_quota_type_create',
      'INSERT',
      format('CALL ... create(%L, %L, %L, %L, %s)',
        p_quota_type_code, p_quota_type_desc_pt,
        COALESCE(p_quota_type_desc_short_pt,'NULL'),
        COALESCE(p_quota_explain,'NULL'),
        p_created_by::TEXT
      ),
      SQLERRM,
      SQLSTATE,
      p_created_by::TEXT
    );
    out_message := format('Erro na inserção: %', SQLERRM);
    RETURN;
  END;
END;
$$;
