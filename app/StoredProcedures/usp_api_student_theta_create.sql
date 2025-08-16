CREATE OR REPLACE PROCEDURE app.usp_api_student_theta_create(
    p_student_id         INT,
    p_year_id            INT,
    p_test_version_id    INT,
    p_area_id            SMALLINT,
    p_language_group_id  SMALLINT DEFAULT 0,
    p_attempt_no         SMALLINT DEFAULT 1,

    p_n_responses        INT,
    p_n_valid            INT,

    p_theta              NUMERIC(10,5),
    p_se_theta           NUMERIC(10,5),

    p_score              NUMERIC(10,2)  DEFAULT NULL,
    p_scale_mean         NUMERIC(10,5)  DEFAULT 500.0,
    p_scale_sd           NUMERIC(10,5)  DEFAULT 100.0,

    p_method             VARCHAR(8)     DEFAULT 'EAP',
    p_model              VARCHAR(8)     DEFAULT '3PL',
    p_c_mode             VARCHAR(10)    DEFAULT 'fixed',
    p_q_nodes            SMALLINT       DEFAULT 41,

    p_user_id            INT
)
LANGUAGE plpgsql
AS $$
BEGIN
  INSERT INTO app.student_theta (
      student_id,
      year_id,
      test_version_id,
      area_id,
      language_group_id,
      attempt_no,
      n_responses,
      n_valid,
      theta,
      se_theta,
      score,
      scale_mean,
      scale_sd,
      method,
      model,
      c_mode,
      q_nodes,
      run_ts,
      created_by,
      modified_on,
      modified_by
  )
  VALUES (
      p_student_id,
      p_year_id,
      p_test_version_id,
      p_area_id,
      p_language_group_id,
      p_attempt_no,
      p_n_responses,
      p_n_valid,
      p_theta,
      p_se_theta,
      p_score,
      p_scale_mean,
      p_scale_sd,
      p_method,
      p_model,
      p_c_mode,
      p_q_nodes,
      NOW(),
      p_user_id,
      NOW(),
      p_user_id
  );
END;
$$;
