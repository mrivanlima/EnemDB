-- Trigger
DROP TRIGGER IF EXISTS trg_set_city_name_friendly ON app.city;

CREATE TRIGGER trg_set_city_name_friendly
BEFORE INSERT OR UPDATE
ON app.city
FOR EACH ROW
EXECUTE FUNCTION app.set_city_name_friendly();