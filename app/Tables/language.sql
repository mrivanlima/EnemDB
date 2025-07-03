CREATE TABLE IF NOT EXISTS app.language (
    language_id            SERIAL,
    language_name          VARCHAR(20),
    language_name_friendly VARCHAR(20),
    created_by             INTEGER NOT NULL,
    created_on             TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    modified_by            INTEGER,
    modified_on            TIMESTAMPTZ,

    -- Constraints
    CONSTRAINT pk_language_id PRIMARY KEY (language_id),
    CONSTRAINT uq_language_name UNIQUE (language_name),
    CONSTRAINT uq_language_name_friendly UNIQUE (language_name_friendly),
    CONSTRAINT fk_language_created_by FOREIGN KEY (created_by) REFERENCES app.user_login(user_login_id),
    CONSTRAINT fk_language_modified_by FOREIGN KEY (modified_by) REFERENCES app.user_login(user_login_id)
);

COMMENT ON TABLE app.language IS 'Represents the language used in the exam, with friendly names and auditing.';

COMMENT ON COLUMN app.language.language_id IS 'Primary key.';
COMMENT ON COLUMN app.language.language_name IS 'Official language name (unique).';
COMMENT ON COLUMN app.language.language_name_friendly IS 'User-friendly display name for the language (unique).';
COMMENT ON COLUMN app.language.created_by IS 'FK to app.user_login; user who created this record.';
COMMENT ON COLUMN app.language.created_on IS 'Timestamp of record creation.';
COMMENT ON COLUMN app.language.modified_by IS 'FK to app.user_login; user who last modified this record.';
COMMENT ON COLUMN app.language.modified_on IS 'Timestamp of the most recent modification.';
