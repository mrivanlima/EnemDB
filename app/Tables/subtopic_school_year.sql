CREATE TABLE IF NOT EXISTS app.subtopic_school_year (
    subtopic_id        INTEGER NOT NULL,
    school_year_id     INTEGER NOT NULL,
    created_by         INTEGER NOT NULL,
    created_on         TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    modified_by        INTEGER,
    modified_on        TIMESTAMPTZ,

    -- Constraints
    CONSTRAINT pk_subtopic_school_year PRIMARY KEY (subtopic_id, school_year_id),
    CONSTRAINT fk_ssy_subtopic_id FOREIGN KEY (subtopic_id) REFERENCES app.subtopic(subtopic_id) ON DELETE CASCADE,
    CONSTRAINT fk_ssy_school_year_id FOREIGN KEY (school_year_id) REFERENCES app.school_year(school_year_id) ON DELETE CASCADE,
    CONSTRAINT fk_ssy_created_by FOREIGN KEY (created_by) REFERENCES app.user_login(user_login_id),
    CONSTRAINT fk_ssy_modified_by FOREIGN KEY (modified_by) REFERENCES app.user_login(user_login_id)
);

-- Table comment
COMMENT ON TABLE app.subtopic_school_year IS 'Associates subtopics with school years (grades), supporting auditing. Enables each subtopic to be linked to multiple years, and each year to multiple subtopics.';

-- Field comments
COMMENT ON COLUMN app.subtopic_school_year.subtopic_id IS 'FK to app.subtopic; identifies the subtopic.';
COMMENT ON COLUMN app.subtopic_school_year.school_year_id IS 'FK to app.school_year; identifies the school year/grade.';
COMMENT ON COLUMN app.subtopic_school_year.created_by IS 'FK to app.user_login; user who created this record.';
COMMENT ON COLUMN app.subtopic_school_year.created_on IS 'Timestamp of record creation.';
COMMENT ON COLUMN app.subtopic_school_year.modified_by IS 'FK to app.user_login; user who last modified this record.';
COMMENT ON COLUMN app.subtopic_school_year.modified_on IS 'Timestamp of the most recent modification.';
