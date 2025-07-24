CREATE TABLE IF NOT EXISTS app.auth_provider (
    auth_provider_id     SERIAL,
    provider_name        VARCHAR(50) NOT NULL,
    provider_key         VARCHAR(255) NOT NULL,
    provider_type_id     INTEGER NOT NULL,

    created_by           INTEGER NOT NULL,
    created_on           TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    modified_by          INTEGER,
    modified_on          TIMESTAMPTZ,

    -- Constraints
    CONSTRAINT pk_auth_provider PRIMARY KEY (auth_provider_id),
    CONSTRAINT uq_auth_provider_key UNIQUE (provider_key),
    CONSTRAINT fk_auth_provider_type_id FOREIGN KEY (provider_type_id) REFERENCES app.provider_type(provider_type_id) ON DELETE RESTRICT,
    CONSTRAINT fk_auth_provider_created_by FOREIGN KEY (created_by) REFERENCES app.user_login(user_login_id),
    CONSTRAINT fk_auth_provider_modified_by FOREIGN KEY (modified_by) REFERENCES app.user_login(user_login_id)
);

-- Table comment
COMMENT ON TABLE app.auth_provider IS 'Stores available authentication providers (e.g., Google, Facebook, local).';

-- Column comments
COMMENT ON COLUMN app.auth_provider.auth_provider_id IS 'Primary key.';
COMMENT ON COLUMN app.auth_provider.provider_name IS 'Display name of the authentication provider.';
COMMENT ON COLUMN app.auth_provider.provider_key IS 'Unique key or identifier used for system lookup.';
COMMENT ON COLUMN app.auth_provider.provider_type_id IS 'FK to app.provider_type; indicates the type of provider (e.g., local, oauth).';
COMMENT ON COLUMN app.auth_provider.created_by IS 'FK to app.user_login; creator of this record.';
COMMENT ON COLUMN app.auth_provider.created_on IS 'Timestamp when the provider was created.';
COMMENT ON COLUMN app.auth_provider.modified_by IS 'FK to app.user_login; last modifier of this record.';
COMMENT ON COLUMN app.auth_provider.modified_on IS 'Timestamp when the provider was last modified.';
