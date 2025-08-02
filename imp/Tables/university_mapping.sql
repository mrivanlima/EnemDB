drop table if exists imp.university_mapping;
create table imp.university_mapping (
    university_original_name             VARCHAR(255) NOT NULL,
    university_mapped_name               VARCHAR(255) NOT NULL
);