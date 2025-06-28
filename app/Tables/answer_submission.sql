CREATE TABLE IF NOT EXISTS app.answer_submission (
    answer_submission_id      SERIAL,
    user_id                  INTEGER NOT NULL,
    year_id                  INTEGER NOT NULL,
    exam_day                 SMALLINT NOT NULL,
    booklet_color_id         INTEGER NOT NULL,
    foreign_language         TEXT NOT NULL,
    raw_answers              TEXT NOT NULL,
    mapped_answers           TEXT,           -- Now nullable!
    created_by               TEXT NOT NULL,
    created_on               TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    modified_by              TEXT,
    modified_on              TIMESTAMPTZ,
    -- Constraints
    CONSTRAINT pk_answer_submission_id PRIMARY KEY (answer_submission_id),
    --CONSTRAINT fk_answer_submission_user_id FOREIGN KEY (user_id) REFERENCES app.account(user_id),
    CONSTRAINT fk_answer_submission_year_id FOREIGN KEY (year_id) REFERENCES app.year(year_id),
    CONSTRAINT fk_answer_submission_booklet_color_id FOREIGN KEY (booklet_color_id) REFERENCES app.booklet_color(booklet_color_id),
    CONSTRAINT uq_answer_submission_user_year_day UNIQUE (user_id, year_id, exam_day)
);
