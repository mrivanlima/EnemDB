CREATE OR REPLACE PROCEDURE imp.batch_create_academic_organization()
LANGUAGE plpgsql
AS $$
DECLARE
    rec RECORD;
    v_message TEXT;
BEGIN
    FOR rec IN
        SELECT DISTINCT trim(ds_organizacao_academica) AS academic_organization_name
        FROM imp.sisu_spot_offer
        WHERE ds_organizacao_academica IS NOT NULL AND trim(ds_organizacao_academica) <> ''
        ORDER BY 1
    LOOP
        CALL app.usp_api_academic_organization_create(
            p_academic_organization_name => rec.academic_organization_name,
            p_created_by                 => 1,
            out_message                  => v_message
        );

        RAISE NOTICE 'Org: %, Mensagem: %', rec.academic_organization_name, v_message;
    END LOOP;
END;
$$;

