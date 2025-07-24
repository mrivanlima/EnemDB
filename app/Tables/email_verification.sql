CREATE TABLE IF NOT EXISTS app.email_verification (
    email_verification_id  SERIAL,
    user_login_id          INTEGER NOT NULL,
    verification_token     VARCHAR(256) NOT NULL,
    requested_on           TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    verified_on            TIMESTAMPTZ,
    is_verified            BOOLEAN NOT NULL DEFAULT FALSE,
    is_active              BOOLEAN NOT NULL DEFAULT TRUE,
    created_by             INTEGER NOT NULL,
    created_on             TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    modified_by            INTEGER,
    modified_on            TIMESTAMPTZ,

    -- Constraints (all named)
    CONSTRAINT pk_email_verification_id PRIMARY KEY (email_verification_id),
    CONSTRAINT fk_email_verification_user_login_id FOREIGN KEY (user_login_id) REFERENCES app.user_login(user_login_id) ON DELETE CASCADE,
    CONSTRAINT uq_email_verification_token UNIQUE (verification_token),
    CONSTRAINT fk_email_verification_created_by FOREIGN KEY (created_by) REFERENCES app.user_login(user_login_id),
    CONSTRAINT fk_email_verification_modified_by FOREIGN KEY (modified_by) REFERENCES app.user_login(user_login_id)
);

-- Table comment
COMMENT ON TABLE app.email_verification IS 'Tracks email verification tokens, requested/verified status, and auditing info for user accounts.';

-- Field comments (one-liners)
COMMENT ON COLUMN app.email_verification.email_verification_id IS 'Primary key.';
COMMENT ON COLUMN app.email_verification.user_login_id IS 'FK to app.user_login; identifies the user being verified.';
COMMENT ON COLUMN app.email_verification.verification_token IS 'Unique verification token sent to user.';
COMMENT ON COLUMN app.email_verification.requested_on IS 'Timestamp when verification was requested.';
COMMENT ON COLUMN app.email_verification.verified_on IS 'Timestamp when email was verified (nullable).';
COMMENT ON COLUMN app.email_verification.is_verified IS 'TRUE if the email is verified.';
COMMENT ON COLUMN app.email_verification.is_active IS 'TRUE if this verification process is currently valid.';
COMMENT ON COLUMN app.email_verification.created_by IS 'FK to app.user_login; who created this record.';
COMMENT ON COLUMN app.email_verification.created_on IS 'Creation timestamp.';
COMMENT ON COLUMN app.email_verification.modified_by IS 'FK to app.user_login; who last modified this record.';
COMMENT ON COLUMN app.email_verification.modified_on IS 'Modification timestamp.';
