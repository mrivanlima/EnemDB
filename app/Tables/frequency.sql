CREATE TABLE IF NOT EXISTS app.frequency (
    frequency_id               SERIAL,
    frequency_name             TEXT NOT NULL,
    frequency_name_friendly    TEXT NOT NULL,
    created_by                 TEXT NOT NULL,
    created_on                 TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    modified_by                TEXT,
    modified_on                TIMESTAMPTZ,
    -- Constraints
    CONSTRAINT pk_frequency_id PRIMARY KEY (frequency_id),
    CONSTRAINT uq_frequency_name UNIQUE (frequency_name),
    CONSTRAINT uq_frequency_name_friendly UNIQUE (frequency_name_friendly)
);
