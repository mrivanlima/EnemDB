CREATE TABLE IF NOT EXISTS app.quota_type (
    quota_type_id            SERIAL,
    quota_type_code          TEXT NOT NULL,
    quota_type_desc_pt       TEXT NOT NULL,
    quota_type_desc_short_pt TEXT NOT NULL,
    quota_explain            TEXT NOT NULL,
    created_by               TEXT NOT NULL DEFAULT 'system',
    created_on               TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    modified_by              TEXT,
    modified_on              TIMESTAMPTZ,
    CONSTRAINT pk_quota_type_id PRIMARY KEY (quota_type_id),
    CONSTRAINT uq_quota_type_code UNIQUE (quota_type_code),
    CONSTRAINT uq_quota_type_short UNIQUE (quota_type_desc_short_pt)
);
