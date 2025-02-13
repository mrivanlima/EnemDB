create table if not exists stg.course
(
    course_id smallserial,
    course_code text,
	course_name varchar(500),
    course_name_ascii varchar(500)
);