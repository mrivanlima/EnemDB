CREATE TABLE IF NOT EXISTS app.frequency (
    frequency_id               SERIAL,
    frequency_name             VARCHAR(50) NOT NULL,
    frequency_name_friendly    VARCHAR(50) NOT NULL,
    created_by                 INTEGER NOT NULL,
    created_on                 TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    modified_by                INTEGER,
    modified_on                TIMESTAMPTZ,

    -- Constraints
    CONSTRAINT pk_frequency_id PRIMARY KEY (frequency_id),
    CONSTRAINT uq_frequency_name UNIQUE (frequency_name),
    CONSTRAINT uq_frequency_name_friendly UNIQUE (frequency_name_friendly),
    CONSTRAINT fk_frequency_created_by FOREIGN KEY (created_by) REFERENCES app.user_login(user_login_id),
    CONSTRAINT fk_frequency_modified_by FOREIGN KEY (modified_by) REFERENCES app.user_login(user_login_id)
);

-- Table comment
COMMENT ON TABLE app.frequency IS 'Represents possible frequency values for scheduling, attendance, or reporting (e.g., daily, weekly), with friendly names and audit fields.';

-- Field comments (one-liners)
COMMENT ON COLUMN app.frequency.frequency_id IS 'Primary key.';
COMMENT ON COLUMN app.frequency.frequency_name IS 'Official name of the frequency (unique).';
COMMENT ON COLUMN app.frequency.frequency_name_friendly IS 'User-friendly display name for the frequency (unique).';
COMMENT ON COLUMN app.frequency.created_by IS 'FK to app.user_login; identifies the user who created this record.';
COMMENT ON COLUMN app.frequency.created_on IS 'Timestamp when the frequency record was created.';
COMMENT ON COLUMN app.frequency.modified_by IS 'FK to app.user_login; identifies the user who last modified this record.';
COMMENT ON COLUMN app.frequency.modified_on IS 'Timestamp of the most recent modification.';
