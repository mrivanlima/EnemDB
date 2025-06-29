CREATE TABLE IF NOT EXISTS app.user_auth_provider (
    user_auth_provider_id SERIAL,
    user_login_id         INTEGER NOT NULL,
    provider_name         TEXT NOT NULL,   -- e.g., 'local', 'google'
    provider_uid          TEXT NOT NULL,   -- For Google: their subject/ID; for local: email
    linked_on             TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    unlinked_on           TIMESTAMPTZ,
    is_active             BOOLEAN NOT NULL DEFAULT TRUE,

    created_by            INTEGER NOT NULL,
    created_on            TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    modified_by           INTEGER,
    modified_on           TIMESTAMPTZ,

    -- Constraints (all named)
    CONSTRAINT pk_user_auth_provider_id PRIMARY KEY (user_auth_provider_id),
    CONSTRAINT fk_user_auth_provider_user_login_id FOREIGN KEY (user_login_id) REFERENCES app.user_login (user_login_id) ON DELETE CASCADE,
    CONSTRAINT fk_user_auth_provider_created_by FOREIGN KEY (created_by) REFERENCES app.user_login(user_login_id),
    CONSTRAINT fk_user_auth_provider_modified_by FOREIGN KEY (modified_by) REFERENCES app.user_login(user_login_id),
    CONSTRAINT uq_user_auth_provider UNIQUE (provider_name, provider_uid, is_active)
);

-- Table comment
COMMENT ON TABLE app.user_auth_provider IS 'Tracks which authentication providers (local, Google, etc.) are linked to each user_login. Supports multiple providers per user and future extensibility.';

-- Field comments (one-liners)
COMMENT ON COLUMN app.user_auth_provider.user_auth_provider_id IS 'Primary key.';
COMMENT ON COLUMN app.user_auth_provider.user_login_id IS 'FK to app.user_login.';
COMMENT ON COLUMN app.user_auth_provider.provider_name IS 'Provider name, e.g., "local", "google".';
COMMENT ON COLUMN app.user_auth_provider.provider_uid IS 'Unique ID from provider (Google subject, or user email for local).';
COMMENT ON COLUMN app.user_auth_provider.linked_on IS 'Timestamp when provider was linked.';
COMMENT ON COLUMN app.user_auth_provider.unlinked_on IS 'Timestamp when provider was unlinked (nullable).';
COMMENT ON COLUMN app.user_auth_provider.is_active IS 'TRUE if provider is currently linked.';
COMMENT ON COLUMN app.user_auth_provider.created_by IS 'FK to app.user_login; user who created this record.';
COMMENT ON COLUMN app.user_auth_provider.created_on IS 'Creation timestamp.';
COMMENT ON COLUMN app.user_auth_provider.modified_by IS 'FK to app.user_login; user who last modified this record.';
COMMENT ON COLUMN app.user_auth_provider.modified_on IS 'Modification timestamp.';
