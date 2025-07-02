CREATE TABLE IF NOT EXISTS app.exam_booklet_color (
    exam_booklet_color_id       SERIAL,
    color_name                  TEXT NOT NULL,
    color_name_friendly         TEXT NOT NULL,
    created_by                  INTEGER NOT NULL,
    created_on                  TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    modified_by                 INTEGER,
    modified_on                 TIMESTAMPTZ,

    -- Constraints
    CONSTRAINT pk_exam_booklet_color_id PRIMARY KEY (exam_booklet_color_id),
    CONSTRAINT uq_color_name UNIQUE (color_name),
    CONSTRAINT uq_color_name_friendly UNIQUE (color_name_friendly),
    CONSTRAINT fk_exam_booklet_color_created_by FOREIGN KEY (created_by) REFERENCES app.user_login(user_login_id),
    CONSTRAINT fk_exam_booklet_color_modified_by FOREIGN KEY (modified_by) REFERENCES app.user_login(user_login_id)
);

-- Table comment
COMMENT ON TABLE app.exam_booklet_color IS 'Represents the color of the ENEM exam booklet (e.g., Blue, Yellow), with support for friendly names and auditing.';

-- Field comments
COMMENT ON COLUMN app.exam_booklet_color.exam_booklet_color_id IS 'Primary key.';
COMMENT ON COLUMN app.exam_booklet_color.color_name IS 'Official color name (unique).';
COMMENT ON COLUMN app.exam_booklet_color.color_name_friendly IS 'User-friendly display name for the exam color (unique).';
COMMENT ON COLUMN app.exam_booklet_color.created_by IS 'FK to app.user_login; user who created this record.';
COMMENT ON COLUMN app.exam_booklet_color.created_on IS 'Timestamp of record creation.';
COMMENT ON COLUMN app.exam_booklet_color.modified_by IS 'FK to app.user_login; user who last modified this record.';
COMMENT ON COLUMN app.exam_booklet_color.modified_on IS 'Timestamp of the most recent modification.';
