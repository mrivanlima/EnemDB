CREATE TABLE app.booklet_color (
    booklet_color_code   VARCHAR(20),
    display_name         TEXT NOT NULL,
    is_accessible        BOOLEAN DEFAULT FALSE,
    sort_order           SMALLINT DEFAULT 0,
    active               BOOLEAN DEFAULT TRUE,

    -- Constraints
    CONSTRAINT pk_booklet_color PRIMARY KEY (booklet_color_code)
);
