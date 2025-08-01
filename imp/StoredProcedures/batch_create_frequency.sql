CREATE OR REPLACE PROCEDURE imp.batch_create_frequency()
LANGUAGE plpgsql
AS $$
DECLARE
    rec RECORD;
    v_message TEXT;
    v_haserror BOOLEAN;
BEGIN
    FOR rec IN
        SELECT DISTINCT trim(ds_periodicidade) AS frequency_name
        FROM imp.sisu_spot_offer
        WHERE ds_periodicidade IS NOT NULL AND trim(ds_periodicidade) <> ''
    LOOP
        CALL app.usp_api_frequency_create(
            p_frequency_name := rec.frequency_name,
            p_created_by := 1,
            out_message := v_message,
            out_haserror := v_haserror
        );

        RAISE NOTICE 'Importando frequência: %, Mensagem: %, Erro: %', rec.frequency_name, v_message, v_haserror;
    END LOOP;
END;
$$;
