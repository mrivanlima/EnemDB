CREATE TABLE IF NOT EXISTS app.shift (
    shift_id                SERIAL,
    shift_name              TEXT NOT NULL,
    shift_name_friendly     TEXT NOT NULL,
    created_by              TEXT NOT NULL,
    created_on              TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    modified_by             TEXT,
    modified_on             TIMESTAMPTZ,
    -- Constraints
    CONSTRAINT pk_shift_id PRIMARY KEY (shift_id),
    CONSTRAINT uq_shift_name UNIQUE (shift_name),
    CONSTRAINT uq_shift_name_friendly UNIQUE (shift_name_friendly)
);
