DROP TRIGGER IF EXISTS trg_set_campus_name_friendly ON app.campus;

CREATE TRIGGER trg_set_campus_name_friendly
BEFORE INSERT OR UPDATE
ON app.campus
FOR EACH ROW
EXECUTE FUNCTION app.set_campus_name_friendly();