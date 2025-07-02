CREATE TABLE IF NOT EXISTS app.school_year (
    school_year_id         SERIAL,
    school_year_name       TEXT NOT NULL,
    school_year_name_friendly TEXT NOT NULL,
    created_by             INTEGER NOT NULL,
    created_on             TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    modified_by            INTEGER,
    modified_on            TIMESTAMPTZ,

    -- Constraints
    CONSTRAINT pk_school_year_id PRIMARY KEY (school_year_id),
    CONSTRAINT uq_school_year_name UNIQUE (school_year_name),
    CONSTRAINT uq_school_year_name_friendly UNIQUE (school_year_name_friendly),
    CONSTRAINT fk_school_year_created_by FOREIGN KEY (created_by) REFERENCES app.user_login(user_login_id),
    CONSTRAINT fk_school_year_modified_by FOREIGN KEY (modified_by) REFERENCES app.user_login(user_login_id)
);

-- Table comment
COMMENT ON TABLE app.school_year IS 'Represents a school grade/year (e.g., 6th grade, 1st year of high school), supporting friendly names and auditing.';

-- Field comments
COMMENT ON COLUMN app.school_year.school_year_id IS 'Primary key.';
COMMENT ON COLUMN app.school_year.school_year_name IS 'Official name of the school year (unique).';
COMMENT ON COLUMN app.school_year.school_year_name_friendly IS 'User-friendly display name for the school year (unique).';
COMMENT ON COLUMN app.school_year.created_by IS 'FK to app.user_login; user who created this record.';
COMMENT ON COLUMN app.school_year.created_on IS 'Timestamp of record creation.';
COMMENT ON COLUMN app.school_year.modified_by IS 'FK to app.user_login; user who last modified this record.';
COMMENT ON COLUMN app.school_year.modified_on IS 'Timestamp of the most recent modification.';
