CREATE TABLE app.year (
    year_id              SERIAL,
    year                 SMALLINT NOT NULL,
    year_name            TEXT NOT NULL,
    year_name_friendly   TEXT NOT NULL,
    created_by           TEXT NOT NULL,
    created_on           TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    modified_by          TEXT,
    modified_on          TIMESTAMPTZ,

    -- Constraints (all named)
    CONSTRAINT pk_year_id PRIMARY KEY (year_id),
    CONSTRAINT uq_year UNIQUE (year),
    CONSTRAINT uq_year_name UNIQUE (year_name),
    CONSTRAINT uq_year_name_friendly UNIQUE (year_name_friendly)
);
