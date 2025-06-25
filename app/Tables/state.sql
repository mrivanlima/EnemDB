CREATE TABLE IF NOT EXISTS app.state (
    state_id               SERIAL,
    region_id              INT NOT NULL,
    state_abbr             TEXT NOT NULL,
    state_name             TEXT NOT NULL,
    state_name_friendly    TEXT NOT NULL,
    created_by             TEXT NOT NULL,
    created_on             TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    modified_by            TEXT,
    modified_on            TIMESTAMPTZ,
    -- Constraints
    CONSTRAINT pk_state_id PRIMARY KEY (state_id),
    CONSTRAINT fk_region_id FOREIGN KEY (region_id) REFERENCES app.region(region_id),
    CONSTRAINT uq_state_abbr UNIQUE (state_abbr),
    CONSTRAINT uq_state_name UNIQUE (state_name),
    CONSTRAINT uq_state_name_friendly UNIQUE (state_name_friendly)
);
