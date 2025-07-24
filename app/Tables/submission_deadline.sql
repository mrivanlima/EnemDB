CREATE TABLE IF NOT EXISTS app.submission_deadline (
    submission_deadline_id   SERIAL,
    year_id                  INTEGER NOT NULL,
    exam_day                 SMALLINT NOT NULL,
    deadline                 TIMESTAMPTZ NOT NULL,
    created_by               INTEGER NOT NULL,
    created_on               TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    modified_by              INTEGER,
    modified_on              TIMESTAMPTZ,

    -- Constraints
    CONSTRAINT pk_submission_deadline_id PRIMARY KEY (submission_deadline_id),
    CONSTRAINT fk_submission_deadline_year_id FOREIGN KEY (year_id) REFERENCES app.year(year_id),
    CONSTRAINT fk_submission_deadline_created_by FOREIGN KEY (created_by) REFERENCES app.user_login(user_login_id),
    CONSTRAINT fk_submission_deadline_modified_by FOREIGN KEY (modified_by) REFERENCES app.user_login(user_login_id),
    CONSTRAINT uq_submission_deadline_year_day UNIQUE (year_id, exam_day)
);

-- Table comment
COMMENT ON TABLE app.submission_deadline IS 'Stores deadlines for exam answer submissions by year and exam day, with audit information.';

-- Field comments (one-liners)
COMMENT ON COLUMN app.submission_deadline.submission_deadline_id IS 'Primary key.';
COMMENT ON COLUMN app.submission_deadline.year_id IS 'FK to app.year; exam year.';
COMMENT ON COLUMN app.submission_deadline.exam_day IS 'Exam day number.';
COMMENT ON COLUMN app.submission_deadline.deadline IS 'Deadline timestamp for submissions.';
COMMENT ON COLUMN app.submission_deadline.created_by IS 'FK to app.user_login; user who created this record.';
COMMENT ON COLUMN app.submission_deadline.created_on IS 'Timestamp when the record was created.';
COMMENT ON COLUMN app.submission_deadline.modified_by IS 'FK to app.user_login; user who last modified this record.';
COMMENT ON COLUMN app.submission_deadline.modified_on IS 'Timestamp of last modification.';

