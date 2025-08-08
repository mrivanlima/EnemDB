CREATE OR REPLACE VIEW app.v_seats_scores AS
SELECT 
    y.year,
    y.year_id,
    u.university_name,
    u.university_abbr,
    u.university_name_friendly,
    u.university_id,
    ao.academic_organization_name,
    ao.academic_organization_name_friendly,
    ao.academic_organization_id,
    uc.university_category_name,
    uc.university_category_name_friendly,
    uc.university_category_id,
    c.campus_name,
    c.campus_name_friendly,
    c.campus_id,
    st.state_name,
    st.state_name_friendly,
    st.state_abbr,
    st.state_id,
    ci.city_name,
    ci.city_name_friendly,
    ci.city_id,
    r.region_name,
    r.region_name_friendly,
    r.region_id,
    d.degree_name,
    d.degree_name_friendly,
    d.degree_id,
    dl.degree_level_name,
    dl.degree_level_name_friendly,
    dl.degree_level_id,
    sh.shift_name,
    sh.shift_name_friendly,
    f.frequency_name,
    f.frequency_name_friendly,
    f.frequency_id,

    COALESCE(sq.special_quota_desc_pt, qt.quota_type_desc_pt) AS quota_type_desc_pt,
    qt.quota_type_code,
    COALESCE(sq.special_quota_desc_short, qt.quota_type_desc_short_pt) AS quota_type_desc_short_pt,
    COALESCE(sq.quota_explain, qt.quota_explain) AS quota_explain,

    COALESCE(sq.is_deaf, qt.is_deaf) AS is_deaf,
    COALESCE(sq.public_high_school, qt.public_high_school) AS public_high_school,
    COALESCE(sq.is_black, qt.is_black) AS is_black,
    COALESCE(sq.is_native, qt.is_native) AS is_native,
    COALESCE(sq.one_salary, qt.one_salary) AS one_salary,
    COALESCE(sq.one_half_salary, qt.one_half_salary) AS one_half_salary,
    COALESCE(sq.is_quilombola, qt.is_quilombola) AS is_quilombola,
    COALESCE(sq.is_disabled, qt.is_disabled) AS is_disabled,
    COALESCE(sq.is_trans, qt.is_trans) AS is_trans,
    COALESCE(sq.is_refugee, qt.is_refugee) AS is_refugee,
    COALESCE(sq.is_ampla_concorrencia, qt.is_ampla_concorrencia) AS is_ampla_concorrencia,
    COALESCE(sq.economic_vulnerable, qt.economic_vulnerable) AS economic_vulnerable,
    COALESCE(sq.is_child_dead_public_servant, qt.is_child_dead_public_servant) AS is_child_dead_public_servant,
    COALESCE(sq.is_public_teacher, qt.is_public_teacher) AS is_public_teacher,
    COALESCE(sq.is_agriculture_school, qt.is_agriculture_school) AS is_agriculture_school,
    COALESCE(sq.is_agro_reform, qt.is_agro_reform) AS is_agro_reform,
    COALESCE(sq.is_cigano, qt.is_cigano) AS is_cigano,
    COALESCE(sq.is_prisoner, qt.is_prisoner) AS is_prisoner,
    COALESCE(sq.is_paraiba, qt.is_paraiba) AS is_paraiba,
    COALESCE(sq.is_rural_productor, qt.is_rural_productor) AS is_rural_productor,
    COALESCE(sq.is_4_salaries, qt.is_4_salaries) AS is_4_salaries,
    COALESCE(sq.is_efa, qt.is_efa) AS is_efa,

    qt.quota_type_id,
    sq.special_quota_id,

    s.semester_number,
    s.seats_authorized,
    s.seats_offered,
    s.score_bonus_percent,
    s.weight_essay,
    s.min_score_essay,
    s.weight_language,
    s.min_score_language,
    s.weight_math,
    s.min_score_math,
    s.weight_sciences,
    s.min_score_sciences,
    s.weight_humanities,
    s.min_score_humanities,
    s.weight_nature_science,
    s.min_score_nature_science,
    s.min_enem_score,
    s.cutoff_score,
    s.num_students,
    s.num_students::NUMERIC / NULLIF(s.seats_offered, 0) AS num_students_ratio


FROM app.seats s
JOIN app.year y
    ON y.year_id = s.year_id
JOIN app.university u
    ON u.university_id = s.university_id
JOIN app.academic_organization ao
    ON ao.academic_organization_id = s.academic_organization_id
JOIN app.university_category uc
    ON uc.university_category_id = s.university_category_id
JOIN app.campus c
    ON c.campus_id = s.campus_id
JOIN app.state st
    ON st.state_id = s.state_id
JOIN app.city ci
    ON ci.city_id = s.city_id
JOIN app.region r
    ON r.region_id = s.region_id
JOIN app.degree d
    ON d.degree_id = s.degree_id
JOIN app.degree_level dl
    ON dl.degree_level_id = s.degree_level_id
JOIN app.shift sh
    ON sh.shift_id = s.shift_id
JOIN app.frequency f
    ON f.frequency_id = s.frequency_id
JOIN app.quota_type qt
    ON qt.quota_type_id = s.quota_type_id
LEFT JOIN app.special_quota sq
    ON sq.special_quota_id = s.special_quota_id;
