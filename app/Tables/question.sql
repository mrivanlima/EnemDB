CREATE TABLE app.question (
    question_id         SERIAL,
    booklet_id          INTEGER         NOT NULL,
    language_id         SMALLINT NULL,
    question_position   SMALLINT, -- position within the booklet
    question_text       TEXT,
    alternative_text_a  TEXT,
    alternative_text_b  TEXT,
    alternative_text_c  TEXT,
    alternative_text_d  TEXT,
    alternative_text_e  TEXT,
    question_text_image  TEXT,
    alternative_text_a_image  VARCHAR(550),
    alternative_text_b_image  VARCHAR(550),
    alternative_text_c_image  VARCHAR(550),
    alternative_text_d_image  VARCHAR(550),
    alternative_text_e_image  VARCHAR(550),
    correct_answer      CHAR(1), -- should be A, B, C, D, E or x
    param_a             NUMERIC(10,5),
    param_b             NUMERIC(10,5),
    param_c             NUMERIC(10,5),
    notes               TEXT,
    created_by          INTEGER         NOT NULL,
    created_on          TIMESTAMPTZ     NOT NULL DEFAULT NOW(),
    modified_by         INTEGER,
    modified_on         TIMESTAMPTZ,

    -- Constraints (all named)
    CONSTRAINT pk_question_id               PRIMARY KEY (question_id),
    CONSTRAINT uq_question_per_booklet      UNIQUE (booklet_id, question_position, language_id),

    -- Foreign keys
    CONSTRAINT fk_question_booklet          FOREIGN KEY (booklet_id)  REFERENCES app.booklet(booklet_id),
    CONSTRAINT fk_question_language         FOREIGN KEY (language_id) REFERENCES app.language(language_id),
    CONSTRAINT fk_question_created_by       FOREIGN KEY (created_by)  REFERENCES app.user_login(user_login_id),
    CONSTRAINT fk_question_modified_by      FOREIGN KEY (modified_by) REFERENCES app.user_login(user_login_id)
);

-- Table comment
COMMENT ON TABLE app.question IS 'Stores ENEM questions, their metadata, and position within each exam/booklet.';

-- Column comments
COMMENT ON COLUMN app.question.question_id        IS 'Primary key.';
COMMENT ON COLUMN app.question.booklet_id         IS 'FK to app.booklet; the booklet/version this question belongs to.';
COMMENT ON COLUMN app.question.language_id        IS 'FK to app.language; language of the question text.';
COMMENT ON COLUMN app.question.question_position  IS 'Order/position of the question within the booklet (starting at 1).';
COMMENT ON COLUMN app.question.question_text      IS 'Full text of the question as presented in the exam.';
COMMENT ON COLUMN app.question.alternative_text_a IS 'Text for option A.';
COMMENT ON COLUMN app.question.alternative_text_b IS 'Text for option B.';
COMMENT ON COLUMN app.question.alternative_text_c IS 'Text for option C.';
COMMENT ON COLUMN app.question.alternative_text_d IS 'Text for option D.';
COMMENT ON COLUMN app.question.alternative_text_e IS 'Text for option E.';
COMMENT ON COLUMN app.question.correct_answer     IS 'Correct option (A–E).';
COMMENT ON COLUMN app.question.param_a            IS 'TRI parameter a (discrimination).';
COMMENT ON COLUMN app.question.param_b            IS 'TRI parameter b (difficulty).';
COMMENT ON COLUMN app.question.param_c            IS 'TRI parameter c (guessing).';
COMMENT ON COLUMN app.question.notes              IS 'Free-form notes, comments, or tags.';
COMMENT ON COLUMN app.question.created_by         IS 'FK to app.user_login; user who created the record.';
COMMENT ON COLUMN app.question.created_on         IS 'Timestamp when the record was created.';
COMMENT ON COLUMN app.question.modified_by        IS 'FK to app.user_login; user who last modified the record.';
COMMENT ON COLUMN app.question.modified_on        IS 'Timestamp of the last modification.';
