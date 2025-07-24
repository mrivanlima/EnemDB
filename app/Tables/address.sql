CREATE TABLE IF NOT EXISTS app.address (
    address_id      SERIAL,
    street_id       INT NOT NULL,
    number          VARCHAR(100) NOT NULL,
    complement      VARCHAR(100) NOT NULL,
    created_on      TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    modified_on     TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    created_by      INTEGER,
    modified_by     INTEGER,

    -- Constraints
    CONSTRAINT pk_address PRIMARY KEY (address_id),
    CONSTRAINT fk_address_street_id FOREIGN KEY (street_id) REFERENCES app.street(street_id) ON DELETE CASCADE,
    CONSTRAINT fk_address_created_by FOREIGN KEY (created_by) REFERENCES app.user_login(user_login_id),
    CONSTRAINT fk_address_modified_by FOREIGN KEY (modified_by) REFERENCES app.user_login(user_login_id)
);

-- Table comment
COMMENT ON TABLE app.address IS 'Stores address information linked to a street, with auditing and postal details.';

-- Column comments
COMMENT ON COLUMN app.address.address_id IS 'Primary key.';
COMMENT ON COLUMN app.address.street_id IS 'FK to app.street; identifies the street for this address.';
COMMENT ON COLUMN app.address.number IS 'House, building, or unit number.';
COMMENT ON COLUMN app.address.complement IS 'Additional address details (e.g., apartment, suite).';
COMMENT ON COLUMN app.address.created_on IS 'Timestamp when the address record was created.';
COMMENT ON COLUMN app.address.modified_on IS 'Timestamp when the address record was last modified.';
COMMENT ON COLUMN app.address.created_by IS 'FK to app.user_login (creator of this address).';
COMMENT ON COLUMN app.address.modified_by IS 'FK to app.user_login (last modifier of this address).';
