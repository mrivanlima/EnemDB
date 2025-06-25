CREATE TABLE IF NOT EXISTS app.special_quota (
    special_quota_id         SERIAL,
    quota_type_id            INTEGER NOT NULL,
    special_quota_desc_pt    TEXT NOT NULL,
    special_quota_desc_short TEXT NOT NULL,
    quota_explain            TEXT NOT NULL,
    created_by               TEXT NOT NULL DEFAULT 'system',
    created_on               TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    modified_by              TEXT,
    modified_on              TIMESTAMPTZ,
    CONSTRAINT pk_special_quota_id PRIMARY KEY (special_quota_id),
    CONSTRAINT fk_special_quota_quota_type_id FOREIGN KEY (quota_type_id)
        REFERENCES app.quota_type (quota_type_id),
    CONSTRAINT uq_special_quota_desc_short UNIQUE (special_quota_desc_short)
);
