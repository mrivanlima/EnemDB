CREATE OR REPLACE PROCEDURE app.usp_api_question_current_create (
  IN  p_language_id        SMALLINT,      -- NULL allowed
  IN  p_booklet_color_id   INT,
  IN  p_test_version_id    INT,           -- P1/P2
  IN  p_question_position  SMALLINT,
  IN  p_correct_answer     CHAR(1),       -- A..E (uppercased)
  IN  p_param_a            NUMERIC(10,5), -- NULL allowed
  IN  p_param_b            NUMERIC(10,5), -- NULL allowed
  IN  p_param_c            NUMERIC(10,5), -- NULL allowed
  IN  p_notes              TEXT,          -- NULL allowed
  IN  p_created_by         INT,
  OUT out_message          TEXT
)
LANGUAGE plpgsql
AS $$
DECLARE
  v_ans         CHAR(1);
  v_err_msg     TEXT;
  v_err_code    TEXT;
  v_command     TEXT;
  v_test_code   TEXT;
  v_color_name  TEXT;
BEGIN
  -- normalize & validate correct_answer
  v_ans :=
    CASE
      WHEN p_correct_answer IS NULL OR btrim(p_correct_answer) = '' THEN NULL
      ELSE upper(substr(p_correct_answer,1,1))
    END;
  IF v_ans IS NULL OR v_ans NOT IN ('A','B','C','D','E') THEN
    out_message := format('Validação falhou: correct_answer inválido (%s). Use A..E.', v_ans);
    RETURN;
  END IF;


  -- FK checks
  PERFORM 1 FROM app.booklet_color WHERE booklet_color_id = p_booklet_color_id;
  IF NOT FOUND THEN
    out_message := format('Validação falhou: booklet_color_id %s não existe.', p_booklet_color_id);
    RETURN;
  END IF;

  PERFORM 1 FROM app.test_version WHERE test_version_id = p_test_version_id;
  IF NOT FOUND THEN
    out_message := format('Validação falhou: test_version_id %s não existe.', p_test_version_id);
    RETURN;
  END IF;

  IF p_language_id IS NOT NULL THEN
    PERFORM 1 FROM app.language WHERE language_id = p_language_id;
    IF NOT FOUND THEN
      out_message := format('Validação falhou: language_id %s não existe.', p_language_id);
      RETURN;
    END IF;
  END IF;

  PERFORM 1 FROM app.user_login WHERE user_login_id = p_created_by;
  IF NOT FOUND THEN
    out_message := format('Validação falhou: created_by (user_login_id=%s) não existe.', p_created_by);
    RETURN;
  END IF;

  -- regra cor × dia (teu requisito): BRANCO -> só P1 ; CINZA -> só P2
  SELECT upper(tv.test_code) INTO v_test_code
  FROM app.test_version tv WHERE tv.test_version_id = p_test_version_id;

  SELECT upper(bc.booklet_color_name) INTO v_color_name
  FROM app.booklet_color bc WHERE bc.booklet_color_id = p_booklet_color_id;

  IF v_color_name = 'BRANCO' AND v_test_code <> 'P1' THEN
    out_message := 'Validação falhou: BRANCO só é válido no Dia 1 (P1).'; RETURN;
  END IF;
  IF v_color_name = 'CINZA' AND v_test_code <> 'P2' THEN
    out_message := 'Validação falhou: CINZA só é válido no Dia 2 (P2).'; RETURN;
  END IF;
  -- AZUL/AMARELO/VERDE: válidos em P1 e P2

  -- unicidade lógica (trata language_id NULL como igual)
  IF EXISTS (
    SELECT 1
    FROM app.question_current qc
    WHERE qc.booklet_color_id   = p_booklet_color_id
      AND qc.test_version_id    = p_test_version_id
      AND qc.question_position  = p_question_position
      AND (qc.language_id IS NOT DISTINCT FROM p_language_id)
  ) THEN
    out_message := 'Validação falhou: já existe questão para (booklet_color, test_version, posição, idioma).';
    RETURN;
  END IF;

  -- insert
  INSERT INTO app.question_current (
    language_id, booklet_color_id, test_version_id, question_position,
    correct_answer, param_a, param_b, param_c, notes,
    created_by, created_on, modified_by, modified_on
  ) VALUES (
    p_language_id, p_booklet_color_id, p_test_version_id, p_question_position,
    v_ans, p_param_a, p_param_b, p_param_c, p_notes,
    p_created_by, NOW(), p_created_by, NOW()
  );

  out_message := 'OK';

EXCEPTION WHEN OTHERS THEN
  GET STACKED DIAGNOSTICS v_err_msg = MESSAGE_TEXT, v_err_code = RETURNED_SQLSTATE;

  v_command := format(
    'CALL app.usp_api_question_current_create(' ||
    'p_language_id=>%s, p_booklet_color_id=>%s, p_test_version_id=>%s, p_question_position=>%s, '||
    'p_correct_answer=>%L, p_param_a=>%s, p_param_b=>%s, p_param_c=>%s, p_notes=>%L, p_created_by=>%s)',
    CASE WHEN p_language_id IS NULL THEN 'NULL' ELSE p_language_id::text END,
    COALESCE(p_booklet_color_id::text,'NULL'),
    COALESCE(p_test_version_id::text,'NULL'),
    COALESCE(p_question_position::text,'NULL'),
    v_ans,
    COALESCE(p_param_a::text,'NULL'),
    COALESCE(p_param_b::text,'NULL'),
    COALESCE(p_param_c::text,'NULL'),
    p_notes,
    COALESCE(p_created_by::text,'NULL')
  );

  INSERT INTO app.error_log (
    table_name, process, operation, command,
    error_message, error_code, user_name
  ) VALUES (
    'question_current',
    'app.usp_api_question_current_create',
    'INSERT',
    v_command,
    v_err_msg,
    v_err_code,
    p_created_by
  );

  out_message := format('Erro ao inserir: %s', v_err_msg);
END;
$$;
