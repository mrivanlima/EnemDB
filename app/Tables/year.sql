CREATE TABLE IF NOT EXISTS app.year (
    year_id              SERIAL,
    year                 SMALLINT NOT NULL,
    year_name            VARCHAR(40) NOT NULL,
    year_name_friendly   VARCHAR(40) NOT NULL,
    created_by           INTEGER NOT NULL,
    created_on           TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    modified_by          INTEGER,
    modified_on          TIMESTAMPTZ,

    -- Constraints (all named)
    CONSTRAINT pk_year_id PRIMARY KEY (year_id),
    CONSTRAINT uq_year UNIQUE (year),
    CONSTRAINT uq_year_name UNIQUE (year_name),
    CONSTRAINT uq_year_name_friendly UNIQUE (year_name_friendly),
    CONSTRAINT fk_year_created_by FOREIGN KEY (created_by) REFERENCES app.user_login(user_login_id),
    CONSTRAINT fk_year_modified_by FOREIGN KEY (modified_by) REFERENCES app.user_login(user_login_id)
);

-- Table comment
COMMENT ON TABLE app.year IS 'Stores exam years with friendly names and audit information.';

-- Field comments (one-liners)
COMMENT ON COLUMN app.year.year_id IS 'Primary key.';
COMMENT ON COLUMN app.year.year IS 'Year number (e.g., 2024).';
COMMENT ON COLUMN app.year.year_name IS 'Official year name.';
COMMENT ON COLUMN app.year.year_name_friendly IS 'User-friendly year name for display.';
COMMENT ON COLUMN app.year.created_by IS 'FK to app.user_login; user who created this record.';
COMMENT ON COLUMN app.year.created_on IS 'Timestamp when the record was created.';
COMMENT ON COLUMN app.year.modified_by IS 'FK to app.user_login; user who last modified this record.';
COMMENT ON COLUMN app.year.modified_on IS 'Timestamp of the last modification.';
