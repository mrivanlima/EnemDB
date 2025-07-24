CREATE TABLE IF NOT EXISTS app.booklet_mapping (
    booklet_mapping_id    SERIAL,
    year_id               INTEGER NOT NULL,
    exam_day_id           INT NOT NULL,
    booklet_color_id      INTEGER NOT NULL,
    language_id           INTEGER, 
    base_question_no      INTEGER NOT NULL,
    booklet_question_no   INTEGER NOT NULL,
    created_by            INTEGER NOT NULL,
    created_on            TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    modified_by           INTEGER,
    modified_on           TIMESTAMPTZ,

    -- Constraints
    CONSTRAINT pk_booklet_mapping_id PRIMARY KEY (booklet_mapping_id),
    CONSTRAINT FK_booklet_mapping_language_id FOREIGN KEY (language_id) REFERENCES app.language(language_id),
    CONSTRAINT fk_booklet_mapping_year_id FOREIGN KEY (year_id) REFERENCES app.year(year_id),
    CONSTRAINT fk_booklet_mapping_exam_day_id FOREIGN KEY (exam_day_id) REFERENCES app.exam_day(exam_day_id),
    CONSTRAINT fk_booklet_mapping_booklet_color_id FOREIGN KEY (booklet_color_id) REFERENCES app.booklet_color(booklet_color_id),
    CONSTRAINT fk_booklet_mapping_created_by FOREIGN KEY (created_by) REFERENCES app.user_login(user_login_id),
    CONSTRAINT fk_booklet_mapping_modified_by FOREIGN KEY (modified_by) REFERENCES app.user_login(user_login_id),
    CONSTRAINT uq_booklet_mapping UNIQUE (year_id, exam_day_id, booklet_color_id, base_question_no, language_id)
);

-- Table comment
COMMENT ON TABLE app.booklet_mapping IS 'Maps each base question number to its position in each colored exam booklet, for each year and exam day.';

-- Field comments (one-liners)
COMMENT ON COLUMN app.booklet_mapping.booklet_mapping_id IS 'Primary key.';
COMMENT ON COLUMN app.booklet_mapping.year_id IS 'FK to app.year; identifies the exam year.';
COMMENT ON COLUMN app.booklet_mapping.exam_day_id IS 'Exam day number (e.g., 1 for first day, 2 for second).';
COMMENT ON COLUMN app.booklet_mapping.booklet_color_id IS 'FK to app.booklet_color; identifies the booklet color/version.';
COMMENT ON COLUMN app.booklet_mapping.base_question_no IS 'Canonical (base) question number as per master list.';
COMMENT ON COLUMN app.booklet_mapping.booklet_question_no IS 'Question number as printed in this booklet color/version.';
COMMENT ON COLUMN app.booklet_mapping.created_by IS 'FK to app.user_login; who created this booklet mapping record.';
COMMENT ON COLUMN app.booklet_mapping.created_on IS 'Timestamp when the booklet mapping record was created.';
COMMENT ON COLUMN app.booklet_mapping.modified_by IS 'FK to app.user_login; who last modified this booklet mapping record.';
COMMENT ON COLUMN app.booklet_mapping.modified_on IS 'Timestamp of the most recent modification.';

