CREATE TABLE IF NOT EXISTS app.topic (
    topic_id               SERIAL,
    subject_id             INTEGER NOT NULL,
    topic_name             VARCHAR(50) NOT NULL,
    topic_name_friendly    VARCHAR(50) NOT NULL,
    created_by             INTEGER NOT NULL,
    created_on             TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    modified_by            INTEGER,
    modified_on            TIMESTAMPTZ,

    -- Constraints
    CONSTRAINT pk_topic_id PRIMARY KEY (topic_id),
    CONSTRAINT fk_topic_subject_id FOREIGN KEY (subject_id) REFERENCES app.subject(subject_id) ON DELETE CASCADE,
    CONSTRAINT uq_topic_subject_name UNIQUE (subject_id, topic_name),
    CONSTRAINT uq_topic_subject_name_friendly UNIQUE (subject_id, topic_name_friendly),
    CONSTRAINT fk_topic_created_by FOREIGN KEY (created_by) REFERENCES app.user_login(user_login_id),
    CONSTRAINT fk_topic_modified_by FOREIGN KEY (modified_by) REFERENCES app.user_login(user_login_id)
);

-- Table comment
COMMENT ON TABLE app.topic IS 'Represents a topic within a subject (e.g., Algebra in Mathematics), supporting friendly names and auditing.';

-- Field comments
COMMENT ON COLUMN app.topic.topic_id IS 'Primary key.';
COMMENT ON COLUMN app.topic.subject_id IS 'FK to app.subject; identifies the subject to which the topic belongs.';
COMMENT ON COLUMN app.topic.topic_name IS 'Official name of the topic (unique within subject).';
COMMENT ON COLUMN app.topic.topic_name_friendly IS 'User-friendly display name for the topic (unique within subject).';
COMMENT ON COLUMN app.topic.created_by IS 'FK to app.user_login; user who created this record.';
COMMENT ON COLUMN app.topic.created_on IS 'Timestamp of record creation.';
COMMENT ON COLUMN app.topic.modified_by IS 'FK to app.user_login; user who last modified this record.';
COMMENT ON COLUMN app.topic.modified_on IS 'Timestamp of the most recent modification.';
