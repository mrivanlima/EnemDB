CREATE TABLE app.question (
    question_id            SERIAL,
    exam_year              INTEGER NOT NULL,
    booklet_color          TEXT NOT NULL,
    question_position      INTEGER NOT NULL,
    subject_area           TEXT NOT NULL,
    skill_code             TEXT NOT NULL,
    difficulty_tri         NUMERIC,
    thematic_area          TEXT,
    question_text          TEXT NOT NULL,
    image_url              TEXT,
    notes                  TEXT,
    created_by             INTEGER NOT NULL,
    created_on             TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    modified_by            INTEGER,
    modified_on            TIMESTAMPTZ,
    is_active              BOOLEAN NOT NULL DEFAULT TRUE,
    source_pdf_page        INTEGER,
    original_enem_code     TEXT,

    -- Constraints (all named)
    CONSTRAINT pk_question_id PRIMARY KEY (question_id),
    CONSTRAINT uq_question_per_booklet UNIQUE (exam_year, booklet_color, question_position),
    CONSTRAINT fk_question_created_by FOREIGN KEY (created_by) REFERENCES app.user_login(user_login_id),
    CONSTRAINT fk_question_modified_by FOREIGN KEY (modified_by) REFERENCES app.user_login(user_login_id)
);

-- Table comment
COMMENT ON TABLE app.question IS 'Stores ENEM questions, their metadata, and position within each exam/booklet.';

-- Field comments (one-liners)
COMMENT ON COLUMN app.question.question_id IS 'Primary key.';
COMMENT ON COLUMN app.question.exam_year IS 'Year the exam was administered (e.g., 2024).';
COMMENT ON COLUMN app.question.booklet_color IS 'Booklet color version (e.g., Azul, Amarelo).';
COMMENT ON COLUMN app.question.question_position IS 'Order/position of the question in the test booklet.';
COMMENT ON COLUMN app.question.subject_area IS 'Subject area (e.g., Linguagens, Matemática, etc.).';
COMMENT ON COLUMN app.question.skill_code IS 'Skill code or competency reference as published by ENEM.';
COMMENT ON COLUMN app.question.difficulty_tri IS 'TRI-based difficulty score for the question.';
COMMENT ON COLUMN app.question.thematic_area IS 'Theme or subtopic of the question.';
COMMENT ON COLUMN app.question.question_text IS 'The full text of the question as presented on the exam.';
COMMENT ON COLUMN app.question.image_url IS 'URL to an associated image, if applicable.';
COMMENT ON COLUMN app.question.notes IS 'Free-form notes, comments, or tags.';
COMMENT ON COLUMN app.question.created_by IS 'FK to app.user_login; user who created the record.';
COMMENT ON COLUMN app.question.created_on IS 'Timestamp when the record was created.';
COMMENT ON COLUMN app.question.modified_by IS 'FK to app.user_login; user who last modified the record.';
COMMENT ON COLUMN app.question.modified_on IS 'Timestamp of the last modification.';
COMMENT ON COLUMN app.question.is_active IS 'Soft delete/archive flag.';
COMMENT ON COLUMN app.question.source_pdf_page IS 'Original PDF page number from the ENEM booklet.';
COMMENT ON COLUMN app.question.original_enem_code IS 'Official ENEM item code from microdados, if available.';


