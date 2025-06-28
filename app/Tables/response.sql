CREATE TABLE app.response (
    response_id           SERIAL,
    exam_attempt_id       INTEGER NOT NULL,
    account_id            INTEGER NOT NULL,
    question_id           INTEGER NOT NULL,
    alternative_id        INTEGER NOT NULL,
    is_correct            BOOLEAN NOT NULL,
    flag_for_review       BOOLEAN NOT NULL DEFAULT FALSE,
    notes                 TEXT,
    notes_friendly        TEXT,
    created_by            TEXT NOT NULL,
    created_on            TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    modified_by           TEXT,
    modified_on           TIMESTAMPTZ,
    is_active             BOOLEAN NOT NULL DEFAULT TRUE,

    -- Constraints (all named)
    CONSTRAINT pk_response_id PRIMARY KEY (response_id),
    CONSTRAINT fk_response_exam_attempt_id FOREIGN KEY (exam_attempt_id) REFERENCES app.exam_attempt (exam_attempt_id) ON DELETE CASCADE,
    CONSTRAINT fk_response_account_id FOREIGN KEY (account_id) REFERENCES app.account (account_id) ON DELETE CASCADE,
    CONSTRAINT fk_response_question_id FOREIGN KEY (question_id) REFERENCES app.question (question_id) ON DELETE CASCADE,
    CONSTRAINT fk_response_alternative_id FOREIGN KEY (alternative_id) REFERENCES app.alternative (alternative_id) ON DELETE CASCADE,
    CONSTRAINT uq_response_per_attempt UNIQUE (exam_attempt_id, question_id)
);

-- Table comment
COMMENT ON TABLE app.response IS 'Stores user answers for each question and attempt, with review flag, notes, and audit fields.';

-- Field comments (one-liners)
COMMENT ON COLUMN app.response.response_id IS 'Primary key.';
COMMENT ON COLUMN app.response.exam_attempt_id IS 'FK to exam attempt grouping responses.';
COMMENT ON COLUMN app.response.account_id IS 'FK to user account.';
COMMENT ON COLUMN app.response.question_id IS 'FK to app.question.';
COMMENT ON COLUMN app.response.alternative_id IS 'FK to selected app.alternative.';
COMMENT ON COLUMN app.response.is_correct IS 'TRUE if the selected answer was correct.';
COMMENT ON COLUMN app.response.flag_for_review IS 'TRUE if user flagged this question for review.';
COMMENT ON COLUMN app.response.notes IS 'Notes or comments for this response.';
COMMENT ON COLUMN app.response.notes_friendly IS 'Normalized notes for search.';
COMMENT ON COLUMN app.response.created_by IS 'Record creator.';
COMMENT ON COLUMN app.response.created_on IS 'Creation timestamp.';
COMMENT ON COLUMN app.response.modified_by IS 'Last modifier.';
COMMENT ON COLUMN app.response.modified_on IS 'Modification timestamp.';
COMMENT ON COLUMN app.response.is_active IS 'Active/archive flag.';
