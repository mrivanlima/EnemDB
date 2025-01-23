CREATE TABLE app.error_log (
    error_log_id bigserial,
    error_on timestamp with time zone default current_timestamp,
    error_message text,
    error_code varchar(100),
    error_line text,
    error_process varchar(100) NULL,
    constraint pk_error_log primary key (error_log_id)
);