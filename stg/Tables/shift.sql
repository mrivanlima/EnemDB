create table if not exists stg.shift
(
    shift_id smallserial,
    shift_name varchar(100),
    shift_name_ascii varchar(100)
);