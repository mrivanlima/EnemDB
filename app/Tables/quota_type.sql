CREATE TABLE IF NOT EXISTS app.quota_type (
    quota_type_id            SERIAL,
    quota_type_code          TEXT NOT NULL,
    quota_type_desc_pt       TEXT NOT NULL,
    quota_type_desc_short_pt TEXT NOT NULL,
    quota_explain            TEXT NOT NULL,
    created_by               INTEGER NOT NULL DEFAULT 1,  -- system user_login_id or assign as needed
    created_on               TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    modified_by              INTEGER,
    modified_on              TIMESTAMPTZ,
    CONSTRAINT pk_quota_type_id PRIMARY KEY (quota_type_id),
    CONSTRAINT uq_quota_type_code UNIQUE (quota_type_code),
    CONSTRAINT uq_quota_type_short UNIQUE (quota_type_desc_short_pt),
    CONSTRAINT fk_quota_type_created_by FOREIGN KEY (created_by) REFERENCES app.user_login(user_login_id),
    CONSTRAINT fk_quota_type_modified_by FOREIGN KEY (modified_by) REFERENCES app.user_login(user_login_id)
);

-- Table comment
COMMENT ON TABLE app.quota_type IS 'Defines quota or affirmative action types, with detailed and short Portuguese descriptions, explanation, and audit fields.';

-- Field comments (one-liners)
COMMENT ON COLUMN app.quota_type.quota_type_id IS 'Primary key.';
COMMENT ON COLUMN app.quota_type.quota_type_code IS 'Unique code identifying the quota type.';
COMMENT ON COLUMN app.quota_type.quota_type_desc_pt IS 'Full description of the quota type in Portuguese.';
COMMENT ON COLUMN app.quota_type.quota_type_desc_short_pt IS 'Short description of the quota type in Portuguese.';
COMMENT ON COLUMN app.quota_type.quota_explain IS 'Text explanation of how this quota type works.';
COMMENT ON COLUMN app.quota_type.created_by IS 'FK to app.user_login; user who created this record (default: system).';
COMMENT ON COLUMN app.quota_type.created_on IS 'Timestamp when the record was created.';
COMMENT ON COLUMN app.quota_type.modified_by IS 'FK to app.user_login; user who last modified this record.';
COMMENT ON COLUMN app.quota_type.modified_on IS 'Timestamp of last modification.';
