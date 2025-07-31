CREATE OR REPLACE PROCEDURE imp.batch_create_shift()
LANGUAGE plpgsql
AS $$
DECLARE
    rec              RECORD;
    result_message   TEXT;
    has_error        BOOLEAN;
BEGIN
    FOR rec IN
        SELECT DISTINCT trim(ds_turno) AS shift_name
        FROM imp.sisu_spot_offer
        WHERE ds_turno IS NOT NULL
    LOOP
        CALL app.usp_api_shift_create(
            p_shift_name   => rec.shift_name,
            p_created_by   => 1,  -- Ajuste conforme necessário
            out_message    => result_message,
            out_haserror   => has_error
        );

        RAISE NOTICE 'Shift: %, Resultado: %, Erro: %', rec.shift_name, result_message, has_error;
    END LOOP;
END;
$$;
