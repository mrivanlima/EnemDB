CREATE TABLE IF NOT EXISTS app.user_auth_provider (
    user_auth_provider_id  SERIAL,
    user_login_id          INTEGER NOT NULL,
    auth_provider_id       INTEGER NOT NULL,
    provider_uid           TEXT NOT NULL,
    is_active              BOOLEAN NOT NULL DEFAULT TRUE,
    created_by             INTEGER NOT NULL,
    created_on             TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    modified_by            INTEGER,
    modified_on            TIMESTAMPTZ,

    -- Constraints
    CONSTRAINT pk_user_auth_provider_id PRIMARY KEY (user_auth_provider_id),
    CONSTRAINT fk_uap_user_login_id FOREIGN KEY (user_login_id) REFERENCES app.user_login(user_login_id) ON DELETE CASCADE,
    CONSTRAINT fk_uap_auth_provider_id FOREIGN KEY (auth_provider_id) REFERENCES app.auth_provider(auth_provider_id) ON DELETE RESTRICT,
    CONSTRAINT fk_uap_created_by FOREIGN KEY (created_by) REFERENCES app.user_login(user_login_id),
    CONSTRAINT fk_uap_modified_by FOREIGN KEY (modified_by) REFERENCES app.user_login(user_login_id),
    CONSTRAINT uq_user_auth UNIQUE (user_login_id, auth_provider_id)
);

COMMENT ON TABLE app.user_auth_provider IS 'Links users to external or local authentication providers (e.g., Google, GitHub, local).';

COMMENT ON COLUMN app.user_auth_provider.user_auth_provider_id IS 'Primary key.';
COMMENT ON COLUMN app.user_auth_provider.user_login_id IS 'FK to app.user_login.';
COMMENT ON COLUMN app.user_auth_provider.auth_provider_id IS 'FK to app.auth_provider.';
COMMENT ON COLUMN app.user_auth_provider.provider_uid IS 'Unique ID provided by the authentication service (e.g., Google user ID).';
COMMENT ON COLUMN app.user_auth_provider.is_active IS 'Indicates if this link is active.';
COMMENT ON COLUMN app.user_auth_provider.created_by IS 'FK to user_login; creator of the record.';
COMMENT ON COLUMN app.user_auth_provider.created_on IS 'Timestamp of creation.';
COMMENT ON COLUMN app.user_auth_provider.modified_by IS 'FK to user_login; last modifier.';
COMMENT ON COLUMN app.user_auth_provider.modified_on IS 'Timestamp of last modification.';

