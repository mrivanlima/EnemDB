CREATE TABLE IF NOT EXISTS app.university (
    university_id            SERIAL,
    university_code          INT NOT NULL,
    university_name          TEXT NOT NULL,
    university_abbr          TEXT NOT NULL,
    university_name_friendly TEXT NOT NULL,
    created_by               TEXT NOT NULL,
    created_on               TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    modified_by              TEXT,
    modified_on              TIMESTAMPTZ,
    -- Constraints (all named)
    CONSTRAINT pk_university_id PRIMARY KEY (university_id),
    CONSTRAINT uq_university_code UNIQUE (university_code),
    CONSTRAINT uq_university_name UNIQUE (university_name),
    CONSTRAINT uq_university_name_friendly UNIQUE (university_name_friendly)
);