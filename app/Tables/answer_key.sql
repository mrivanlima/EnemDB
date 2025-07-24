CREATE TABLE IF NOT EXISTS app.answer_key (
    answer_key_id   SERIAL,
    year_id         INTEGER NOT NULL,
    exam_day        SMALLINT NOT NULL,
    key_type        VARCHAR(40) NOT NULL,         -- e.g., 'official', 'unofficial'
    key_source      VARCHAR(40) NOT NULL,         -- e.g., 'INEP', 'Prof. Lima'
    answers         VARCHAR(40) NOT NULL,         -- Correct answers in base order (string of N letters)
    created_by      INTEGER NOT NULL,
    created_on      TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    modified_by     INTEGER,
    modified_on     TIMESTAMPTZ,

    -- Constraints
    CONSTRAINT pk_answer_key_id PRIMARY KEY (answer_key_id),
    CONSTRAINT fk_answer_key_year_id FOREIGN KEY (year_id) REFERENCES app.year(year_id),
    CONSTRAINT fk_answer_key_created_by FOREIGN KEY (created_by) REFERENCES app.user_login(user_login_id),
    CONSTRAINT fk_answer_key_modified_by FOREIGN KEY (modified_by) REFERENCES app.user_login(user_login_id),
    CONSTRAINT uq_answer_key_year_day_type UNIQUE (year_id, exam_day, key_type)
);

-- Table comment
COMMENT ON TABLE app.answer_key IS 'Stores official and unofficial answer keys for each exam year, day, and key type.';

-- Field comments (one-liners)
COMMENT ON COLUMN app.answer_key.answer_key_id IS 'Primary key.';
COMMENT ON COLUMN app.answer_key.year_id IS 'FK to app.year; identifies the exam year.';
COMMENT ON COLUMN app.answer_key.exam_day IS 'Exam day number (e.g., 1 for first day, 2 for second day).';
COMMENT ON COLUMN app.answer_key.key_type IS 'Type of answer key, e.g., "official" or "unofficial".';
COMMENT ON COLUMN app.answer_key.key_source IS 'Source or author of the answer key (e.g., "INEP", teacher name).';
COMMENT ON COLUMN app.answer_key.answers IS 'String of correct answers in base order (one letter per question).';
COMMENT ON COLUMN app.answer_key.created_by IS 'FK to app.user_login; who created the answer key record.';
COMMENT ON COLUMN app.answer_key.created_on IS 'Timestamp when the answer key was created.';
COMMENT ON COLUMN app.answer_key.modified_by IS 'FK to app.user_login; who last modified the answer key record.';
COMMENT ON COLUMN app.answer_key.modified_on IS 'Timestamp of the most recent modification.';
