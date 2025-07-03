--CALL app.usp_exam_questions_import(2024, NULL);

drop table if exists temp_exam_questions;
create temp table temp_exam_questions as
SELECT
	eq.exam_id,
	eq.year::integer,
	eq.color,
	case
		when unaccent(lower(q->>'language')) = 'english' then 'ingles'
		when unaccent(lower(q->>'language')) = 'spanish' then 'espanhol'
		else null
	end as language_name_friendly,
	case
		when q->>'booklet' ilike '%blue%' then 'Azul'
		when q->>'booklet' ilike '%yellow%' then 'Amarelo'
		when q->>'booklet' ilike '%green%' then 'Verde'
		when q->>'booklet' ilike '%orange%' then 'Laranja'
		when q->>'booklet' ilike '%purple%' then 'Roxo'
		when q->>'booklet' ilike '%white%' then 'Branco'
		when q->>'booklet' ilike '%gray%' then 'Cinza'
		else null
	end as booklet_color_name,
	q ->> 'language'    AS language,
	q ->> 'text'        AS question_text,
	(q->>'number')::integer as booklet_question_no,
	substring(q->>'booklet' from '_(\d+)\.pdf$')::integer as exam_day,
    substring(q->>'booklet' from '^(\d{4})_')::integer as exam_year
	/*q_json -> 'number'      AS booklet_question_no,
	q_json ->> 'booklet'     AS booklet_file,
	q_json ->> 'text'        AS question_text,
	q_json ->> 'full_text'   AS question_full_text,
	q_json ->> 'language'    AS language,
	q_json ->> 'available'   AS available*/
FROM imp.exam_questions eq
JOIN LATERAL jsonb_array_elements(eq.questions) AS q ON TRUE;

select 
y.year_id,
ed.exam_day_id,
bc.booklet_color_id,
l.language_id,
eq.question_number as base_question_no,
e.booklet_question_no
from temp_exam_questions e
	join app.exam_question eq
		on eq.question_text = e.question_text
	join app.exam_day ed
		ON ed.exam_day_id = e.exam_day
	join app.booklet_color bc
		on bc.booklet_color_name = e.booklet_color_name
	join app.year y
		on y.year = e.exam_year
	left JOIN app.Language l
		on l.language_name_friendly = e.language_name_friendly
where e.booklet_color_name <> 'Azul'


INSERT INTO app.booklet_mapping (
    year_id,
    exam_day_id,
    booklet_color_id,
    language_id,
    base_question_no,
    booklet_question_no,
    created_by
)
SELECT
    y.year_id,
    ed.exam_day_id,
    bc.booklet_color_id,
    l.language_id,
    eq.question_number as base_question_no,
    e.booklet_question_no,
    1   -- Replace 1 with the actual user_login_id for created_by
FROM temp_exam_questions e
JOIN app.exam_question eq
    ON eq.question_text = e.question_text
JOIN app.exam_day ed
    ON ed.exam_day_id = e.exam_day
JOIN app.booklet_color bc
    ON bc.booklet_color_name = e.booklet_color_name
JOIN app.year y
    ON y.year = e.exam_year
LEFT JOIN app.language l
    ON l.language_name_friendly = e.language_name_friendly
WHERE e.booklet_color_name <> 'Azul';

select
eq.question_number,
bm.booklet_question_no

from app.booklet_mapping bm
	join app.exam_question eq
	 	on bm.base_question_no = eq.question_number
		 and bm.year_id = eq.exam_year_id
		 AND bm.exam_day_id = eq.exam_day_id
		 and coalesce(bm.language_id, 0) = coalesce(eq.language_id, 0)
	join app.booklet_color bc
		on bc.booklet_color_id = bm.booklet_color_id
		and bc.booklet_color_name_friendly = 'Amarelo'
order by 1

select * from app.booklet_color bc


