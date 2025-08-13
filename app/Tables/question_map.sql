CREATE TABLE app.question_map (
    question_map_id     SERIAL,
    booklet_color_id    INT         NOT NULL,  -- FK to app.booklet_color
    number_in_base      SMALLINT    NOT NULL,
    number_in_variant   SMALLINT    NOT NULL,
    language_id         SMALLINT    NULL,      -- FK to app.language
    year_id             INT         NOT NULL,  -- FK to app.year
    test_version_id     INT         NOT NULL,  -- FK to app.test_version
    created_by          INT         NOT NULL,  -- FK to app.user_login
    created_on          TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    modified_by         INT,
    modified_on         TIMESTAMPTZ,

    -- Constraints (all named)
    CONSTRAINT pk_question_map_id PRIMARY KEY (question_map_id),
    CONSTRAINT uq_question_map UNIQUE (
        booklet_color_id,
        number_in_base,
        number_in_variant,
        language_id,
        year_id,
        test_version_id
    ),

    -- Foreign keys
    CONSTRAINT fk_question_map_booklet_color FOREIGN KEY (booklet_color_id)
        REFERENCES app.booklet_color (booklet_color_id),
    CONSTRAINT fk_question_map_language FOREIGN KEY (language_id)
        REFERENCES app.language (language_id),
    CONSTRAINT fk_question_map_year FOREIGN KEY (year_id)
        REFERENCES app.year (year_id),
    CONSTRAINT fk_question_map_test_version FOREIGN KEY (test_version_id)
        REFERENCES app.test_version (test_version_id),
    CONSTRAINT fk_question_map_created_by FOREIGN KEY (created_by)
        REFERENCES app.user_login (user_login_id),
    CONSTRAINT fk_question_map_modified_by FOREIGN KEY (modified_by)
        REFERENCES app.user_login (user_login_id)
);

-- Table comment
COMMENT ON TABLE app.question_map IS
'Maps questions from a base color to variant booklets by color, question numbers, language, year, and test version.';

-- Column comments
COMMENT ON COLUMN app.question_map.booklet_color_id IS 'FK to app.booklet_color; color of the variant booklet.';
COMMENT ON COLUMN app.question_map.number_in_base IS 'Question number in the base (reference) booklet.';
COMMENT ON COLUMN app.question_map.number_in_variant IS 'Question number in the variant booklet.';
COMMENT ON COLUMN app.question_map.language_id IS 'FK to app.language; language of the question.';
COMMENT ON COLUMN app.question_map.year_id IS 'FK to app.year; year of the exam.';
COMMENT ON COLUMN app.question_map.test_version_id IS 'FK to app.test_version; identifies the version (e.g., P1, P2).';
COMMENT ON COLUMN app.question_map.created_by IS 'FK to app.user_login; user who created the record.';
COMMENT ON COLUMN app.question_map.created_on IS 'Timestamp when the record was created.';
COMMENT ON COLUMN app.question_map.modified_by IS 'FK to app.user_login; user who last modified the record.';
COMMENT ON COLUMN app.question_map.modified_on IS 'Timestamp of the last modification.';
