CREATE TABLE IF NOT EXISTS app.shift (
    shift_id                SERIAL,
    shift_name              VARCHAR(255) NOT NULL,
    shift_name_friendly     VARCHAR(255) NOT NULL,
    created_by              INTEGER NOT NULL,
    created_on              TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    modified_by             INTEGER,
    modified_on             TIMESTAMPTZ,

    -- Constraints
    CONSTRAINT pk_shift_id PRIMARY KEY (shift_id),
    CONSTRAINT uq_shift_name UNIQUE (shift_name),
    CONSTRAINT uq_shift_name_friendly UNIQUE (shift_name_friendly),
    CONSTRAINT fk_shift_created_by FOREIGN KEY (created_by) REFERENCES app.user_login(user_login_id),
    CONSTRAINT fk_shift_modified_by FOREIGN KEY (modified_by) REFERENCES app.user_login(user_login_id)
);

-- Table comment
COMMENT ON TABLE app.shift IS 'Defines academic shift or session types (e.g., morning, evening) with friendly names and audit information.';

-- Field comments (one-liners)
COMMENT ON COLUMN app.shift.shift_id IS 'Primary key.';
COMMENT ON COLUMN app.shift.shift_name IS 'Official name of the shift (unique).';
COMMENT ON COLUMN app.shift.shift_name_friendly IS 'User-friendly display name for the shift (unique).';
COMMENT ON COLUMN app.shift.created_by IS 'FK to app.user_login; user who created this record.';
COMMENT ON COLUMN app.shift.created_on IS 'Timestamp when the record was created.';
COMMENT ON COLUMN app.shift.modified_by IS 'FK to app.user_login; user who last modified this record.';
COMMENT ON COLUMN app.shift.modified_on IS 'Timestamp of the most recent modification.';


