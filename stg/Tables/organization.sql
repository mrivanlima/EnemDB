create table if not exists stg.organization
(
    organization_id smallserial,
	academic_organization_description varchar(100),
    academic_organization_description_ascii varchar(100)
);