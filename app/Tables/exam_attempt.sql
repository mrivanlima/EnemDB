CREATE TABLE app.exam_attempt (
    exam_attempt_id          SERIAL,
    user_login_id            INTEGER NOT NULL,
    exam_year                INTEGER NOT NULL,
    booklet_color            TEXT NOT NULL,
    booklet_color_friendly   TEXT,
    test_day_number          INTEGER NOT NULL,
    started_on               TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    finished_on              TIMESTAMPTZ,
    score                    NUMERIC,
    is_simulation            BOOLEAN NOT NULL DEFAULT FALSE,
    notes                    TEXT,
    notes_friendly           TEXT,
    created_by               INTEGER NOT NULL,
    created_on               TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    modified_by              INTEGER,
    modified_on              TIMESTAMPTZ,
    is_active                BOOLEAN NOT NULL DEFAULT TRUE,

    -- Constraints (all named)
    CONSTRAINT pk_exam_attempt_id PRIMARY KEY (exam_attempt_id),
    CONSTRAINT fk_exam_attempt_user_login_id FOREIGN KEY (user_login_id) REFERENCES app.user_login(user_login_id) ON DELETE CASCADE,
    CONSTRAINT fk_exam_attempt_created_by FOREIGN KEY (created_by) REFERENCES app.user_login(user_login_id),
    CONSTRAINT fk_exam_attempt_modified_by FOREIGN KEY (modified_by) REFERENCES app.user_login(user_login_id)
);

-- Table comment
COMMENT ON TABLE app.exam_attempt IS 'Tracks each exam attempt per user, with day, booklet, score, simulation flag, and friendly fields for search.';

-- Field comments (one-liners)
COMMENT ON COLUMN app.exam_attempt.exam_attempt_id IS 'Primary key.';
COMMENT ON COLUMN app.exam_attempt.user_login_id IS 'FK to app.user_login (user account).';
COMMENT ON COLUMN app.exam_attempt.exam_year IS 'Year of the exam attempted.';
COMMENT ON COLUMN app.exam_attempt.booklet_color IS 'Booklet color for the attempt.';
COMMENT ON COLUMN app.exam_attempt.booklet_color_friendly IS 'Normalized booklet color for search.';
COMMENT ON COLUMN app.exam_attempt.test_day_number IS 'Day number (1 or 2) of the exam.';
COMMENT ON COLUMN app.exam_attempt.started_on IS 'Timestamp when attempt started.';
COMMENT ON COLUMN app.exam_attempt.finished_on IS 'Timestamp when attempt finished.';
COMMENT ON COLUMN app.exam_attempt.score IS 'Final score for the attempt.';
COMMENT ON COLUMN app.exam_attempt.is_simulation IS 'TRUE if this was a simulation/mock.';
COMMENT ON COLUMN app.exam_attempt.notes IS 'Notes about this attempt.';
COMMENT ON COLUMN app.exam_attempt.notes_friendly IS 'Normalized notes for search.';
COMMENT ON COLUMN app.exam_attempt.created_by IS 'FK to app.user_login; user who created this record.';
COMMENT ON COLUMN app.exam_attempt.created_on IS 'Creation timestamp.';
COMMENT ON COLUMN app.exam_attempt.modified_by IS 'FK to app.user_login; user who last modified this record.';
COMMENT ON COLUMN app.exam_attempt.modified_on IS 'Modification timestamp.';
COMMENT ON COLUMN app.exam_attempt.is_active IS 'Active/archive flag.';
