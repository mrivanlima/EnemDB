CREATE TABLE IF NOT EXISTS app.street (
    street_id              SERIAL,
    neighborhood_id        INT NOT NULL,
    street_name            VARCHAR(100) NOT NULL,
    street_name_friendly   VARCHAR(100) NOT NULL,
    zipcode                VARCHAR(10) NOT NULL,
    created_by             INTEGER NOT NULL,
    created_on             TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    modified_by            INTEGER,
    modified_on            TIMESTAMPTZ,

    -- Constraints
    CONSTRAINT pk_street_id PRIMARY KEY (street_id),
    CONSTRAINT fk_street_neighborhood_id FOREIGN KEY (neighborhood_id) REFERENCES app.neighborhood(neighborhood_id) ON DELETE CASCADE,
    CONSTRAINT fk_street_created_by FOREIGN KEY (created_by) REFERENCES app.user_login(user_login_id),
    CONSTRAINT fk_street_modified_by FOREIGN KEY (modified_by) REFERENCES app.user_login(user_login_id),
    CONSTRAINT uq_street_neighborhood UNIQUE (neighborhood_id, street_name),
    CONSTRAINT uq_street_zipcode UNIQUE (zipcode)
);

-- Table comment
COMMENT ON TABLE app.street IS 'Represents a street within a neighborhood, supporting friendly names, auditing, and unique zipcodes.';

-- Field comments
COMMENT ON COLUMN app.street.street_id IS 'Primary key.';
COMMENT ON COLUMN app.street.neighborhood_id IS 'FK to app.neighborhood; identifies the neighborhood this street belongs to.';
COMMENT ON COLUMN app.street.street_name IS 'Official name of the street (unique per neighborhood).';
COMMENT ON COLUMN app.street.street_name_friendly IS 'User-friendly display name of the street (unique per neighborhood).';
COMMENT ON COLUMN app.street.zipcode IS 'Unique ZIP code assigned to the street.';
COMMENT ON COLUMN app.street.created_by IS 'FK to app.user_login; identifies the user who created this record.';
COMMENT ON COLUMN app.street.created_on IS 'Timestamp when the street record was created.';
COMMENT ON COLUMN app.street.modified_by IS 'FK to app.user_login; identifies the user who last modified this record.';
COMMENT ON COLUMN app.street.modified_on IS 'Timestamp of the most recent modification.';
