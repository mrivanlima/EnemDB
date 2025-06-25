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