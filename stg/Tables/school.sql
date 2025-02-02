create table if not exists stg.school
(
    school_id smallserial,
	school_code text,
	school_name varchar(200),
    school_name_ascii varchar(200),
	school_abrv varchar(30),
	school_abrv_ascii varchar(30)
);