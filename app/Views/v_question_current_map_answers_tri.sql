CREATE OR REPLACE VIEW app.v_question_current_map_answers_tri AS
WITH resolved AS (
    SELECT
        sa.student_id,
        sa.year_id,
        sa.test_version_id,
        sa.booklet_color_id,
        sa.language_id,

        -- nº da questão no caderno do aluno (variante)
        sa.question_number                AS variant_question_number,

        sa.selected_option,
        qc.correct_answer,

        -- número base do item (AZUL = próprio número; variantes = mapeado)
        CASE
            WHEN bc.booklet_color_name = 'AZUL'
                THEN sa.question_number
            ELSE qm.number_in_base
        END AS base_question_position,

        -- nº de alternativas (ajuste se necessário)
        5 AS num_alternatives

    FROM app.student_answer sa
    JOIN app.booklet_color bc
      ON bc.booklet_color_id = sa.booklet_color_id

    -- Para cadernos não-AZUL, mapeia para o número base
    LEFT JOIN app.question_map qm
      ON bc.booklet_color_name <> 'AZUL'
     AND qm.booklet_color_id = sa.booklet_color_id
     AND COALESCE(qm.language_id,0) = COALESCE(sa.language_id,0)
     AND qm.test_version_id = sa.test_version_id
     AND qm.year_id = sa.year_id
     AND qm.number_in_variant = sa.question_number

    -- Resolve o item base em question_current
    JOIN app.question_current qc
      ON qc.test_version_id = sa.test_version_id
     AND COALESCE(qc.language_id,0) = COALESCE(sa.language_id,0)
     AND qc.question_position =
         CASE
             WHEN bc.booklet_color_name = 'AZUL'
                 THEN sa.question_number
             ELSE qm.number_in_base
         END
)
SELECT
    student_id,
    year_id,
    test_version_id,
    booklet_color_id,
    language_id,

    -- identificador único do item base (para agrupar respostas da mesma questão)
    base_question_position,

    -- nº que o aluno viu no seu caderno (útil para auditoria/debug)
    variant_question_number AS question_number,

    selected_option,
    correct_answer,

    -- variável dicotômica para o 3PL (omissão = NULL)
    CASE
        WHEN selected_option IS NULL THEN NULL
        WHEN selected_option = correct_answer THEN 1
        ELSE 0
    END AS is_correct,

    num_alternatives
FROM resolved;
