-- Trigger
DROP TRIGGER IF EXISTS trg_set_frequency_name_friendly ON app.frequency;

CREATE TRIGGER trg_set_frequency_name_friendly
BEFORE INSERT OR UPDATE
ON app.frequency
FOR EACH ROW
EXECUTE FUNCTION app.set_frequency_name_friendly();