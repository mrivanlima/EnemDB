
CREATE TABLE app.student_answer (
  student_answer_id  SERIAL,
  student_id         INT         NOT NULL,
  year_id            INT         NOT NULL,   -- FK to app.year (kept)
  exam_year          INT         NOT NULL,   -- partition key (literal year, e.g. 2024)
  test_version_id    INT         NOT NULL,
  booklet_color_id   INT         NOT NULL,
  language_id        SMALLINT,
  question_number    SMALLINT    NOT NULL,
  selected_option    CHAR(1),
  answered_at        TIMESTAMPTZ,
  response_time_ms   INT,
  created_by         INT         NOT NULL,
  created_on         TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  modified_by        INT,
  modified_on        TIMESTAMPTZ,

  -- ✅ PK must include the partition key
  CONSTRAINT pk_student_answer PRIMARY KEY (exam_year, student_answer_id),

  -- ✅ UNIQUE must include the partition key too
  CONSTRAINT uq_student_answer_once UNIQUE
    (student_id, exam_year, test_version_id, booklet_color_id, language_id, question_number),

  -- optional guard
  CONSTRAINT ck_student_answer_opt CHECK (selected_option IS NULL OR selected_option IN ('A','B','C','D','E')),

  -- FKs
  CONSTRAINT fk_sa_student         FOREIGN KEY (student_id)        REFERENCES app.user_login(user_login_id),
  CONSTRAINT fk_sa_year            FOREIGN KEY (year_id)           REFERENCES app.year(year_id),
  CONSTRAINT fk_sa_test_version    FOREIGN KEY (test_version_id)   REFERENCES app.test_version(test_version_id),
  CONSTRAINT fk_sa_booklet_color   FOREIGN KEY (booklet_color_id)  REFERENCES app.booklet_color(booklet_color_id),
  CONSTRAINT fk_sa_language        FOREIGN KEY (language_id)       REFERENCES app.language(language_id),
  CONSTRAINT fk_sa_created_by      FOREIGN KEY (created_by)        REFERENCES app.user_login(user_login_id),
  CONSTRAINT fk_sa_modified_by     FOREIGN KEY (modified_by)       REFERENCES app.user_login(user_login_id)
) PARTITION BY RANGE (exam_year);


CREATE TABLE app.student_answer_2027 PARTITION OF app.student_answer
FOR VALUES FROM (2027) TO (2028);

CREATE TABLE app.student_answer_2026 PARTITION OF app.student_answer
FOR VALUES FROM (2026) TO (2027);

CREATE TABLE app.student_answer_2025 PARTITION OF app.student_answer
FOR VALUES FROM (2025) TO (2026);

CREATE TABLE app.student_answer_2024 PARTITION OF app.student_answer
FOR VALUES FROM (2024) TO (2025);

CREATE TABLE app.student_answer_2023 PARTITION OF app.student_answer
FOR VALUES FROM (2023) TO (2024);

CREATE TABLE app.student_answer_2022 PARTITION OF app.student_answer
FOR VALUES FROM (2022) TO (2023);

CREATE TABLE app.student_answer_2021 PARTITION OF app.student_answer
FOR VALUES FROM (2021) TO (2022);

CREATE TABLE app.student_answer_2020 PARTITION OF app.student_answer
FOR VALUES FROM (2020) TO (2021);

CREATE TABLE app.student_answer_2019 PARTITION OF app.student_answer
FOR VALUES FROM (2019) TO (2020);

CREATE TABLE app.student_answer_2018 PARTITION OF app.student_answer
FOR VALUES FROM (2018) TO (2019);

CREATE TABLE app.student_answer_2017 PARTITION OF app.student_answer
FOR VALUES FROM (2017) TO (2018);

CREATE TABLE app.student_answer_2016 PARTITION OF app.student_answer
FOR VALUES FROM (2016) TO (2017);

CREATE TABLE app.student_answer_2015 PARTITION OF app.student_answer
FOR VALUES FROM (2015) TO (2016);

CREATE TABLE app.student_answer_2014 PARTITION OF app.student_answer
FOR VALUES FROM (2014) TO (2015);

CREATE TABLE app.student_answer_2013 PARTITION OF app.student_answer
FOR VALUES FROM (2013) TO (2014);


