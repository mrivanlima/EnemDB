CREATE TABLE IF NOT EXISTS app.exam_year (
    exam_year_id        SERIAL,
    year_name          INTEGER NOT NULL,
    year_name_friendly  TEXT NOT NULL,
    created_by          INTEGER NOT NULL,
    created_on          TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    modified_by         INTEGER,
    modified_on         TIMESTAMPTZ,

    -- Constraints
    CONSTRAINT pk_exam_year_id PRIMARY KEY (exam_year_id),
    CONSTRAINT uq_exam_year_name UNIQUE (year_name),
    CONSTRAINT uq_exam_year_name_friendly UNIQUE (year_name_friendly),
    CONSTRAINT fk_exam_year_created_by FOREIGN KEY (created_by) REFERENCES app.user_login(user_login_id),
    CONSTRAINT fk_exam_year_modified_by FOREIGN KEY (modified_by) REFERENCES app.user_login(user_login_id)
);

-- Table comment
COMMENT ON TABLE app.exam_year IS 'Represents the year of the ENEM exam, supporting friendly names and auditing.';

-- Field comments
COMMENT ON COLUMN app.exam_year.exam_year_id IS 'Primary key.';
COMMENT ON COLUMN app.exam_year.year_name IS 'Official year value (unique).';
COMMENT ON COLUMN app.exam_year.year_name_friendly IS 'User-friendly display name for the exam year (unique).';
COMMENT ON COLUMN app.exam_year.created_by IS 'FK to app.user_login; user who created this record.';
COMMENT ON COLUMN app.exam_year.created_on IS 'Timestamp of record creation.';
COMMENT ON COLUMN app.exam_year.modified_by IS 'FK to app.user_login; user who last modified this record.';
COMMENT ON COLUMN app.exam_year.modified_on IS 'Timestamp of the most recent modification.';
