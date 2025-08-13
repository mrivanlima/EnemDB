DROP TABLE IF EXISTS app.test_version;
CREATE TABLE app.test_version (
    test_version_id  SERIAL,
    test_code        TEXT         NOT NULL,   -- e.g., 'P1'
    created_by       INTEGER      NOT NULL,
    created_on       TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    modified_by      INTEGER,
    modified_on      TIMESTAMPTZ,

    -- Constraints (all named)
    CONSTRAINT pk_test_version_id        PRIMARY KEY (test_version_id),
    CONSTRAINT uq_test_version_code      UNIQUE (test_code),

    -- Foreign keys
    CONSTRAINT fk_test_version_created_by  FOREIGN KEY (created_by)  REFERENCES app.user_login(user_login_id),
    CONSTRAINT fk_test_version_modified_by FOREIGN KEY (modified_by) REFERENCES app.user_login(user_login_id)

    -- Optional format guard (enable if you want only 'P#' patterns):
    -- ,CONSTRAINT ck_test_version_code_fmt CHECK (test_code ~ '^P[0-9]+$')
);

-- Table comment
COMMENT ON TABLE app.test_version IS 'Stores ENEM test versions (e.g., P1, P2) with audit metadata.';

-- Column comments
COMMENT ON COLUMN app.test_version.test_version_id IS 'Primary key.';
COMMENT ON COLUMN app.test_version.test_code       IS 'Short code for the test version (e.g., P1).';
COMMENT ON COLUMN app.test_version.created_by      IS 'FK to app.user_login; user who created the record.';
COMMENT ON COLUMN app.test_version.created_on      IS 'Timestamp when the record was created.';
COMMENT ON COLUMN app.test_version.modified_by     IS 'FK to app.user_login; user who last modified the record.';
COMMENT ON COLUMN app.test_version.modified_on     IS 'Timestamp of the last modification.';
