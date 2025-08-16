CREATE TABLE app.question_current (
    question_current_id SERIAL,
    language_id         SMALLINT NULL,
    booklet_color_id    INT         NOT NULL,  -- FK to app.booklet_color
    test_version_id     INT         NOT NULL,  -- FK to app.test_version
    area_id             SMALLINT,      -- FK to app.area
    question_position   SMALLINT, 
    correct_answer      CHAR(1), -- should be A, B, C, D, E
    param_a             NUMERIC(10,5),
    param_b             NUMERIC(10,5),
    param_c             NUMERIC(10,5),
    notes               TEXT,
    created_by          INTEGER         NOT NULL,
    created_on          TIMESTAMPTZ     NOT NULL DEFAULT NOW(),
    modified_by         INTEGER,
    modified_on         TIMESTAMPTZ,

    -- Constraints (all named)
    CONSTRAINT pk_question_current_id               PRIMARY KEY (question_current_id),
    CONSTRAINT uq_question_per_booklet_color      UNIQUE (booklet_color_id, question_position, language_id, test_version_id),

    -- Foreign keys
    CONSTRAINT fk_question_current_booklet_color FOREIGN KEY (booklet_color_id)  REFERENCES app.booklet_color(booklet_color_id),
    CONSTRAINT fk_question_current_test_version FOREIGN KEY (test_version_id)  REFERENCES app.test_version(test_version_id),
    CONSTRAINT fk_question_language              FOREIGN KEY (language_id) REFERENCES app.language(language_id),
    CONSTRAINT fk_question_created_by            FOREIGN KEY (created_by)  REFERENCES app.user_login(user_login_id),
    CONSTRAINT fk_question_modified_by           FOREIGN KEY (modified_by) REFERENCES app.user_login(user_login_id),
    CONSTRAINT fk_question_area                  FOREIGN KEY (area_id) REFERENCES app.area(area_id)
);

-- Table comment
COMMENT ON TABLE app.question IS 'Stores ENEM questions, their metadata, and position within each exam/booklet.';

-- Column comments
COMMENT ON COLUMN app.question.question_id        IS 'Primary key.';
COMMENT ON COLUMN app.question.language_id        IS 'FK to app.language; language of the question text.';
COMMENT ON COLUMN app.question.question_position  IS 'Order/position of the question within the booklet (starting at 1).';
COMMENT ON COLUMN app.question.correct_answer     IS 'Correct option (A–E).';
COMMENT ON COLUMN app.question.param_a            IS 'TRI parameter a (discrimination).';
COMMENT ON COLUMN app.question.param_b            IS 'TRI parameter b (difficulty).';
COMMENT ON COLUMN app.question.param_c            IS 'TRI parameter c (guessing).';
COMMENT ON COLUMN app.question.notes              IS 'Free-form notes, comments, or tags.';
COMMENT ON COLUMN app.question.created_by         IS 'FK to app.user_login; user who created the record.';
COMMENT ON COLUMN app.question.created_on         IS 'Timestamp when the record was created.';
COMMENT ON COLUMN app.question.modified_by        IS 'FK to app.user_login; user who last modified the record.';
COMMENT ON COLUMN app.question.modified_on        IS 'Timestamp of the last modification.';
