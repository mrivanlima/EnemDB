CREATE TABLE IF NOT EXISTS app.subtopic (
    subtopic_id               SERIAL,
    topic_id                  INTEGER NOT NULL,
    subtopic_name             TEXT NOT NULL,
    subtopic_name_friendly    TEXT NOT NULL,
    created_by                INTEGER NOT NULL,
    created_on                TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    modified_by               INTEGER,
    modified_on               TIMESTAMPTZ,

    -- Constraints
    CONSTRAINT pk_subtopic_id PRIMARY KEY (subtopic_id),
    CONSTRAINT fk_subtopic_topic_id FOREIGN KEY (topic_id) REFERENCES app.topic(topic_id) ON DELETE CASCADE,
    CONSTRAINT uq_subtopic_topic_name UNIQUE (topic_id, subtopic_name),
    CONSTRAINT uq_subtopic_topic_name_friendly UNIQUE (topic_id, subtopic_name_friendly),
    CONSTRAINT fk_subtopic_created_by FOREIGN KEY (created_by) REFERENCES app.user_login(user_login_id),
    CONSTRAINT fk_subtopic_modified_by FOREIGN KEY (modified_by) REFERENCES app.user_login(user_login_id)
);

-- Table comment
COMMENT ON TABLE app.subtopic IS 'Represents a subtopic within a topic (e.g., Logarithms in Algebra), supporting friendly names and auditing.';

-- Field comments
COMMENT ON COLUMN app.subtopic.subtopic_id IS 'Primary key.';
COMMENT ON COLUMN app.subtopic.topic_id IS 'FK to app.topic; identifies the topic to which the subtopic belongs.';
COMMENT ON COLUMN app.subtopic.subtopic_name IS 'Official name of the subtopic (unique within topic).';
COMMENT ON COLUMN app.subtopic.subtopic_name_friendly IS 'User-friendly display name for the subtopic (unique within topic).';
COMMENT ON COLUMN app.subtopic.created_by IS 'FK to app.user_login; user who created this record.';
COMMENT ON COLUMN app.subtopic.created_on IS 'Timestamp of record creation.';
COMMENT ON COLUMN app.subtopic.modified_by IS 'FK to app.user_login; user who last modified this record.';
COMMENT ON COLUMN app.subtopic.modified_on IS 'Timestamp of the most recent modification.';
