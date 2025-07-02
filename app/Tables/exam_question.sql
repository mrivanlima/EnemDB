CREATE TABLE IF NOT EXISTS app.exam_question (
    exam_question_id         SERIAL,
    question_number          INTEGER NOT NULL,
    question_text            TEXT NOT NULL,
    image_path               TEXT,
    alternative_a            TEXT NOT NULL,
    alternative_b            TEXT NOT NULL,
    alternative_c            TEXT NOT NULL,
    alternative_d            TEXT NOT NULL,
    alternative_e            TEXT NOT NULL,
    correct_alternative      CHAR(1),
    area_id                  INTEGER,
    booklet_color_id         INTEGER NOT NULL,
    exam_day_id              INTEGER NOT NULL,
    exam_year_id             INTEGER NOT NULL,
    subtopic_id              INTEGER,
    subject_id               INTEGER,
    topic_id                 INTEGER,
    created_by               INTEGER NOT NULL,
    created_on               TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    modified_by              INTEGER,
    modified_on              TIMESTAMPTZ,

    -- Constraints
    CONSTRAINT pk_exam_question_id PRIMARY KEY (exam_question_id),
    CONSTRAINT uq_exam_question_unique UNIQUE (question_number, exam_booklet_color_id, exam_day_id, exam_year_id),
    CONSTRAINT fk_exam_question_area_id FOREIGN KEY (area_id) REFERENCES app.area(area_id),
    CONSTRAINT fk_exam_question_booklet_color_id FOREIGN KEY (booklet_color_id) REFERENCES app.booklet_color(booklet_color_id),
    CONSTRAINT fk_exam_question_exam_day_id FOREIGN KEY (exam_day_id) REFERENCES app.exam_day(exam_day_id),
    CONSTRAINT fk_exam_question_exam_year_id FOREIGN KEY (exam_year_id) REFERENCES app.exam_year(exam_year_id),
    CONSTRAINT fk_exam_question_subject_id FOREIGN KEY (subject_id) REFERENCES app.subject(subject_id),
    CONSTRAINT fk_exam_question_topic_id FOREIGN KEY (topic_id) REFERENCES app.topic(topic_id),
    CONSTRAINT fk_exam_question_subtopic_id FOREIGN KEY (subtopic_id) REFERENCES app.subtopic(subtopic_id),
    CONSTRAINT fk_exam_question_created_by FOREIGN KEY (created_by) REFERENCES app.user_login(user_login_id),
    CONSTRAINT fk_exam_question_modified_by FOREIGN KEY (modified_by) REFERENCES app.user_login(user_login_id)
);

-- Table comment
COMMENT ON TABLE app.exam_question IS 'Stores ENEM exam questions, including references to color, day, year, area, subject, topic, subtopic, and auditing.';

-- Field comments
COMMENT ON COLUMN app.exam_question.exam_question_id IS 'Primary key.';
COMMENT ON COLUMN app.exam_question.question_number IS 'Number of the question in the exam.';
COMMENT ON COLUMN app.exam_question.question_text IS 'Full text/enunciation of the question.';
COMMENT ON COLUMN app.exam_question.image_path IS 'Filesystem path or URL to associated question image.';
COMMENT ON COLUMN app.exam_question.alternative_a IS 'Text of alternative A.';
COMMENT ON COLUMN app.exam_question.alternative_b IS 'Text of alternative B.';
COMMENT ON COLUMN app.exam_question.alternative_c IS 'Text of alternative C.';
COMMENT ON COLUMN app.exam_question.alternative_d IS 'Text of alternative D.';
COMMENT ON COLUMN app.exam_question.alternative_e IS 'Text of alternative E.';
COMMENT ON COLUMN app.exam_question.correct_alternative IS 'Correct alternative for the question (A-E).';
COMMENT ON COLUMN app.exam_question.area_id IS 'FK to app.area; the high-level ENEM exam area for the question.';
COMMENT ON COLUMN app.exam_question.booklet_color_id IS 'FK to app.exam_booklet_color; identifies the exam booklet color.';
COMMENT ON COLUMN app.exam_question.exam_day_id IS 'FK to app.exam_day; identifies the exam day.';
COMMENT ON COLUMN app.exam_question.exam_year_id IS 'FK to app.exam_year; identifies the exam year.';
COMMENT ON COLUMN app.exam_question.subject_id IS 'FK to app.subject; identifies the subject for the question.';
COMMENT ON COLUMN app.exam_question.topic_id IS 'FK to app.topic; identifies the topic for the question.';
COMMENT ON COLUMN app.exam_question.subtopic_id IS 'FK to app.subtopic; identifies the subtopic for the question.';
COMMENT ON COLUMN app.exam_question.created_by IS 'FK to app.user_login; user who created this record.';
COMMENT ON COLUMN app.exam_question.created_on IS 'Timestamp of record creation.';
COMMENT ON COLUMN app.exam_question.modified_by IS 'FK to app.user_login; user who last modified this record.';
COMMENT ON COLUMN app.exam_question.modified_on IS 'Timestamp of the most recent modification.';
