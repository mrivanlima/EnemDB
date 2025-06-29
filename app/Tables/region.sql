CREATE TABLE IF NOT EXISTS app.region (
    region_id               SERIAL,
    region_name             TEXT NOT NULL,
    region_name_friendly    TEXT NOT NULL,
    created_by              INTEGER NOT NULL,
    created_on              TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    modified_by             INTEGER,
    modified_on             TIMESTAMPTZ,

    -- Constraints
    CONSTRAINT pk_region_id PRIMARY KEY (region_id),
    CONSTRAINT uq_region_name UNIQUE (region_name),
    CONSTRAINT uq_region_name_friendly UNIQUE (region_name_friendly),
    CONSTRAINT fk_region_created_by FOREIGN KEY (created_by) REFERENCES app.user_login(user_login_id),
    CONSTRAINT fk_region_modified_by FOREIGN KEY (modified_by) REFERENCES app.user_login(user_login_id)
);

-- Table comment
COMMENT ON TABLE app.region IS 'Represents geographic or administrative regions, with friendly names and audit trail.';

-- Field comments (one-liners)
COMMENT ON COLUMN app.region.region_id IS 'Primary key.';
COMMENT ON COLUMN app.region.region_name IS 'Official region name (unique).';
COMMENT ON COLUMN app.region.region_name_friendly IS 'User-friendly or display name for the region (unique).';
COMMENT ON COLUMN app.region.created_by IS 'FK to app.user_login; identifies the user who created this record.';
COMMENT ON COLUMN app.region.created_on IS 'Timestamp when the region record was created.';
COMMENT ON COLUMN app.region.modified_by IS 'FK to app.user_login; identifies the user who last modified this record.';
COMMENT ON COLUMN app.region.modified_on IS 'Timestamp of the most recent modification.';
