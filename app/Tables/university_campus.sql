CREATE TABLE IF NOT EXISTS app.university_campus (
    university_campus_id              SERIAL,
    university_campus_name            TEXT NOT NULL,
    university_campus_name_friendly   TEXT NOT NULL,
    created_by                        TEXT NOT NULL,
    created_on                        TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    modified_by                       TEXT,
    modified_on                       TIMESTAMPTZ,
    -- Constraints
    CONSTRAINT pk_university_campus_id PRIMARY KEY (university_campus_id),
    CONSTRAINT uq_university_campus_name UNIQUE (university_campus_name),
    CONSTRAINT uq_university_campus_name_friendly UNIQUE (university_campus_name_friendly)
);
