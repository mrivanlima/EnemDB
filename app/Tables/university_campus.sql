CREATE TABLE IF NOT EXISTS app.university_campus (
    university_campus_id              SERIAL,
    university_campus_name            VARCHAR(50) NOT NULL,
    university_campus_name_friendly  VARCHAR(50) NOT NULL,
    created_by                       INTEGER NOT NULL,
    created_on                       TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    modified_by                      INTEGER,
    modified_on                      TIMESTAMPTZ,

    -- Constraints
    CONSTRAINT pk_university_campus_id PRIMARY KEY (university_campus_id),
    CONSTRAINT uq_university_campus_name UNIQUE (university_campus_name),
    CONSTRAINT uq_university_campus_name_friendly UNIQUE (university_campus_name_friendly),
    CONSTRAINT fk_university_campus_created_by FOREIGN KEY (created_by) REFERENCES app.user_login(user_login_id),
    CONSTRAINT fk_university_campus_modified_by FOREIGN KEY (modified_by) REFERENCES app.user_login(user_login_id)
);

-- Table comment
COMMENT ON TABLE app.university_campus IS 'Stores university campus names with friendly display names and audit information.';

-- Field comments (one-liners)
COMMENT ON COLUMN app.university_campus.university_campus_id IS 'Primary key.';
COMMENT ON COLUMN app.university_campus.university_campus_name IS 'Official university campus name (unique).';
COMMENT ON COLUMN app.university_campus.university_campus_name_friendly IS 'User-friendly display name for the campus (unique).';
COMMENT ON COLUMN app.university_campus.created_by IS 'FK to app.user_login; user who created this record.';
COMMENT ON COLUMN app.university_campus.created_on IS 'Timestamp when the record was created.';
COMMENT ON COLUMN app.university_campus.modified_by IS 'FK to app.user_login; user who last modified this record.';
COMMENT ON COLUMN app.university_campus.modified_on IS 'Timestamp of the most recent modification.';
