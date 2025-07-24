CREATE TABLE IF NOT EXISTS app.user_role (
    user_role_id    SERIAL,
    user_login_id   INTEGER NOT NULL,
    role_id         INTEGER NOT NULL,
    created_by      INTEGER NOT NULL,
    created_on      TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    modified_by     INTEGER,
    modified_on     TIMESTAMPTZ,

    -- Constraints (all named)
    CONSTRAINT pk_user_role_id PRIMARY KEY (user_role_id),
    CONSTRAINT fk_user_role_user_login FOREIGN KEY (user_login_id) REFERENCES app.user_login(user_login_id) ON DELETE CASCADE,
    CONSTRAINT fk_user_role_role_id FOREIGN KEY (role_id) REFERENCES app.role(role_id) ON DELETE CASCADE,
    CONSTRAINT fk_user_role_created_by FOREIGN KEY (created_by) REFERENCES app.user_login(user_login_id),
    CONSTRAINT fk_user_role_modified_by FOREIGN KEY (modified_by) REFERENCES app.user_login(user_login_id),
    CONSTRAINT uq_user_role UNIQUE (user_login_id, role_id)
);

COMMENT ON TABLE app.user_role IS 'Associates users with roles, including assignment and audit metadata.';

COMMENT ON COLUMN app.user_role.user_role_id IS 'Primary key.';
COMMENT ON COLUMN app.user_role.user_login_id IS 'FK to app.user_login (user receiving the role).';
COMMENT ON COLUMN app.user_role.role_id IS 'FK to app.role (assigned role).';
COMMENT ON COLUMN app.user_role.created_by IS 'FK to app.user_login (creator of this record).';
COMMENT ON COLUMN app.user_role.created_on IS 'Timestamp when this record was created.';
COMMENT ON COLUMN app.user_role.modified_by IS 'FK to app.user_login (last modifier).';
COMMENT ON COLUMN app.user_role.modified_on IS 'Timestamp of last modification.';

