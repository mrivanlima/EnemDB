CREATE TABLE IF NOT EXISTS app.submission_deadline (
    submission_deadline_id   SERIAL,
    year_id                  INTEGER NOT NULL,
    exam_day                 SMALLINT NOT NULL,
    deadline                 TIMESTAMPTZ NOT NULL,
    created_by               TEXT NOT NULL,
    created_on               TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    modified_by              TEXT,
    modified_on              TIMESTAMPTZ,
    -- Constraints
    CONSTRAINT pk_submission_deadline_id PRIMARY KEY (submission_deadline_id),
    CONSTRAINT fk_submission_deadline_year_id FOREIGN KEY (year_id) REFERENCES app.year(year_id),
    CONSTRAINT uq_submission_deadline_year_day UNIQUE (year_id, exam_day)
);
