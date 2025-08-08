CREATE TABLE app.booklet_color (
    booklet_color_id             SERIAL,
    booklet_color_name           VARCHAR(50) NOT NULL,
    booklet_color_name_friendly  VARCHAR(50) NOT NULL,
    is_accessible                BOOLEAN NOT NULL DEFAULT FALSE,
    sort_order                   SMALLINT NOT NULL DEFAULT 0,
    active                       BOOLEAN NOT NULL DEFAULT TRUE,
    created_by                   INTEGER NOT NULL,
    created_on                   TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    modified_by                  INTEGER,
    modified_on                  TIMESTAMPTZ,

    -- Constraints
    CONSTRAINT pk_booklet_color_id PRIMARY KEY (booklet_color_id),
    CONSTRAINT uq_booklet_color_name UNIQUE (booklet_color_name),
    CONSTRAINT uq_booklet_color_name_friendly UNIQUE (booklet_color_name_friendly),
    CONSTRAINT fk_booklet_color_created_by FOREIGN KEY (created_by) REFERENCES app.user_login(user_login_id),
    CONSTRAINT fk_booklet_color_modified_by FOREIGN KEY (modified_by) REFERENCES app.user_login(user_login_id)
);

-- Table comment
COMMENT ON TABLE app.booklet_color IS 'Defines available exam booklet colors, their friendly display names, accessibility, sort order, and active status.';

-- Field comments (one-liners)
COMMENT ON COLUMN app.booklet_color.booklet_color_id IS 'Primary key.';
COMMENT ON COLUMN app.booklet_color.booklet_color_name IS 'Official name of the booklet color, unique.';
COMMENT ON COLUMN app.booklet_color.booklet_color_name_friendly IS 'User-friendly or display name for the booklet color, unique.';
COMMENT ON COLUMN app.booklet_color.is_accessible IS 'TRUE if this booklet is designed for accessibility needs.';
COMMENT ON COLUMN app.booklet_color.sort_order IS 'Integer for sorting/display order (lowest value first).';
COMMENT ON COLUMN app.booklet_color.active IS 'TRUE if this booklet color is currently in use.';
COMMENT ON COLUMN app.booklet_color.created_by IS 'FK to app.user_login; who created this booklet color record.';
COMMENT ON COLUMN app.booklet_color.created_on IS 'Timestamp when the booklet color record was created.';
COMMENT ON COLUMN app.booklet_color.modified_by IS 'FK to app.user_login; who last modified this booklet color record.';
COMMENT ON COLUMN app.booklet_color.modified_on IS 'Timestamp of the most recent modification.';
