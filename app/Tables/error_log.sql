-- CREATE TABLE app.error_log (
--     error_log_id bigserial,
--     error_on timestamp with time zone default current_timestamp,
--     error_message text,
--     error_code varchar(100),
--     error_line text,
--     error_process varchar(100) NULL,
--     constraint pk_error_log primary key (error_log_id)
-- );

CREATE TABLE app.error_log (
    error_log_id    SERIAL PRIMARY KEY,
    table_name      TEXT NOT NULL,
    process         TEXT NOT NULL,      -- The stored procedure or function name
    operation       TEXT NOT NULL,      -- INSERT, UPDATE, DELETE, etc.
    command         TEXT,               -- The SQL or procedure call that failed
    error_message   TEXT NOT NULL,      -- The error message/exception text
    error_code      TEXT,               -- Optional: error code (SQLSTATE, etc.)
    context_info    TEXT,               -- Optional: extra info as needed (JSON, etc.)
    user_name       TEXT,               -- Who ran it (can be null)
    created_on      TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Table comment
COMMENT ON TABLE app.error_log IS 'Logs errors or exceptions from database operations, with process, operation, SQL, error details, and context for auditing and troubleshooting.';

-- Field comments (one-liners)
COMMENT ON COLUMN app.error_log.error_log_id IS 'Primary key.';
COMMENT ON COLUMN app.error_log.table_name IS 'The table affected by the operation.';
COMMENT ON COLUMN app.error_log.process IS 'Name of the stored procedure or function where the error occurred.';
COMMENT ON COLUMN app.error_log.operation IS 'Type of database operation (INSERT, UPDATE, DELETE, etc.).';
COMMENT ON COLUMN app.error_log.command IS 'The SQL statement or procedure call that caused the error.';
COMMENT ON COLUMN app.error_log.error_message IS 'Detailed error message or exception text.';
COMMENT ON COLUMN app.error_log.error_code IS 'Optional: error code, e.g., SQLSTATE.';
COMMENT ON COLUMN app.error_log.context_info IS 'Optional: additional context or parameters, possibly as JSON.';
COMMENT ON COLUMN app.error_log.user_name IS 'Who executed the operation (nullable).';
COMMENT ON COLUMN app.error_log.created_on IS 'Timestamp when the error was logged.';

