CREATE TABLE IF NOT EXISTS app.provider_type (
    provider_type_id   SERIAL,
    type_code          VARCHAR(50) NOT NULL UNIQUE,
    description        VARCHAR(255),
    created_by         INTEGER NOT NULL,
    created_on         TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    modified_by        INTEGER,
    modified_on        TIMESTAMPTZ,

    -- Constraints
    CONSTRAINT pk_provider_type PRIMARY KEY (provider_type_id),
    CONSTRAINT uq_provider_type_code UNIQUE (type_code),
    CONSTRAINT fk_provider_type_created_by FOREIGN KEY (created_by) REFERENCES app.user_login(user_login_id),
    CONSTRAINT fk_provider_type_modified_by FOREIGN KEY (modified_by) REFERENCES app.user_login(user_login_id)
);

-- Table comment
COMMENT ON TABLE app.provider_type IS 'Defines types of authentication providers (e.g., local, oauth, saml).';

-- Field comments
COMMENT ON COLUMN app.provider_type.provider_type_id IS 'Primary key.';
COMMENT ON COLUMN app.provider_type.type_code IS 'Short code like local, oauth, saml.';
COMMENT ON COLUMN app.provider_type.description IS 'Optional description of the provider type.';
COMMENT ON COLUMN app.provider_type.created_by IS 'FK to app.user_login; record creator.';
COMMENT ON COLUMN app.provider_type.created_on IS 'Timestamp when the record was created.';
COMMENT ON COLUMN app.provider_type.modified_by IS 'FK to app.user_login; last modifier.';
COMMENT ON COLUMN app.provider_type.modified_on IS 'Timestamp when the record was last modified.';
