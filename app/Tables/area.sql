CREATE TABLE IF NOT EXISTS app.area (
    area_id           SERIAL,
    area_name         TEXT NOT NULL,
    area_name_friendly TEXT NOT NULL,
    created_by        INTEGER NOT NULL,
    created_on        TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    modified_by       INTEGER,
    modified_on       TIMESTAMPTZ,

    -- Constraints
    CONSTRAINT pk_area_id PRIMARY KEY (area_id),
    CONSTRAINT uq_area_name UNIQUE (area_name),
    CONSTRAINT uq_area_name_friendly UNIQUE (area_name_friendly),
    CONSTRAINT fk_area_created_by FOREIGN KEY (created_by) REFERENCES app.user_login(user_login_id),
    CONSTRAINT fk_area_modified_by FOREIGN KEY (modified_by) REFERENCES app.user_login(user_login_id)
);

-- Table comment
COMMENT ON TABLE app.area IS 'Represents a subject area of the ENEM exam (e.g., Linguagens, Códigos e suas Tecnologias e Redação), with support for friendly names and auditing.';

-- Field comments
COMMENT ON COLUMN app.area.area_id IS 'Primary key.';
COMMENT ON COLUMN app.area.area_name IS 'Official name of the subject area (unique).';
COMMENT ON COLUMN app.area.area_name_friendly IS 'User-friendly display name for the subject area (unique).';
COMMENT ON COLUMN app.area.created_by IS 'FK to app.user_login; user who created this record.';
COMMENT ON COLUMN app.area.created_on IS 'Timestamp of record creation.';
COMMENT ON COLUMN app.area.modified_by IS 'FK to app.user_login; user who last modified this record.';
COMMENT ON COLUMN app.area.modified_on IS 'Timestamp of the most recent modification.';
