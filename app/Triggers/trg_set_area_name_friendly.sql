DROP TRIGGER IF EXISTS trg_set_area_name_friendly ON app.area;

CREATE TRIGGER trg_set_area_name_friendly
BEFORE INSERT OR UPDATE ON app.area
FOR EACH ROW
EXECUTE FUNCTION app.set_area_name_friendly();
