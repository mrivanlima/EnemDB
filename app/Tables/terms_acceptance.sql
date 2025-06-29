CREATE TABLE IF NOT EXISTS app.terms_acceptance (
    terms_acceptance_id  SERIAL,
    user_login_id        INTEGER NOT NULL,
    terms_version        TEXT NOT NULL,       -- E.g. "2024-06", "v1.0", etc.
    accepted_on          TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    accepted_by          INTEGER NOT NULL,    -- FK to user_login who accepted
    is_active            BOOLEAN NOT NULL DEFAULT TRUE,
    created_by           INTEGER NOT NULL,
    created_on           TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    modified_by          INTEGER,
    modified_on          TIMESTAMPTZ,

    -- Constraints (all named)
    CONSTRAINT pk_terms_acceptance_id PRIMARY KEY (terms_acceptance_id),
    CONSTRAINT fk_terms_acceptance_user_login_id FOREIGN KEY (user_login_id) REFERENCES app.user_login(user_login_id) ON DELETE CASCADE,
    CONSTRAINT fk_terms_acceptance_accepted_by FOREIGN KEY (accepted_by) REFERENCES app.user_login(user_login_id),
    CONSTRAINT fk_terms_acceptance_created_by FOREIGN KEY (created_by) REFERENCES app.user_login(user_login_id),
    CONSTRAINT fk_terms_acceptance_modified_by FOREIGN KEY (modified_by) REFERENCES app.user_login(user_login_id)
);

-- Table comment
COMMENT ON TABLE app.terms_acceptance IS 'Tracks when a user account accepts Terms of Service and/or Privacy Policy, including version.';

-- Field comments (one-liners)
COMMENT ON COLUMN app.terms_acceptance.terms_acceptance_id IS 'Primary key.';
COMMENT ON COLUMN app.terms_acceptance.user_login_id IS 'FK to app.user_login; user who accepted the terms.';
COMMENT ON COLUMN app.terms_acceptance.terms_version IS 'Version of the terms/policy accepted.';
COMMENT ON COLUMN app.terms_acceptance.accepted_on IS 'Timestamp when user accepted the terms.';
COMMENT ON COLUMN app.terms_acceptance.accepted_by IS 'FK to app.user_login; user who accepted the terms.';
COMMENT ON COLUMN app.terms_acceptance.is_active IS 'TRUE if this record is the most current acceptance.';
COMMENT ON COLUMN app.terms_acceptance.created_by IS 'FK to app.user_login; who created this record.';
COMMENT ON COLUMN app.terms_acceptance.created_on IS 'Creation timestamp.';
COMMENT ON COLUMN app.terms_acceptance.modified_by IS 'FK to app.user_login; who last modified this record.';
COMMENT ON COLUMN app.terms_acceptance.modified_on IS 'Modification timestamp.';
