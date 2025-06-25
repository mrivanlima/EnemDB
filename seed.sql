-- ALTER SEQUENCE app.user_login_user_id_seq MINVALUE 0;
-- ALTER SEQUENCE app.user_login_user_id_seq RESTART WITH 0;

INSERT INTO app.account (
    user_unique_id,  
    username, 
    email,
    password_hash, 
    password_salt, 
    is_verified,  
    is_active, 
    is_locked, 
    password_attempts, 
    changed_initial_password, 
    locked_time, 
    created_by, 
    created_on, 
    modified_by, 
    modified_on
) VALUES (
    uuid_generate_v4(),  -- Generate a new UUID
    'System', 
    'system@email.com',
    'System', 
    'System', 
    true,  -- is_verified
    true,  -- is_active
    false,  -- is_locked
    0,  -- password_attempts
    true,  -- changed_initial_password
    NULL,  -- locked_time
    1,  -- created_by
    current_timestamp,  -- created_on
    1,  -- modified_by
    current_timestamp  -- modified_on
);

CALL app.usp_seed();



DO $$
DECLARE
    rec RECORD;
    v_out_message TEXT;
BEGIN
    FOR rec IN 
        SELECT DISTINCT edicao FROM imp.vagas_ofertadas
        WHERE edicao IS NOT NULL
    LOOP
        CALL app.usp_api_year_create(
            rec.edicao::SMALLINT,     -- p_year (cast if needed)
            'system',                 -- p_created_by
            v_out_message,            -- OUT parameter
            rec.edicao                -- p_year_name
        );
        -- Optionally print/log result:
        RAISE NOTICE 'Inserted year %, result: %', rec.edicao, v_out_message;
    END LOOP;
END;
$$;

DO $$
DECLARE
    rec RECORD;
    v_out_message TEXT;
BEGIN
    FOR rec IN
        SELECT DISTINCT
            co_ies AS university_code,
            no_ies AS university_name,
            sg_ies AS university_abbr
        FROM imp.vagas_ofertadas
        WHERE co_ies IS NOT NULL
    LOOP
        CALL app.usp_api_university_create(
            rec.university_code,
            rec.university_name,
            rec.university_abbr,
            'system',
            v_out_message
        );
        RAISE NOTICE 'Inserted university_code %, result: %', rec.university_code, v_out_message;
    END LOOP;
END;
$$;

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

DO $$
DECLARE
    rec RECORD;
    v_out_message TEXT;
BEGIN
    FOR rec IN
        SELECT DISTINCT ds_categoria_adm
        FROM imp.vagas_ofertadas
        WHERE ds_categoria_adm IS NOT NULL
    LOOP
        CALL app.usp_api_university_category_create(
            rec.ds_categoria_adm,
            'system',
            v_out_message
        );
        RAISE NOTICE 'Inserted university_category "%", result: %',
            rec.ds_categoria_adm, v_out_message;
    END LOOP;
END;
$$;

DO $$
DECLARE
    rec RECORD;
    v_out_message TEXT;
BEGIN
    FOR rec IN
        SELECT DISTINCT no_campus
        FROM imp.vagas_ofertadas
        WHERE no_campus IS NOT NULL
    LOOP
        CALL app.usp_api_university_campus_create(
            rec.no_campus,
            'system',
            v_out_message
        );
        RAISE NOTICE 'Inserted university_campus "%", result: %',
            rec.no_campus, v_out_message;
    END LOOP;
END;
$$;

DO $$
DECLARE
    rec RECORD;
    v_out_message TEXT;
BEGIN
    FOR rec IN
        SELECT DISTINCT ds_regiao
        FROM imp.vagas_ofertadas
        WHERE ds_regiao IS NOT NULL
    LOOP
        CALL app.usp_api_region_create(
            rec.ds_regiao,
            'system',
            v_out_message
        );
        RAISE NOTICE 'Inserted region "%", result: %',
            rec.ds_regiao, v_out_message;
    END LOOP;
END;
$$;



DO $$
DECLARE
    rec RECORD;
    v_out_message TEXT;
BEGIN
    FOR rec IN
        SELECT DISTINCT no_curso
        FROM imp.vagas_ofertadas
        WHERE no_curso IS NOT NULL
    LOOP
        CALL app.usp_api_degree_create(
            rec.no_curso,
            'system',
            v_out_message
        );
        RAISE NOTICE 'Inserted degree "%", result: %',
            rec.no_curso, v_out_message;
    END LOOP;
END;
$$;



DO $$
DECLARE
    rec RECORD;
    v_out_message TEXT;
BEGIN
    FOR rec IN
        SELECT DISTINCT ds_grau
        FROM imp.vagas_ofertadas
        WHERE ds_grau IS NOT NULL
    LOOP
        CALL app.usp_api_degree_level_create(
            rec.ds_grau,
            'system',
            v_out_message
        );
        RAISE NOTICE 'Inserted degree level "%", result: %',
            rec.ds_grau, v_out_message;
    END LOOP;
END;
$$;

DO $$
DECLARE
    rec RECORD;
    v_out_message TEXT;
BEGIN
    FOR rec IN
        SELECT DISTINCT ds_turno
        FROM imp.vagas_ofertadas
        WHERE ds_turno IS NOT NULL
    LOOP
        CALL app.usp_api_shift_create(
            rec.ds_turno,
            'system',
            v_out_message
        );
        RAISE NOTICE 'Inserted shift "%", result: %',
            rec.ds_turno, v_out_message;
    END LOOP;
END;
$$;

DO $$
DECLARE
    rec RECORD;
    v_out_message TEXT;
BEGIN
    FOR rec IN
        SELECT DISTINCT ds_periodicidade
        FROM imp.vagas_ofertadas
        WHERE ds_periodicidade IS NOT NULL
    LOOP
        CALL app.usp_api_frequency_create(
            rec.ds_periodicidade,
            'system',
            v_out_message
        );
        RAISE NOTICE 'Inserted frequency "%", result: %',
            rec.ds_periodicidade, v_out_message;
    END LOOP;
END;
$$;









TRUNCATE TABLE app.state RESTART IDENTITY CASCADE;
TRUNCATE TABLE app.region RESTART IDENTITY CASCADE;

-- Insert all regions of Brazil
INSERT INTO app.region (region_name, region_name_friendly, created_by, created_on)
VALUES
('Norte',     unaccent('Norte'),     'system', NOW()),
('Nordeste',  unaccent('Nordeste'),  'system', NOW()),
('Centro-Oeste', unaccent('Centro-Oeste'), 'system', NOW()),
('Sudeste',   unaccent('Sudeste'),   'system', NOW()),
('Sul',       unaccent('Sul'),       'system', NOW());

-- Insert all states of Brazil, assuming region_id mapping:
-- 1=Norte, 2=Nordeste, 3=Centro-Oeste, 4=Sudeste, 5=Sul

INSERT INTO app.state (
    region_id, state_abbr, state_name, state_name_friendly, created_by, created_on
)
VALUES
-- Norte
(1, 'AC', 'Acre',         unaccent('Acre'),         'system', NOW()),
(1, 'AP', 'Amapá',        unaccent('Amapá'),        'system', NOW()),
(1, 'AM', 'Amazonas',     unaccent('Amazonas'),     'system', NOW()),
(1, 'PA', 'Pará',         unaccent('Pará'),         'system', NOW()),
(1, 'RO', 'Rondônia',     unaccent('Rondônia'),     'system', NOW()),
(1, 'RR', 'Roraima',      unaccent('Roraima'),      'system', NOW()),
(1, 'TO', 'Tocantins',    unaccent('Tocantins'),    'system', NOW()),

-- Nordeste
(2, 'AL', 'Alagoas',      unaccent('Alagoas'),      'system', NOW()),
(2, 'BA', 'Bahia',        unaccent('Bahia'),        'system', NOW()),
(2, 'CE', 'Ceará',        unaccent('Ceará'),        'system', NOW()),
(2, 'MA', 'Maranhão',     unaccent('Maranhão'),     'system', NOW()),
(2, 'PB', 'Paraíba',      unaccent('Paraíba'),      'system', NOW()),
(2, 'PE', 'Pernambuco',   unaccent('Pernambuco'),   'system', NOW()),
(2, 'PI', 'Piauí',        unaccent('Piauí'),        'system', NOW()),
(2, 'RN', 'Rio Grande do Norte', unaccent('Rio Grande do Norte'), 'system', NOW()),
(2, 'SE', 'Sergipe',      unaccent('Sergipe'),      'system', NOW()),

-- Centro-Oeste
(3, 'DF', 'Distrito Federal', unaccent('Distrito Federal'), 'system', NOW()),
(3, 'GO', 'Goiás',        unaccent('Goiás'),        'system', NOW()),
(3, 'MT', 'Mato Grosso',  unaccent('Mato Grosso'),  'system', NOW()),
(3, 'MS', 'Mato Grosso do Sul', unaccent('Mato Grosso do Sul'), 'system', NOW()),

-- Sudeste
(4, 'ES', 'Espírito Santo', unaccent('Espírito Santo'), 'system', NOW()),
(4, 'MG', 'Minas Gerais',  unaccent('Minas Gerais'), 'system', NOW()),
(4, 'RJ', 'Rio de Janeiro', unaccent('Rio de Janeiro'), 'system', NOW()),
(4, 'SP', 'São Paulo',     unaccent('São Paulo'),   'system', NOW()),

-- Sul
(5, 'PR', 'Paraná',       unaccent('Paraná'),       'system', NOW()),
(5, 'RS', 'Rio Grande do Sul', unaccent('Rio Grande do Sul'), 'system', NOW()),
(5, 'SC', 'Santa Catarina', unaccent('Santa Catarina'), 'system', NOW());