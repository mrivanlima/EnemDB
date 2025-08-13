

-- INSERT INTO app.user_login (
--     email,
--     password_hash,
--     is_email_verified,
--     is_active,
--     soft_deleted_at,
--     created_by,
--     created_on,
--     modified_by,
--     modified_on
-- )
-- VALUES (
--     'admin@yourdomain.com',                                  -- email
--     '$2a$12$EixZaYVK1fsbw1Zfbx3OXePaWxn96p36O8aCw/1hZ/8AXY9PQwztC', -- example hash for 'Admin123!'
--     TRUE,                                                    -- is_email_verified
--     TRUE,                                                    -- is_active
--     NULL,                                                    -- soft_deleted_at (NULL for active accounts)
--     1,                                                       -- created_by (usually another admin user or 1 for system)
--     NOW(),                                                   -- created_on
--     NULL,                                                    -- modified_by (NULL at creation)
--     NULL                                                     -- modified_on (NULL at creation)
-- );


INSERT INTO app.user_login (
  email, 
  password_hash, 
  is_email_verified, 
  is_active,
  soft_deleted_at, 
  created_by, 
  created_on, 
  modified_by, 
  modified_on
)
SELECT
  gs::text || '@yourdomain.com' AS email,
  '$2a$12$EixZaYVK1fsbw1Zfbx3OXePaWxn96p36O8aCw/1hZ/8AXY9PQwztC' AS password_hash,
  TRUE, 
  TRUE,
  NULL,
  1,
  NOW(),
  NULL,
  NULL
FROM generate_series(1, 1000) AS gs;




call imp.batch_create_universities();
call imp.batch_create_years();

DO $$
DECLARE
    v_message TEXT;
BEGIN
    CALL app.usp_api_year_create(
        2024::SMALLINT,  -- p_year
        1::INTEGER,      -- p_created_by
        v_message        -- OUT out_message
    );
    RAISE NOTICE 'Resultado: %', v_message;
END $$;


call imp.usp_seed_academic_organization();
CALL imp.usp_seed_university_category();
CALL imp.batch_create_campus();




\copy imp.region_state(region_name, state_name) FROM 'Region_mapping.csv' WITH CSV HEADER ENCODING 'LATIN1';
\copy imp.brazil_states(ibge_code, name, uf) FROM 'estados.csv' WITH CSV HEADER ENCODING 'LATIN1';
\copy imp.city(state_code, city_code, name) FROM 'municipios.csv' WITH CSV HEADER ENCODING 'LATIN1';
\copy imp.degree_mapping(published_degree, area, context, similarity, equivalent) FROM 'degree_mapping_equivalents_filled.csv' WITH CSV HEADER ENCODING 'LATIN1';


\copy imp.enem_question_parameter(question_position,subject_area,question_code,answer_key,skill_code,is_abandoned,abandonment_reason,param_a,param_b,param_c,exam_color,exam_code,language_type,is_adapted_question) FROM 'itens_prova_2024.csv' WITH (FORMAT csv, HEADER, DELIMITER ';', NULL '', ENCODING 'LATIN1');



CALL imp.batch_create_degrees();
CALL imp.batch_create_degree_levels();
CALL imp.batch_create_shift();
CALL imp.batch_create_regions();
CALL imp.batch_create_states();
CALL imp.batch_create_cities();
CALL imp.batch_create_frequency();
CALL imp.batch_create_quota_type();
CALL app.usp_quote_type_flags_update();
CALL imp.batch_create_special_quota();
CALL app.usp_special_quota_flags_update();
CALL imp.batch_create_university_mapping();
CALL imp.batch_create_seats(1);
CALL app.usp_seats_cutoff_update();

DO $$
DECLARE
    v_message TEXT;
BEGIN
    -- AZUL
    CALL app.usp_api_booklet_color_create('AZUL'::TEXT, FALSE::BOOLEAN, 1::SMALLINT, TRUE::BOOLEAN, 1::INTEGER, v_message);
    RAISE NOTICE 'AZUL: %', v_message;

    -- AMARELO
    CALL app.usp_api_booklet_color_create('AMARELO'::TEXT, FALSE::BOOLEAN, 2::SMALLINT, TRUE::BOOLEAN, 1::INTEGER, v_message);
    RAISE NOTICE 'AMARELO: %', v_message;

    -- BRANCO
    CALL app.usp_api_booklet_color_create('BRANCO'::TEXT, FALSE::BOOLEAN, 3::SMALLINT, TRUE::BOOLEAN, 1::INTEGER, v_message);
    RAISE NOTICE 'BRANCO: %', v_message;

    -- VERDE
    CALL app.usp_api_booklet_color_create('VERDE'::TEXT, FALSE::BOOLEAN, 4::SMALLINT, TRUE::BOOLEAN, 1::INTEGER, v_message);
    RAISE NOTICE 'VERDE: %', v_message;

    -- CINZA
    CALL app.usp_api_booklet_color_create('CINZA'::TEXT, FALSE::BOOLEAN, 5::SMALLINT, TRUE::BOOLEAN, 1::INTEGER, v_message);
    RAISE NOTICE 'CINZA: %', v_message;

    -- LARANJA
    CALL app.usp_api_booklet_color_create('LARANJA'::TEXT, FALSE::BOOLEAN, 6::SMALLINT, TRUE::BOOLEAN, 1::INTEGER, v_message);
    RAISE NOTICE 'LARANJA: %', v_message;

    -- ROXO
    CALL app.usp_api_booklet_color_create('ROXO'::TEXT, FALSE::BOOLEAN, 7::SMALLINT, TRUE::BOOLEAN, 1::INTEGER, v_message);
    RAISE NOTICE 'ROXO: %', v_message;

    -- LEITOR TELA
    CALL app.usp_api_booklet_color_create('LEITOR TELA'::TEXT, FALSE::BOOLEAN, 7::SMALLINT, TRUE::BOOLEAN, 1::INTEGER, v_message);
    RAISE NOTICE 'LEITOR TELA: %', v_message;

END;
$$;


DO $$
DECLARE
    v_message TEXT;
BEGIN
    CALL app.usp_api_area_create('Linguagens, Códigos e suas Tecnologias', 'LC', 1, v_message);
    RAISE NOTICE 'LC: %', v_message;

    CALL app.usp_api_area_create('Matemática e suas Tecnologias', 'MT', 1, v_message);
    RAISE NOTICE 'MT: %', v_message;

    CALL app.usp_api_area_create('Ciências da Natureza e suas Tecnologias', 'CN', 1, v_message);
    RAISE NOTICE 'CN: %', v_message;

    CALL app.usp_api_area_create('Ciências Humanas e suas Tecnologias', 'CH', 1, v_message);
    RAISE NOTICE 'CH: %', v_message;
END;
$$;

-- Insert Day 1
DO $$
DECLARE
    v_message TEXT;
BEGIN
    CALL app.usp_api_exam_day_create(
        p_day_name   => '1',
        p_created_by => 1,
        out_message  => v_message
    );
    RAISE NOTICE 'Resultado: %', v_message;
END;
$$;

-- Insert Day 2
DO $$
DECLARE
    v_message TEXT;
BEGIN
    CALL app.usp_api_exam_day_create(
        p_day_name   => '2',
        p_created_by => 1,
        out_message  => v_message
    );
    RAISE NOTICE 'Resultado: %', v_message;
END;
$$;

DO $$
DECLARE
    v_out_message TEXT;
BEGIN
    CALL app.usp_batch_booklets_create(
        p_year        := '2024',
        p_prova       := 'P1',         -- ou 'P2' para a segunda prova
        p_caderno     := '01',         -- número do caderno (ex: '01', '02')
        p_cor         := 'AZUL',       -- cor do caderno (AZUL, ROSA, etc)
        p_created_by  := 1,            -- ID do usuário que está executando
        out_message   := v_out_message
    );

    RAISE NOTICE 'Resultado: %', v_out_message;
END $$;

-- Inserir idioma Inglês
CALL app.usp_api_language_create(
    'Inglês',   -- p_language_name
    1,          -- p_created_by (exemplo: user_login_id = 1)
    NULL        -- out_message (será preenchido pela procedure)
);

-- Inserir idioma Espanhol
CALL app.usp_api_language_create(
    'Espanhol', -- p_language_name
    1,          -- p_created_by (exemplo: user_login_id = 1)
    NULL        -- out_message
);

DO $$
BEGIN
  CALL app.usp_batch_question_create(1::integer);
END $$;

CALL app.usp_batch_question_update(2024::integer);


DO $$
DECLARE
  v_msg TEXT;
BEGIN
  CALL app.usp_api_test_version_create('P1', 1, v_msg);
  RAISE NOTICE 'P1 -> %', v_msg;

  CALL app.usp_api_test_version_create('P2', 1, v_msg);
  RAISE NOTICE 'P2 -> %', v_msg;
END $$;


DO $$
DECLARE v_msg text;
BEGIN
  CALL app.usp_batch_create_question_map(
    p_exam_year  => 2024::smallint,
    p_test_code  => 'P1'::text,
    p_created_by => 1::int,
    out_message  => v_msg
  );
  RAISE NOTICE '%', v_msg;
END $$;

DO $$
DECLARE v_msg text;
BEGIN
  CALL app.usp_batch_create_question_map(
    p_exam_year  => 2024::smallint,
    p_test_code  => 'P2'::text,
    p_created_by => 1::int,
    out_message  => v_msg
  );
  RAISE NOTICE '%', v_msg;
END $$;



DO $$
DECLARE
  s INT; i INT;
  v_msg TEXT;
  v_opt CHAR(1);
  v_ms  INT;
  v_ok  BIGINT := 0;
  v_fail BIGINT := 0;

  -- constants for 2024 P1
  v_year_id          CONSTANT INT := 2;     -- app.year: 2024
  v_exam_year        CONSTANT INT := 2024;
  v_test_version_id  CONSTANT INT := 1;     -- P1

  -- Allowed colors
  v_d1_colors INT[] := ARRAY[1,2,4,3];  -- Day 1: AZUL(1), AMARELO(2), VERDE(4), BRANCO(3)
  v_d2_colors INT[] := ARRAY[1,2,4,5];    -- Day 2 (P1-only): AZUL(1), AMARELO(2), VERDE(4)  (CINZA excluída)
  color_d1 INT;
  color_d2 INT;
BEGIN
  FOR s IN 1..10 LOOP
    -- Random color per day (per student)
    color_d1 := v_d1_colors[1 + floor(random()*array_length(v_d1_colors,1))::INT];
    color_d2 := v_d2_colors[1 + floor(random()*array_length(v_d2_colors,1))::INT];

    -- Day 1 (Q1..90) with language_id=1 for Q1..Q5
    FOR i IN 1..90 LOOP
      v_opt := (ARRAY['A','B','C','D','E'])[1 + floor(random()*5)::INT];
      v_ms  := 20000 + floor(random()*60001)::INT;  -- 20s..80s

      CALL app.usp_api_student_answer_create(
        p_student_id        => s::INT,
        p_year_id           => v_year_id,
        p_exam_year         => v_exam_year,
        p_test_version_id   => v_test_version_id,    -- P1
        p_booklet_color_id  => color_d1::INT,
        p_language_id       => (CASE WHEN i <= 5 THEN 1 ELSE NULL END)::SMALLINT,
        p_question_number   => i::SMALLINT,
        p_selected_option   => v_opt,
        p_answered_at       => NOW(),
        p_response_time_ms  => v_ms,
        p_created_by        => 1::INT,
        out_message         => v_msg
      );
      IF v_msg = 'OK' THEN v_ok := v_ok + 1; ELSE v_fail := v_fail + 1; END IF;
    END LOOP;

    -- Day 2 (Q1..90) language NULL
    FOR i IN 91..180 LOOP
      v_opt := (ARRAY['A','B','C','D','E'])[1 + floor(random()*5)::INT];
      v_ms  := 20000 + floor(random()*60001)::INT;

      CALL app.usp_api_student_answer_create(
        p_student_id        => s::INT,
        p_year_id           => v_year_id,
        p_exam_year         => v_exam_year,
        p_test_version_id   => v_test_version_id,    -- P1
        p_booklet_color_id  => color_d2::INT,
        p_language_id       => NULL::SMALLINT,
        p_question_number   => i::SMALLINT,
        p_selected_option   => v_opt,
        p_answered_at       => NOW(),
        p_response_time_ms  => v_ms,
        p_created_by        => 1::INT,
        out_message         => v_msg
      );
      IF v_msg = 'OK' THEN v_ok := v_ok + 1; ELSE v_fail := v_fail + 1; END IF;
    END LOOP;
  END LOOP;

  RAISE NOTICE 'Finished: % OK, % failed.', v_ok, v_fail;
END $$;





/*
DO $$
 DECLARE
     rec RECORD;
     v_out_message TEXT;
 BEGIN
     FOR rec IN
         SELECT DISTINCT ds_organizacao_academica
         FROM imp.vagas_ofertadas
         WHERE ds_organizacao_academica IS NOT NULL
     LOOP
         CALL app.usp_api_academic_organization_create(
             rec.ds_organizacao_academica,
             'system',
             v_out_message
         );
         RAISE NOTICE 'Inserted academic organization "%", result: %',
             rec.ds_organizacao_academica, v_out_message;
     END LOOP;
 END;
$$;
*/

/*
INSERT INTO app.booklet_color (
    booklet_color_name,
    booklet_color_name_friendly,
    is_accessible,
    sort_order,
    active,
    created_by,
    created_on,
    modified_by,
    modified_on
)
VALUES
  ('Amarelo', 'Caderno Amarelo', FALSE, 1, TRUE, 1, NOW(), NULL, NULL),
  ('Azul', 'Caderno Azul', FALSE, 2, TRUE, 1, NOW(), NULL, NULL),
  ('Rosa', 'Caderno Rosa', FALSE, 3, TRUE, 1, NOW(), NULL, NULL),
  ('Cinza', 'Caderno Cinza', FALSE, 4, TRUE, 1, NOW(), NULL, NULL),
  ('Branco', 'Caderno Branco (Acessível)', TRUE, 5, TRUE, 1, NOW(), NULL, NULL),
  ('Laranja', 'Caderno Laranja', FALSE, 6, TRUE, 1, NOW(), NULL, NULL),
  ('Verde', 'Caderno Verde', FALSE, 7, TRUE, 1, NOW(), NULL, NULL),
  ('Roxo', 'Caderno Roxo', FALSE, 8, TRUE, 1, NOW(), NULL, NULL);

  INSERT INTO app.area (
    area_name,
    area_name_friendly,
    created_by,
    created_on,
    modified_by,
    modified_on
)
VALUES
  ('Ciências da Natureza e suas Tecnologias', 'Ciencias da Natureza e suas Tecnologias', 1, NOW(), NULL, NULL),
  ('Ciências Humanas e suas Tecnologias', 'Ciencias Humanas e suas Tecnologias', 1, NOW(), NULL, NULL),
  ('Linguagens, Códigos e suas Tecnologias e Redação', 'Linguagens, Codigos e suas Tecnologias e Redacao', 1, NOW(), NULL, NULL),
  ('Matemática e suas Tecnologias', 'Matematica e suas Tecnologias', 1, NOW(), NULL, NULL);


INSERT INTO app.exam_day (
    day_name,
    day_name_friendly,
    created_by,
    created_on,
    modified_by,
    modified_on
)
VALUES
  ('Primeiro Dia', 'Primeiro Dia', 1, NOW(), NULL, NULL),
  ('Segundo Dia', 'Segundo Dia', 1, NOW(), NULL, NULL);


  INSERT INTO app.exam_year (
    year_name,
    year_name_friendly,
    created_by,
    created_on,
    modified_by,
    modified_on
)
VALUES
  (2010, '2010', 1, NOW(), NULL, NULL),
  (2011, '2011', 1, NOW(), NULL, NULL),
  (2012, '2012', 1, NOW(), NULL, NULL),
  (2013, '2013', 1, NOW(), NULL, NULL),
  (2014, '2014', 1, NOW(), NULL, NULL),
  (2015, '2015', 1, NOW(), NULL, NULL),
  (2016, '2016', 1, NOW(), NULL, NULL),
  (2017, '2017', 1, NOW(), NULL, NULL),
  (2018, '2018', 1, NOW(), NULL, NULL),
  (2019, '2019', 1, NOW(), NULL, NULL),
  (2020, '2020', 1, NOW(), NULL, NULL),
  (2021, '2021', 1, NOW(), NULL, NULL),
  (2022, '2022', 1, NOW(), NULL, NULL),
  (2023, '2023', 1, NOW(), NULL, NULL),
  (2024, '2024', 1, NOW(), NULL, NULL),
  (2025, '2025', 1, NOW(), NULL, NULL),
  (2026, '2026', 1, NOW(), NULL, NULL),
  (2027, '2027', 1, NOW(), NULL, NULL),
  (2028, '2028', 1, NOW(), NULL, NULL),
  (2029, '2029', 1, NOW(), NULL, NULL),
  (2030, '2030', 1, NOW(), NULL, NULL);


INSERT INTO app.subject (
    subject_name,
    subject_name_friendly,
    created_by,
    created_on,
    modified_by,
    modified_on
)
VALUES
  ('Arte', 'Arte', 1, NOW(), NULL, NULL),
  ('Biologia', 'Biologia', 1, NOW(), NULL, NULL),
  ('Ciências', 'Ciencias', 1, NOW(), NULL, NULL),
  ('Educação Física', 'Educacao Fisica', 1, NOW(), NULL, NULL),
  ('Espanhol', 'Espanhol', 1, NOW(), NULL, NULL),
  ('Filosofia', 'Filosofia', 1, NOW(), NULL, NULL),
  ('Física', 'Fisica', 1, NOW(), NULL, NULL),
  ('Geografia', 'Geografia', 1, NOW(), NULL, NULL),
  ('História', 'Historia', 1, NOW(), NULL, NULL),
  ('Inglês', 'Ingles', 1, NOW(), NULL, NULL),
  ('Literatura', 'Literatura', 1, NOW(), NULL, NULL),
  ('Matemática', 'Matematica', 1, NOW(), NULL, NULL),
  ('Português', 'Portugues', 1, NOW(), NULL, NULL),
  ('Química', 'Quimica', 1, NOW(), NULL, NULL),
  ('Redação', 'Redacao', 1, NOW(), NULL, NULL),
  ('Sociologia', 'Sociologia', 1, NOW(), NULL, NULL),
  ('Tecnologia da Informação', 'Tecnologia da Informacao', 1, NOW(), NULL, NULL),
  ('Ensino Religioso', 'Ensino Religioso', 1, NOW(), NULL, NULL),
  ('Projeto de Vida', 'Projeto de Vida', 1, NOW(), NULL, NULL);


-- Matemática
SELECT subject_id FROM app.subject WHERE subject_name = 'Matemática';
\gset
INSERT INTO app.topic (subject_id, topic_name, topic_name_friendly, created_by, created_on, modified_by, modified_on) VALUES
  (:subject_id, 'Aritmética', 'Aritmetica', 1, NOW(), NULL, NULL),
  (:subject_id, 'Álgebra', 'Algebra', 1, NOW(), NULL, NULL),
  (:subject_id, 'Geometria', 'Geometria', 1, NOW(), NULL, NULL),
  (:subject_id, 'Funções', 'Funcoes', 1, NOW(), NULL, NULL),
  (:subject_id, 'Probabilidade e Estatística', 'Probabilidade e Estatistica', 1, NOW(), NULL, NULL),
  (:subject_id, 'Trigonometria', 'Trigonometria', 1, NOW(), NULL, NULL),
  (:subject_id, 'Matemática Financeira', 'Matematica Financeira', 1, NOW(), NULL, NULL);

-- Português
SELECT subject_id FROM app.subject WHERE subject_name = 'Português';
\gset
INSERT INTO app.topic (subject_id, topic_name, topic_name_friendly, created_by, created_on, modified_by, modified_on) VALUES
  (:subject_id, 'Gramática', 'Gramatica', 1, NOW(), NULL, NULL),
  (:subject_id, 'Interpretação de Texto', 'Interpretacao de Texto', 1, NOW(), NULL, NULL),
  (:subject_id, 'Ortografia', 'Ortografia', 1, NOW(), NULL, NULL),
  (:subject_id, 'Literatura', 'Literatura', 1, NOW(), NULL, NULL),
  (:subject_id, 'Redação', 'Redacao', 1, NOW(), NULL, NULL);

 INSERT INTO app.topic (subject_id, topic_name, topic_name_friendly, created_by, created_on, modified_by, modified_on) VALUES
  (:subject_id, 'Gêneros Textuais', 'Generos Textuais', 1, NOW(), NULL, NULL),
  (:subject_id, 'Variedades Linguísticas', 'Variedades Linguisticas', 1, NOW(), NULL, NULL);
 

-- Ciências
SELECT subject_id FROM app.subject WHERE subject_name = 'Ciências';
\gset
INSERT INTO app.topic (subject_id, topic_name, topic_name_friendly, created_by, created_on, modified_by, modified_on) VALUES
  (:subject_id, 'Corpo Humano', 'Corpo Humano', 1, NOW(), NULL, NULL),
  (:subject_id, 'Ecologia', 'Ecologia', 1, NOW(), NULL, NULL),
  (:subject_id, 'Matéria e Energia', 'Materia e Energia', 1, NOW(), NULL, NULL),
  (:subject_id, 'Astronomia', 'Astronomia', 1, NOW(), NULL, NULL),
  (:subject_id, 'Saúde e Doenças', 'Saude e Doencas', 1, NOW(), NULL, NULL);

INSERT INTO app.topic (subject_id, topic_name, topic_name_friendly, created_by, created_on, modified_by, modified_on) VALUES
  (:subject_id, 'Seres Vivos', 'Seres Vivos', 1, NOW(), NULL, NULL),
  (:subject_id, 'Terra e Universo', 'Terra e Universo', 1, NOW(), NULL, NULL),
  (:subject_id, 'Tecnologia e Sociedade', 'Tecnologia e Sociedade', 1, NOW(), NULL, NULL);


-- História
SELECT subject_id FROM app.subject WHERE subject_name = 'História';
\gset
INSERT INTO app.topic (subject_id, topic_name, topic_name_friendly, created_by, created_on, modified_by, modified_on) VALUES
  (:subject_id, 'História do Brasil', 'Historia do Brasil', 1, NOW(), NULL, NULL),
  (:subject_id, 'História Geral', 'Historia Geral', 1, NOW(), NULL, NULL),
  (:subject_id, 'Cidadania', 'Cidadania', 1, NOW(), NULL, NULL),
  (:subject_id, 'Antiguidade', 'Antiguidade', 1, NOW(), NULL, NULL),
  (:subject_id, 'Idade Média', 'Idade Media', 1, NOW(), NULL, NULL),
  (:subject_id, 'Idade Moderna', 'Idade Moderna', 1, NOW(), NULL, NULL),
  (:subject_id, 'Idade Contemporânea', 'Idade Contemporanea', 1, NOW(), NULL, NULL),
  (:subject_id, 'Movimentos Sociais e Políticos', 'Movimentos Sociais e Politicos', 1, NOW(), NULL, NULL),
  (:subject_id, 'Formação das Sociedades Brasileiras', 'Formacao das Sociedades Brasileiras', 1, NOW(), NULL, NULL),
  (:subject_id, 'História das Américas', 'Historia das Americas', 1, NOW(), NULL, NULL);

INSERT INTO app.topic (subject_id, topic_name, topic_name_friendly, created_by, created_on, modified_by, modified_on) VALUES
  (:subject_id, 'História da África e Afro-brasileira', 'Historia da Africa e Afrobrasileira', 1, NOW(), NULL, NULL),
  (:subject_id, 'História Indígena', 'Historia Indigena', 1, NOW(), NULL, NULL),
  (:subject_id, 'História das Mulheres e Gênero', 'Historia das Mulheres e Genero', 1, NOW(), NULL, NULL),
  (:subject_id, 'História da Ciência e Tecnologia', 'Historia da Ciencia e Tecnologia', 1, NOW(), NULL, NULL),
  (:subject_id, 'Globalização', 'Globalizacao', 1, NOW(), NULL, NULL);


-- Geografia
SELECT subject_id FROM app.subject WHERE subject_name = 'Geografia';
\gset
INSERT INTO app.topic (subject_id, topic_name, topic_name_friendly, created_by, created_on, modified_by, modified_on) VALUES
  (:subject_id, 'Geografia Física', 'Geografia Fisica', 1, NOW(), NULL, NULL),
  (:subject_id, 'Geografia Humana', 'Geografia Humana', 1, NOW(), NULL, NULL),
  (:subject_id, 'Cartografia', 'Cartografia', 1, NOW(), NULL, NULL),
  (:subject_id, 'Economia', 'Economia', 1, NOW(), NULL, NULL),
  (:subject_id, 'Demografia', 'Demografia', 1, NOW(), NULL, NULL),
  (:subject_id, 'Meio Ambiente e Sustentabilidade', 'Meio Ambiente e Sustentabilidade', 1, NOW(), NULL, NULL),
  (:subject_id, 'Globalização', 'Globalizacao', 1, NOW(), NULL, NULL),
  (:subject_id, 'Urbanização', 'Urbanizacao', 1, NOW(), NULL, NULL),
  (:subject_id, 'Geopolítica', 'Geopolitica', 1, NOW(), NULL, NULL),
  (:subject_id, 'Recursos Naturais', 'Recursos Naturais', 1, NOW(), NULL, NULL);

  INSERT INTO app.topic (subject_id, topic_name, topic_name_friendly, created_by, created_on, modified_by, modified_on) VALUES
  (:subject_id, 'Climatologia e Meteorologia', 'Climatologia e Meteorologia', 1, NOW(), NULL, NULL),
  (:subject_id, 'Agricultura e Pecuária', 'Agricultura e Pecuaria', 1, NOW(), NULL, NULL),
  (:subject_id, 'Saneamento Básico e Saúde Ambiental', 'Saneamento Basico e Saude Ambiental', 1, NOW(), NULL, NULL),
  (:subject_id, 'Populações Tradicionais', 'Populacoes Tradicionais', 1, NOW(), NULL, NULL),
  (:subject_id, 'Transportes e Logística', 'Transportes e Logistica', 1, NOW(), NULL, NULL);



-- Arte
SELECT subject_id FROM app.subject WHERE subject_name = 'Arte';
\gset
INSERT INTO app.topic (subject_id, topic_name, topic_name_friendly, created_by, created_on, modified_by, modified_on) VALUES
  (:subject_id, 'História da Arte', 'Historia da Arte', 1, NOW(), NULL, NULL),
  (:subject_id, 'Música', 'Musica', 1, NOW(), NULL, NULL),
  (:subject_id, 'Teatro', 'Teatro', 1, NOW(), NULL, NULL),
  (:subject_id, 'Dança', 'Danca', 1, NOW(), NULL, NULL),
  (:subject_id, 'Artes Visuais', 'Artes Visuais', 1, NOW(), NULL, NULL);

SELECT subject_id FROM app.subject WHERE subject_name = 'Arte';
\gset

INSERT INTO app.topic (subject_id, topic_name, topic_name_friendly, created_by, created_on, modified_by, modified_on) VALUES
  (:subject_id, 'Cinema', 'Cinema', 1, NOW(), NULL, NULL),
  (:subject_id, 'Design', 'Design', 1, NOW(), NULL, NULL),
  (:subject_id, 'Artes Plásticas', 'Artes Plasticas', 1, NOW(), NULL, NULL),
  (:subject_id, 'Fotografia', 'Fotografia', 1, NOW(), NULL, NULL),
  (:subject_id, 'Crítica de Arte', 'Critica de Arte', 1, NOW(), NULL, NULL),
  (:subject_id, 'Cultura Popular e Arte Contemporânea', 'Cultura Popular e Arte Contemporanea', 1, NOW(), NULL, NULL),
  (:subject_id, 'Arte Digital', 'Arte Digital', 1, NOW(), NULL, NULL),
  (:subject_id, 'Performance', 'Performance', 1, NOW(), NULL, NULL),
  (:subject_id, 'Arquitetura e Urbanismo', 'Arquitetura e Urbanismo', 1, NOW(), NULL, NULL),
  (:subject_id, 'Patrimônio Cultural', 'Patrimonio Cultural', 1, NOW(), NULL, NULL),
  (:subject_id, 'Movimentos e Estilos Artísticos', 'Movimentos e Estilos Artistico', 1, NOW(), NULL, NULL);



-- Educação Física
SELECT subject_id FROM app.subject WHERE subject_name = 'Educação Física';
\gset
INSERT INTO app.topic (subject_id, topic_name, topic_name_friendly, created_by, created_on, modified_by, modified_on) VALUES
  (:subject_id, 'Esportes', 'Esportes', 1, NOW(), NULL, NULL),
  (:subject_id, 'Saúde e Movimento', 'Saude e Movimento', 1, NOW(), NULL, NULL),
  (:subject_id, 'Jogos e Brincadeiras', 'Jogos e Brincadeiras', 1, NOW(), NULL, NULL),
  (:subject_id, 'Cultura Corporal', 'Cultura Corporal', 1, NOW(), NULL, NULL);

INSERT INTO app.topic (subject_id, topic_name, topic_name_friendly, created_by, created_on, modified_by, modified_on) VALUES
  (:subject_id, 'Condicionamento Físico', 'Condicionamento Fisico', 1, NOW(), NULL, NULL),
  (:subject_id, 'Dança e Expressão Corporal', 'Danca e Expressao Corporal', 1, NOW(), NULL, NULL),
  (:subject_id, 'Atividades Rítmicas e Recreativas', 'Atividades Ritmicas e Recreativas', 1, NOW(), NULL, NULL),
  (:subject_id, 'Prevenção de Lesões e Primeiros Socorros', 'Prevencao de Lesoes e Primeiros Socorros', 1, NOW(), NULL, NULL),
  (:subject_id, 'História e Sociologia do Esporte', 'Historia e Sociologia do Esporte', 1, NOW(), NULL, NULL),
  (:subject_id, 'Nutrição e Saúde', 'Nutricao e Saude', 1, NOW(), NULL, NULL);

INSERT INTO app.topic (subject_id, topic_name, topic_name_friendly, created_by, created_on, modified_by, modified_on) VALUES
  (:subject_id, 'Psicologia do Esporte', 'Psicologia do Esporte', 1, NOW(), NULL, NULL),
  (:subject_id, 'Inclusão e Acessibilidade no Esporte', 'Inclusao e Acessibilidade no Esporte', 1, NOW(), NULL, NULL),
  (:subject_id, 'Atividades Aquáticas', 'Atividades Aquaticas', 1, NOW(), NULL, NULL),
  (:subject_id, 'Esportes Adaptados', 'Esportes Adaptados', 1, NOW(), NULL, NULL);



-- Inglês
SELECT subject_id FROM app.subject WHERE subject_name = 'Inglês';
\gset
INSERT INTO app.topic (subject_id, topic_name, topic_name_friendly, created_by, created_on, modified_by, modified_on) VALUES
  (:subject_id, 'Compreensão Oral', 'Compreensao Oral', 1, NOW(), NULL, NULL),
  (:subject_id, 'Leitura e Interpretação', 'Leitura e Interpretacao', 1, NOW(), NULL, NULL),
  (:subject_id, 'Gramática', 'Gramatica', 1, NOW(), NULL, NULL),
  (:subject_id, 'Vocabulário', 'Vocabulario', 1, NOW(), NULL, NULL),
  (:subject_id, 'Produção de Texto', 'Producao de Texto', 1, NOW(), NULL, NULL),
  (:subject_id, 'Pronúncia e Fonética', 'Pronuncia e Fonetica', 1, NOW(), NULL, NULL),
  (:subject_id, 'Conversação e Expressão Oral', 'Conversacao e Expressao Oral', 1, NOW(), NULL, NULL),
  (:subject_id, 'Estratégias de Estudo e Compreensão', 'Estrategias de Estudo e Compreensao', 1, NOW(), NULL, NULL),
  (:subject_id, 'Cultura dos Países de Língua Inglesa', 'Cultura dos Paises de Lingua Inglesa', 1, NOW(), NULL, NULL),
  (:subject_id, 'Escrita Formal e Informal', 'Escrita Formal e Informal', 1, NOW(), NULL, NULL),
  (:subject_id, 'Expressões Idiomáticas e Phrasal Verbs', 'Expressoes Idiomaticas e Phrasal Verbs', 1, NOW(), NULL, NULL),
  (:subject_id, 'Compreensão Auditiva Avançada', 'Compreensao Auditiva Avancada', 1, NOW(), NULL, NULL),
  (:subject_id, 'Gramática Avançada', 'Gramatica Avancada', 1, NOW(), NULL, NULL),
  (:subject_id, 'Interpretação Crítica', 'Interpretacao Critica', 1, NOW(), NULL, NULL),
  (:subject_id, 'Tecnologias e Mídias em Inglês', 'Tecnologias e Midias em Ingles', 1, NOW(), NULL, NULL);



-- Espanhol
SELECT subject_id FROM app.subject WHERE subject_name = 'Espanhol';
\gset
INSERT INTO app.topic (subject_id, topic_name, topic_name_friendly, created_by, created_on, modified_by, modified_on) VALUES
  (:subject_id, 'Compreensão Oral', 'Compreensao Oral', 1, NOW(), NULL, NULL),
  (:subject_id, 'Leitura e Interpretação', 'Leitura e Interpretacao', 1, NOW(), NULL, NULL),
  (:subject_id, 'Gramática', 'Gramatica', 1, NOW(), NULL, NULL),
  (:subject_id, 'Vocabulário', 'Vocabulario', 1, NOW(), NULL, NULL),
  (:subject_id, 'Produção de Texto', 'Producao de Texto', 1, NOW(), NULL, NULL);

SELECT subject_id FROM app.subject WHERE subject_name = 'Biologia';
\gset
INSERT INTO app.topic (subject_id, topic_name, topic_name_friendly, created_by, created_on, modified_by, modified_on) VALUES
  (:subject_id, 'Citologia', 'Citologia', 1, NOW(), NULL, NULL),
  (:subject_id, 'Histologia', 'Histologia', 1, NOW(), NULL, NULL),
  (:subject_id, 'Fisiologia', 'Fisiologia', 1, NOW(), NULL, NULL),
  (:subject_id, 'Genética', 'Genetica', 1, NOW(), NULL, NULL),
  (:subject_id, 'Evolução', 'Evolucao', 1, NOW(), NULL, NULL),
  (:subject_id, 'Ecologia', 'Ecologia', 1, NOW(), NULL, NULL),
  (:subject_id, 'Botânica', 'Botanica', 1, NOW(), NULL, NULL),
  (:subject_id, 'Zoologia', 'Zoologia', 1, NOW(), NULL, NULL),
  (:subject_id, 'Microbiologia', 'Microbiologia', 1, NOW(), NULL, NULL),
  (:subject_id, 'Imunologia', 'Imunologia', 1, NOW(), NULL, NULL);

 INSERT INTO app.topic (subject_id, topic_name, topic_name_friendly, created_by, created_on, modified_by, modified_on) VALUES
  (:subject_id, 'Bioquímica', 'Bioquimica', 1, NOW(), NULL, NULL),
  (:subject_id, 'Embriologia', 'Embriologia', 1, NOW(), NULL, NULL),
  (:subject_id, 'Parasitologia', 'Parasitologia', 1, NOW(), NULL, NULL);
 


-- Física
SELECT subject_id FROM app.subject WHERE subject_name = 'Física';
\gset
INSERT INTO app.topic (subject_id, topic_name, topic_name_friendly, created_by, created_on, modified_by, modified_on) VALUES
  (:subject_id, 'Mecânica', 'Mecanica', 1, NOW(), NULL, NULL),
  (:subject_id, 'Gravitação', 'Gravitacao', 1, NOW(), NULL, NULL),
  (:subject_id, 'Hidrostática', 'Hidrostatica', 1, NOW(), NULL, NULL),
  (:subject_id, 'Termologia', 'Termologia', 1, NOW(), NULL, NULL),
  (:subject_id, 'Óptica', 'Optica', 1, NOW(), NULL, NULL),
  (:subject_id, 'Ondulatória', 'Ondulatoria', 1, NOW(), NULL, NULL),
  (:subject_id, 'Eletricidade', 'Eletricidade', 1, NOW(), NULL, NULL),
  (:subject_id, 'Eletromagnetismo', 'Eletromagnetismo', 1, NOW(), NULL, NULL),
  (:subject_id, 'Física Moderna', 'Fisica Moderna', 1, NOW(), NULL, NULL);


-- Química
SELECT subject_id FROM app.subject WHERE subject_name = 'Química';
\gset
INSERT INTO app.topic (subject_id, topic_name, topic_name_friendly, created_by, created_on, modified_by, modified_on) VALUES
  (:subject_id, 'Química Geral', 'Quimica Geral', 1, NOW(), NULL, NULL),
  (:subject_id, 'Química Inorgânica', 'Quimica Inorganica', 1, NOW(), NULL, NULL),
  (:subject_id, 'Fisico-Química', 'Fisico-Quimica', 1, NOW(), NULL, NULL),
  (:subject_id, 'Química Orgânica', 'Quimica Organica', 1, NOW(), NULL, NULL),
  (:subject_id, 'Química Ambiental', 'Quimica Ambiental', 1, NOW(), NULL, NULL),
  (:subject_id, 'Estequiometria', 'Estequiometria', 1, NOW(), NULL, NULL);

  -- Adicional, só se quiser máxima granularidade:
INSERT INTO app.topic (subject_id, topic_name, topic_name_friendly, created_by, created_on, modified_by, modified_on) VALUES
  (:subject_id, 'Química Analítica', 'Quimica Analitica', 1, NOW(), NULL, NULL),
  (:subject_id, 'Química do Cotidiano', 'Quimica do Cotidiano', 1, NOW(), NULL, NULL);



-- Sociologia
SELECT subject_id FROM app.subject WHERE subject_name = 'Sociologia';
\gset
INSERT INTO app.topic (subject_id, topic_name, topic_name_friendly, created_by, created_on, modified_by, modified_on) VALUES
  (:subject_id, 'Teorias Sociológicas', 'Teorias Sociologicas', 1, NOW(), NULL, NULL),
  (:subject_id, 'Cidadania e Sociedade', 'Cidadania e Sociedade', 1, NOW(), NULL, NULL),
  (:subject_id, 'Cultura', 'Cultura', 1, NOW(), NULL, NULL),
  (:subject_id, 'Estratificação Social', 'Estratificacao Social', 1, NOW(), NULL, NULL);

-- Filosofia
SELECT subject_id FROM app.subject WHERE subject_name = 'Filosofia';
\gset
INSERT INTO app.topic (subject_id, topic_name, topic_name_friendly, created_by, created_on, modified_by, modified_on) VALUES
  (:subject_id, 'Filosofia Antiga', 'Filosofia Antiga', 1, NOW(), NULL, NULL),
  (:subject_id, 'Filosofia Moderna', 'Filosofia Moderna', 1, NOW(), NULL, NULL),
  (:subject_id, 'Filosofia Contemporânea', 'Filosofia Contemporanea', 1, NOW(), NULL, NULL),
  (:subject_id, 'Ética', 'Etica', 1, NOW(), NULL, NULL);

-- Redação
SELECT subject_id FROM app.subject WHERE subject_name = 'Redação';
\gset
INSERT INTO app.topic (subject_id, topic_name, topic_name_friendly, created_by, created_on, modified_by, modified_on) VALUES
  (:subject_id, 'Estrutura do Texto Dissertativo', 'Estrutura do Texto Dissertativo', 1, NOW(), NULL, NULL),
  (:subject_id, 'Argumentação', 'Argumentacao', 1, NOW(), NULL, NULL),
  (:subject_id, 'Coesão e Coerência', 'Coesao e Coerencia', 1, NOW(), NULL, NULL);

-- Tecnologia da Informação
SELECT subject_id FROM app.subject WHERE subject_name = 'Tecnologia da Informação';
\gset
INSERT INTO app.topic (subject_id, topic_name, topic_name_friendly, created_by, created_on, modified_by, modified_on) VALUES
  (:subject_id, 'Fundamentos de Informática', 'Fundamentos de Informatica', 1, NOW(), NULL, NULL),
  (:subject_id, 'Internet e Redes', 'Internet e Redes', 1, NOW(), NULL, NULL),
  (:subject_id, 'Segurança Digital', 'Seguranca Digital', 1, NOW(), NULL, NULL);

-- Projeto de Vida
SELECT subject_id FROM app.subject WHERE subject_name = 'Projeto de Vida';
\gset
INSERT INTO app.topic (subject_id, topic_name, topic_name_friendly, created_by, created_on, modified_by, modified_on) VALUES
  (:subject_id, 'Autoconhecimento', 'Autoconhecimento', 1, NOW(), NULL, NULL),
  (:subject_id, 'Planejamento de Carreira', 'Planejamento de Carreira', 1, NOW(), NULL, NULL),
  (:subject_id, 'Habilidades Socioemocionais', 'Habilidades Socioemocionais', 1, NOW(), NULL, NULL);

-- Ensino Religioso
SELECT subject_id FROM app.subject WHERE subject_name = 'Ensino Religioso';
\gset
INSERT INTO app.topic (subject_id, topic_name, topic_name_friendly, created_by, created_on, modified_by, modified_on) VALUES
  (:subject_id, 'Diversidade Religiosa', 'Diversidade Religiosa', 1, NOW(), NULL, NULL),
  (:subject_id, 'Ética e Valores', 'Etica e Valores', 1, NOW(), NULL, NULL),
  (:subject_id, 'Religiões do Mundo', 'Religioes do Mundo', 1, NOW(), NULL, NULL);

-- Matemática > Álgebra
SELECT topic_id FROM app.topic WHERE topic_name = 'Álgebra';
\gset
INSERT INTO app.subtopic (topic_id, subtopic_name, subtopic_name_friendly, created_by, created_on, modified_by, modified_on) VALUES
  (:topic_id, 'Equações do 1º grau', 'Equacoes do 1 grau', 1, NOW(), NULL, NULL),
  (:topic_id, 'Equações do 2º grau', 'Equacoes do 2 grau', 1, NOW(), NULL, NULL),
  (:topic_id, 'Sistemas Lineares', 'Sistemas Lineares', 1, NOW(), NULL, NULL),
  (:topic_id, 'Inequações', 'Inequacoes', 1, NOW(), NULL, NULL),
  (:topic_id, 'Polinômios', 'Polinomios', 1, NOW(), NULL, NULL),
  (:topic_id, 'Logaritmos', 'Logaritmos', 1, NOW(), NULL, NULL);

-- -- Matemática > Geometria
SELECT topic_id FROM app.topic WHERE topic_name = 'Geometria';
 \gset
INSERT INTO app.subtopic (topic_id, subtopic_name, subtopic_name_friendly, created_by, created_on, modified_by, modified_on) VALUES
   (:topic_id, 'Geometria Plana', 'Geometria Plana', 1, NOW(), NULL, NULL),
   (:topic_id, 'Geometria Espacial', 'Geometria Espacial', 1, NOW(), NULL, NULL),
   (:topic_id, 'Semelhança de Triângulos', 'Semelhanca de Triangulos', 1, NOW(), NULL, NULL),
   (:topic_id, 'Áreas e Perímetros', 'Areas e Perimetros', 1, NOW(), NULL, NULL),
   (:topic_id, 'Trigonometria no Triângulo Retângulo', 'Trigonometria no Triangulo Retangulo', 1, NOW(), NULL, NULL);

-- -- Matemática > Funções
 SELECT topic_id FROM app.topic WHERE topic_name = 'Funções';
 \gset
 INSERT INTO app.subtopic (topic_id, subtopic_name, subtopic_name_friendly, created_by, created_on, modified_by, modified_on) VALUES
   (:topic_id, 'Função do 1º grau', 'Funcao do 1 grau', 1, NOW(), NULL, NULL),
   (:topic_id, 'Função do 2º grau', 'Funcao do 2 grau', 1, NOW(), NULL, NULL),
   (:topic_id, 'Função Exponencial', 'Funcao Exponencial', 1, NOW(), NULL, NULL),
   (:topic_id, 'Função Logarítmica', 'Funcao Logaritmica', 1, NOW(), NULL, NULL);

-- -- Matemática > Probabilidade e Estatística
SELECT topic_id FROM app.topic WHERE topic_name = 'Probabilidade e Estatística';
 \gset
 INSERT INTO app.subtopic (topic_id, subtopic_name, subtopic_name_friendly, created_by, created_on, modified_by, modified_on) VALUES
   (:topic_id, 'Análise Combinatória', 'Analise Combinatoria', 1, NOW(), NULL, NULL),
   (:topic_id, 'Probabilidade', 'Probabilidade', 1, NOW(), NULL, NULL),
   (:topic_id, 'Estatística Descritiva', 'Estatistica Descritiva', 1, NOW(), NULL, NULL),
   (:topic_id, 'Média, Moda e Mediana', 'Media Moda e Mediana', 1, NOW(), NULL, NULL);

-- -- Matemática > Trigonometria
 SELECT topic_id FROM app.topic WHERE topic_name = 'Trigonometria';
 \gset
 INSERT INTO app.subtopic (topic_id, subtopic_name, subtopic_name_friendly, created_by, created_on, modified_by, modified_on) VALUES
   (:topic_id, 'Seno, Cosseno e Tangente', 'Seno Cosseno e Tangente', 1, NOW(), NULL, NULL),
   (:topic_id, 'Círculo Trigonométrico', 'Circulo Trigonometrico', 1, NOW(), NULL, NULL),
   (:topic_id, 'Funções Trigonométricas', 'Funcoes Trigonometricas', 1, NOW(), NULL, NULL);

-- Progressões (PA e PG) em Álgebra
SELECT topic_id FROM app.topic WHERE topic_name = 'Álgebra';
\gset
INSERT INTO app.subtopic (topic_id, subtopic_name, subtopic_name_friendly, created_by, created_on, modified_by, modified_on) VALUES
  (:topic_id, 'Progressão Aritmética (PA)', 'Progresao Aritmetica PA', 1, NOW(), NULL, NULL),
  (:topic_id, 'Progressão Geométrica (PG)', 'Progresao Geometrica PG', 1, NOW(), NULL, NULL),
  (:topic_id, 'Soma dos termos de PA', 'Soma dos termos de PA', 1, NOW(), NULL, NULL),
  (:topic_id, 'Soma dos termos de PG', 'Soma dos termos de PG', 1, NOW(), NULL, NULL);

-- Geometria Analítica
SELECT topic_id FROM app.topic WHERE topic_name = 'Geometria';
\gset
INSERT INTO app.subtopic (topic_id, subtopic_name, subtopic_name_friendly, created_by, created_on, modified_by, modified_on) VALUES
  (:topic_id, 'Ponto e Distância', 'Ponto e Distancia', 1, NOW(), NULL, NULL),
  (:topic_id, 'Equação da Reta', 'Equacao da Reta', 1, NOW(), NULL, NULL),
  (:topic_id, 'Circunferência', 'Circunferencia', 1, NOW(), NULL, NULL),
  (:topic_id, 'Parábola', 'Parabola', 1, NOW(), NULL, NULL),
  (:topic_id, 'Elipse', 'Elipse', 1, NOW(), NULL, NULL),
  (:topic_id, 'Hipérbole', 'Hiperbole', 1, NOW(), NULL, NULL);

-- Poliedros e Corpos Redondos em Geometria
INSERT INTO app.subtopic (topic_id, subtopic_name, subtopic_name_friendly, created_by, created_on, modified_by, modified_on) VALUES
  (:topic_id, 'Prismas', 'Prismas', 1, NOW(), NULL, NULL),
  (:topic_id, 'Pirâmides', 'Piramides', 1, NOW(), NULL, NULL),
  (:topic_id, 'Cilindros', 'Cilindros', 1, NOW(), NULL, NULL),
  (:topic_id, 'Cones', 'Cones', 1, NOW(), NULL, NULL),
  (:topic_id, 'Esferas', 'Esferas', 1, NOW(), NULL, NULL);

-- Conjuntos e Lógica em Aritmética
SELECT topic_id FROM app.topic WHERE topic_name = 'Aritmética';
\gset
INSERT INTO app.subtopic (topic_id, subtopic_name, subtopic_name_friendly, created_by, created_on, modified_by, modified_on) VALUES
  (:topic_id, 'Noções de Conjuntos', 'Nocoes de Conjuntos', 1, NOW(), NULL, NULL),
  (:topic_id, 'Operações com Conjuntos', 'Operacoes com Conjuntos', 1, NOW(), NULL, NULL),
  (:topic_id, 'Diagramas de Venn', 'Diagramas de Venn', 1, NOW(), NULL, NULL),
  (:topic_id, 'Noções de Lógica', 'Nocoes de Logica', 1, NOW(), NULL, NULL);

-- Análise Combinatória em Probabilidade e Estatística
SELECT topic_id FROM app.topic WHERE topic_name = 'Probabilidade e Estatística';
\gset
INSERT INTO app.subtopic (topic_id, subtopic_name, subtopic_name_friendly, created_by, created_on, modified_by, modified_on) VALUES
  (:topic_id, 'Arranjos', 'Arranjos', 1, NOW(), NULL, NULL),
  (:topic_id, 'Permutações', 'Permutacoes', 1, NOW(), NULL, NULL),
  (:topic_id, 'Combinações', 'Combinacoes', 1, NOW(), NULL, NULL);

-- Estatística Avançada em Probabilidade e Estatística
INSERT INTO app.subtopic (topic_id, subtopic_name, subtopic_name_friendly, created_by, created_on, modified_by, modified_on) VALUES
  (:topic_id, 'Desvio Padrão', 'Desvio Padrao', 1, NOW(), NULL, NULL),
  (:topic_id, 'Variância', 'Variancia', 1, NOW(), NULL, NULL);

 -- Matrizes e Determinantes (Álgebra)
SELECT topic_id FROM app.topic WHERE topic_name = 'Álgebra';
\gset
INSERT INTO app.subtopic (topic_id, subtopic_name, subtopic_name_friendly, created_by, created_on, modified_by, modified_on) VALUES
  (:topic_id, 'Matrizes', 'Matrizes', 1, NOW(), NULL, NULL),
  (:topic_id, 'Determinantes', 'Determinantes', 1, NOW(), NULL, NULL),
  (:topic_id, 'Sequências Numéricas', 'Sequencias Numericas', 1, NOW(), NULL, NULL),
  (:topic_id, 'Teorema do Resto', 'Teorema do Resto', 1, NOW(), NULL, NULL),
  (:topic_id, 'Teorema das Raízes', 'Teorema das Raizes', 1, NOW(), NULL, NULL),
  (:topic_id, 'Números Complexos', 'Numeros Complexos', 1, NOW(), NULL, NULL);

-- Transformações Geométricas (Geometria)
SELECT topic_id FROM app.topic WHERE topic_name = 'Geometria';
\gset
INSERT INTO app.subtopic (topic_id, subtopic_name, subtopic_name_friendly, created_by, created_on, modified_by, modified_on) VALUES
  (:topic_id, 'Transformações Geométricas', 'Transformacoes Geometricas', 1, NOW(), NULL, NULL);
 

 SELECT topic_id FROM app.topic WHERE topic_name = 'Aritmética';
\gset
INSERT INTO app.subtopic (topic_id, subtopic_name, subtopic_name_friendly, created_by, created_on, modified_by, modified_on) VALUES
  (:topic_id, 'Divisibilidade Avançada', 'Divisibilidade Avancada', 1, NOW(), NULL, NULL),
  (:topic_id, 'Números Primos', 'Numeros Primos', 1, NOW(), NULL, NULL),
  (:topic_id, 'Congruência', 'Congruencia', 1, NOW(), NULL, NULL);

SELECT topic_id FROM app.topic WHERE topic_name = 'Funções';
\gset
INSERT INTO app.subtopic (topic_id, subtopic_name, subtopic_name_friendly, created_by, created_on, modified_by, modified_on) VALUES
  (:topic_id, 'Função Modular', 'Funcao Modular', 1, NOW(), NULL, NULL),
  (:topic_id, 'Função por Partes', 'Funcao por Partes', 1, NOW(), NULL, NULL);

SELECT topic_id FROM app.topic WHERE topic_name = 'Funções';
\gset
INSERT INTO app.subtopic (topic_id, subtopic_name, subtopic_name_friendly, created_by, created_on, modified_by, modified_on) VALUES
  (:topic_id, 'Otimização e Modelagem', 'Otimizacao e Modelagem', 1, NOW(), NULL, NULL);

SELECT topic_id FROM app.topic WHERE topic_name = 'Matemática Financeira';
\gset
INSERT INTO app.subtopic (topic_id, subtopic_name, subtopic_name_friendly, created_by, created_on, modified_by, modified_on) VALUES
  (:topic_id, 'Séries de Pagamentos', 'Series de Pagamentos', 1, NOW(), NULL, NULL);

-- Propriedades dos Logaritmos em Álgebra
SELECT topic_id FROM app.topic WHERE topic_name = 'Álgebra';
\gset
INSERT INTO app.subtopic (topic_id, subtopic_name, subtopic_name_friendly, created_by, created_on, modified_by, modified_on) VALUES
  (:topic_id, 'Propriedades dos Logaritmos', 'Propriedades dos Logaritmos', 1, NOW(), NULL, NULL);

-- Sistemas Não Lineares em Álgebra
INSERT INTO app.subtopic (topic_id, subtopic_name, subtopic_name_friendly, created_by, created_on, modified_by, modified_on) VALUES
  (:topic_id, 'Sistemas Não Lineares', 'Sistemas Nao Lineares', 1, NOW(), NULL, NULL);


 -- Mecânica
SELECT topic_id FROM app.topic WHERE topic_name = 'Mecânica';
\gset
INSERT INTO app.subtopic (topic_id, subtopic_name, subtopic_name_friendly, created_by, created_on, modified_by, modified_on) VALUES
  (:topic_id, 'Cinemática', 'Cinematica', 1, NOW(), NULL, NULL),
  (:topic_id, 'Dinâmica', 'Dinamica', 1, NOW(), NULL, NULL),
  (:topic_id, 'Estática', 'Estatica', 1, NOW(), NULL, NULL),
  (:topic_id, 'Trabalho e Energia', 'Trabalho e Energia', 1, NOW(), NULL, NULL),
  (:topic_id, 'Quantidade de Movimento', 'Quantidade de Movimento', 1, NOW(), NULL, NULL),
  (:topic_id, 'Movimento Circular', 'Movimento Circular', 1, NOW(), NULL, NULL);

-- Gravitação
SELECT topic_id FROM app.topic WHERE topic_name = 'Gravitação';
\gset
INSERT INTO app.subtopic (topic_id, subtopic_name, subtopic_name_friendly, created_by, created_on, modified_by, modified_on) VALUES
  (:topic_id, 'Lei da Gravitação Universal', 'Lei da Gravitacao Universal', 1, NOW(), NULL, NULL),
  (:topic_id, 'Satélites e Órbitas', 'Satelites e Orbitas', 1, NOW(), NULL, NULL),
  (:topic_id, 'Peso e Massa', 'Peso e Massa', 1, NOW(), NULL, NULL);

-- Hidrostática
SELECT topic_id FROM app.topic WHERE topic_name = 'Hidrostática';
\gset
INSERT INTO app.subtopic (topic_id, subtopic_name, subtopic_name_friendly, created_by, created_on, modified_by, modified_on) VALUES
  (:topic_id, 'Pressão', 'Pressao', 1, NOW(), NULL, NULL),
  (:topic_id, 'Empuxo', 'Empuxo', 1, NOW(), NULL, NULL),
  (:topic_id, 'Princípio de Pascal', 'Principio de Pascal', 1, NOW(), NULL, NULL),
  (:topic_id, 'Princípio de Arquimedes', 'Principio de Arquimedes', 1, NOW(), NULL, NULL);

-- Termologia
SELECT topic_id FROM app.topic WHERE topic_name = 'Termologia';
\gset
INSERT INTO app.subtopic (topic_id, subtopic_name, subtopic_name_friendly, created_by, created_on, modified_by, modified_on) VALUES
  (:topic_id, 'Calorimetria', 'Calorimetria', 1, NOW(), NULL, NULL),
  (:topic_id, 'Termometria', 'Termometria', 1, NOW(), NULL, NULL),
  (:topic_id, 'Dilatação Térmica', 'Dilatacao Termica', 1, NOW(), NULL, NULL),
  (:topic_id, 'Mudanças de Estado Físico', 'Mudancas de Estado Fisico', 1, NOW(), NULL, NULL),
  (:topic_id, 'Leis dos Gases', 'Leis dos Gases', 1, NOW(), NULL, NULL);

-- Óptica
SELECT topic_id FROM app.topic WHERE topic_name = 'Óptica';
\gset
INSERT INTO app.subtopic (topic_id, subtopic_name, subtopic_name_friendly, created_by, created_on, modified_by, modified_on) VALUES
  (:topic_id, 'Óptica Geométrica', 'Optica Geometrica', 1, NOW(), NULL, NULL),
  (:topic_id, 'Reflexão', 'Reflexao', 1, NOW(), NULL, NULL),
  (:topic_id, 'Refração', 'Refracao', 1, NOW(), NULL, NULL),
  (:topic_id, 'Espelhos', 'Espelhos', 1, NOW(), NULL, NULL),
  (:topic_id, 'Lentes', 'Lentes', 1, NOW(), NULL, NULL);

-- Ondulatória
SELECT topic_id FROM app.topic WHERE topic_name = 'Ondulatória';
\gset
INSERT INTO app.subtopic (topic_id, subtopic_name, subtopic_name_friendly, created_by, created_on, modified_by, modified_on) VALUES
  (:topic_id, 'Propriedades das Ondas', 'Propriedades das Ondas', 1, NOW(), NULL, NULL),
  (:topic_id, 'Som', 'Som', 1, NOW(), NULL, NULL),
  (:topic_id, 'Luz como Onda', 'Luz como Onda', 1, NOW(), NULL, NULL),
  (:topic_id, 'Frequência e Comprimento de Onda', 'Frequencia e Comprimento de Onda', 1, NOW(), NULL, NULL),
  (:topic_id, 'Interferência e Difração', 'Interferencia e Difracao', 1, NOW(), NULL, NULL);

-- Eletricidade
SELECT topic_id FROM app.topic WHERE topic_name = 'Eletricidade';
\gset
INSERT INTO app.subtopic (topic_id, subtopic_name, subtopic_name_friendly, created_by, created_on, modified_by, modified_on) VALUES
  (:topic_id, 'Eletrostática', 'Eletrostatica', 1, NOW(), NULL, NULL),
  (:topic_id, 'Corrente Elétrica', 'Corrente Eletrica', 1, NOW(), NULL, NULL),
  (:topic_id, 'Resistores', 'Resistores', 1, NOW(), NULL, NULL),
  (:topic_id, 'Leis de Ohm', 'Leis de Ohm', 1, NOW(), NULL, NULL),
  (:topic_id, 'Circuitos Elétricos', 'Circuitos Eletricos', 1, NOW(), NULL, NULL);

-- Eletromagnetismo
SELECT topic_id FROM app.topic WHERE topic_name = 'Eletromagnetismo';
\gset
INSERT INTO app.subtopic (topic_id, subtopic_name, subtopic_name_friendly, created_by, created_on, modified_by, modified_on) VALUES
  (:topic_id, 'Campo Magnético', 'Campo Magnetico', 1, NOW(), NULL, NULL),
  (:topic_id, 'Força Magnética', 'Forca Magnetica', 1, NOW(), NULL, NULL),
  (:topic_id, 'Indução Eletromagnética', 'Inducao Eletromagnetica', 1, NOW(), NULL, NULL),
  (:topic_id, 'Geradores e Motores', 'Geradores e Motores', 1, NOW(), NULL, NULL);

-- Física Moderna
SELECT topic_id FROM app.topic WHERE topic_name = 'Física Moderna';
\gset
INSERT INTO app.subtopic (topic_id, subtopic_name, subtopic_name_friendly, created_by, created_on, modified_by, modified_on) VALUES
  (:topic_id, 'Física Quântica', 'Fisica Quantica', 1, NOW(), NULL, NULL),
  (:topic_id, 'Relatividade', 'Relatividade', 1, NOW(), NULL, NULL),
  (:topic_id, 'Física Nuclear', 'Fisica Nuclear', 1, NOW(), NULL, NULL),
  (:topic_id, 'Radioatividade', 'Radioatividade', 1, NOW(), NULL, NULL);

-- Termologia: Máquinas térmicas
SELECT topic_id FROM app.topic WHERE topic_name = 'Termologia';
\gset
INSERT INTO app.subtopic (topic_id, subtopic_name, subtopic_name_friendly, created_by, created_on, modified_by, modified_on) VALUES
  (:topic_id, 'Máquinas Térmicas', 'Maquinas Termicas', 1, NOW(), NULL, NULL);

-- Óptica: Espelhos esféricos e Lentes esféricas
SELECT topic_id FROM app.topic WHERE topic_name = 'Óptica';
\gset
INSERT INTO app.subtopic (topic_id, subtopic_name, subtopic_name_friendly, created_by, created_on, modified_by, modified_on) VALUES
  (:topic_id, 'Espelhos Esféricos', 'Espelhos Esfericos', 1, NOW(), NULL, NULL),
  (:topic_id, 'Lentes Esféricas', 'Lentes Esfericas', 1, NOW(), NULL, NULL);

-- Mecânica: Princípios de conservação
SELECT topic_id FROM app.topic WHERE topic_name = 'Mecânica';
\gset
INSERT INTO app.subtopic (topic_id, subtopic_name, subtopic_name_friendly, created_by, created_on, modified_by, modified_on) VALUES
  (:topic_id, 'Conservação de Energia', 'Conservacao de Energia', 1, NOW(), NULL, NULL),
  (:topic_id, 'Conservação da Quantidade de Movimento', 'Conservacao da Quantidade de Movimento', 1, NOW(), NULL, NULL);

-- Erros de medição e algarismos significativos
SELECT topic_id FROM app.topic WHERE topic_name = 'Mecânica';
\gset
INSERT INTO app.subtopic (topic_id, subtopic_name, subtopic_name_friendly, created_by, created_on, modified_by, modified_on) VALUES
  (:topic_id, 'Erros de Medição', 'Erros de Medicao', 1, NOW(), NULL, NULL),
  (:topic_id, 'Algarismos Significativos', 'Algarismos Significativos', 1, NOW(), NULL, NULL);

-- Unidades de medida
INSERT INTO app.subtopic (topic_id, subtopic_name, subtopic_name_friendly, created_by, created_on, modified_by, modified_on) VALUES
  (:topic_id, 'Unidades de Medida', 'Unidades de Medida', 1, NOW(), NULL, NULL),
  (:topic_id, 'Conversão de Unidades', 'Conversao de Unidades', 1, NOW(), NULL, NULL);

 -- Citologia
SELECT topic_id FROM app.topic WHERE topic_name = 'Citologia';
\gset
INSERT INTO app.subtopic (topic_id, subtopic_name, subtopic_name_friendly, created_by, created_on, modified_by, modified_on) VALUES
  (:topic_id, 'Membrana Plasmática', 'Membrana Plasmatica', 1, NOW(), NULL, NULL),
  (:topic_id, 'Organelas Celulares', 'Organelas Celulares', 1, NOW(), NULL, NULL),
  (:topic_id, 'Ciclo Celular', 'Ciclo Celular', 1, NOW(), NULL, NULL),
  (:topic_id, 'Divisão Celular', 'Divisao Celular', 1, NOW(), NULL, NULL),
  (:topic_id, 'Metabolismo Celular', 'Metabolismo Celular', 1, NOW(), NULL, NULL);

-- Histologia
SELECT topic_id FROM app.topic WHERE topic_name = 'Histologia';
\gset
INSERT INTO app.subtopic (topic_id, subtopic_name, subtopic_name_friendly, created_by, created_on, modified_by, modified_on) VALUES
  (:topic_id, 'Tecidos Epiteliais', 'Tecidos Epiteliais', 1, NOW(), NULL, NULL),
  (:topic_id, 'Tecidos Conjuntivos', 'Tecidos Conjuntivos', 1, NOW(), NULL, NULL),
  (:topic_id, 'Tecidos Musculares', 'Tecidos Musculares', 1, NOW(), NULL, NULL),
  (:topic_id, 'Tecidos Nervosos', 'Tecidos Nervosos', 1, NOW(), NULL, NULL);

-- Fisiologia
SELECT topic_id FROM app.topic WHERE topic_name = 'Fisiologia';
\gset
INSERT INTO app.subtopic (topic_id, subtopic_name, subtopic_name_friendly, created_by, created_on, modified_by, modified_on) VALUES
  (:topic_id, 'Sistema Digestório', 'Sistema Digestorio', 1, NOW(), NULL, NULL),
  (:topic_id, 'Sistema Respiratório', 'Sistema Respiratorio', 1, NOW(), NULL, NULL),
  (:topic_id, 'Sistema Circulatório', 'Sistema Circulatorio', 1, NOW(), NULL, NULL),
  (:topic_id, 'Sistema Excretor', 'Sistema Excretor', 1, NOW(), NULL, NULL),
  (:topic_id, 'Sistema Nervoso', 'Sistema Nervoso', 1, NOW(), NULL, NULL),
  (:topic_id, 'Sistema Endócrino', 'Sistema Endocrino', 1, NOW(), NULL, NULL),
  (:topic_id, 'Sistema Reprodutor', 'Sistema Reprodutor', 1, NOW(), NULL, NULL),
  (:topic_id, 'Sistema Imunológico', 'Sistema Imunologico', 1, NOW(), NULL, NULL);

-- Genética
SELECT topic_id FROM app.topic WHERE topic_name = 'Genética';
\gset
INSERT INTO app.subtopic (topic_id, subtopic_name, subtopic_name_friendly, created_by, created_on, modified_by, modified_on) VALUES
  (:topic_id, 'DNA e RNA', 'DNA e RNA', 1, NOW(), NULL, NULL),
  (:topic_id, 'Leis de Mendel', 'Leis de Mendel', 1, NOW(), NULL, NULL),
  (:topic_id, 'Genética Molecular', 'Genetica Molecular', 1, NOW(), NULL, NULL),
  (:topic_id, 'Mutações', 'Mutacoes', 1, NOW(), NULL, NULL),
  (:topic_id, 'Herança Genética', 'Heranca Genetica', 1, NOW(), NULL, NULL),
  (:topic_id, 'Genética de Populações', 'Genetica de Populacoes', 1, NOW(), NULL, NULL),
  (:topic_id, 'Biotecnologia', 'Biotecnologia', 1, NOW(), NULL, NULL);

-- Evolução
SELECT topic_id FROM app.topic WHERE topic_name = 'Evolução';
\gset
INSERT INTO app.subtopic (topic_id, subtopic_name, subtopic_name_friendly, created_by, created_on, modified_by, modified_on) VALUES
  (:topic_id, 'Teorias Evolutivas', 'Teorias Evolutivas', 1, NOW(), NULL, NULL),
  (:topic_id, 'Seleção Natural', 'Selecao Natural', 1, NOW(), NULL, NULL),
  (:topic_id, 'Especiação', 'Especiacao', 1, NOW(), NULL, NULL),
  (:topic_id, 'Evidências da Evolução', 'Evidencias da Evolucao', 1, NOW(), NULL, NULL),
  (:topic_id, 'Adaptação', 'Adaptacao', 1, NOW(), NULL, NULL);

-- Ecologia
-- SELECT topic_id FROM app.topic WHERE topic_name = 'Ecologia';
-- \gset
-- INSERT INTO app.subtopic (topic_id, subtopic_name, subtopic_name_friendly, created_by, created_on, modified_by, modified_on) VALUES
--   (:topic_id, 'Cadeias e Teias Alimentares', 'Cadeias e Teias Alimentares', 1, NOW(), NULL, NULL),
--   (:topic_id, 'Ciclos Biogeoquímicos', 'Ciclos Biogeoquimicos', 1, NOW(), NULL, NULL),
--   (:topic_id, 'Populações e Comunidades', 'Populacoes e Comunidades', 1, NOW(), NULL, NULL),
--   (:topic_id, 'Sucessão Ecológica', 'Sucessao Ecologica', 1, NOW(), NULL, NULL),
--   (:topic_id, 'Sustentabilidade', 'Sustentabilidade', 1, NOW(), NULL, NULL),
--   (:topic_id, 'Poluição', 'Poluicao', 1, NOW(), NULL, NULL),
--   (:topic_id, 'Impactos Ambientais', 'Impactos Ambientais', 1, NOW(), NULL, NULL);

-- Botânica
SELECT topic_id FROM app.topic WHERE topic_name = 'Botânica';
\gset
INSERT INTO app.subtopic (topic_id, subtopic_name, subtopic_name_friendly, created_by, created_on, modified_by, modified_on) VALUES
  (:topic_id, 'Classificação dos Vegetais', 'Classificacao dos Vegetais', 1, NOW(), NULL, NULL),
  (:topic_id, 'Fisiologia Vegetal', 'Fisiologia Vegetal', 1, NOW(), NULL, NULL),
  (:topic_id, 'Reprodução Vegetal', 'Reproducao Vegetal', 1, NOW(), NULL, NULL),
  (:topic_id, 'Tecidos Vegetais', 'Tecidos Vegetais', 1, NOW(), NULL, NULL),
  (:topic_id, 'Fotossíntese', 'Fotossintese', 1, NOW(), NULL, NULL);

-- Zoologia
SELECT topic_id FROM app.topic WHERE topic_name = 'Zoologia';
\gset
INSERT INTO app.subtopic (topic_id, subtopic_name, subtopic_name_friendly, created_by, created_on, modified_by, modified_on) VALUES
  (:topic_id, 'Classificação dos Animais', 'Classificacao dos Animais', 1, NOW(), NULL, NULL),
  (:topic_id, 'Fisiologia Animal', 'Fisiologia Animal', 1, NOW(), NULL, NULL),
  (:topic_id, 'Reprodução Animal', 'Reproducao Animal', 1, NOW(), NULL, NULL),
  (:topic_id, 'Desenvolvimento Animal', 'Desenvolvimento Animal', 1, NOW(), NULL, NULL),
  (:topic_id, 'Grupos de Animais', 'Grupos de Animais', 1, NOW(), NULL, NULL);

-- Microbiologia
SELECT topic_id FROM app.topic WHERE topic_name = 'Microbiologia';
\gset
INSERT INTO app.subtopic (topic_id, subtopic_name, subtopic_name_friendly, created_by, created_on, modified_by, modified_on) VALUES
  (:topic_id, 'Vírus', 'Virus', 1, NOW(), NULL, NULL),
  (:topic_id, 'Bactérias', 'Bacterias', 1, NOW(), NULL, NULL),
  (:topic_id, 'Protozoários', 'Protozoarios', 1, NOW(), NULL, NULL),
  (:topic_id, 'Fungos', 'Fungos', 1, NOW(), NULL, NULL),
  (:topic_id, 'Doenças Microbianas', 'Doencas Microbianas', 1, NOW(), NULL, NULL);

-- Imunologia
SELECT topic_id FROM app.topic WHERE topic_name = 'Imunologia';
\gset
INSERT INTO app.subtopic (topic_id, subtopic_name, subtopic_name_friendly, created_by, created_on, modified_by, modified_on) VALUES
  (:topic_id, 'Sistema Imunológico', 'Sistema Imunologico', 1, NOW(), NULL, NULL),
  (:topic_id, 'Imunidade Inata', 'Imunidade Inata', 1, NOW(), NULL, NULL),
  (:topic_id, 'Imunidade Adquirida', 'Imunidade Adquirida', 1, NOW(), NULL, NULL),
  (:topic_id, 'Vacinas', 'Vacinas', 1, NOW(), NULL, NULL),
  (:topic_id, 'Alergias e Doenças Autoimunes', 'Alergias e Doencas Autoimunes', 1, NOW(), NULL, NULL);

-- Histologia (extra)
SELECT topic_id FROM app.topic WHERE topic_name = 'Histologia';
\gset
INSERT INTO app.subtopic (topic_id, subtopic_name, subtopic_name_friendly, created_by, created_on, modified_by, modified_on) VALUES
  (:topic_id, 'Tecidos Vegetais', 'Tecidos Vegetais', 1, NOW(), NULL, NULL);
  
-- Bioquímica (opcional, se criar o tópico)
SELECT topic_id FROM app.topic WHERE topic_name = 'Bioquímica';
\gset
INSERT INTO app.subtopic (topic_id, subtopic_name, subtopic_name_friendly, created_by, created_on, modified_by, modified_on) VALUES
  (:topic_id, 'Ácidos Nucleicos', 'Acidos Nucleicos', 1, NOW(), NULL, NULL),
  (:topic_id, 'Carboidratos', 'Carboidratos', 1, NOW(), NULL, NULL),
  (:topic_id, 'Lipídeos', 'Lipideos', 1, NOW(), NULL, NULL),
  (:topic_id, 'Proteínas', 'Proteinas', 1, NOW(), NULL, NULL),
  (:topic_id, 'Vitaminas', 'Vitaminas', 1, NOW(), NULL, NULL),
  (:topic_id, 'Enzimas', 'Enzimas', 1, NOW(), NULL, NULL);

-- Embriologia (opcional, se criar o tópico)
SELECT topic_id FROM app.topic WHERE topic_name = 'Embriologia';
\gset
INSERT INTO app.subtopic (topic_id, subtopic_name, subtopic_name_friendly, created_by, created_on, modified_by, modified_on) VALUES
  (:topic_id, 'Fecundação', 'Fecundacao', 1, NOW(), NULL, NULL),
  (:topic_id, 'Segmentação', 'Segmentacao', 1, NOW(), NULL, NULL),
  (:topic_id, 'Gastrulação', 'Gastrulacao', 1, NOW(), NULL, NULL),
  (:topic_id, 'Organogênese', 'Organogenese', 1, NOW(), NULL, NULL);

-- Parasitologia (opcional, se criar o tópico)
SELECT topic_id FROM app.topic WHERE topic_name = 'Parasitologia';
\gset
INSERT INTO app.subtopic (topic_id, subtopic_name, subtopic_name_friendly, created_by, created_on, modified_by, modified_on) VALUES
  (:topic_id, 'Protozooses', 'Protozooses', 1, NOW(), NULL, NULL),
  (:topic_id, 'Helmintíases', 'Helmintiases', 1, NOW(), NULL, NULL),
  (:topic_id, 'Ectoparasitoses', 'Ectoparasitoses', 1, NOW(), NULL, NULL);


 -- Química Geral
SELECT topic_id FROM app.topic WHERE topic_name = 'Química Geral';
\gset
INSERT INTO app.subtopic (topic_id, subtopic_name, subtopic_name_friendly, created_by, created_on, modified_by, modified_on) VALUES
  (:topic_id, 'Estrutura Atômica', 'Estrutura Atomica', 1, NOW(), NULL, NULL),
  (:topic_id, 'Tabelas Periódicas', 'Tabelas Periodicas', 1, NOW(), NULL, NULL),
  (:topic_id, 'Propriedades Periódicas', 'Propriedades Periodicas', 1, NOW(), NULL, NULL),
  (:topic_id, 'Ligações Químicas', 'Ligacoes Quimicas', 1, NOW(), NULL, NULL),
  (:topic_id, 'Funções Químicas', 'Funcoes Quimicas', 1, NOW(), NULL, NULL),
  (:topic_id, 'Soluções', 'Solucoes', 1, NOW(), NULL, NULL),
  (:topic_id, 'Misturas e Separação de Misturas', 'Misturas e Separacao de Misturas', 1, NOW(), NULL, NULL);

-- Química Inorgânica
SELECT topic_id FROM app.topic WHERE topic_name = 'Química Inorgânica';
\gset
INSERT INTO app.subtopic (topic_id, subtopic_name, subtopic_name_friendly, created_by, created_on, modified_by, modified_on) VALUES
  (:topic_id, 'Ácidos', 'Acidos', 1, NOW(), NULL, NULL),
  (:topic_id, 'Bases', 'Bases', 1, NOW(), NULL, NULL),
  (:topic_id, 'Sais', 'Sais', 1, NOW(), NULL, NULL),
  (:topic_id, 'Óxidos', 'Oxidos', 1, NOW(), NULL, NULL),
  (:topic_id, 'Reações Inorgânicas', 'Reacoes Inorganicas', 1, NOW(), NULL, NULL),
  (:topic_id, 'Propriedades dos Compostos Inorgânicos', 'Propriedades dos Compostos Inorganicos', 1, NOW(), NULL, NULL);

-- Físico-Química
SELECT topic_id FROM app.topic WHERE topic_name = 'Fisico-Química';
\gset
INSERT INTO app.subtopic (topic_id, subtopic_name, subtopic_name_friendly, created_by, created_on, modified_by, modified_on) VALUES
  (:topic_id, 'Termoquímica', 'Termoquimica', 1, NOW(), NULL, NULL),
  (:topic_id, 'Eletroquímica', 'Eletroquimica', 1, NOW(), NULL, NULL),
  (:topic_id, 'Cinética Química', 'Cinetica Quimica', 1, NOW(), NULL, NULL),
  (:topic_id, 'Equilíbrio Químico', 'Equilibrio Quimico', 1, NOW(), NULL, NULL),
  (:topic_id, 'Soluções e Propriedades Coligativas', 'Solucoes e Propriedades Coligativas', 1, NOW(), NULL, NULL),
  (:topic_id, 'pH e pOH', 'pH e pOH', 1, NOW(), NULL, NULL),
  (:topic_id, 'Radioatividade', 'Radioatividade', 1, NOW(), NULL, NULL);

-- Química Orgânica
SELECT topic_id FROM app.topic WHERE topic_name = 'Química Orgânica';
\gset
INSERT INTO app.subtopic (topic_id, subtopic_name, subtopic_name_friendly, created_by, created_on, modified_by, modified_on) VALUES
  (:topic_id, 'Hidrocarbonetos', 'Hidrocarbonetos', 1, NOW(), NULL, NULL),
  (:topic_id, 'Funções Orgânicas', 'Funcoes Organicas', 1, NOW(), NULL, NULL),
  (:topic_id, 'Reações Orgânicas', 'Reacoes Organicas', 1, NOW(), NULL, NULL),
  (:topic_id, 'Isomeria', 'Isomeria', 1, NOW(), NULL, NULL),
  (:topic_id, 'Polímeros', 'Polimeros', 1, NOW(), NULL, NULL),
  (:topic_id, 'Biomoléculas', 'Biomoleculas', 1, NOW(), NULL, NULL);

-- Química Ambiental
SELECT topic_id FROM app.topic WHERE topic_name = 'Química Ambiental';
\gset
INSERT INTO app.subtopic (topic_id, subtopic_name, subtopic_name_friendly, created_by, created_on, modified_by, modified_on) VALUES
  (:topic_id, 'Poluição da Água', 'Poluicao da Agua', 1, NOW(), NULL, NULL),
  (:topic_id, 'Poluição do Ar', 'Poluicao do Ar', 1, NOW(), NULL, NULL),
  (:topic_id, 'Chuva Ácida', 'Chuva Acida', 1, NOW(), NULL, NULL),
  (:topic_id, 'Efeito Estufa e Aquecimento Global', 'Efeito Estufa e Aquecimento Global', 1, NOW(), NULL, NULL),
  (:topic_id, 'Tratamento de Água e Esgoto', 'Tratamento de Agua e Esgoto', 1, NOW(), NULL, NULL),
  (:topic_id, 'Sustentabilidade', 'Sustentabilidade', 1, NOW(), NULL, NULL),
  (:topic_id, 'Química do Cotidiano', 'Quimica do Cotidiano', 1, NOW(), NULL, NULL);

-- Estequiometria
SELECT topic_id FROM app.topic WHERE topic_name = 'Estequiometria';
\gset
INSERT INTO app.subtopic (topic_id, subtopic_name, subtopic_name_friendly, created_by, created_on, modified_by, modified_on) VALUES
  (:topic_id, 'Lei de Conservação das Massas', 'Lei de Conservacao das Massas', 1, NOW(), NULL, NULL),
  (:topic_id, 'Cálculos estequiométricos', 'Calculos estequiometricos', 1, NOW(), NULL, NULL),
  (:topic_id, 'Reagente Limitante', 'Reagente Limitante', 1, NOW(), NULL, NULL),
  (:topic_id, 'Rendimento de Reação', 'Rendimento de Reacao', 1, NOW(), NULL, NULL),
  (:topic_id, 'Volumes de Gases', 'Volumes de Gases', 1, NOW(), NULL, NULL),
  (:topic_id, 'Pureza de Reagentes', 'Pureza de Reagentes', 1, NOW(), NULL, NULL);
 
SELECT topic_id FROM app.topic WHERE topic_name = 'Química Analítica';
\gset
INSERT INTO app.subtopic (topic_id, subtopic_name, subtopic_name_friendly, created_by, created_on, modified_by, modified_on) VALUES
  (:topic_id, 'Volumetria', 'Volumetria', 1, NOW(), NULL, NULL),
  (:topic_id, 'Titulação', 'Titulacao', 1, NOW(), NULL, NULL),
  (:topic_id, 'Gravimetria', 'Gravimetria', 1, NOW(), NULL, NULL),
  (:topic_id, 'Análise Qualitativa', 'Analise Qualitativa', 1, NOW(), NULL, NULL),
  (:topic_id, 'Análise Quantitativa', 'Analise Quantitativa', 1, NOW(), NULL, NULL);










 INSERT INTO app.language (language_name, created_by)
VALUES ('inglês', 1),('espanhol', 1);


INSERT INTO app.year (year, year_name, year_name_friendly, created_by) VALUES
    (2010, 'dois mil e dez', 'dois mil e dez', 1),
    (2011, 'dois mil e onze', 'dois mil e onze', 1),
    (2012, 'dois mil e doze', 'dois mil e doze', 1),
    (2013, 'dois mil e treze', 'dois mil e treze', 1),
    (2014, 'dois mil e quatorze', 'dois mil e quatorze', 1),
    (2015, 'dois mil e quinze', 'dois mil e quinze', 1),
    (2016, 'dois mil e dezesseis', 'dois mil e dezesseis', 1),
    (2017, 'dois mil e dezessete', 'dois mil e dezessete', 1),
    (2018, 'dois mil e dezoito', 'dois mil e dezoito', 1),
    (2019, 'dois mil e dezenove', 'dois mil e dezenove', 1),
    (2020, 'dois mil e vinte', 'dois mil e vinte', 1),
    (2021, 'dois mil e vinte e um', 'dois mil e vinte e um', 1),
    (2022, 'dois mil e vinte e dois', 'dois mil e vinte e dois', 1),
    (2023, 'dois mil e vinte e três', 'dois mil e vinte e três', 1),
    (2024, 'dois mil e vinte e quatro', 'dois mil e vinte e quatro', 1),
    (2025, 'dois mil e vinte e cinco', 'dois mil e vinte e cinco', 1),
    (2026, 'dois mil e vinte e seis', 'dois mil e vinte e seis', 1),
    (2027, 'dois mil e vinte e sete', 'dois mil e vinte e sete', 1),
    (2028, 'dois mil e vinte e oito', 'dois mil e vinte e oito', 1),
    (2029, 'dois mil e vinte e nove', 'dois mil e vinte e nove', 1),
    (2030, 'dois mil e trinta', 'dois mil e trinta', 1);

 


-- SELECT topic_id FROM app.topic WHERE topic_name = 'Ecologia';
-- \gset
-- INSERT INTO app.subtopic (topic_id, subtopic_name, subtopic_name_friendly, created_by, created_on, modified_by, modified_on) VALUES
--   (:topic_id, 'Biomas Brasileiros', 'Biomas Brasileiros', 1, NOW(), NULL, NULL);


 --SELECT topic_id FROM app.topic WHERE topic_name = 'Gramática';
--  \gset
--  INSERT INTO app.subtopic (topic_id, subtopic_name, subtopic_name_friendly, created_by, created_on, modified_by, modified_on) VALUES
--    (:topic_id, 'Ortografia', 'Ortografia', 1, NOW(), NULL, NULL),
--    (:topic_id, 'Morfologia', 'Morfologia', 1, NOW(), NULL, NULL),
--    (:topic_id, 'Sintaxe', 'Sintaxe', 1, NOW(), NULL, NULL),
--    (:topic_id, 'Pontuação', 'Pontuacao', 1, NOW(), NULL, NULL),
--    (:topic_id, 'Concordância Verbal', 'Concordancia Verbal', 1, NOW(), NULL, NULL),
--    (:topic_id, 'Concordância Nominal', 'Concordancia Nominal', 1, NOW(), NULL, NULL);

-- -- Português > Gramática
--  SELECT topic_id FROM app.topic WHERE topic_name = 'Gramática';
--  \gset
--  INSERT INTO app.subtopic (topic_id, subtopic_name, subtopic_name_friendly, created_by, created_on, modified_by, modified_on) VALUES
--    (:topic_id, 'Ortografia', 'Ortografia', 1, NOW(), NULL, NULL),
--    (:topic_id, 'Morfologia', 'Morfologia', 1, NOW(), NULL, NULL),
--    (:topic_id, 'Sintaxe', 'Sintaxe', 1, NOW(), NULL, NULL),
--    (:topic_id, 'Pontuação', 'Pontuacao', 1, NOW(), NULL, NULL),
--    (:topic_id, 'Concordância Verbal', 'Concordancia Verbal', 1, NOW(), NULL, NULL),
--    (:topic_id, 'Concordância Nominal', 'Concordancia Nominal', 1, NOW(), NULL, NULL);

-- -- Português > Interpretação de Texto
--  SELECT topic_id FROM app.topic WHERE topic_name = 'Interpretação de Texto';
--  \gset
--  INSERT INTO app.subtopic (topic_id, subtopic_name, subtopic_name_friendly, created_by, created_on, modified_by, modified_on) VALUES
--    (:topic_id, 'Leitura Literal', 'Leitura Literal', 1, NOW(), NULL, NULL),
--    (:topic_id, 'Leitura Inferencial', 'Leitura Inferencial', 1, NOW(), NULL, NULL),
--    (:topic_id, 'Figuras de Linguagem', 'Figuras de Linguagem', 1, NOW(), NULL, NULL),
--    (:topic_id, 'Gêneros Textuais', 'Generos Textuais', 1, NOW(), NULL, NULL);

-- -- -- Ciências > Ecologia
--  SELECT topic_id FROM app.topic WHERE topic_name = 'Ecologia';
--  \gset
--  INSERT INTO app.subtopic (topic_id, subtopic_name, subtopic_name_friendly, created_by, created_on, modified_by, modified_on) VALUES
--    (:topic_id, 'Cadeia Alimentar', 'Cadeia Alimentar', 1, NOW(), NULL, NULL),
--    (:topic_id, 'Relações Ecológicas', 'Relacoes Ecologicas', 1, NOW(), NULL, NULL),
--    (:topic_id, 'Ciclos Biogeoquímicos', 'Ciclos Biogeoquimicos', 1, NOW(), NULL, NULL),
--    (:topic_id, 'Ecossistemas', 'Ecossistemas', 1, NOW(), NULL, NULL);

-- -- -- História > História do Brasil
--  SELECT topic_id FROM app.topic WHERE topic_name = 'História do Brasil';
--  \gset
--  INSERT INTO app.subtopic (topic_id, subtopic_name, subtopic_name_friendly, created_by, created_on, modified_by, modified_on) VALUES
--    (:topic_id, 'Período Colonial', 'Periodo Colonial', 1, NOW(), NULL, NULL),
--    (:topic_id, 'Independência', 'Independencia', 1, NOW(), NULL, NULL),
--    (:topic_id, 'Império', 'Imperio', 1, NOW(), NULL, NULL),
--    (:topic_id, 'República', 'Republica', 1, NOW(), NULL, NULL),
--    (:topic_id, 'Ditadura Militar', 'Ditadura Militar', 1, NOW(), NULL, NULL),
--    (:topic_id, 'Nova República', 'Nova Republica', 1, NOW(), NULL, NULL);

-- -- Geografia > Geografia Física
-- SELECT topic_id FROM app.topic WHERE topic_name = 'Geografia Física';
-- \gset
-- INSERT INTO app.subtopic (topic_id, subtopic_name, subtopic_name_friendly, created_by, created_on, modified_by, modified_on) VALUES
--   (:topic_id, 'Relevo', 'Relevo', 1, NOW(), NULL, NULL),
--   (:topic_id, 'Clima', 'Clima', 1, NOW(), NULL, NULL),
--   (:topic_id, 'Vegetação', 'Vegetacao', 1, NOW(), NULL, NULL),
--   (:topic_id, 'Hidrografia', 'Hidrografia', 1, NOW(), NULL, NULL),
--   (:topic_id, 'Solo', 'Solo', 1, NOW(), NULL, NULL);

-- -- Biologia > Genética
-- SELECT topic_id FROM app.topic WHERE topic_name = 'Genética';
-- \gset
-- INSERT INTO app.subtopic (topic_id, subtopic_name, subtopic_name_friendly, created_by, created_on, modified_by, modified_on) VALUES
--   (:topic_id, 'DNA e RNA', 'DNA e RNA', 1, NOW(), NULL, NULL),
--   (:topic_id, 'Herança Genética', 'Heranca Genetica', 1, NOW(), NULL, NULL),
--   (:topic_id, 'Mutação', 'Mutacao', 1, NOW(), NULL, NULL);

-- -- Física > Mecânica
-- SELECT topic_id FROM app.topic WHERE topic_name = 'Mecânica';
-- \gset
-- INSERT INTO app.subtopic (topic_id, subtopic_name, subtopic_name_friendly, created_by, created_on, modified_by, modified_on) VALUES
--   (:topic_id, 'Cinemática', 'Cinematica', 1, NOW(), NULL, NULL),
--   (:topic_id, 'Dinâmica', 'Dinamica', 1, NOW(), NULL, NULL),
--   (:topic_id, 'Estática', 'Estatica', 1, NOW(), NULL, NULL);

-- -- Química > Química Orgânica
-- SELECT topic_id FROM app.topic WHERE topic_name = 'Química Orgânica';
-- \gset
-- INSERT INTO app.subtopic (topic_id, subtopic_name, subtopic_name_friendly, created_by, created_on, modified_by, modified_on) VALUES
--   (:topic_id, 'Funções Orgânicas', 'Funcoes Organicas', 1, NOW(), NULL, NULL),
--   (:topic_id, 'Isomeria', 'Isomeria', 1, NOW(), NULL, NULL),
--   (:topic_id, 'Reações Orgânicas', 'Reacoes Organicas', 1, NOW(), NULL, NULL);

-- -- Inglês > Gramática
-- SELECT topic_id FROM app.topic WHERE topic_name = 'Gramática' AND subject_id = (SELECT subject_id FROM app.subject WHERE subject_name = 'Inglês');
-- \gset
-- INSERT INTO app.subtopic (topic_id, subtopic_name, subtopic_name_friendly, created_by, created_on, modified_by, modified_on) VALUES
--   (:topic_id, 'Verb Tenses', 'Verb Tenses', 1, NOW(), NULL, NULL),
--   (:topic_id, 'Articles', 'Articles', 1, NOW(), NULL, NULL),
--   (:topic_id, 'Pronouns', 'Pronouns', 1, NOW(), NULL, NULL);

-- -- Sociologia > Cultura
-- SELECT topic_id FROM app.topic WHERE topic_name = 'Cultura' AND subject_id = (SELECT subject_id FROM app.subject WHERE subject_name = 'Sociologia');
-- \gset
-- INSERT INTO app.subtopic (topic_id, subtopic_name, subtopic_name_friendly, created_by, created_on, modified_by, modified_on) VALUES
--   (:topic_id, 'Cultura Popular', 'Cultura Popular', 1, NOW(), NULL, NULL),
--   (:topic_id, 'Indústria Cultural', 'Industria Cultural', 1, NOW(), NULL, NULL);

-- -- Filosofia > Ética
-- SELECT topic_id FROM app.topic WHERE topic_name = 'Ética' AND subject_id = (SELECT subject_id FROM app.subject WHERE subject_name = 'Filosofia');
-- \gset
-- INSERT INTO app.subtopic (topic_id, subtopic_name, subtopic_name_friendly, created_by, created_on, modified_by, modified_on) VALUES
--   (:topic_id, 'Ética Aristotélica', 'Etica Aristotelica', 1, NOW(), NULL, NULL),
--   (:topic_id, 'Ética Kantiana', 'Etica Kantiana', 1, NOW(), NULL, NULL),
--   (:topic_id, 'Ética Utilitarista', 'Etica Utilitarista', 1, NOW(), NULL, NULL);





-- -- INSERT INTO app.account (
-- --     user_unique_id,  
-- --     username, 
-- --     email,
-- --     password_hash, 
-- --     password_salt, 
-- --     is_verified,  
-- --     is_active, 
-- --     is_locked, 
-- --     password_attempts, 
-- --     changed_initial_password, 
-- --     locked_time, 
-- --     created_by, 
-- --     created_on, 
-- --     modified_by, 
-- --     modified_on
-- -- ) VALUES (
-- --     uuid_generate_v4(),  -- Generate a new UUID
-- --     'System', 
-- --     'system@email.com',
-- --     'System', 
-- --     'System', 
-- --     true,  -- is_verified
-- --     true,  -- is_active
-- --     false,  -- is_locked
-- --     0,  -- password_attempts
-- --     true,  -- changed_initial_password
-- --     NULL,  -- locked_time
-- --     1,  -- created_by
-- --     current_timestamp,  -- created_on
-- --     1,  -- modified_by
-- --     current_timestamp  -- modified_on
-- -- );

-- -- CALL app.usp_seed();



-- DO $$
-- DECLARE
--     rec RECORD;
--     v_out_message TEXT;
-- BEGIN
--     FOR rec IN 
--         SELECT DISTINCT edicao FROM imp.vagas_ofertadas
--         WHERE edicao IS NOT NULL
--     LOOP
--         CALL app.usp_api_year_create(
--             rec.edicao::SMALLINT,     -- p_year (cast if needed)
--             'system',                 -- p_created_by
--             v_out_message,            -- OUT parameter
--             rec.edicao                -- p_year_name
--         );
--         -- Optionally print/log result:
--         RAISE NOTICE 'Inserted year %, result: %', rec.edicao, v_out_message;
--     END LOOP;
-- END;
-- $$;

-- DO $$
-- DECLARE
--     rec RECORD;
--     v_out_message TEXT;
-- BEGIN
--     FOR rec IN
--         SELECT DISTINCT
--             co_ies AS university_code,
--             no_ies AS university_name,
--             sg_ies AS university_abbr
--         FROM imp.vagas_ofertadas
--         WHERE co_ies IS NOT NULL
--     LOOP
--         CALL app.usp_api_university_create(
--             rec.university_code,
--             rec.university_name,
--             rec.university_abbr,
--             'system',
--             v_out_message
--         );
--         RAISE NOTICE 'Inserted university_code %, result: %', rec.university_code, v_out_message;
--     END LOOP;
-- END;
-- $$;

-- DO $$
-- DECLARE
--     rec RECORD;
--     v_out_message TEXT;
-- BEGIN
--     FOR rec IN
--         SELECT DISTINCT ds_organizacao_academica
--         FROM imp.vagas_ofertadas
--         WHERE ds_organizacao_academica IS NOT NULL
--     LOOP
--         CALL app.usp_api_academic_organization_create(
--             rec.ds_organizacao_academica,
--             'system',
--             v_out_message
--         );
--         RAISE NOTICE 'Inserted academic organization "%", result: %',
--             rec.ds_organizacao_academica, v_out_message;
--     END LOOP;
-- END;
-- $$;

-- DO $$
-- DECLARE
--     rec RECORD;
--     v_out_message TEXT;
-- BEGIN
--     FOR rec IN
--         SELECT DISTINCT ds_categoria_adm
--         FROM imp.vagas_ofertadas
--         WHERE ds_categoria_adm IS NOT NULL
--     LOOP
--         CALL app.usp_api_university_category_create(
--             rec.ds_categoria_adm,
--             'system',
--             v_out_message
--         );
--         RAISE NOTICE 'Inserted university_category "%", result: %',
--             rec.ds_categoria_adm, v_out_message;
--     END LOOP;
-- END;
-- $$;

-- DO $$
-- DECLARE
--     rec RECORD;
--     v_out_message TEXT;
-- BEGIN
--     FOR rec IN
--         SELECT DISTINCT no_campus
--         FROM imp.vagas_ofertadas
--         WHERE no_campus IS NOT NULL
--     LOOP
--         CALL app.usp_api_university_campus_create(
--             rec.no_campus,
--             'system',
--             v_out_message
--         );
--         RAISE NOTICE 'Inserted university_campus "%", result: %',
--             rec.no_campus, v_out_message;
--     END LOOP;
-- END;
-- $$;

-- DO $$
-- DECLARE
--     rec RECORD;
--     v_out_message TEXT;
-- BEGIN
--     FOR rec IN
--         SELECT DISTINCT ds_regiao
--         FROM imp.vagas_ofertadas
--         WHERE ds_regiao IS NOT NULL
--     LOOP
--         CALL app.usp_api_region_create(
--             rec.ds_regiao,
--             'system',
--             v_out_message
--         );
--         RAISE NOTICE 'Inserted region "%", result: %',
--             rec.ds_regiao, v_out_message;
--     END LOOP;
-- END;
-- $$;



-- DO $$
-- DECLARE
--     rec RECORD;
--     v_out_message TEXT;
-- BEGIN
--     FOR rec IN
--         SELECT DISTINCT no_curso
--         FROM imp.vagas_ofertadas
--         WHERE no_curso IS NOT NULL
--     LOOP
--         CALL app.usp_api_degree_create(
--             rec.no_curso,
--             'system',
--             v_out_message
--         );
--         RAISE NOTICE 'Inserted degree "%", result: %',
--             rec.no_curso, v_out_message;
--     END LOOP;
-- END;
-- $$;



-- DO $$
-- DECLARE
--     rec RECORD;
--     v_out_message TEXT;
-- BEGIN
--     FOR rec IN
--         SELECT DISTINCT ds_grau
--         FROM imp.vagas_ofertadas
--         WHERE ds_grau IS NOT NULL
--     LOOP
--         CALL app.usp_api_degree_level_create(
--             rec.ds_grau,
--             'system',
--             v_out_message
--         );
--         RAISE NOTICE 'Inserted degree level "%", result: %',
--             rec.ds_grau, v_out_message;
--     END LOOP;
-- END;
-- $$;

-- DO $$
-- DECLARE
--     rec RECORD;
--     v_out_message TEXT;
-- BEGIN
--     FOR rec IN
--         SELECT DISTINCT ds_turno
--         FROM imp.vagas_ofertadas
--         WHERE ds_turno IS NOT NULL
--     LOOP
--         CALL app.usp_api_shift_create(
--             rec.ds_turno,
--             'system',
--             v_out_message
--         );
--         RAISE NOTICE 'Inserted shift "%", result: %',
--             rec.ds_turno, v_out_message;
--     END LOOP;
-- END;
-- $$;

-- DO $$
-- DECLARE
--     rec RECORD;
--     v_out_message TEXT;
-- BEGIN
--     FOR rec IN
--         SELECT DISTINCT ds_periodicidade
--         FROM imp.vagas_ofertadas
--         WHERE ds_periodicidade IS NOT NULL
--     LOOP
--         CALL app.usp_api_frequency_create(
--             rec.ds_periodicidade,
--             'system',
--             v_out_message
--         );
--         RAISE NOTICE 'Inserted frequency "%", result: %',
--             rec.ds_periodicidade, v_out_message;
--     END LOOP;
-- END;
-- $$;









-- TRUNCATE TABLE app.state RESTART IDENTITY CASCADE;
-- TRUNCATE TABLE app.region RESTART IDENTITY CASCADE;

-- -- Insert all regions of Brazil
-- INSERT INTO app.region (region_name, region_name_friendly, created_by, created_on)
-- VALUES
-- ('Norte',     unaccent('Norte'),     'system', NOW()),
-- ('Nordeste',  unaccent('Nordeste'),  'system', NOW()),
-- ('Centro-Oeste', unaccent('Centro-Oeste'), 'system', NOW()),
-- ('Sudeste',   unaccent('Sudeste'),   'system', NOW()),
-- ('Sul',       unaccent('Sul'),       'system', NOW());

-- -- Insert all states of Brazil, assuming region_id mapping:
-- -- 1=Norte, 2=Nordeste, 3=Centro-Oeste, 4=Sudeste, 5=Sul

-- INSERT INTO app.state (
--     region_id, state_abbr, state_name, state_name_friendly, created_by, created_on
-- )
-- VALUES
-- -- Norte
-- (1, 'AC', 'Acre',         unaccent('Acre'),         'system', NOW()),
-- (1, 'AP', 'Amapá',        unaccent('Amapá'),        'system', NOW()),
-- (1, 'AM', 'Amazonas',     unaccent('Amazonas'),     'system', NOW()),
-- (1, 'PA', 'Pará',         unaccent('Pará'),         'system', NOW()),
-- (1, 'RO', 'Rondônia',     unaccent('Rondônia'),     'system', NOW()),
-- (1, 'RR', 'Roraima',      unaccent('Roraima'),      'system', NOW()),
-- (1, 'TO', 'Tocantins',    unaccent('Tocantins'),    'system', NOW()),

-- -- Nordeste
-- (2, 'AL', 'Alagoas',      unaccent('Alagoas'),      'system', NOW()),
-- (2, 'BA', 'Bahia',        unaccent('Bahia'),        'system', NOW()),
-- (2, 'CE', 'Ceará',        unaccent('Ceará'),        'system', NOW()),
-- (2, 'MA', 'Maranhão',     unaccent('Maranhão'),     'system', NOW()),
-- (2, 'PB', 'Paraíba',      unaccent('Paraíba'),      'system', NOW()),
-- (2, 'PE', 'Pernambuco',   unaccent('Pernambuco'),   'system', NOW()),
-- (2, 'PI', 'Piauí',        unaccent('Piauí'),        'system', NOW()),
-- (2, 'RN', 'Rio Grande do Norte', unaccent('Rio Grande do Norte'), 'system', NOW()),
-- (2, 'SE', 'Sergipe',      unaccent('Sergipe'),      'system', NOW()),

-- -- Centro-Oeste
-- (3, 'DF', 'Distrito Federal', unaccent('Distrito Federal'), 'system', NOW()),
-- (3, 'GO', 'Goiás',        unaccent('Goiás'),        'system', NOW()),
-- (3, 'MT', 'Mato Grosso',  unaccent('Mato Grosso'),  'system', NOW()),
-- (3, 'MS', 'Mato Grosso do Sul', unaccent('Mato Grosso do Sul'), 'system', NOW()),

-- -- Sudeste
-- (4, 'ES', 'Espírito Santo', unaccent('Espírito Santo'), 'system', NOW()),
-- (4, 'MG', 'Minas Gerais',  unaccent('Minas Gerais'), 'system', NOW()),
-- (4, 'RJ', 'Rio de Janeiro', unaccent('Rio de Janeiro'), 'system', NOW()),
-- (4, 'SP', 'São Paulo',     unaccent('São Paulo'),   'system', NOW()),

-- -- Sul
-- (5, 'PR', 'Paraná',       unaccent('Paraná'),       'system', NOW()),
-- (5, 'RS', 'Rio Grande do Sul', unaccent('Rio Grande do Sul'), 'system', NOW()),
-- (5, 'SC', 'Santa Catarina', unaccent('Santa Catarina'), 'system', NOW());


-- DO $$
-- DECLARE
--     v_out_message TEXT;
-- BEGIN
--     -- LB_PPI
--     CALL app.usp_api_quota_type_create(
--         'LB_PPI',
--         'Candidatos autodeclarados pretos, pardos ou indígenas, com renda familiar bruta per capita igual ou inferior a 1 salário mínimo e que tenham cursado integralmente o ensino médio em escolas públicas ou em escolas comunitárias que atuam no âmbito da educação do campo conveniadas com o poder público (Lei nº 12.711/2012).',
--         'PPI, baixa renda, escola pública',
--         'Candidatos autodeclarados pretos, pardos ou indígenas, com renda familiar bruta per capita igual ou inferior a 1 salário mínimo e que tenham cursado integralmente o ensino médio em escolas públicas ou em escolas comunitárias que atuam no âmbito da educação do campo conveniadas com o poder público (Lei nº 12.711/2012).',
--         'system',
--         v_out_message
--     ); RAISE NOTICE 'LB_PPI: %', v_out_message;

--     -- LI_PPI
--     CALL app.usp_api_quota_type_create(
--         'LI_PPI',
--         'Candidatos autodeclarados pretos, pardos ou indígenas, independentemente da renda, que tenham cursado integralmente o ensino médio em escolas públicas ou em escolas comunitárias que atuam no âmbito da educação do campo conveniadas com o poder público (Lei nº 12.711/2012).',
--         'PPI, qualquer renda, escola pública',
--         'Candidatos autodeclarados pretos, pardos ou indígenas, independentemente da renda, que tenham cursado integralmente o ensino médio em escolas públicas ou em escolas comunitárias que atuam no âmbito da educação do campo conveniadas com o poder público (Lei nº 12.711/2012).',
--         'system',
--         v_out_message
--     ); RAISE NOTICE 'LI_PPI: %', v_out_message;

--     -- LB_Q
--     CALL app.usp_api_quota_type_create(
--         'LB_Q',
--         'Candidatos autodeclarados quilombolas, com renda familiar bruta per capita igual ou inferior a 1 salário mínimo e que tenham cursado integralmente o ensino médio em escolas públicas ou em escolas comunitárias que atuam no âmbito da educação do campo conveniadas com o poder público (Lei nº 12.711/2012).',
--         'Quilombola, baixa renda, escola pública',
--         'Candidatos autodeclarados quilombolas, com renda familiar bruta per capita igual ou inferior a 1 salário mínimo e que tenham cursado integralmente o ensino médio em escolas públicas ou em escolas comunitárias que atuam no âmbito da educação do campo conveniadas com o poder público (Lei nº 12.711/2012).',
--         'system',
--         v_out_message
--     ); RAISE NOTICE 'LB_Q: %', v_out_message;

--     -- LI_Q
--     CALL app.usp_api_quota_type_create(
--         'LI_Q',
--         'Candidatos autodeclarados quilombolas, independentemente da renda, tenham cursado integralmente o ensino médio em escolas públicas ou em escolas comunitárias que atuam no âmbito da educação do campo conveniadas com o poder público (Lei nº 12.711/2012).',
--         'Quilombola, qualquer renda, escola pública',
--         'Candidatos autodeclarados quilombolas, independentemente da renda, tenham cursado integralmente o ensino médio em escolas públicas ou em escolas comunitárias que atuam no âmbito da educação do campo conveniadas com o poder público (Lei nº 12.711/2012).',
--         'system',
--         v_out_message
--     ); RAISE NOTICE 'LI_Q: %', v_out_message;

--     -- LB_PCD
--     CALL app.usp_api_quota_type_create(
--         'LB_PCD',
--         'Candidatos com deficiência, que tenham renda familiar bruta per capita igual ou inferior a 1 salário mínimo e que tenham cursado integralmente o ensino médio em escolas públicas ou em escolas comunitárias que atuam no âmbito da educação do campo conveniadas com o poder público (Lei nº 12.711/2012).',
--         'PcD, baixa renda, escola pública',
--         'Candidatos com deficiência, que tenham renda familiar bruta per capita igual ou inferior a 1 salário mínimo e que tenham cursado integralmente o ensino médio em escolas públicas ou em escolas comunitárias que atuam no âmbito da educação do campo conveniadas com o poder público (Lei nº 12.711/2012).',
--         'system',
--         v_out_message
--     ); RAISE NOTICE 'LB_PCD: %', v_out_message;

--     -- LI_PCD
--     CALL app.usp_api_quota_type_create(
--         'LI_PCD',
--         'Candidatos com deficiência, independentemente da renda, que tenham cursado integralmente o ensino médio em escolas públicas ou em escolas comunitárias que atuam no âmbito da educação do campo conveniadas com o poder público (Lei nº 12.711/2012).',
--         'PcD, qualquer renda, escola pública',
--         'Candidatos com deficiência, independentemente da renda, que tenham cursado integralmente o ensino médio em escolas públicas ou em escolas comunitárias que atuam no âmbito da educação do campo conveniadas com o poder público (Lei nº 12.711/2012).',
--         'system',
--         v_out_message
--     ); RAISE NOTICE 'LI_PCD: %', v_out_message;

--     -- LB_EP
--     CALL app.usp_api_quota_type_create(
--         'LB_EP',
--         'Candidatos com renda familiar bruta per capita igual ou inferior a 1 salário mínimo que tenham cursado integralmente o ensino médio em escolas públicas ou em escolas comunitárias que atuam no âmbito da educação do campo conveniadas com o poder público (Lei nº 12.711/2012).',
--         'Baixa renda, escola pública',
--         'Candidatos com renda familiar bruta per capita igual ou inferior a 1 salário mínimo que tenham cursado integralmente o ensino médio em escolas públicas ou em escolas comunitárias que atuam no âmbito da educação do campo conveniadas com o poder público (Lei nº 12.711/2012).',
--         'system',
--         v_out_message
--     ); RAISE NOTICE 'LB_EP: %', v_out_message;

--     -- LI_EP
--     CALL app.usp_api_quota_type_create(
--         'LI_EP',
--         'Candidatos que, independentemente da renda, tenham cursado integralmente o ensino médio em escolas públicas ou em escolas comunitárias que atuam no âmbito da educação do campo conveniadas com o poder público (Lei nº 12.711/2012).',
--         'Qualquer renda, escola pública',
--         'Candidatos que, independentemente da renda, tenham cursado integralmente o ensino médio em escolas públicas ou em escolas comunitárias que atuam no âmbito da educação do campo conveniadas com o poder público (Lei nº 12.711/2012).',
--         'system',
--         v_out_message
--     ); RAISE NOTICE 'LI_EP: %', v_out_message;

--     -- AC
--     CALL app.usp_api_quota_type_create(
--         'AC',
--         'Ampla concorrência',
--         'Ampla concorrência',
--         'Ampla concorrência',
--         'system',
--         v_out_message
--     ); RAISE NOTICE 'AC: %', v_out_message;

--     -- LB_PP
--     CALL app.usp_api_quota_type_create(
--         'LB_PP',
--         'Candidatos autodeclarados pretos ou pardos, com renda familiar bruta per capita igual ou inferior a 1 salário mínimo e que tenham cursado integralmente o ensino médio em escolas públicas ou em escolas comunitárias que atuam no âmbito da educação do campo conveniadas com o poder público (Lei nº 12.711/2012).',
--         'Pretos/pardos, baixa renda, escola pública',
--         'Candidatos autodeclarados pretos ou pardos, com renda familiar bruta per capita igual ou inferior a 1 salário mínimo e que tenham cursado integralmente o ensino médio em escolas públicas ou em escolas comunitárias que atuam no âmbito da educação do campo conveniadas com o poder público (Lei nº 12.711/2012).',
--         'system',
--         v_out_message
--     ); RAISE NOTICE 'LB_PP: %', v_out_message;

--     -- LI_PP
--     CALL app.usp_api_quota_type_create(
--         'LI_PP',
--         'Candidatos autodeclarados pretos ou pardos, independentemente da renda, que tenham cursado integralmente o ensino médio em escolas públicas ou em escolas comunitárias que atuam no âmbito da educação do campo conveniadas com o poder público (Lei nº 12.711/2012).',
--         'Pretos/pardos, qualquer renda, escola pública',
--         'Candidatos autodeclarados pretos ou pardos, independentemente da renda, que tenham cursado integralmente o ensino médio em escolas públicas ou em escolas comunitárias que atuam no âmbito da educação do campo conveniadas com o poder público (Lei nº 12.711/2012).',
--         'system',
--         v_out_message
--     ); RAISE NOTICE 'LI_PP: %', v_out_message;

--     -- LB_I
--     CALL app.usp_api_quota_type_create(
--         'LB_I',
--         'Candidatos autodeclarados indígenas, com renda familiar bruta per capita igual ou inferior a 1 salário mínimo e que tenham cursado integralmente o ensino médio em escolas públicas ou em escolas comunitárias que atuam no âmbito da educação do campo conveniadas com o poder público (Lei nº 12.711/2012).',
--         'Indígena, baixa renda, escola pública',
--         'Candidatos autodeclarados indígenas, com renda familiar bruta per capita igual ou inferior a 1 salário mínimo e que tenham cursado integralmente o ensino médio em escolas públicas ou em escolas comunitárias que atuam no âmbito da educação do campo conveniadas com o poder público (Lei nº 12.711/2012).',
--         'system',
--         v_out_message
--     ); RAISE NOTICE 'LB_I: %', v_out_message;

--     -- LI_I
--     CALL app.usp_api_quota_type_create(
--         'LI_I',
--         'Candidatos autodeclarados indígenas, independentemente da renda, que tenham cursado integralmente o ensino médio em escolas públicas ou em escolas comunitárias que atuam no âmbito da educação do campo conveniadas com o poder público (Lei nº 12.711/2012).',
--         'Indígena, qualquer renda, escola pública',
--         'Candidatos autodeclarados indígenas, independentemente da renda, que tenham cursado integralmente o ensino médio em escolas públicas ou em escolas comunitárias que atuam no âmbito da educação do campo conveniadas com o poder público (Lei nº 12.711/2012).',
--         'system',
--         v_out_message
--     ); RAISE NOTICE 'LI_I: %', v_out_message;

--     -- B
--     CALL app.usp_api_quota_type_create(
--         'B',
--         'Candidatos que tenham cursado integralmente o Ensino Médio em instituições públicas de ensino.',
--         'Baixa renda, escola pública',
--         'Candidatos que tenham cursado integralmente o Ensino Médio em instituições públicas de ensino.',
--         'system',
--         v_out_message
--     ); RAISE NOTICE 'B: %', v_out_message;
-- END;
-- $$;

-- DO $$
-- DECLARE
--     v_out_message TEXT;
-- BEGIN
--     CALL app.usp_api_quota_type_create(
--         'V',
--         'Cotas Especiais/Locais (institucionais ou ação afirmativa específica definida pela instituição de ensino).',
--         'Cota Especial',
--         'Reservada para tipos de cotas especiais/institucionais não padronizados nacionalmente.',
--         'system',
--         v_out_message
--     );
--     RAISE NOTICE 'V: %', v_out_message;
-- END;
-- $$;

-- DO $$
-- DECLARE
--     v_out_message TEXT;
--     v_quota_type_id INTEGER;
-- BEGIN
--     -- Get the quota_type_id for 'V'
--     SELECT quota_type_id INTO v_quota_type_id FROM app.quota_type WHERE quota_type_code = 'V';

--     -- Insert each special quota
--     CALL app.usp_api_special_quota_create(v_quota_type_id, 'indígenas, condição que deve ser comprovada mediante apresentação do RANI (Registro Administrativo de Nascimento de Indígena) ou declaração emitida por entidade de representação indígena. (A2)', 'Indígena (RANI/declaração)', 'Indígena com comprovação por RANI ou declaração.', 'system', v_out_message);
--     CALL app.usp_api_special_quota_create(v_quota_type_id, 'que tenham cursado parcialmente o ensino médio em escola pública (pelo menos um ano com aprovação) ou em escolas de direito privado sem fins lucrativos, cujo orçamento da instituição seja proveniente do poder público, em pelo menos 50%. (A1)', 'Ensino médio parcial público', 'Ensino médio parcialmente em escola pública ou privada sem fins lucrativos (50%).', 'system', v_out_message);
--     CALL app.usp_api_special_quota_create(v_quota_type_id, 'Candidatos com deficiência, qualquer que seja a sua procedência escolar.', 'PcD qualquer escola', 'Pessoa com deficiência de qualquer origem escolar.', 'system', v_out_message);
--     CALL app.usp_api_special_quota_create(v_quota_type_id, 'que tenham cursado todo o Ensino Médio e os últimos quatro anos do Ensino Fundamental em Escola Pública e que sejam índios reconhecidos pela FUNAI ou moradores de comunidades remanescentes de quilombos registrados na Fundação Cultural Palmares.', 'Indígena FUNAI/Quilombola', 'Índio FUNAI ou Quilombola (Ensino público).', 'system', v_out_message);
--     CALL app.usp_api_special_quota_create(v_quota_type_id, 'que tenham cursado todo o Ensino Médio e os últimos quatro anos do Ensino Fundamental em Escola Pública e que se autodeclararam negros.', 'Negros ensino público', 'Negros, ensino público.', 'system', v_out_message);
--     CALL app.usp_api_special_quota_create(v_quota_type_id, 'que tenham cursado todo o Ensino Médio e os últimos quatro anos do Ensino Fundamental em Escola Pública e que não se autodeclararam negros.', 'Não negros ensino público', 'Não negros, ensino público.', 'system', v_out_message);
--     CALL app.usp_api_special_quota_create(v_quota_type_id, 'que tenham cursado todo o Ensino Médio e os últimos quatro anos do Ensino Fundamental em Escola Pública e que sejam Pessoa com Deficiência (PcD).', 'PcD ensino público', 'PcD, ensino público.', 'system', v_out_message);
--     CALL app.usp_api_special_quota_create(v_quota_type_id, 'Cotas Sociais', 'Cotas sociais', 'Cotas sociais.', 'system', v_out_message);
--     CALL app.usp_api_special_quota_create(v_quota_type_id, 'Cotas Sociais para Negros', 'Cotas sociais negros', 'Cotas sociais para negros.', 'system', v_out_message);
--     CALL app.usp_api_special_quota_create(v_quota_type_id, 'Pessoas com deficiência, oriundos de qualquer percurso escolar', 'PcD, qualquer percurso', 'PcD, qualquer percurso escolar.', 'system', v_out_message);
--     CALL app.usp_api_special_quota_create(v_quota_type_id, 'Indígenas', 'Indígenas', 'Indígenas.', 'system', v_out_message);
--     CALL app.usp_api_special_quota_create(v_quota_type_id, 'Candidatos autodeclarados como pessoa trans, com renda familiar bruta per capita igual ou inferior a 1 salários mínimo que tenham cursado integralmente o ensino médio em escolas públicas (Resolução CONSEPE nº 5.905/2024)', 'Trans baixa renda', 'Pessoa trans, baixa renda, ensino público.', 'system', v_out_message);
--     CALL app.usp_api_special_quota_create(v_quota_type_id, 'Candidatos que se declararem negros (pretos e pardos) e que tenham cursado todo o ensino médio e pelo menos quatro anos letivos do Ensino Fundamental em escola pública (renda familiar de 1,5 salários mínimos per capita)', 'Negros 1,5 SM', 'Negros, ensino público, renda 1,5 SM.', 'system', v_out_message);
--     CALL app.usp_api_special_quota_create(v_quota_type_id, 'Candidatos que se declararem não-negros e que tenham cursado todo o ensino médio e pelo menos quatro anos letivos do Ensino Fundamental em escola pública  (renda familiar de 1,5 salários mínimos per capita)', 'Não negros 1,5 SM', 'Não negros, ensino público, renda 1,5 SM.', 'system', v_out_message);
--     CALL app.usp_api_special_quota_create(v_quota_type_id, 'Candidatos membros de comunidade quilombola e que tenham cursado todo o ensino médio e pelo menos quatro anos letivos do Ensino Fundamental em escola pública  (renda familiar de 1,5 salários mínimos per capita)', 'Quilombola 1,5 SM', 'Quilombola, ensino público, renda 1,5 SM.', 'system', v_out_message);
--     CALL app.usp_api_special_quota_create(v_quota_type_id, 'Candidatos membros de grupos indígenas (aldeados) e que tenham cursado todo o ensino médio e pelo menos quatro anos letivos do Ensino Fundamental em escola pública  (renda familiar de 1,5 salários mínimos per capita)', 'Indígena aldeado 1,5 SM', 'Indígena aldeado, ensino público, renda 1,5 SM.', 'system', v_out_message);
--     CALL app.usp_api_special_quota_create(v_quota_type_id, 'Candidatos membros de Comunidade Cigana que tenham cursado todo o ensino médio e pelo menos quatro anos letivos do Ensino Fundamental em escola pública  (renda familiar de 1,5 salários mínimos per capita)', 'Cigano 1,5 SM', 'Cigano, ensino público, renda 1,5 SM.', 'system', v_out_message);
--     CALL app.usp_api_special_quota_create(v_quota_type_id, 'Candidatos Transsexuais, Travestis e Transgêneros que tenham cursado todo o ensino médio e pelo menos quatro anos letivos do Ensino Fundamental em escola pública  (renda familiar de 1,5 salários mínimos per capita)', 'Trans/travesti/gênero 1,5 SM', 'Trans/travesti/gênero, ensino público, renda 1,5 SM.', 'system', v_out_message);
--     CALL app.usp_api_special_quota_create(v_quota_type_id, 'Candidatos com Deficiência que tenham cursado todo o ensino médio e pelo menos quatro anos letivos do Ensino Fundamental em escola pública  (renda familiar de 1,5 salários mínimos per capita)', 'PcD 1,5 SM', 'PcD, ensino público, renda 1,5 SM.', 'system', v_out_message);
--     CALL app.usp_api_special_quota_create(v_quota_type_id, 'que cursaram integralmente o Ensino Médio em Escola Pública/ESTUDANTES COM DEFICIÊNCIA', 'Estudantes PcD ensino público', 'Estudantes PcD, ensino público.', 'system', v_out_message);
--     CALL app.usp_api_special_quota_create(v_quota_type_id, 'que cursaram integralmente o Ensino Médio em Escola Pública/ESTUDANTES NEGROS', 'Estudantes negros ensino público', 'Estudantes negros, ensino público.', 'system', v_out_message);
--     CALL app.usp_api_special_quota_create(v_quota_type_id, 'que cursaram integralmente o Ensino Médio em Escola Pública/DEMAIS ESTUDANTES DE ESCOLA PÚBLICA', 'Outros ensino público', 'Demais estudantes, ensino público.', 'system', v_out_message);
--     CALL app.usp_api_special_quota_create(v_quota_type_id, 'que cursaram integralmente o Ensino Médio em Escola Pública/ESTUDANTES INDÍGENAS', 'Estudantes indígenas ensino público', 'Estudantes indígenas, ensino público.', 'system', v_out_message);
--     CALL app.usp_api_special_quota_create(v_quota_type_id, 'Candidatos com deficiência', 'PcD', 'Candidatos PcD.', 'system', v_out_message);
--     CALL app.usp_api_special_quota_create(v_quota_type_id, 'Candidato (s) autodeclarados negros (somatório das categorias pretos e pardos, segundo classificação étnico-racial adotada pelo IBGE) que tenham cursado o ensino fundamental 2 (do 6º ao 9º ano) e ensino medio completo ( incluindo os cursos técnicos com duração de 4 anos) ou ter realizado curso supletivo ou outra modalidade de ensino equivalente, em estabelecimento da Rede Pública de Ensino do Brasil. Vedado aos portadores de diploma de nível superior', 'Negros IBGE', 'Negros, critério IBGE.', 'system', v_out_message);
--     CALL app.usp_api_special_quota_create(v_quota_type_id, 'Candidato (s) com procedência de no mínimo sete anos de estudos regulares ou que tenham realizado curso supletivo ou outra modalidade de ensino equivalente, em estabelecimento da Rede Pública de Ensino do Brasil, compreendendo parte do ensino fundamental (6º ao 9º ano) e Ensino Médio  completo (incluindo os cursos técnicos com duração de 4 anos) ou ter realizado curso supletivo ou outra modalidade de ensino equivalente.', 'Ensino público 7 anos', 'Ensino público mínimo 7 anos.', 'system', v_out_message);
--     CALL app.usp_api_special_quota_create(v_quota_type_id, 'Cota Social - Pretos, Pardos e Indígenas (PPI)', 'Cota social PPI', 'Cota social: pretos, pardos, indígenas.', 'system', v_out_message);
--     CALL app.usp_api_special_quota_create(v_quota_type_id, 'Pessoa com Deficiência (PcD)', 'PcD', 'Pessoa com deficiência.', 'system', v_out_message);
--     CALL app.usp_api_special_quota_create(v_quota_type_id, 'Cota Social - Egresso de Escola Pública (EEP)', 'Cota social EEP', 'Cota social: egresso escola pública.', 'system', v_out_message);
--     CALL app.usp_api_special_quota_create(v_quota_type_id, 'Ação Afirmativa 1 - Pessoas negras, quilombolas e indígenas que tenham cursado integralmente o Ensino Médio em escolas da rede pública de ensino, com renda per capita (mensal) de até um salário-mínimo e meio (1,5).', 'Ação Afirmativa 1', 'Negros, quilombolas e indígenas, escola pública, renda até 1,5 SM.', 'system', v_out_message);
--     CALL app.usp_api_special_quota_create(v_quota_type_id, 'Ação Afirmativa 2 - Pessoas com deficiência que tenham cursado integralmente o Ensino Médio em escolas da rede pública de ensino, com renda per capita (mensal) de até um salário-mínimo e meio (1,5);', 'Ação Afirmativa 2', 'PcD, escola pública, renda até 1,5 SM.', 'system', v_out_message);
--     CALL app.usp_api_special_quota_create(v_quota_type_id, 'Ação Afirmativa 3 - Pessoas que tenham cursado integralmente o Ensino Médio em escolas da rede pública de ensino, com renda per capita (mensal) de até um salário-mínimo e meio (1,5) e que não estejam concorrendo na forma das Ações Afirmativas 1 e 2.', 'Ação Afirmativa 3', 'Escola pública, renda até 1,5 SM, não incluídos nas anteriores.', 'system', v_out_message);
--     CALL app.usp_api_special_quota_create(v_quota_type_id, 'Candidatos estudantes oriundos de Escolas Públicas integrantes da estrutura da Secretaria de Estado de Educação, unidade integrante do Governo do Estado ou Municípios, vinculadas pedagógica e administrativamente às respectivas Diretorias Regionais de Ensino', 'Secretaria Educação', 'Estudantes da Secretaria de Educação.', 'system', v_out_message);
--     CALL app.usp_api_special_quota_create(v_quota_type_id, 'Candidatos estudantes oriundos de Escolas Públicas integrantes da estrutura da Secretaria de Estado de Educação, unidade integrante do Governo do Estado ou Municípios, vinculadas pedagógica e administrativamente às respectivas Diretorias Regionais de Ensino, com renda familiar de até 02 (dois) salários mínimos.', 'Secretaria Educação até 2 SM', 'Estudantes Secretaria de Educação, renda até 2 SM.', 'system', v_out_message);
--     CALL app.usp_api_special_quota_create(v_quota_type_id, 'Candidatos estudantes oriundos de Escolas Públicas integrantes da estrutura da Secretaria de Estado de Educação, unidade integrante do Governo do Estado ou Municípios, vinculadas pedagógica e administrativamente às respectivas Diretorias Regionais de Ensino autodeclarados pretos ou pardos', 'Secretaria Educação negros/pardos', 'Negros/pardos da Secretaria de Educação.', 'system', v_out_message);
--     CALL app.usp_api_special_quota_create(v_quota_type_id, 'Pessoas com deficiência e transtornos globais do desenvolvimento (PCD)', 'PcD TGD', 'PcD e transtornos globais do desenvolvimento.', 'system', v_out_message);
--     CALL app.usp_api_special_quota_create(v_quota_type_id, 'Negros/as (Pretos/as ou Pardos/as) que cursaram integralmente o Ensino Médio em escolas públicas', 'Negros ensino público', 'Negros ensino público.', 'system', v_out_message);
--     CALL app.usp_api_special_quota_create(v_quota_type_id, 'Indígenas que cursaram integralmente o Ensino Médio em escolas públicas', 'Indígenas ensino público', 'Indígenas ensino público.', 'system', v_out_message);
--     CALL app.usp_api_special_quota_create(v_quota_type_id, 'travestis, transexuais, transgêneras - transmasculinas, transfemininas e/ou trans não binárias, que tenham cursado o ensino médio integralmente em escola pública,', 'Trans/travestis ensino público', 'Travestis, trans, transgêneras, ensino público.', 'system', v_out_message);
--     CALL app.usp_api_special_quota_create(v_quota_type_id, 'refugiados', 'Refugiados', 'Refugiados.', 'system', v_out_message);
--     CALL app.usp_api_special_quota_create(v_quota_type_id, 'pertencentes a povos de comunidades remanescentes de quilombos ou comunidades identitárias tradicionais, que tenham cursado integralmente o ensino médio em escolas públicas.', 'Quilombola/tradicional ensino público', 'Quilombolas/tradicionais ensino público.', 'system', v_out_message);
--     CALL app.usp_api_special_quota_create(v_quota_type_id, 'pertencentes a povos indígenas aldeados, que tenham cursado integralmente o ensino médio em escolas públicas.', 'Indígena aldeado ensino público', 'Indígenas aldeados ensino público.', 'system', v_out_message);
--     CALL app.usp_api_special_quota_create(v_quota_type_id, 'transexuais, travestis e transgêneros, que tenham cursado integralmente o ensino médio em escolas públicas.', 'Trans/travestis ensino público', 'Trans, travestis, ensino público.', 'system', v_out_message);
--     CALL app.usp_api_special_quota_create(v_quota_type_id, 'pertencentes a povos de origem cigana, que tenham cursado integralmente o ensino médio em escolas públicas.', 'Cigano ensino público', 'Ciganos ensino público.', 'system', v_out_message);
--     CALL app.usp_api_special_quota_create(v_quota_type_id, 'em situação de privação de liberdade ou egressas do sistema prisional ou refugiadas, que tenham cursado integralmente o ensino médio em escolas públicas.', 'Privação/egresso/refugiado', 'Privação de liberdade, egresso sistema prisional ou refugiado, ensino público.', 'system', v_out_message);
--     CALL app.usp_api_special_quota_create(v_quota_type_id, 'para a reserva de vagas para pessoas trans (travestis, transexuais, transgêneras - transmasculinas, transfemininas e/ou trans não binárias), que tenham cursado o ensino médio integralmente em escola pública', 'Reserva trans', 'Reserva vagas para trans/travestis/transgêneras, ensino público.', 'system', v_out_message);
--     CALL app.usp_api_special_quota_create(v_quota_type_id, 'Candidatos egressos de escolas públicas da rede federal, estadual ou municipal, que cursaram os anos finais do Ensino Fundamental (6º ao 9º anos) e todo o Ensino Médio (1º ao 3º anos), com renda familiar bruta per capita igual ou inferior a 1 salário mínimo (corresponde ao estrato A1 e a 10% das vagas), devendo essa condição ser comprovada no ato da matrícula.', 'Egresso ensino público baixa renda', 'Egresso escola pública, baixa renda, comprovada.', 'system', v_out_message);
--     CALL app.usp_api_special_quota_create(v_quota_type_id, 'Candidatos egressos de escolas públicas da rede federal, estadual ou municipal, que cursaram os anos finais do Ensino Fundamental (6º ao 9º anos) e todo o Ensino Médio (1º ao 3º anos), com qualquer renda renda per capita bruta (corresponde ao estrato A2 e a 10% das vagas), devendo essa condição ser comprovada no ato da matrícula.', 'Egresso ensino público qualquer renda', 'Egresso escola pública, qualquer renda, comprovada.', 'system', v_out_message);
--     CALL app.usp_api_special_quota_create(v_quota_type_id, 'Candidatos Candidatos egressos de escolas públicas da rede federal, estadual ou municipal, que cursaram os anos finais do Ensino Fundamental (6º ao 9º anos) e todo o Ensino Médio (1º ao 3º anos), com renda familiar bruta per capita igual ou inferior a 1 salário mínimo, para estudantes autodeclarados (as) pretos(as), pardos(as), quilombolas ou indígenas (corresponde ao estrato A3 e a 10% das vagas), devendo essa condição ser analisada e aprovada por Comissão de Heteroidentificação, bem como comprovada no ato da matrícula.', 'Egresso público A3', 'Egresso público, renda baixa, negros/pardos/quilombolas/indígenas, com análise e comprovante.', 'system', v_out_message);
--     CALL app.usp_api_special_quota_create(v_quota_type_id, 'Candidatos Candidatos egressos de escolas públicas da rede federal, estadual ou municipal, que cursaram os anos finais do Ensino Fundamental (6º ao 9º anos) e todo o Ensino Médio (1º ao 3º anos), com qualquer renda familiar bruta per capita, para estudantes autodeclarados (as) pretos(as), pardos(as), quilombolas ou indígenas (corresponde ao estrato A4 e a 10% das vagas), devendo essa condição ser analisada e aprovada por Comissão de Heteroidentificação, bem como comprovada no ato da matrícula.', 'Egresso público A4', 'Egresso público, qualquer renda, negros/pardos/quilombolas/indígenas, com análise e comprovante.', 'system', v_out_message);
--     CALL app.usp_api_special_quota_create(v_quota_type_id, 'Quilombolas', 'Quilombolas', 'Quilombolas.', 'system', v_out_message);
--     CALL app.usp_api_special_quota_create(v_quota_type_id, 'com deficiência oriundos da rede de ensino privada ou pública. Os candidatos oriundos da rede pública devem optar por concorrer à vaga desta ação afirmativa ou às vagas reservadas para os grupos de cotas estabelecidos na Lei nº 12.711/2012, não sendo permitida aplicação cumulativa.', 'PcD rede pública/privada', 'PcD de escola pública ou privada, escolha de vaga afirmativa.', 'system', v_out_message);
--     CALL app.usp_api_special_quota_create(v_quota_type_id, 'com deficiência (Denominada A1)', 'PcD A1', 'PcD, Ação afirmativa 1.', 'system', v_out_message);
--     CALL app.usp_api_special_quota_create(v_quota_type_id, 'autodeclarados Negros (Denominada A2)', 'Negros A2', 'Negros, Ação afirmativa 2.', 'system', v_out_message);
--     CALL app.usp_api_special_quota_create(v_quota_type_id, 'com Deficiência (Resolução CONAC/UFRB 117/2024)', 'PcD CONAC/UFRB', 'PcD, conforme Resolução CONAC/UFRB.', 'system', v_out_message);

-- END
-- $$;

-- INSERT INTO app.offered_seats (
--     year_id,
--     university_id,
--     academic_organization_id,
--     university_category_id,
--     university_campus_id,
--     state_id,
--     city_id,
--     region_id,
--     degree_id,
--     degree_level_id,
--     shift_id,
--     frequency_id,
--     quota_type_id,
--     special_quota_id,
--     edition,
--     seats_authorized,
--     seats_offered,
--     score_bonus_percent,
--     num_semesters,
--     weight_essay,
--     min_score_essay,
--     weight_language,
--     min_score_language,
--     weight_math,
--     min_score_math,
--     weight_humanities,
--     min_score_humanities,
--     weight_sciences,
--     min_score_sciences,
--     min_avg_score_enem,
--     pct_state_ppi_ibge,
--     pct_state_pp_ibge,
--     pct_state_indigenous_ibge,
--     pct_state_quilombola_ibge,
--     pct_state_pcd_ibge,
--     pct_quota_law,
--     pct_quota_ppi,
--     pct_quota_pp,
--     pct_quota_indigenous,
--     pct_quota_quilombola,
--     pct_quota_pcd,
--     created_by
-- )
-- SELECT
--     y.year_id,
--     u.university_id,
--     ao.academic_organization_id,
--     uc.university_category_id,
--     ucamp.university_campus_id,
--     s.state_id,
--     c.city_id,
--     r.region_id,
--     d.degree_id,
--     dl.degree_level_id,
--     sh.shift_id,
--     f.frequency_id,
--     qt.quota_type_id,
--     sq.special_quota_id,
--     ivo.edicao,
--     ivo.nu_vagas_autorizadas,
--     ivo.qt_vagas_ofertadas,
--     ivo.nu_percentual_bonus,
--     ivo.qt_semestre,
--     ivo.peso_redacao,
--     ivo.nota_minima_redacao,
--     ivo.peso_linguagens,
--     ivo.nota_minima_linguagens,
--     ivo.peso_matematica,
--     ivo.nota_minima_matematica,
--     ivo.peso_ciencias_humanas,
--     ivo.nota_minima_ciencias_humanas,
--     ivo.peso_ciencias_natureza,
--     ivo.nota_minima_ciencias_natureza,
--     ivo.nu_media_minima_enem,
--     ivo.perc_uf_ibge_ppi,
--     ivo.perc_uf_ibge_pp,
--     ivo.perc_uf_ibge_i,
--     ivo.perc_uf_ibge_q,
--     ivo.perc_uf_ibge_pcd,
--     ivo.nu_perc_lei,
--     ivo.nu_perc_ppi,
--     ivo.nu_perc_pp,
--     ivo.nu_perc_i,
--     ivo.nu_perc_q,
--     ivo.nu_perc_pcd,
--     'system'
-- FROM
--     imp.vagas_ofertadas ivo
-- LEFT JOIN app.year y
--     ON y.year = ivo.edicao::integer
-- LEFT JOIN app.university u
--     ON u.university_code = ivo.co_ies
-- LEFT JOIN app.academic_organization ao
--     ON ao.academic_organization_name = ivo.ds_organizacao_academica
-- LEFT JOIN app.university_category uc
--     ON uc.university_category_name = ivo.ds_categoria_adm
-- LEFT JOIN app.university_campus ucamp
--     ON ucamp.university_campus_name = ivo.no_campus
-- LEFT JOIN app.state s
--     ON s.state_abbr = ivo.sg_uf_campus
-- LEFT JOIN app.city c
--     ON c.city_name = ivo.no_municipio_campus AND c.state_id = s.state_id
-- LEFT JOIN app.region r
--     ON r.region_name = ivo.ds_regiao
-- LEFT JOIN app.degree d
--     ON d.degree_name = ivo.no_curso
-- LEFT JOIN app.degree_level dl
--     ON dl.degree_level_name = ivo.ds_grau
-- LEFT JOIN app.shift sh
--     ON sh.shift_name = ivo.ds_turno
-- LEFT JOIN app.frequency f
--     ON f.frequency_name = ivo.ds_periodicidade
-- LEFT JOIN app.quota_type qt
--     ON qt.quota_type_code = ivo.tp_cota
-- LEFT JOIN app.special_quota sq
--     ON sq.special_quota_desc_short = ivo.ds_mod_concorrencia
-- ;

*/

