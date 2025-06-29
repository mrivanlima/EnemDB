CREATE OR REPLACE PROCEDURE app.usp_api_account_role_create (
    IN  p_account_id     INTEGER,
    IN  p_role_id        INTEGER,
    IN  p_assigned_by    TEXT,
    OUT out_message      TEXT
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_exists            INTEGER;
    v_account_role_id   INTEGER;
    v_command           TEXT;
    v_error_message     TEXT;
    v_error_code        TEXT;
BEGIN
    -- VALIDATIONS
    IF p_account_id IS NULL THEN
        out_message := 'Validation failed: account_id cannot be null.';
        RETURN;
    END IF;

    IF p_role_id IS NULL THEN
        out_message := 'Validation failed: role_id cannot be null.';
        RETURN;
    END IF;

    IF p_assigned_by IS NULL OR length(trim(p_assigned_by)) = 0 THEN
        out_message := 'Validation failed: assigned_by cannot be empty.';
        RETURN;
    END IF;

    -- Ensure account exists and is active
    SELECT 1 INTO v_exists FROM app.account WHERE account_id = p_account_id AND is_active = TRUE;
    IF NOT FOUND THEN
        out_message := format('Validation failed: account_id %s does not exist or is not active.', p_account_id);
        RETURN;
    END IF;

    -- Ensure role exists and is active
    SELECT 1 INTO v_exists FROM app.role WHERE role_id = p_role_id AND is_active = TRUE;
    IF NOT FOUND THEN
        out_message := format('Validation failed: role_id %s does not exist or is not active.', p_role_id);
        RETURN;
    END IF;

    -- Prevent duplicate assignment (active only)
    SELECT 1 INTO v_exists FROM app.account_role 
     WHERE account_id = p_account_id AND role_id = p_role_id AND is_active = TRUE;
    IF FOUND THEN
        out_message := format('Validation failed: Role %s already assigned to account %s.', p_role_id, p_account_id);
        RETURN;
    END IF;

    -- DML & ERROR LOGGING
    BEGIN
        INSERT INTO app.accou
