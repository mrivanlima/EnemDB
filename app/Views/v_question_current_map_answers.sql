CREATE OR REPLACE VIEW app.v_question_current_map_answers AS

select 
   qc.question_current_id,
   sa.student_id,
   sa.year_id,
   sa.test_version_id,
   sa.booklet_color_id,
   sa.question_number,
   sa.selected_option,
   qc.correct_answer,
   sa.language_id,
   qc.area_id,
   CASE WHEN TRIM(sa.selected_option) = TRIM(qc.correct_answer) THEN 1 ELSE 0 END AS is_correct,
   5 as alternatives

from app.student_answer sa
	join app.booklet_color bc
		on bc.booklet_color_id = sa.booklet_color_id
		and bc.booklet_color_name = 'AZUL'
	join app.question_current qc
	   on qc.question_position = sa.question_number
	   and COALESCE(qc.language_id,0) = COALESCE(sa.language_id,0)
	   and qc.test_version_id = sa.test_version_id

union

select 
   qc.question_current_id,
   sa.student_id,
   sa.year_id,
   sa.test_version_id,
   sa.booklet_color_id,
   sa.question_number,
   sa.selected_option,
   qc.correct_answer,
   sa.language_id,
   qc.area_id,
   CASE WHEN TRIM(sa.selected_option) = TRIM(qc.correct_answer) THEN 1 ELSE 0 END AS is_correct,
   5 as alternatives
from app.student_answer sa
	join app.booklet_color bc
		on bc.booklet_color_id = sa.booklet_color_id
		and bc.booklet_color_name <> 'AZUL'
	join app.question_map qm
		on qm.booklet_color_id = sa.booklet_color_id 
		and COALESCE(qm.language_id,0) = COALESCE(sa.language_id,0)
		and qm.test_version_id = sa.test_version_id
	    and qm.number_in_variant = sa.question_number
		and qm.year_id = sa.year_id
	join app.question_current qc
	   on qc.question_position = qm.number_in_variant
	   and COALESCE(qc.language_id,0) = COALESCE(sa.language_id,0)
	   and qc.test_version_id = sa.test_version_id
