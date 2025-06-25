CREATE TABLE IF NOT EXISTS app.degree (
    degree_id               SERIAL,
    degree_name             TEXT NOT NULL,
    degree_name_friendly    TEXT NOT NULL,
    created_by              TEXT NOT NULL,
    created_on              TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    modified_by             TEXT,
    modified_on             TIMESTAMPTZ,
    -- Constraints
    CONSTRAINT pk_degree_id PRIMARY KEY (degree_id),
    CONSTRAINT uq_degree_name UNIQUE (degree_name),
    CONSTRAINT uq_degree_name_friendly UNIQUE (degree_name_friendly)
);
