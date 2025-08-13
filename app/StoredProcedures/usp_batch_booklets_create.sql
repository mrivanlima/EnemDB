CREATE OR REPLACE PROCEDURE app.usp_batch_booklets_create (
    IN p_year TEXT,
    IN p_prova TEXT,
    IN p_caderno TEXT,
    IN p_cor TEXT,
    IN p_created_by INT,
    OUT out_message TEXT
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_booklet_name TEXT;
    v_exam_code INT;
    v_area_code TEXT;
    v_year_id INT;
    v_area_id INT;
    v_exam_day_id INT;
    v_booklet_color_id SMALLINT;
    v_dia TEXT;
BEGIN
    -- Cria tabela temporária com questões divergentes
    DROP TABLE IF EXISTS temp_odd_answer_questions;
    CREATE TEMP TABLE temp_odd_answer_questions AS
    WITH answer_counts AS (
        SELECT
            question_position,
            answer_key,
            COUNT(*) AS cnt
        FROM imp.enem_question_parameter
        WHERE is_adapted_question = 0
          AND exam_color = p_cor
          AND question_position > 5
        GROUP BY question_position, answer_key
    ),
    multiple_answers AS (
        SELECT question_position
        FROM answer_counts
        GROUP BY question_position
        HAVING COUNT(*) > 1
    ),
    odd_answers AS (
        SELECT ac.question_position, ac.answer_key
        FROM answer_counts ac
        JOIN multiple_answers ma ON ac.question_position = ma.question_position
        WHERE ac.cnt = 1
    )
    SELECT DISTINCT q.exam_code, q.exam_color, q.subject_area
    FROM imp.enem_question_parameter q
    JOIN odd_answers o 
      ON q.question_position = o.question_position
     AND q.answer_key = o.answer_key
    WHERE q.exam_color = p_cor
      AND q.question_position > 5;

    -- Busca year_id
    SELECT year_id INTO v_year_id
    FROM app.year
    WHERE year = p_year::INT;

    IF NOT FOUND THEN
        out_message := 'Ano não encontrado.';
        RETURN;
    END IF;

    -- Busca color_id
    SELECT booklet_color_id INTO v_booklet_color_id
    FROM app.booklet_color
    WHERE upper(booklet_color_name) = upper(p_cor);

    IF NOT FOUND THEN
        out_message := 'Cor do caderno não encontrada.';
        RETURN;
    END IF;

    -- Loop para inserir cada caderno
    FOR v_exam_code, v_area_code IN
        SELECT exam_code, subject_area FROM temp_odd_answer_questions
    LOOP
        -- Define dia da prova com base na área
        IF v_area_code IN ('CH', 'CN') THEN
            v_dia := '1';
        ELSIF v_area_code IN ('LC', 'MT') THEN
            v_dia := '2';
        ELSE
            RAISE NOTICE 'Código de área desconhecido: %', v_area_code;
            CONTINUE;
        END IF;

        -- Busca area_id
        SELECT area_id INTO v_area_id
        FROM app.area
        WHERE area_code = v_area_code;

        IF NOT FOUND THEN
            RAISE NOTICE 'Área não encontrada: %', v_area_code;
            CONTINUE;
        END IF;

        -- Busca exam_day_id
        SELECT exam_day_id INTO v_exam_day_id
        FROM app.exam_day
        WHERE day_name = v_dia;

        IF NOT FOUND THEN
            RAISE NOTICE 'Dia de prova não encontrado: %', v_dia;
            CONTINUE;
        END IF;

       

        -- Monta o nome do caderno
        v_booklet_name := format(
            'ENEM_%s_%s_CAD_%s_DIA_%s_%s',
            p_year, p_prova, p_caderno, v_dia, upper(p_cor)
        );

        -- Insere caderno via SP
        CALL app.usp_api_booklet_create(
            p_booklet_name       := v_booklet_name,
            p_booklet_code       := v_exam_code,
            p_year_id            := v_year_id,
            p_area_id            := v_area_id,
            p_exam_day_id        := v_exam_day_id,
            p_booklet_color_id   := v_booklet_color_id,
            p_created_by         := p_created_by,
            out_message          := out_message
        );

        RAISE NOTICE 'Caderno inserido: %, Código: %, Área: %, Dia: %, Mensagem: %',
            v_booklet_name, v_exam_code, v_area_code, v_dia, out_message;
    END LOOP;

    UPDATE app.booklet
        SET booklet_name = REPLACE(booklet_name, 'CAD_01', 'CAD_07')
    WHERE booklet_name ILIKE '%DIA_2%';

    DROP TABLE IF EXISTS temp_odd_answer_questions;
END;
$$;
