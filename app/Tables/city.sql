CREATE TABLE IF NOT EXISTS app.booklet_color (
    booklet_color_id           SERIAL,
    booklet_color_name         TEXT NOT NULL,
    booklet_color_name_friendly TEXT NOT NULL,
    is_accessible              BOOLEAN NOT NULL DEFAULT FALSE,
    sort_order                 SMALLINT NOT NULL DEFAULT 0,
    active                     BOOLEAN NOT NULL DEFAULT TRUE,
    created_by                 TEXT NOT NULL,
    created_on                 TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    modified_by                TEXT,
    modified_on                TIMESTAMPTZ,
    -- Constraints
    CONSTRAINT pk_booklet_color_id PRIMARY KEY (booklet_color_id),
    CONSTRAINT uq_booklet_color_name UNIQUE (booklet_color_name),
    CONSTRAINT uq_booklet_color_name_friendly UNIQUE (booklet_color_name_friendly)
);
