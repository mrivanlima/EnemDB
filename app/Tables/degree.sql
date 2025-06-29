CREATE TABLE IF NOT EXISTS app.degree (
    degree_id               SERIAL,
    degree_name             TEXT NOT NULL,
    degree_name_friendly    TEXT NOT NULL,
    created_by              INTEGER NOT NULL,
    created_on              TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    modified_by             INTEGER,
    modified_on             TIMESTAMPTZ,

    -- Constraints
    CONSTRAINT pk_degree_id PRIMARY KEY (degree_id),
    CONSTRAINT uq_degree_name UNIQUE (degree_name),
    CONSTRAINT uq_degree_name_friendly UNIQUE (degree_name_friendly),
    CONSTRAINT fk_degree_created_by FOREIGN KEY (created_by) REFERENCES app.user_login(user_login_id),
    CONSTRAINT fk_degree_modified_by FOREIGN KEY (modified_by) REFERENCES app.user_login(user_login_id)
);

-- Table comment
COMMENT ON TABLE app.degree IS 'Represents specific academic degrees (e.g., Bachelor of Science, Master of Arts), with unique friendly names and full audit fields.';

-- Field comments (one-liners)
COMMENT ON COLUMN app.degree.degree_id IS 'Primary key.';
COMMENT ON COLUMN app.degree.degree_name IS 'Official name of the academic degree (unique).';
COMMENT ON COLUMN app.degree.degree_name_friendly IS 'User-friendly display name for the degree (unique).';
COMMENT ON COLUMN app.degree.created_by IS 'FK to app.user_login; identifies the user who created this record.';
COMMENT ON COLUMN app.degree.created_on IS 'Timestamp when the degree record was created.';
COMMENT ON COLUMN app.degree.modified_by IS 'FK to app.user_login; identifies the user who last modified this record.';
COMMENT ON COLUMN app.degree.modified_on IS 'Timestamp of the most recent modification.';
