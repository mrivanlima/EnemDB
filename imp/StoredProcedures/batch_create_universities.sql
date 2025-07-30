CREATE OR REPLACE PROCEDURE imp.batch_create_universities()
LANGUAGE plpgsql
AS $$
DECLARE
    rec RECORD;
    v_message TEXT;
BEGIN
    FOR rec IN
        SELECT DISTINCT
            CAST(trim(co_ies) AS INTEGER) AS university_code,
            trim(upper(sg_ies)) AS university_abbr,
            trim(
                CASE
                    WHEN no_ies ILIKE '%AFRO-BRASILEIRA%' THEN upper(no_ies)
                    WHEN no_ies ILIKE '%SEMI-ÁRIDO%' THEN upper(no_ies)
                    ELSE upper(regexp_replace(no_ies, '\s*-\s*.*$', '', 'g'))
                END
            ) AS university_name,
            1 AS created_by,
            1 AS modified_by
        FROM imp.sisu_spot_offer
        WHERE co_ies IS NOT NULL
        ORDER BY CAST(trim(co_ies) AS INTEGER)
    LOOP
        CALL app.usp_api_university_create(
            p_university_code   => rec.university_code,
            p_university_name   => rec.university_name,
            p_university_abbr   => rec.university_abbr,
            p_created_by        => rec.created_by::TEXT,
            p_modified_by       => rec.modified_by::TEXT,
            out_message         => v_message
        );

        RAISE NOTICE 'Inserção: código %, sigla %, nome %, mensagem: %',
            rec.university_code,
            rec.university_abbr,
            rec.university_name,
            v_message;
    END LOOP;
END;
$$;
