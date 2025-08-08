drop table if exists imp.enem_question_parameter;
CREATE TABLE imp.enem_question_parameter (
    question_position         SMALLINT,           -- CO_POSICAO
    subject_area              VARCHAR(2),         -- SG_AREA (ex: LC, CN, CH, MT)
    question_code             INTEGER,            -- CO_ITEM
    answer_key                CHAR(1),            -- TX_GABARITO
    skill_code                SMALLINT,           -- CO_HABILIDADE
    is_abandoned              SMALLINT,           -- IN_ITEM_ABAN (0 = não, 1 = sim)
    abandonment_reason        TEXT,               -- TX_MOTIVO_ABAN (pode ser NULL)
    param_a                   NUMERIC(10,5),       -- NU_PARAM_A
    param_b                   NUMERIC(10,5),       -- NU_PARAM_B
    param_c                   NUMERIC(10,5),       -- NU_PARAM_C
    exam_color                TEXT,        -- TX_COR (ex: AMARELA, AZUL, etc.)
    exam_code                 INTEGER,            -- CO_PROVA
    language_type             SMALLINT,           -- TP_LINGUA (1 = Inglês, 2 = Espanhol)
    is_adapted_question       SMALLINT,           -- IN_ITEM_ADAPTADO (0 = não, 1 = sim)

    -- Constraints
    CONSTRAINT pk_enem_question_parameters PRIMARY KEY (question_code, exam_code)--,
    --CONSTRAINT ck_answer_key CHECK (answer_key IN ('A', 'B', 'C', 'D', 'E'))
);
