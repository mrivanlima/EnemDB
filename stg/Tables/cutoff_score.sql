create table if not exists stg.campus
(
    campus_id smallserial,
    school_code text,
	campus_name varchar(200),
    campus_name_ascii varchar(200),
    campus_municipality_name varchar(200),
    campus_municipality_name_ascii varchar(200),
	campus_abrv varchar(30),
	campus_abrv_ascii varchar(30),
    campus_region varchar(200),
    campus_region_ascii varchar(200)
);