-- Trigger
DROP TRIGGER IF EXISTS trg_set_shift_name_friendly ON app.shift;

CREATE TRIGGER trg_set_shift_name_friendly
BEFORE INSERT OR UPDATE
ON app.shift
FOR EACH ROW
EXECUTE FUNCTION app.set_shift_name_friendly();