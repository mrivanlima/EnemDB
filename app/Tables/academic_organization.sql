CREATE TABLE IF NOT EXISTS app.academic_organization (
    academic_organization_id           SERIAL,
    academic_organization_name         TEXT NOT NULL,
    academic_organization_name_friendly TEXT NOT NULL,
    created_by                         TEXT NOT NULL,
    created_on                         TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    modified_by                        TEXT,
    modified_on                        TIMESTAMPTZ,
    -- Constraints
    CONSTRAINT pk_academic_organization_id PRIMARY KEY (academic_organization_id),
    CONSTRAINT uq_academic_organization_name UNIQUE (academic_organization_name),
    CONSTRAINT uq_academic_organization_name_friendly UNIQUE (academic_organization_name_friendly)
);