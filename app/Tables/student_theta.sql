CREATE TABLE app.student_theta (
  student_theta_id BIGSERIAL,

  student_id         INT        NOT NULL,
  year_id            INT        NOT NULL,
  test_version_id    INT        NOT NULL,
  area_id            SMALLINT   NOT NULL,
  language_group_id  SMALLINT   NOT NULL DEFAULT 0,  -- 0=sem idioma, 1=inglês, 2=espanhol
  attempt_no         SMALLINT   NOT NULL DEFAULT 1,  -- tentativa do aluno

  n_responses        INT        NOT NULL,
  n_valid            INT        NOT NULL,

  theta              NUMERIC(10,5) NOT NULL,
  se_theta           NUMERIC(10,5) NOT NULL,

  score              NUMERIC(10,2),
  scale_mean         NUMERIC(10,5) DEFAULT 500.0,
  scale_sd           NUMERIC(10,5) DEFAULT 100.0,

  method             VARCHAR(8)  NOT NULL DEFAULT 'EAP',
  model              VARCHAR(8)  NOT NULL DEFAULT '3PL',
  c_mode             VARCHAR(10) NOT NULL DEFAULT 'fixed',
  q_nodes            SMALLINT    NOT NULL DEFAULT 41,

  run_ts             TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  created_by         INT,
  modified_on        TIMESTAMPTZ,
  modified_by        INT,

  -- constraints inline
  CONSTRAINT pk_student_theta PRIMARY KEY (student_theta_id),
  CONSTRAINT uq_student_theta UNIQUE (student_id, year_id, test_version_id, area_id, attempt_no),
  CONSTRAINT ck_counts CHECK (n_responses >= 0 AND n_valid >= 0 AND n_valid <= n_responses),
  CONSTRAINT ck_score_range CHECK (score IS NULL OR (score >= 0 AND score <= 1000)),
  CONSTRAINT ck_method CHECK (method IN ('EAP')),
  CONSTRAINT ck_model  CHECK (model  IN ('3PL')),
  CONSTRAINT ck_cmode  CHECK (c_mode IN ('fixed','estimated')),
  CONSTRAINT fk_area   FOREIGN KEY (area_id) REFERENCES app.area(area_id)
);
