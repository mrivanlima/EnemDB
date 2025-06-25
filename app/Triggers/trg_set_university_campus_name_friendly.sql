DROP TRIGGER IF EXISTS trg_set_university_campus_name_friendly ON app.university_campus;

CREATE TRIGGER trg_set_university_campus_name_friendly
BEFORE INSERT OR UPDATE
ON app.university_campus
FOR EACH ROW
EXECUTE FUNCTION app.set_university_campus_name_friendly();