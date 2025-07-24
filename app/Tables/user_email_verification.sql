CREATE TABLE IF NOT EXISTS app.user_email_verification (
    user_email_verification_id SERIAL,
    user_login_id              INTEGER NOT NULL,
    verification_token         VARCHAR(255) NOT NULL,
    expires_at                 TIMESTAMPTZ NOT NULL,
    is_used                    BOOLEAN NOT NULL DEFAULT FALSE,
    used_on                    TIMESTAMPTZ,

    created_by                 INTEGER NOT NULL,
    created_on                 TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    modified_by                INTEGER,
    modified_on                TIMESTAMPTZ,

    CONSTRAINT pk_user_email_verification_id PRIMARY KEY (user_email_verification_id),
    CONSTRAINT fk_user_email_verification_user_login_id FOREIGN KEY (user_login_id)
        REFERENCES app.user_login(user_login_id)
        ON DELETE CASCADE,
    CONSTRAINT uq_user_email_verification_token UNIQUE (verification_token)
);

COMMENT ON TABLE app.user_email_verification IS 'Stores email verification tokens for public confirmation links.';
COMMENT ON COLUMN app.user_email_verification.user_email_verification_id IS 'Primary key.';
COMMENT ON COLUMN app.user_email_verification.user_login_id IS 'FK to app.user_login.';
COMMENT ON COLUMN app.user_email_verification.verification_token IS 'Secure hash used to verify the user email.';
COMMENT ON COLUMN app.user_email_verification.expires_at IS 'Expiration timestamp of the token.';
COMMENT ON COLUMN app.user_email_verification.is_used IS 'TRUE if token has already been used.';
COMMENT ON COLUMN app.user_email_verification.used_on IS 'Timestamp when the token was used.';
COMMENT ON COLUMN app.user_email_verification.created_by IS 'Who created the token (usually system).';
COMMENT ON COLUMN app.user_email_verification.created_on IS 'When token was created.';
COMMENT ON COLUMN app.user_email_verification.modified_by IS 'Who modified the token entry, if any.';
COMMENT ON COLUMN app.user_email_verification.modified_on IS 'When entry was last modified.';
