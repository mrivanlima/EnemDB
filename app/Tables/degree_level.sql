CREATE TABLE IF NOT EXISTS app.degree_level (
    degree_level_id               SERIAL,
    degree_level_name             TEXT NOT NULL,
    degree_level_name_friendly    TEXT NOT NULL,
    created_by                    TEXT NOT NULL,
    created_on                    TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    modified_by                   TEXT,
    modified_on                   TIMESTAMPTZ,
    -- Constraints
    CONSTRAINT pk_degree_level_id PRIMARY KEY (degree_level_id),
    CONSTRAINT uq_degree_level_name UNIQUE (degree_level_name),
    CONSTRAINT uq_degree_level_name_friendly UNIQUE (degree_level_name_friendly)
);
