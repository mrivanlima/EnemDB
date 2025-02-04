create table if not exists imp.campus_mapping
(
    campus_id smallserial,
    campus_code text,
    campus_name_imp text,
    campus_name_corrected text,
    campus_name_ascii text,
    campus_municipality_name_imp text,
    campus_municipality_name_corrected text,
    campus_municipality_name_ascii text,
    campus_abrv_imp text,
    campus_abrv_corrected text,
    campus_abrv_ascii text,
    campus_region_imp text,
    campus_region_corrected text,
    campus_region_ascii text
);