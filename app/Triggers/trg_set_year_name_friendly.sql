CREATE TRIGGER trg_set_year_name_friendly
BEFORE INSERT OR UPDATE
ON app.year
FOR EACH ROW
EXECUTE FUNCTION app.set_year_name_friendly();
