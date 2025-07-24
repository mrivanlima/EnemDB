CREATE TABLE IF NOT EXISTS app.neighborhood (
    neighborhood_id          SERIAL,
    city_id                  INT NOT NULL,
    neighborhood_name        VARCHAR(60) NOT NULL,
    neighborhood_name_friendly VARCHAR(60) NOT NULL,
    created_by               INTEGER NOT NULL,
    created_on               TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    modified_by              INTEGER,
    modified_on              TIMESTAMPTZ,

    -- Constraints
    CONSTRAINT pk_neighborhood_id PRIMARY KEY (neighborhood_id),
    CONSTRAINT fk_neighborhood_city_id FOREIGN KEY (city_id) REFERENCES app.city(city_id) ON DELETE CASCADE,
    CONSTRAINT fk_neighborhood_created_by FOREIGN KEY (created_by) REFERENCES app.user_login(user_login_id),
    CONSTRAINT fk_neighborhood_modified_by FOREIGN KEY (modified_by) REFERENCES app.user_login(user_login_id),
    CONSTRAINT uq_neighborhood_city UNIQUE (city_id, neighborhood_name),
    CONSTRAINT uq_neighborhood_city_friendly UNIQUE (city_id, neighborhood_name_friendly)
);

-- Table comment
COMMENT ON TABLE app.neighborhood IS 'Represents a neighborhood within a city, with support for friendly names and auditing.';

-- Field comments
COMMENT ON COLUMN app.neighborhood.neighborhood_id IS 'Primary key.';
COMMENT ON COLUMN app.neighborhood.city_id IS 'FK to app.city; identifies the city this neighborhood belongs to.';
COMMENT ON COLUMN app.neighborhood.neighborhood_name IS 'Official name of the neighborhood (unique per city).';
COMMENT ON COLUMN app.neighborhood.neighborhood_name_friendly IS 'User-friendly display name of the neighborhood (unique per city).';
COMMENT ON COLUMN app.neighborhood.created_by IS 'FK to app.user_login; identifies the user who created this record.';
COMMENT ON COLUMN app.neighborhood.created_on IS 'Timestamp when the neighborhood record was created.';
COMMENT ON COLUMN app.neighborhood.modified_by IS 'FK to app.user_login; identifies the user who last modified this record.';
COMMENT ON COLUMN app.neighborhood.modified_on IS 'Timestamp of the most recent modification.';
