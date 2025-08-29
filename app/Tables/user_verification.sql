
DROP TABLE IF EXISTS app.user_verification CASCADE;
CREATE TABLE IF NOT EXISTS app.user_verification (
    user_verification_id       SERIAL,
    verification_purpose_id    INTEGER NOT NULL,
    user_login_id              INTEGER NOT NULL,
    verification_token         VARCHAR(255) NOT NULL,
    expires_at                 TIMESTAMPTZ NOT NULL,
    is_used                    BOOLEAN NOT NULL DEFAULT FALSE,
    used_on                    TIMESTAMPTZ,

    created_by                  INTEGER NOT NULL,
    created_on                 TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    modified_by                INTEGER,
    modified_on                TIMESTAMPTZ,

    CONSTRAINT pk_user_verification_id PRIMARY KEY (user_verification_id),
    CONSTRAINT fk_user_verification_user_login_id FOREIGN KEY (user_login_id)
        REFERENCES app.user_login(user_login_id)
        ON DELETE CASCADE,
        CONSTRAINT fk_user_verification_verification_purpose_id FOREIGN KEY (verification_purpose_id)
        REFERENCES app.verification_purpose(verification_purpose_id)
        ON DELETE CASCADE,
    CONSTRAINT uq_user_verification_token UNIQUE (verification_token)
);

COMMENT ON TABLE app.user_verification IS 'Stores email verification tokens for public confirmation links.';
COMMENT ON COLUMN app.user_verification.user_verification_id IS 'Primary key.';
COMMENT ON COLUMN app.user_verification.user_login_id IS 'FK to app.user_login.';
COMMENT ON COLUMN app.user_verification.verification_token IS 'Secure hash used to verify the user email.';
COMMENT ON COLUMN app.user_verification.expires_at IS 'Expiration timestamp of the token.';
COMMENT ON COLUMN app.user_verification.is_used IS 'TRUE if token has already been used.';
COMMENT ON COLUMN app.user_verification.used_on IS 'Timestamp when the token was used.';
COMMENT ON COLUMN app.user_verification.created_by IS 'Who created the token (usually system).';
COMMENT ON COLUMN app.user_verification.created_on IS 'When token was created.';
COMMENT ON COLUMN app.user_verification.modified_by IS 'Who modified the token entry, if any.';
COMMENT ON COLUMN app.user_verification.modified_on IS 'When entry was last modified.';
