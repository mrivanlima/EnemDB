CREATE TABLE IF NOT EXISTS app.subject (
    subject_id             SERIAL,
    subject_name           VARCHAR(255) NOT NULL,
    subject_name_friendly  VARCHAR(255) NOT NULL,
    created_by             INTEGER NOT NULL,
    created_on             TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    modified_by            INTEGER,
    modified_on            TIMESTAMPTZ,

    -- Constraints
    CONSTRAINT pk_subject_id PRIMARY KEY (subject_id),
    CONSTRAINT uq_subject_name UNIQUE (subject_name),
    CONSTRAINT uq_subject_name_friendly UNIQUE (subject_name_friendly),
    CONSTRAINT fk_subject_created_by FOREIGN KEY (created_by) REFERENCES app.user_login(user_login_id),
    CONSTRAINT fk_subject_modified_by FOREIGN KEY (modified_by) REFERENCES app.user_login(user_login_id)
);

-- Table comment
COMMENT ON TABLE app.subject IS 'Represents a high-level school subject (e.g., Mathematics, Languages), supporting friendly names and auditing.';

-- Field comments
COMMENT ON COLUMN app.subject.subject_id IS 'Primary key.';
COMMENT ON COLUMN app.subject.subject_name IS 'Official name of the subject (unique).';
COMMENT ON COLUMN app.subject.subject_name_friendly IS 'User-friendly display name for the subject (unique).';
COMMENT ON COLUMN app.subject.created_by IS 'FK to app.user_login; user who created this record.';
COMMENT ON COLUMN app.subject.created_on IS 'Timestamp of record creation.';
COMMENT ON COLUMN app.subject.modified_by IS 'FK to app.user_login; user who last modified this record.';
COMMENT ON COLUMN app.subject.modified_on IS 'Timestamp of the most recent modification.';
