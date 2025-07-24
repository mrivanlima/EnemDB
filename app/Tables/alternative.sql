CREATE TABLE IF NOT EXISTS app.alternative (
    alternative_id           SERIAL,
    question_id              INTEGER NOT NULL,
    option_letter            CHAR(1) NOT NULL,
    option_text              VARCHAR(40) NOT NULL,
    option_text_friendly     VARCHAR(40),
    is_correct               BOOLEAN NOT NULL,
    image_url                VARCHAR(40),
    notes                    VARCHAR(40),
    notes_friendly           VARCHAR(40),
    created_by               INTEGER NOT NULL,
    created_on               TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    modified_by              INTEGER,
    modified_on              TIMESTAMPTZ,
    is_active                BOOLEAN NOT NULL,

    -- Constraints (all named)
    CONSTRAINT pk_alternative_id PRIMARY KEY (alternative_id),
    CONSTRAINT fk_alternative_question_id FOREIGN KEY (question_id) REFERENCES app.question (question_id) ON DELETE CASCADE,
    CONSTRAINT fk_alternative_created_by FOREIGN KEY (created_by) REFERENCES app.user_login(user_login_id),
    CONSTRAINT fk_alternative_modified_by FOREIGN KEY (modified_by) REFERENCES app.user_login(user_login_id),
    CONSTRAINT uq_alternative_per_question UNIQUE (question_id, option_letter)
);

-- Table comment
COMMENT ON TABLE app.alternative IS 'Stores alternatives (options) for each ENEM question, with friendly columns for search.';

-- Field comments
COMMENT ON COLUMN app.alternative.alternative_id IS 'Primary key.';
COMMENT ON COLUMN app.alternative.question_id IS 'FK to app.question (question_id).';
COMMENT ON COLUMN app.alternative.option_letter IS 'Option label (A, B, C, D, E).';
COMMENT ON COLUMN app.alternative.option_text IS 'Official text of the alternative.';
COMMENT ON COLUMN app.alternative.option_text_friendly IS 'Normalized option text for search.';
COMMENT ON COLUMN app.alternative.is_correct IS 'TRUE if this is the correct answer.';
COMMENT ON COLUMN app.alternative.image_url IS 'URL for associated image (if any).';
COMMENT ON COLUMN app.alternative.notes IS 'Notes or comments about the alternative.';
COMMENT ON COLUMN app.alternative.notes_friendly IS 'Normalized notes for search.';
COMMENT ON COLUMN app.alternative.created_by IS 'FK to app.user_login; record creator.';
COMMENT ON COLUMN app.alternative.created_on IS 'Creation timestamp.';
COMMENT ON COLUMN app.alternative.modified_by IS 'FK to app.user_login; last modifier.';
COMMENT ON COLUMN app.alternative.modified_on IS 'Modification timestamp.';
COMMENT ON COLUMN app.alternative.is_active IS 'Active/archive flag.';
