CREATE OR REPLACE PROCEDURE app.usp_question_params_by_id_update(
    p_question_current_id INT,
    p_param_a NUMERIC(10,5),
    p_param_b NUMERIC(10,5),
    p_param_c NUMERIC(10,5),
    p_modified_by INT
)
LANGUAGE plpgsql
AS $$
BEGIN
  UPDATE app.question_current
     SET param_a     = p_param_a,
         param_b     = p_param_b,
         param_c     = p_param_c,
         modified_by = p_modified_by,
         modified_on = NOW()
   WHERE question_current_id = p_question_current_id;

  IF NOT FOUND THEN
    RAISE EXCEPTION 'question_current_id % not found', p_question_current_id
      USING ERRCODE = 'P0002';
  END IF;
END;
$$;
