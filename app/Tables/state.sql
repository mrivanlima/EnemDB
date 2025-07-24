CREATE TABLE IF NOT EXISTS app.state (
    state_id               SERIAL,
    region_id              INT NOT NULL,
    state_abbr             CHAR(2) NOT NULL,
    state_name             VARCHAR(20) NOT NULL,
    state_name_friendly    VARCHAR(20) NOT NULL,
    created_by             INTEGER NOT NULL,
    created_on             TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    modified_by            INTEGER,
    modified_on            TIMESTAMPTZ,

    -- Constraints
    CONSTRAINT pk_state_id PRIMARY KEY (state_id),
    CONSTRAINT fk_state_region_id FOREIGN KEY (region_id) REFERENCES app.region(region_id),
    CONSTRAINT fk_state_created_by FOREIGN KEY (created_by) REFERENCES app.user_login(user_login_id),
    CONSTRAINT fk_state_modified_by FOREIGN KEY (modified_by) REFERENCES app.user_login(user_login_id),
    CONSTRAINT uq_state_abbr UNIQUE (state_abbr),
    CONSTRAINT uq_state_name UNIQUE (state_name),
    CONSTRAINT uq_state_name_friendly UNIQUE (state_name_friendly)
);

-- Table comment
COMMENT ON TABLE app.state IS 'Represents states/provinces within regions, with abbreviations, friendly names, and audit tracking.';

-- Field comments (one-liners)
COMMENT ON COLUMN app.state.state_id IS 'Primary key.';
COMMENT ON COLUMN app.state.region_id IS 'FK to app.region; region containing this state.';
COMMENT ON COLUMN app.state.state_abbr IS 'State abbreviation (unique).';
COMMENT ON COLUMN app.state.state_name IS 'Full state name (unique).';
COMMENT ON COLUMN app.state.state_name_friendly IS 'User-friendly display name for the state (unique).';
COMMENT ON COLUMN app.state.created_by IS 'FK to app.user_login; user who created this record.';
COMMENT ON COLUMN app.state.created_on IS 'Timestamp when the record was created.';
COMMENT ON COLUMN app.state.modified_by IS 'FK to app.user_login; user who last modified this record.';
COMMENT ON COLUMN app.state.modified_on IS 'Timestamp of the most recent modification.';
