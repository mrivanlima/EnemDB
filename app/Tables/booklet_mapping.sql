CREATE TABLE IF NOT EXISTS app.booklet_mapping (
    booklet_mapping_id     SERIAL,
    year_id               INTEGER NOT NULL,
    exam_day              SMALLINT NOT NULL,
    booklet_color_id      INTEGER NOT NULL,
    base_question_no      INTEGER NOT NULL,
    booklet_question_no   INTEGER NOT NULL,
    created_by            TEXT NOT NULL,
    created_on            TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    modified_by           TEXT,
    modified_on           TIMESTAMPTZ,
    -- Constraints
    CONSTRAINT pk_booklet_mapping_id PRIMARY KEY (booklet_mapping_id),
    CONSTRAINT fk_booklet_mapping_year_id FOREIGN KEY (year_id) REFERENCES app.year(year_id),
    CONSTRAINT fk_booklet_mapping_booklet_color_id FOREIGN KEY (booklet_color_id) REFERENCES app.booklet_color(booklet_color_id),
    CONSTRAINT uq_booklet_mapping UNIQUE (year_id, exam_day, booklet_color_id, base_question_no)
);
