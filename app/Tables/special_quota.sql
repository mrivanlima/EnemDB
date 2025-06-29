CREATE TABLE IF NOT EXISTS app.special_quota (
    special_quota_id         SERIAL,
    quota_type_id            INTEGER NOT NULL,
    special_quota_desc_pt    TEXT NOT NULL,
    special_quota_desc_short TEXT NOT NULL,
    quota_explain            TEXT NOT NULL,
    created_by               INTEGER NOT NULL DEFAULT 1,  -- system user_login_id or adjust as needed
    created_on               TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    modified_by              INTEGER,
    modified_on              TIMESTAMPTZ,

    CONSTRAINT pk_special_quota_id PRIMARY KEY (special_quota_id),
    CONSTRAINT fk_special_quota_quota_type_id FOREIGN KEY (quota_type_id) REFERENCES app.quota_type (quota_type_id),
    CONSTRAINT uq_special_quota_desc_short UNIQUE (special_quota_desc_short),
    CONSTRAINT fk_special_quota_created_by FOREIGN KEY (created_by) REFERENCES app.user_login(user_login_id),
    CONSTRAINT fk_special_quota_modified_by FOREIGN KEY (modified_by) REFERENCES app.user_login(user_login_id)
);

-- Table comment
COMMENT ON TABLE app.special_quota IS 'Defines special quota categories linked to quota types, with descriptions, explanations, and audit fields.';

-- Field comments (one-liners)
COMMENT ON COLUMN app.special_quota.special_quota_id IS 'Primary key.';
COMMENT ON COLUMN app.special_quota.quota_type_id IS 'FK to app.quota_type; the parent quota type.';
COMMENT ON COLUMN app.special_quota.special_quota_desc_pt IS 'Full Portuguese description of the special quota.';
COMMENT ON COLUMN app.special_quota.special_quota_desc_short IS 'Short Portuguese description, unique.';
COMMENT ON COLUMN app.special_quota.quota_explain IS 'Explanation of the special quota rules or usage.';
COMMENT ON COLUMN app.special_quota.created_by IS 'FK to app.user_login; user who created this record.';
COMMENT ON COLUMN app.special_quota.created_on IS 'Timestamp when the record was created.';
COMMENT ON COLUMN app.special_quota.modified_by IS 'FK to app.user_login; user who last modified this record.';
COMMENT ON COLUMN app.special_quota.modified_on IS 'Timestamp of last modification.';
