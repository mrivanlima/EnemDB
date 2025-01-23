-----------------------------------------------------------------
--Create procedure to add new user address
-----------------------------------------------------------------
DROP PROCEDURE IF EXISTS app.usp_api_address_create;
CREATE OR REPLACE PROCEDURE app.usp_api_address_create(
    OUT p_out_address_id INTEGER,
    OUT p_out_message VARCHAR(100),
    IN p_city VARCHAR(100),
    IN p_state VARCHAR(100),
    IN p_street VARCHAR(100),
    IN p_number VARCHAR(100),
    IN p_complement VARCHAR(100),
    IN p_neighborhood VARCHAR(100),
    IN p_zipCode VARCHAR(100),
    IN p_created_on TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    IN p_modified_on TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    IN p_created_by INTEGER DEFAULT NULL,
    IN p_modified_by INTEGER DEFAULT NULL,
    INOUT p_error BOOLEAN DEFAULT FALSE
) 
AS $$
DECLARE 
    l_context TEXT;
BEGIN
    BEGIN
        INSERT INTO app.address (
            city, state, street, number, complement,
            neighborhood, zipCode, created_on, modified_on
        )
        VALUES (
            p_city, p_state, p_street, p_number, p_complement,
            p_neighborhood, p_zipCode, p_created_on, p_modified_on
        ) RETURNING address_id INTO p_out_address_id;

        p_out_message := 'Endereço criado com sucesso!';
    EXCEPTION
        WHEN OTHERS THEN
            p_error := TRUE;
            GET STACKED DIAGNOSTICS l_context = PG_EXCEPTION_CONTEXT;
            INSERT INTO app.error_log (
                error_message, error_code, error_line
            ) VALUES (
                SQLERRM, SQLSTATE, l_context
            );
    END;
END;
$$ LANGUAGE plpgsql;
