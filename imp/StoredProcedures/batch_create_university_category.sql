CREATE OR REPLACE PROCEDURE imp.batch_create_university_category()
LANGUAGE plpgsql
AS $$
DECLARE
    rec RECORD;
    v_message TEXT;
BEGIN
    FOR rec IN
        SELECT DISTINCT trim(ds_categoria_adm) AS university_category_name
        FROM imp.sisu_spot_offer
        WHERE ds_categoria_adm IS NOT NULL AND trim(ds_categoria_adm) <> ''
        ORDER BY 1
    LOOP
        CALL app.usp_api_university_category_create(
            p_university_category_name => rec.university_category_name,
            p_created_by               => 1,  -- Substitua por user_login_id válido
            p_modified_by              => 1,
            out_message                => v_message
        );

        RAISE NOTICE 'Categoria: %, Mensagem: %',
            rec.university_category_name,
            v_message;
    END LOOP;
END;
$$;