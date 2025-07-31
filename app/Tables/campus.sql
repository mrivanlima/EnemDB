CREATE TABLE app.campus (
    campus_id            SERIAL,
    campus_name          VARCHAR(250) NOT NULL,
    campus_name_friendly VARCHAR(250) NOT NULL,
    created_by           INTEGER NOT NULL,
    created_on           TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    modified_by          INTEGER,
    modified_on          TIMESTAMPTZ,

    -- Constraints
    CONSTRAINT pk_campus_id PRIMARY KEY (campus_id),
    CONSTRAINT fk_campus_created_by FOREIGN KEY (created_by) REFERENCES app.user_login(user_login_id),
    CONSTRAINT fk_campus_modified_by FOREIGN KEY (modified_by) REFERENCES app.user_login(user_login_id)
);

-- Table comment
COMMENT ON TABLE app.campus IS 'Represents a campus within a university, supporting friendly names and auditing of creation/modification.';

-- Field comments (one-liners)
COMMENT ON COLUMN app.campus.campus_id IS 'Primary key.';
COMMENT ON COLUMN app.campus.campus_name IS 'Official campus name (unique per university).';
COMMENT ON COLUMN app.campus.campus_name_friendly IS 'User-friendly display name for the campus (unique per university).';
COMMENT ON COLUMN app.campus.created_by IS 'FK to app.user_login; identifies the user who created this record.';
COMMENT ON COLUMN app.campus.created_on IS 'Timestamp when the campus record was created.';
COMMENT ON COLUMN app.campus.modified_by IS 'FK to app.user_login; identifies the user who last modified this record.';
COMMENT ON COLUMN app.campus.modified_on IS 'Timestamp of the most recent modification.';
