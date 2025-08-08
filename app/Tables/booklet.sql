DROP TABLE IF EXISTS app.booklet CASCADE;
CREATE TABLE app.booklet (
    booklet_id            SERIAL,
    booklet_name          VARCHAR(255) NOT NULL,
    booklet_code          INTEGER NOT NULL,
    year_id               INTEGER NOT NULL,
    area_id               INTEGER NOT NULL,
    exam_day_id           INTEGER NOT NULL,
    booklet_color_id      SMALLINT NOT NULL,
    created_by            INTEGER NOT NULL,
    created_on            TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    modified_by           INTEGER,
    modified_on           TIMESTAMPTZ,

    -- Constraints
    CONSTRAINT pk_booklet_id PRIMARY KEY (booklet_id),
    CONSTRAINT fk_booklet_year_id         FOREIGN KEY (year_id) REFERENCES app.year(year_id),
    CONSTRAINT fk_booklet_area_id         FOREIGN KEY (area_id) REFERENCES app.area(area_id),
    CONSTRAINT fk_booklet_exam_day_id     FOREIGN KEY (exam_day_id) REFERENCES app.exam_day(exam_day_id),
    CONSTRAINT fk_booklet_color_id        FOREIGN KEY (booklet_color_id) REFERENCES app.booklet_color(booklet_color_id),
    CONSTRAINT fk_booklet_created_by      FOREIGN KEY (created_by) REFERENCES app.user_login(user_login_id),
    CONSTRAINT fk_booklet_modified_by     FOREIGN KEY (modified_by) REFERENCES app.user_login(user_login_id)
);

-- Table comment
COMMENT ON TABLE app.booklet IS 'Represents a specific exam booklet, defined by color, exam year, area, and exam day.';

-- Field comments
COMMENT ON COLUMN app.booklet.booklet_id IS 'Primary key.';
COMMENT ON COLUMN app.booklet.booklet_name IS 'Descriptive name of the booklet version.';
COMMENT ON COLUMN app.booklet.booklet_code IS 'Code used to identify the specific version of the booklet.';
COMMENT ON COLUMN app.booklet.year_id IS 'FK to app.year; identifies the exam year.';
COMMENT ON COLUMN app.booklet.area_id IS 'FK to app.area; identifies the subject area of the exam.';
COMMENT ON COLUMN app.booklet.exam_day_id IS 'FK to app.exam_day; identifies the exam day.';
COMMENT ON COLUMN app.booklet.booklet_color_id IS 'FK to app.booklet_color; identifies the booklet color/version.';
COMMENT ON COLUMN app.booklet.created_by IS 'FK to app.user_login; user who created the record.';
COMMENT ON COLUMN app.booklet.created_on IS 'Timestamp when the record was created.';
COMMENT ON COLUMN app.booklet.modified_by IS 'FK to app.user_login; user who last modified the record.';
COMMENT ON COLUMN app.booklet.modified_on IS 'Timestamp when the record was last modified.';
