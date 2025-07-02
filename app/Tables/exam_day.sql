CREATE TABLE IF NOT EXISTS app.exam_day (
    exam_day_id           SERIAL,
    day_name              TEXT NOT NULL,
    day_name_friendly     TEXT NOT NULL,
    created_by            INTEGER NOT NULL,
    created_on            TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    modified_by           INTEGER,
    modified_on           TIMESTAMPTZ,

    -- Constraints
    CONSTRAINT pk_exam_day_id PRIMARY KEY (exam_day_id),
    CONSTRAINT uq_day_name UNIQUE (day_name),
    CONSTRAINT uq_day_name_friendly UNIQUE (day_name_friendly),
    CONSTRAINT fk_exam_day_created_by FOREIGN KEY (created_by) REFERENCES app.user_login(user_login_id),
    CONSTRAINT fk_exam_day_modified_by FOREIGN KEY (modified_by) REFERENCES app.user_login(user_login_id)
);

-- Table comment
COMMENT ON TABLE app.exam_day IS 'Represents the day of the ENEM exam (e.g., First day, Second day), supporting friendly names and auditing.';

-- Field comments
COMMENT ON COLUMN app.exam_day.exam_day_id IS 'Primary key.';
COMMENT ON COLUMN app.exam_day.day_name IS 'Official name of the exam day (unique).';
COMMENT ON COLUMN app.exam_day.day_name_friendly IS 'User-friendly display name for the exam day (unique).';
COMMENT ON COLUMN app.exam_day.created_by IS 'FK to app.user_login; user who created this record.';
COMMENT ON COLUMN app.exam_day.created_on IS 'Timestamp of record creation.';
COMMENT ON COLUMN app.exam_day.modified_by IS 'FK to app.user_login; user who last modified this record.';
COMMENT ON COLUMN app.exam_day.modified_on IS 'Timestamp of the most recent modification.';
