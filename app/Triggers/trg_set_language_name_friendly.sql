
DROP TRIGGER IF EXISTS trg_set_language_name_friendly ON app.language;

CREATE TRIGGER trg_set_language_name_friendly
BEFORE INSERT OR UPDATE ON app.language
FOR EACH ROW
EXECUTE FUNCTION app.set_language_name_friendly();