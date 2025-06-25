CREATE TABLE IF NOT EXISTS app.region (
    region_id               SERIAL,
    region_name             TEXT NOT NULL,
    region_name_friendly    TEXT NOT NULL,
    created_by              TEXT NOT NULL,
    created_on              TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    modified_by             TEXT,
    modified_on             TIMESTAMPTZ,
    -- Constraints
    CONSTRAINT pk_region_id PRIMARY KEY (region_id),
    CONSTRAINT uq_region_name UNIQUE (region_name),
    CONSTRAINT uq_region_name_friendly UNIQUE (region_name_friendly)
);
