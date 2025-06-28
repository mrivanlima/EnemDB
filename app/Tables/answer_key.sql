CREATE TABLE IF NOT EXISTS app.answer_key (
    answer_key_id      SERIAL,
    year_id            INTEGER NOT NULL,
    exam_day           SMALLINT NOT NULL,
    key_type           TEXT NOT NULL,         -- e.g., 'official', 'unofficial'
    key_source         TEXT NOT NULL,         -- e.g., 'INEP', 'Prof. Lima'
    answers            TEXT NOT NULL,         -- Correct answers in base order (string of N letters)
    created_by         TEXT NOT NULL,
    created_on         TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    modified_by        TEXT,
    modified_on        TIMESTAMPTZ,
    -- Constraints
    CONSTRAINT pk_answer_key_id PRIMARY KEY (answer_key_id),
    CONSTRAINT fk_answer_key_year_id FOREIGN KEY (year_id) REFERENCES app.year(year_id),
    CONSTRAINT uq_answer_key_year_day_type UNIQUE (year_id, exam_day, key_type)
);
