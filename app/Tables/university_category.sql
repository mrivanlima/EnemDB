CREATE TABLE IF NOT EXISTS app.university_category (
    university_category_id             SERIAL,
    university_category_name           TEXT NOT NULL,
    university_category_name_friendly  TEXT NOT NULL,
    created_by                         TEXT NOT NULL,
    created_on                         TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    modified_by                        TEXT,
    modified_on                        TIMESTAMPTZ,
    -- Constraints
    CONSTRAINT pk_university_category_id PRIMARY KEY (university_category_id),
    CONSTRAINT uq_university_category_name UNIQUE (university_category_name),
    CONSTRAINT uq_university_category_name_friendly UNIQUE (university_category_name_friendly)
);
