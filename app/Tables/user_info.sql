CREATE TABLE IF NOT EXISTS app.user_info (
    user_info_id           SERIAL,
    user_login_id          INTEGER NOT NULL,
    firstname              VARCHAR(100) NOT NULL,
    firstname_friendly     VARCHAR(100) NOT NULL,
    lastname               VARCHAR(100) NOT NULL,
    lastname_friendly      VARCHAR(100) NOT NULL,
    address_id             INTEGER,
    birthdate              DATE,
    gender                 CHAR(1),  -- e.g
    created_by             INTEGER NOT NULL,
    created_on             TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    modified_by            INTEGER,
    modified_on            TIMESTAMPTZ,

    -- Constraints (all named)
    CONSTRAINT pk_user_info PRIMARY KEY (user_info_id),
    CONSTRAINT fk_user_info_login FOREIGN KEY (user_login_id) REFERENCES app.user_login(user_login_id) ON DELETE CASCADE,
    CONSTRAINT fk_user_info_address FOREIGN KEY (address_id) REFERENCES app.address(address_id) ON DELETE CASCADE,
    CONSTRAINT fk_user_info_created_by FOREIGN KEY (created_by) REFERENCES app.user_login(user_login_id),
    CONSTRAINT fk_user_info_modified_by FOREIGN KEY (modified_by) REFERENCES app.user_login(user_login_id)
);

-- Table comment
COMMENT ON TABLE app.user_info IS 'Contains personal user information linked to login and address.';

-- Field comments
COMMENT ON COLUMN app.user_info.user_info_id IS 'Primary key.';
COMMENT ON COLUMN app.user_info.user_login_id IS 'FK to app.user_login; links to authentication record.';
COMMENT ON COLUMN app.user_info.firstname IS 'Legal first name.';
COMMENT ON COLUMN app.user_info.firstname_friendly IS 'Friendly/display first name.';
COMMENT ON COLUMN app.user_info.lastname IS 'Legal last name.';
COMMENT ON COLUMN app.user_info.lastname_friendly IS 'Friendly/display last name.';
COMMENT ON COLUMN app.user_info.address_id IS 'FK to app.address; user''s associated address.';
COMMENT ON COLUMN app.user_info.created_by IS 'FK to app.user_login; who created this record.';
COMMENT ON COLUMN app.user_info.created_on IS 'Timestamp of creation.';
COMMENT ON COLUMN app.user_info.modified_by IS 'FK to app.user_login; who last modified this record.';
COMMENT ON COLUMN app.user_info.modified_on IS 'Timestamp of last modification.';
COMMENT ON COLUMN app.user_info.birthdate IS 'Birth date.';
COMMENT ON COLUMN app.user_info.gender IS 'Gender (M/F/O).';
