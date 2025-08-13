CREATE OR REPLACE PROCEDURE app.usp_api_student_answer_create (
  IN  p_student_id        INT,
  IN  p_year_id           INT,
  IN  p_exam_year         INT,
  IN  p_test_version_id   INT,
  IN  p_booklet_color_id  INT,
  IN  p_language_id       SMALLINT,     -- NULL allowed
  IN  p_question_number   SMALLINT,
  IN  p_selected_option   CHAR(1),      -- NULL allowed
  IN  p_answered_at       TIMESTAMPTZ,  -- NULL allowed
  IN  p_response_time_ms  INT,          -- NULL allowed (>= 0 if sent)
  IN  p_created_by        INT,
  OUT out_message         TEXT
)
LANGUAGE plpgsql
AS $$
DECLARE
  v_year    INT;
  v_sel_opt CHAR(1);
BEGIN
  -- normalize option
  v_sel_opt :=
    CASE
      WHEN p_selected_option IS NULL OR btrim(p_selected_option) = '' THEN NULL
      ELSE upper(substr(p_selected_option,1,1))
    END;

  IF v_sel_opt IS NOT NULL AND v_sel_opt NOT IN ('A','B','C','D','E') THEN
    out_message := format('Validation failed: selected_option inválida (%s).', v_sel_opt);
    RETURN;
  END IF;

  IF p_response_time_ms IS NOT NULL AND p_response_time_ms < 0 THEN
    out_message := 'Validation failed: response_time_ms deve ser >= 0.';
    RETURN;
  END IF;

  -- year_id must exist and match exam_year
  SELECT y.year INTO v_year FROM app.year y WHERE y.year_id = p_year_id;
  IF NOT FOUND THEN
    out_message := format('Validation failed: year_id %s não existe.', p_year_id);
    RETURN;
  END IF;
  IF v_year <> p_exam_year THEN
    out_message := format('Validation failed: exam_year (%s) difere do ano (%s) do year_id %s.',
                          p_exam_year, v_year, p_year_id);
    RETURN;
  END IF;

  -- friendly FK checks (optional but clearer)
  PERFORM 1 FROM app.test_version  WHERE test_version_id   = p_test_version_id;  IF NOT FOUND THEN out_message := format('Validation failed: test_version_id %s não existe.', p_test_version_id); RETURN; END IF;
  PERFORM 1 FROM app.booklet_color WHERE booklet_color_id  = p_booklet_color_id; IF NOT FOUND THEN out_message := format('Validation failed: booklet_color_id %s não existe.', p_booklet_color_id); RETURN; END IF;
  IF p_language_id IS NOT NULL THEN
    PERFORM 1 FROM app.language    WHERE language_id       = p_language_id;      IF NOT FOUND THEN out_message := format('Validation failed: language_id %s não existe.', p_language_id); RETURN; END IF;
  END IF;
  PERFORM 1 FROM app.user_login    WHERE user_login_id     = p_created_by;       IF NOT FOUND THEN out_message := format('Validation failed: created_by (user_login_id=%s) não existe.', p_created_by); RETURN; END IF;
  PERFORM 1 FROM app.user_login    WHERE user_login_id     = p_student_id;       IF NOT FOUND THEN out_message := format('Validation failed: student_id (user_login_id=%s) não existe.', p_student_id); RETURN; END IF;

  -- ensure logical uniqueness (treat NULL language_id as equal)
  IF EXISTS (
    SELECT 1
    FROM app.student_answer sa
    WHERE sa.student_id        = p_student_id
      AND sa.exam_year         = p_exam_year
      AND sa.test_version_id   = p_test_version_id
      AND sa.booklet_color_id  = p_booklet_color_id
      AND sa.question_number   = p_question_number
      AND (sa.language_id IS NOT DISTINCT FROM p_language_id)
  ) THEN
    out_message := 'Validation failed: já existe resposta para este aluno/ano/versão/caderno/idioma/questão.';
    RETURN;
  END IF;

  -- insert; partition will route by exam_year
  INSERT INTO app.student_answer (
    student_id, year_id, exam_year, test_version_id, booklet_color_id, language_id,
    question_number, selected_option, answered_at, response_time_ms,
    created_by, created_on, modified_by, modified_on
  ) VALUES (
    p_student_id, p_year_id, p_exam_year, p_test_version_id, p_booklet_color_id, p_language_id,
    p_question_number, v_sel_opt, p_answered_at, p_response_time_ms,
    p_created_by, NOW(), p_created_by, NOW()
  );

  out_message := 'OK';
END;
$$;