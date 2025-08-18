-- drop the old normal view if it exists
drop materialized view if exists app.vw_student_result;

-- create materialized view
create materialized view app.vw_student_result as
select 
    sr.student_result_id,
    sr.subscription_no,
    sr.published_degree,
    unaccent(sr.published_degree) as published_degree_unaccent,
    sr.student_name,
    sr.quota,
    sr.student_score,
    sr.cutoff_score,
    sr.classification,
    sr.year,
    sr.year_id,

    -- university
    u.university_id,
    upper(u.university_name) as university_name,
    upper(u.university_name_friendly) as university_name_friendly,
    upper(u.university_abbr) as university_abbr,

    -- campus
    ca.campus_id,
    upper(ca.campus_name) as campus_name,
    upper(ca.campus_name_friendly) as campus_name_friendly,

    -- shift
    s.shift_id,
    upper(s.shift_name) as shift_name,
    upper(s.shift_name_friendly) as shift_name_friendly,

    -- degree
    upper(d.degree_name) as degree_name,
    upper(d.degree_name_friendly) as degree_name_friendly,

    -- quota type
    qt.quota_type_id,
    upper(qt.quota_type_code) as quota_type_code,

    -- special quota
    sq.special_quota_id,
    sq.special_quota_desc_short,
    coalesce(sq.special_quota_desc_pt, qt.quota_type_desc_pt) as quota_desc,

    coalesce(sq.is_deaf, qt.is_deaf)                               as is_deaf,
    coalesce(sq.public_high_school, qt.public_high_school)         as public_high_school,
    coalesce(sq.is_black, qt.is_black)                             as is_black,
    coalesce(sq.is_native, qt.is_native)                           as is_native,
    coalesce(sq.one_salary, qt.one_salary)                         as one_salary,
    coalesce(sq.one_half_salary, qt.one_half_salary)               as one_half_salary,
    coalesce(sq.is_quilombola, qt.is_quilombola)                   as is_quilombola,
    coalesce(sq.is_disabled, qt.is_disabled)                       as is_disabled,
    coalesce(sq.is_trans, qt.is_trans)                             as is_trans,
    coalesce(sq.is_refugee, qt.is_refugee)                         as is_refugee,
    coalesce(sq.is_ampla_concorrencia, qt.is_ampla_concorrencia)   as is_ampla_concorrencia,
    coalesce(sq.economic_vulnerable, qt.economic_vulnerable)       as economic_vulnerable,
    coalesce(sq.is_child_dead_public_servant, qt.is_child_dead_public_servant) as is_child_dead_public_servant,
    coalesce(sq.is_public_teacher, qt.is_public_teacher)           as is_public_teacher,
    coalesce(sq.is_agriculture_school, qt.is_agriculture_school)   as is_agriculture_school,
    coalesce(sq.is_agro_reform, qt.is_agro_reform)                 as is_agro_reform,
    coalesce(sq.is_cigano, qt.is_cigano)                           as is_cigano,
    coalesce(sq.is_prisoner, qt.is_prisoner)                       as is_prisoner,
    coalesce(sq.is_paraiba, qt.is_paraiba)                         as is_paraiba,
    coalesce(sq.is_rural_productor, qt.is_rural_productor)         as is_rural_productor,
    coalesce(sq.is_4_salaries, qt.is_4_salaries)                   as is_4_salaries,
    coalesce(sq.is_efa, qt.is_efa)                                 as is_efa
from app.student_result sr
join app.university   u  on u.university_id   = sr.university_id
join app.campus       ca on ca.campus_id      = sr.campus_id
join app.shift        s  on s.shift_id        = sr.shift_id
join app.degree       d  on d.degree_id       = sr.degree_id
join app.quota_type   qt on qt.quota_type_id  = sr.quota_type_id
left join app.special_quota sq on sq.special_quota_id = sr.special_quota_id
with no data;

-- indexes for fast lookup on mv columns
create unique index if not exists ux_vw_student_result_id
    on app.vw_student_result (student_result_id);

create index if not exists ix_vw_student_result_published_degree
    on app.vw_student_result (published_degree_unaccent);

create index if not exists ix_vw_student_result_student_name
    on app.vw_student_result (student_name);

create index if not exists ix_vw_student_result_degree_name_friendly
    on app.vw_student_result (degree_name_friendly);

-- initial populate (non-concurrent; run once after create)

-- (optional) later you can do a concurrent refresh:
--refresh materialized view concurrently app.vw_student_result;
