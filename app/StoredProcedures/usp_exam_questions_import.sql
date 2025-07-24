create or replace procedure app.usp_exam_questions_import(
    p_year integer,
    out out_message text
)
language plpgsql
as $$
declare
    v_command text;
    v_error_message text;
    v_error_code text;
begin
    -- Begin main block
    begin
        drop table if exists temp_exam_questions;
        create temp table temp_exam_questions as
        select
            (q->>'number')::integer as question_number,
            replace(q->>'text', E'\n', ' ') as question_text,
            case
                when unaccent(lower(q->>'language')) = 'english' then 'ingles'
                when unaccent(lower(q->>'language')) = 'spanish' then 'espanhol'
                else null
            end as language_name,
            case
              when q->>'booklet' ilike '%blue%' then 'Azul'
              when q->>'booklet' ilike '%yellow%' then 'Amarelo'
              when q->>'booklet' ilike '%green%' then 'Verde'
              when q->>'booklet' ilike '%orange%' then 'Laranja'
              when q->>'booklet' ilike '%purple%' then 'Roxo'
              when q->>'booklet' ilike '%white%' then 'Branco'
              when q->>'booklet' ilike '%gray%' then 'Cinza'
                else null
            end as booklet_color,
            substring(q->>'booklet' from '_(\d+)\.pdf$')::integer as exam_day,
            substring(q->>'booklet' from '^(\d{4})_')::integer as exam_year,
            q->>'language' as lang
        from imp.exam_questions,
             jsonb_array_elements(questions) as q
        where year = p_year
          and q->>'booklet' ilike '%blue%';

        drop table if exists temp_exam_alternatives;
        create temp table temp_exam_alternatives as
        with letters as (
          select unnest(array['A','B','C','D','E']) as letter
        ),
        questions as (
          select
            q,
            case
              when unaccent(lower(q->>'language')) = 'english' then 'ingles'
              when unaccent(lower(q->>'language')) = 'spanish' then 'espanhol'
              else null
            end as language_name,
            (q->>'number')::integer as question_number,
            case
              when q->>'booklet' ilike '%blue%' then 'Azul'
              when q->>'booklet' ilike '%yellow%' then 'Amarelo'
              when q->>'booklet' ilike '%green%' then 'Verde'
              when q->>'booklet' ilike '%orange%' then 'Laranja'
              when q->>'booklet' ilike '%purple%' then 'Roxo'
              when q->>'booklet' ilike '%white%' then 'Branco'
              when q->>'booklet' ilike '%gray%' then 'Cinza'
              else null
            end as booklet_color,
            substring(q->>'booklet' from '_(\d+)\.pdf$')::integer as exam_day,
            substring(q->>'booklet' from '^(\d{4})_')::integer as exam_year
          from imp.exam_alternatives,
               jsonb_array_elements(alternatives) as q
          where q->>'booklet' ilike '%blue%'
        )
        select
          questions.language_name,
          questions.question_number,
          letters.letter as alternative_letter,
          coalesce(alt->>'text_cleaned', null) as alternative_text,
          questions.booklet_color,
          questions.exam_day,
          questions.exam_year
        from questions
        cross join letters
        left join lateral (
          select alt
          from jsonb_array_elements(questions.q->'alternatives') as alt
          where alt->>'letter' = letters.letter
          limit 1
        ) alt on true
        order by questions.question_number, letters.letter;

        insert into app.exam_question (
            question_number,
            question_text,
            language_id,
            alternative_a,
            alternative_b,
            alternative_c,
            alternative_d,
            alternative_e,
            booklet_color_id,
            exam_day_id,
            exam_year_id,
            created_by,
            created_on
        )
        select
            eq.question_number,
            eq.question_text,
            l.language_id,
            max(case when ea.alternative_letter = 'A' then ea.alternative_text end) as alternative_a,
            max(case when ea.alternative_letter = 'B' then ea.alternative_text end) as alternative_b,
            max(case when ea.alternative_letter = 'C' then ea.alternative_text end) as alternative_c,
            max(case when ea.alternative_letter = 'D' then ea.alternative_text end) as alternative_d,
            max(case when ea.alternative_letter = 'E' then ea.alternative_text end) as alternative_e,
            bc.booklet_color_id,
            ed.exam_day_id,
            ey.exam_year_id,
            1 as created_by,
            now() as created_on
        from temp_exam_questions eq
        join temp_exam_alternatives ea
            on eq.question_number = ea.question_number
            and eq.booklet_color = ea.booklet_color
            and eq.exam_day = ea.exam_day
            and eq.exam_year = ea.exam_year
        left join app.booklet_color bc
            on bc.booklet_color_name = eq.booklet_color
        left join app.exam_day ed
            on ed.exam_day_id = eq.exam_day
        left join app.exam_year ey
            on ey.year_name = eq.exam_year
        left join app.language l
            on l.language_name_friendly = eq.language_name
        group by
            eq.question_number,
            eq.question_text,
            l.language_id,
            bc.booklet_color_id,
            ed.exam_day_id,
            ey.exam_year_id
        order by bc.booklet_color_id, eq.question_number;

        out_message := 'Import completed successfully';
        return;
    exception
        when others then
            v_command := format('call app.sp_import_exam_questions(%s, out_message)', p_year);
            v_error_message := sqlerrm;
            v_error_code := sqlstate;
            insert into app.error_log (
                table_name,
                process,
                operation,
                command,
                error_message,
                error_code,
                user_name
            ) values (
                'exam_questions',
                'app.sp_import_exam_questions',
                'INSERT',
                v_command,
                v_error_message,
                v_error_code,
                current_user
            );
            out_message := format('Error during import: %s', v_error_message);
            return;
    end;
    drop table if exists temp_exam_questions;
    drop table if exists temp_exam_alternatives;
end;
$$;
