DROP TRIGGER IF EXISTS trg_set_region_name_friendly ON app.region;

CREATE TRIGGER trg_set_region_name_friendly
BEFORE INSERT OR UPDATE
ON app.region
FOR EACH ROW
EXECUTE FUNCTION app.set_region_name_friendly();