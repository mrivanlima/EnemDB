CREATE TABLE IF NOT EXISTS app.university_category (
    university_category_id             SERIAL,
    university_category_name           VARCHAR(255) NOT NULL,
    university_category_name_friendly  VARCHAR(255) NOT NULL,
    created_by                         INTEGER NOT NULL,
    created_on                         TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    modified_by                        INTEGER,
    modified_on                        TIMESTAMPTZ,

    -- Constraints
    CONSTRAINT pk_university_category_id PRIMARY KEY (university_category_id),
    CONSTRAINT uq_university_category_name UNIQUE (university_category_name),
    CONSTRAINT uq_university_category_name_friendly UNIQUE (university_category_name_friendly),
    CONSTRAINT fk_university_category_created_by FOREIGN KEY (created_by) REFERENCES app.user_login(user_login_id),
    CONSTRAINT fk_university_category_modified_by FOREIGN KEY (modified_by) REFERENCES app.user_login(user_login_id)
);

-- Table comment
COMMENT ON TABLE app.university_category IS 'Defines categories/types of universities with friendly names and audit fields.';

-- Field comments (one-liners)
COMMENT ON COLUMN app.university_category.university_category_id IS 'Primary key.';
COMMENT ON COLUMN app.university_category.university_category_name IS 'Official name of the university category (unique).';
COMMENT ON COLUMN app.university_category.university_category_name_friendly IS 'User-friendly display name for the university category (unique).';
COMMENT ON COLUMN app.university_category.created_by IS 'FK to app.user_login; user who created this record.';
COMMENT ON COLUMN app.university_category.created_on IS 'Timestamp when the record was created.';
COMMENT ON COLUMN app.university_category.modified_by IS 'FK to app.user_login; user who last modified this record.';
COMMENT ON COLUMN app.university_category.modified_on IS 'Timestamp of the most recent modification.';
