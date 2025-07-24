CREATE TABLE IF NOT EXISTS app.role (
    role_id             SERIAL,
    role_name           VARCHAR(100) NOT NULL,
    role_name_friendly  VARCHAR(100) NOT NULL,
    description         TEXT,
    created_by          INTEGER NOT NULL,
    created_on          TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    modified_by         INTEGER,
    modified_on         TIMESTAMPTZ,
    is_active           BOOLEAN NOT NULL DEFAULT TRUE,

    -- Constraints (all named)
    CONSTRAINT pk_role_id PRIMARY KEY (role_id),
    CONSTRAINT uq_role_name UNIQUE (role_name),
    CONSTRAINT fk_role_created_by FOREIGN KEY (created_by) REFERENCES app.user_login(user_login_id),
    CONSTRAINT fk_role_modified_by FOREIGN KEY (modified_by) REFERENCES app.user_login(user_login_id)
);

-- Table comment
COMMENT ON TABLE app.role IS 'Defines user roles for access control and permissions.';

-- Column comments
COMMENT ON COLUMN app.role.role_id IS 'Primary key.';
COMMENT ON COLUMN app.role.role_name IS 'Unique name of the role (e.g., Admin, Student).';
COMMENT ON COLUMN app.role.role_name_friendly IS 'Unaccented version for search purposes.';
COMMENT ON COLUMN app.role.description IS 'Optional description or purpose of the role.';
COMMENT ON COLUMN app.role.created_by IS 'FK to app.user_login who created this role.';
COMMENT ON COLUMN app.role.created_on IS 'Timestamp of creation.';
COMMENT ON COLUMN app.role.modified_by IS 'FK to app.user_login who last modified this role.';
COMMENT ON COLUMN app.role.modified_on IS 'Timestamp of last modification.';
COMMENT ON COLUMN app.role.is_active IS 'Indicates whether the role is active.';

