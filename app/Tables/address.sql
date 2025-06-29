CREATE TABLE app.address (
    address_id    SERIAL,
    city          VARCHAR(100) NOT NULL,
    state         VARCHAR(100) NOT NULL,
    street        VARCHAR(100) NOT NULL,
    number        VARCHAR(100) NOT NULL,
    complement    VARCHAR(100) NOT NULL,
    neighborhood  VARCHAR(100) NOT NULL,
    zipcode       VARCHAR(100) NOT NULL,
    created_on    TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    modified_on   TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    created_by    INTEGER NULL,
    modified_by   INTEGER NULL,

    -- Constraints (all named)
    CONSTRAINT pk_address PRIMARY KEY (address_id),
    CONSTRAINT fk_address_created_by FOREIGN KEY (created_by) REFERENCES app.user_login(user_login_id),
    CONSTRAINT fk_address_modified_by FOREIGN KEY (modified_by) REFERENCES app.user_login(user_login_id)
);

-- Table comment
COMMENT ON TABLE app.address IS 'Stores address information including city, state, and references to who created or last modified the record.';

-- Field comments (one-liners)
COMMENT ON COLUMN app.address.address_id IS 'Primary key.';
COMMENT ON COLUMN app.address.city IS 'Name of the city for the address.';
COMMENT ON COLUMN app.address.state IS 'State or province for the address.';
COMMENT ON COLUMN app.address.street IS 'Street name for the address.';
COMMENT ON COLUMN app.address.number IS 'House, building, or unit number.';
COMMENT ON COLUMN app.address.complement IS 'Additional address details (e.g., apartment, suite).';
COMMENT ON COLUMN app.address.neighborhood IS 'Neighborhood or district.';
COMMENT ON COLUMN app.address.zipcode IS 'Postal or zip code.';
COMMENT ON COLUMN app.address.created_on IS 'Timestamp when the address record was created.';
COMMENT ON COLUMN app.address.modified_on IS 'Timestamp when the address record was last modified.';
COMMENT ON COLUMN app.address.created_by IS 'FK to app.user_login (creator of this address).';
COMMENT ON COLUMN app.address.modified_by IS 'FK to app.user_login (last modifier of this address).';
