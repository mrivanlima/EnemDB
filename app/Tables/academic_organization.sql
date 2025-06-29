CREATE TABLE IF NOT EXISTS app.academic_organization (
    academic_organization_id            SERIAL,
    academic_organization_name          TEXT NOT NULL,
    academic_organization_name_friendly TEXT NOT NULL,
    created_by                          TEXT NOT NULL,
    created_on                          TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    modified_by                         TEXT,
    modified_on                         TIMESTAMPTZ,
    -- Constraints
    CONSTRAINT pk_academic_organization_id PRIMARY KEY (academic_organization_id),
    CONSTRAINT uq_academic_organization_name UNIQUE (academic_organization_name),
    CONSTRAINT uq_academic_organization_name_friendly UNIQUE (academic_organization_name_friendly)
);

-- Table comment
COMMENT ON TABLE app.academic_organization IS 'Represents educational or academic institutions such as schools, universities, or organizations.';

-- Field comments (one-liners)
COMMENT ON COLUMN app.academic_organization.academic_organization_id IS 'Primary key.';
COMMENT ON COLUMN app.academic_organization.academic_organization_name IS 'Official name of the academic organization, unique.';
COMMENT ON COLUMN app.academic_organization.academic_organization_name_friendly IS 'User-friendly or display name for the academic organization, unique.';
COMMENT ON COLUMN app.academic_organization.created_by IS 'Identifier for the user or system that created this record.';
COMMENT ON COLUMN app.academic_organization.created_on IS 'Timestamp when the record was created.';
COMMENT ON COLUMN app.academic_organization.modified_by IS 'Identifier for the user or system that last modified this record.';
COMMENT ON COLUMN app.academic_organization.modified_on IS 'Timestamp of the most recent modification.';
