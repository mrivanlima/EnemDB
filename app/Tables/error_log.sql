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
