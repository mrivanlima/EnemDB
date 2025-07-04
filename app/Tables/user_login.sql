CREATE TABLE IF NOT EXISTS app.user_login (
    user_login_id         SERIAL,
    email                 CITEXT NOT NULL,
    password_hash         TEXT,
    is_email_verified     BOOLEAN NOT NULL DEFAULT FALSE,
    is_active             BOOLEAN NOT NULL DEFAULT TRUE,
    soft_deleted_at       TIMESTAMPTZ,
    created_by            INTEGER NOT NULL,
    created_on            TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    modified_by           INTEGER,
    modified_on           TIMESTAMPTZ,

    -- Constraints (all named)
    CONSTRAINT pk_user_login_id PRIMARY KEY (user_login_id),
    CONSTRAINT uq_user_login_email UNIQUE (email)
);

-- Table comment
COMMENT ON TABLE app.user_login IS 'Stores primary authentication details for all users. Uses email as unique login.';

-- Field comments (one-liners)
COMMENT ON COLUMN app.user_login.user_login_id IS 'Primary key.';
COMMENT ON COLUMN app.user_login.email IS 'User email, unique, case-insensitive.';
COMMENT ON COLUMN app.user_login.password_hash IS 'BCrypt (or similar) hash of password. NULL for Google-only accounts.';
COMMENT ON COLUMN app.user_login.is_email_verified IS 'TRUE if the email was verified by user.';
COMMENT ON COLUMN app.user_login.is_active IS 'FALSE for deactivated/soft-deleted accounts.';
COMMENT ON COLUMN app.user_login.soft_deleted_at IS 'Timestamp of soft deletion, if any.';
COMMENT ON COLUMN app.user_login.created_by IS 'FK to app.user_login; record creator (system or admin).';
COMMENT ON COLUMN app.user_login.created_on IS 'Creation timestamp.';
COMMENT ON COLUMN app.user_login.modified_by IS 'FK to app.user_login; last modifier (system or admin).';
COMMENT ON COLUMN app.user_login.modified_on IS 'Modification timestamp.';
