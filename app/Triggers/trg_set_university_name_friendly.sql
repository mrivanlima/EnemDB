CREATE TRIGGER trg_set_university_name_friendly
BEFORE INSERT OR UPDATE
ON app.university
FOR EACH ROW
EXECUTE FUNCTION app.set_university_name_friendly();