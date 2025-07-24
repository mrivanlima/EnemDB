CREATE TABLE IF NOT EXISTS app.answer_submission (
    answer_submission_id      SERIAL,
    user_id                  INTEGER NOT NULL,
    year_id                  INTEGER NOT NULL,
    exam_day                 SMALLINT NOT NULL,
    booklet_color_id         INTEGER NOT NULL,
    foreign_language         VARCHAR(40) NOT NULL,
    raw_answers              VARCHAR(40) NOT NULL,
    mapped_answers           VARCHAR(40),           -- Now nullable!
    created_by               INTEGER NOT NULL,
    created_on               TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    modified_by              INTEGER,
    modified_on              TIMESTAMPTZ,

    -- Constraints
    CONSTRAINT pk_answer_submission_id PRIMARY KEY (answer_submission_id),
    CONSTRAINT fk_answer_submission_user_id FOREIGN KEY (user_id) REFERENCES app.user_login(user_login_id),
    CONSTRAINT fk_answer_submission_year_id FOREIGN KEY (year_id) REFERENCES app.year(year_id),
    CONSTRAINT fk_answer_submission_booklet_color_id FOREIGN KEY (booklet_color_id) REFERENCES app.booklet_color(booklet_color_id),
    CONSTRAINT fk_answer_submission_created_by FOREIGN KEY (created_by) REFERENCES app.user_login(user_login_id),
    CONSTRAINT fk_answer_submission_modified_by FOREIGN KEY (modified_by) REFERENCES app.user_login(user_login_id),
    CONSTRAINT uq_answer_submission_user_year_day UNIQUE (user_id, year_id, exam_day)
);

-- Table comment
COMMENT ON TABLE app.answer_submission IS 'Stores individual users’ answer submissions per exam year, day, and booklet color.';

-- Field comments (one-liners)
COMMENT ON COLUMN app.answer_submission.answer_submission_id IS 'Primary key.';
COMMENT ON COLUMN app.answer_submission.user_id IS 'FK to app.user_login; identifies who submitted the answers.';
COMMENT ON COLUMN app.answer_submission.year_id IS 'FK to app.year; identifies the exam year.';
COMMENT ON COLUMN app.answer_submission.exam_day IS 'Exam day number (e.g., 1 or 2).';
COMMENT ON COLUMN app.answer_submission.booklet_color_id IS 'FK to app.booklet_color; identifies the version of the booklet used.';
COMMENT ON COLUMN app.answer_submission.foreign_language IS 'Foreign language selected (e.g., "English", "Spanish").';
COMMENT ON COLUMN app.answer_submission.raw_answers IS 'User’s original submitted answers (as entered).';
COMMENT ON COLUMN app.answer_submission.mapped_answers IS 'System-mapped or normalized answers (nullable).';
COMMENT ON COLUMN app.answer_submission.created_by IS 'FK to app.user_login; who created the submission record.';
COMMENT ON COLUMN app.answer_submission.created_on IS 'Timestamp when the submission was created.';
COMMENT ON COLUMN app.answer_submission.modified_by IS 'FK to app.user_login; who last modified the submission record.';
COMMENT ON COLUMN app.answer_submission.modified_on IS 'Timestamp of the most recent modification.';
