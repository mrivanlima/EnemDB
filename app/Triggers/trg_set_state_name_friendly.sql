DROP TRIGGER IF EXISTS trg_set_state_name_friendly ON app.state;

CREATE TRIGGER trg_set_state_name_friendly
BEFORE INSERT OR UPDATE
ON app.state
FOR EACH ROW
EXECUTE FUNCTION app.set_state_name_friendly();