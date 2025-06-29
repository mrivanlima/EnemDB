CREATE TABLE IF NOT EXISTS app.university (
    university_id            SERIAL,
    university_code          INT NOT NULL,
    university_name          TEXT NOT NULL,
    university_abbr          TEXT NOT NULL,
    university_name_friendly TEXT NOT NULL,
    created_by               INTEGER NOT NULL,
    created_on               TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    modified_by              INTEGER,
    modified_on              TIMESTAMPTZ,

    -- Constraints (all named)
    CONSTRAINT pk_university_id PRIMARY KEY (university_id),
    CONSTRAINT uq_university_code UNIQUE (university_code),
    CONSTRAINT uq_university_name UNIQUE (university_name),
    CONSTRAINT uq_university_name_friendly UNIQUE (university_name_friendly),
    CONSTRAINT fk_university_created_by FOREIGN KEY (created_by) REFERENCES app.user_login(user_login_id),
    CONSTRAINT fk_university_modified_by FOREIGN KEY (modified_by) REFERENCES app.user_login(user_login_id)
);

-- Table comment
COMMENT ON TABLE app.university IS 'Stores universities with unique codes, full names, abbreviations, friendly names, and audit information.';

-- Field comments (one-liners)
COMMENT ON COLUMN app.university.university_id IS 'Primary key.';
COMMENT ON COLUMN app.university.university_code IS 'Unique numeric code for the university.';
COMMENT ON COLUMN app.university.university_name IS 'Official university name (unique).';
COMMENT ON COLUMN app.university.university_abbr IS 'Official university abbreviation.';
COMMENT ON COLUMN app.university.university_name_friendly IS 'User-friendly display name for the university (unique).';
COMMENT ON COLUMN app.university.created_by IS 'FK to app.user_login; user who created this record.';
COMMENT ON COLUMN app.university.created_on IS 'Timestamp when the record was created.';
COMMENT ON COLUMN app.university.modified_by IS 'FK to app.user_login; user who last modified this record.';
COMMENT ON COLUMN app.university.modified_on IS 'Timestamp of the most recent modification.';
