CREATE TABLE IF NOT EXISTS app.degree_level (
    degree_level_id               SERIAL,
    degree_level_name             TEXT NOT NULL,
    degree_level_name_friendly    TEXT NOT NULL,
    created_by                    INTEGER NOT NULL,
    created_on                    TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    modified_by                   INTEGER,
    modified_on                   TIMESTAMPTZ,

    -- Constraints
    CONSTRAINT pk_degree_level_id PRIMARY KEY (degree_level_id),
    CONSTRAINT uq_degree_level_name UNIQUE (degree_level_name),
    CONSTRAINT uq_degree_level_name_friendly UNIQUE (degree_level_name_friendly),
    CONSTRAINT fk_degree_level_created_by FOREIGN KEY (created_by) REFERENCES app.user_login(user_login_id),
    CONSTRAINT fk_degree_level_modified_by FOREIGN KEY (modified_by) REFERENCES app.user_login(user_login_id)
);

-- Table comment
COMMENT ON TABLE app.degree_level IS 'Represents possible academic degree levels (e.g., Bachelor, Master, Doctorate), supporting unique friendly names and audit fields.';

-- Field comments (one-liners)
COMMENT ON COLUMN app.degree_level.degree_level_id IS 'Primary key.';
COMMENT ON COLUMN app.degree_level.degree_level_name IS 'Official name of the degree level (unique).';
COMMENT ON COLUMN app.degree_level.degree_level_name_friendly IS 'User-friendly display name for the degree level (unique).';
COMMENT ON COLUMN app.degree_level.created_by IS 'FK to app.user_login; identifies the user who created this record.';
COMMENT ON COLUMN app.degree_level.created_on IS 'Timestamp when the degree level record was created.';
COMMENT ON COLUMN app.degree_level.modified_by IS 'FK to app.user_login; identifies the user who last modified this record.';
COMMENT ON COLUMN app.degree_level.modified_on IS 'Timestamp of the most recent modification.';
