CREATE TABLE IF NOT EXISTS app.city (
    city_id               SERIAL,
    state_id              INT NOT NULL,
    city_name             TEXT NOT NULL,
    city_name_friendly    TEXT NOT NULL,
    created_by            INTEGER NOT NULL,
    created_on            TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    modified_by           INTEGER,
    modified_on           TIMESTAMPTZ,

    -- Constraints
    CONSTRAINT pk_city_id PRIMARY KEY (city_id),
    CONSTRAINT fk_city_state_id FOREIGN KEY (state_id) REFERENCES app.state(state_id) ON DELETE CASCADE,
    CONSTRAINT fk_city_created_by FOREIGN KEY (created_by) REFERENCES app.user_login(user_login_id),
    CONSTRAINT fk_city_modified_by FOREIGN KEY (modified_by) REFERENCES app.user_login(user_login_id),
    CONSTRAINT uq_city_state UNIQUE (state_id, city_name),
    CONSTRAINT uq_city_state_friendly UNIQUE (state_id, city_name_friendly)
);

-- Table comment
COMMENT ON TABLE app.city IS 'Represents a city within a state, supporting friendly names and auditing of creation/modification.';

-- Field comments (one-liners)
COMMENT ON COLUMN app.city.city_id IS 'Primary key.';
COMMENT ON COLUMN app.city.state_id IS 'FK to app.state; identifies the state where the city is located.';
COMMENT ON COLUMN app.city.city_name IS 'Official city name (unique per state).';
COMMENT ON COLUMN app.city.city_name_friendly IS 'User-friendly display name for the city (unique per state).';
COMMENT ON COLUMN app.city.created_by IS 'FK to app.user_login; identifies the user who created this record.';
COMMENT ON COLUMN app.city.created_on IS 'Timestamp when the city record was created.';
COMMENT ON COLUMN app.city.modified_by IS 'FK to app.user_login; identifies the user who last modified this record.';
COMMENT ON COLUMN app.city.modified_on IS 'Timestamp of the most recent modification.';
