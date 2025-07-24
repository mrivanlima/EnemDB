CREATE TABLE app.student_ability_estimation (
    estimation_id          SERIAL PRIMARY KEY,
    student_id             INTEGER NOT NULL,            -- FK to your user/student table
    year_id                INTEGER NOT NULL REFERENCES app.year(year_id),
    exam_day               SMALLINT NOT NULL,
    subject                TEXT NOT NULL,               -- e.g., 'Math', 'Humanities'
    theta                  NUMERIC(8,5) NOT NULL,       -- Ability estimate (latent trait)
    standard_error         NUMERIC(8,5),                -- Standard error of theta estimate
    estimation_method      TEXT NOT NULL,               -- e.g., 'MLE', 'Bayesian', 'EAP'
    response_pattern       TEXT,                         -- Optionally store student's answers pattern (mapped)
    created_by             INTEGER NOT NULL,
    created_on             TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    modified_by            INTEGER,
    modified_on            TIMESTAMPTZ,

    CONSTRAINT fk_student_ability_estimation_created_by FOREIGN KEY (created_by) REFERENCES app.user_login(user_login_id),
    CONSTRAINT fk_student_ability_estimation_modified_by FOREIGN KEY (modified_by) REFERENCES app.user_login(user_login_id)
);

-- Table comment
COMMENT ON TABLE app.student_ability_estimation IS 'Stores ability estimation results for students per year, exam day, subject, with method and audit info.';

-- Field comments (one-liners)
COMMENT ON COLUMN app.student_ability_estimation.estimation_id IS 'Primary key.';
COMMENT ON COLUMN app.student_ability_estimation.student_id IS 'FK to user/student table identifying the student.';
COMMENT ON COLUMN app.student_ability_estimation.year_id IS 'FK to app.year; exam year.';
COMMENT ON COLUMN app.student_ability_estimation.exam_day IS 'Exam day number.';
COMMENT ON COLUMN app.student_ability_estimation.subject IS 'Subject area (e.g., Math, Humanities).';
COMMENT ON COLUMN app.student_ability_estimation.theta IS 'Estimated ability score (latent trait).';
COMMENT ON COLUMN app.student_ability_estimation.standard_error IS 'Standard error of the theta estimate.';
COMMENT ON COLUMN app.student_ability_estimation.estimation_method IS 'Method used for ability estimation.';
COMMENT ON COLUMN app.student_ability_estimation.response_pattern IS 'Optional mapped pattern of student responses.';
COMMENT ON COLUMN app.student_ability_estimation.created_by IS 'FK to app.user_login; user who created this record.';
COMMENT ON COLUMN app.student_ability_estimation.created_on IS 'Timestamp when the record was created.';
COMMENT ON COLUMN app.student_ability_estimation.modified_by IS 'FK to app.user_login; user who last modified this record.';
COMMENT ON COLUMN app.student_ability_estimation.modified_on IS 'Timestamp of last modification.';

