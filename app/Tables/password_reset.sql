CREATE TABLE IF NOT EXISTS app.password_reset (
    password_reset_id     SERIAL,
    user_login_id         INTEGER NOT NULL,
    reset_token           VARCHAR(255) NOT NULL,
    requested_on          TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    used_on               TIMESTAMPTZ,
    is_used               BOOLEAN NOT NULL DEFAULT FALSE,
    is_active             BOOLEAN NOT NULL DEFAULT TRUE,
    created_by            INTEGER NOT NULL,
    created_on            TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    modified_by           INTEGER,
    modified_on           TIMESTAMPTZ,

    -- Constraints (all named)
    CONSTRAINT pk_password_reset_id PRIMARY KEY (password_reset_id),
    CONSTRAINT fk_password_reset_user_login_id FOREIGN KEY (user_login_id) REFERENCES app.user_login(user_login_id) ON DELETE CASCADE,
    CONSTRAINT uq_password_reset_token UNIQUE (reset_token),
    CONSTRAINT fk_password_reset_created_by FOREIGN KEY (created_by) REFERENCES app.user_login(user_login_id),
    CONSTRAINT fk_password_reset_modified_by FOREIGN KEY (modified_by) REFERENCES app.user_login(user_login_id)
);

-- Table comment
COMMENT ON TABLE app.password_reset IS 'Handles password reset requests for user accounts, with secure tokens and audit fields.';

-- Field comments (one-liners)
COMMENT ON COLUMN app.password_reset.password_reset_id IS 'Primary key.';
COMMENT ON COLUMN app.password_reset.user_login_id IS 'FK to app.user_login.';
COMMENT ON COLUMN app.password_reset.reset_token IS 'Unique, secure token for password reset.';
COMMENT ON COLUMN app.password_reset.requested_on IS 'Timestamp when reset was requested.';
COMMENT ON COLUMN app.password_reset.used_on IS 'Timestamp when reset was completed/used.';
COMMENT ON COLUMN app.password_reset.is_used IS 'TRUE if this token has already been used.';
COMMENT ON COLUMN app.password_reset.is_active IS 'TRUE if token is currently valid.';
COMMENT ON COLUMN app.password_reset.created_by IS 'FK to app.user_login; who created this record.';
COMMENT ON COLUMN app.password_reset.created_on IS 'Creation timestamp.';
COMMENT ON COLUMN app.password_reset.modified_by IS 'FK to app.user_login; who last modified this record.';
COMMENT ON COLUMN app.password_reset.modified_on IS 'Modification timestamp.';
