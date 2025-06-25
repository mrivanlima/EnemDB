DROP TRIGGER IF EXISTS trg_set_degree_level_name_friendly ON app.degree_level;

CREATE TRIGGER trg_set_degree_level_name_friendly
BEFORE INSERT OR UPDATE
ON app.degree_level
FOR EACH ROW
EXECUTE FUNCTION app.set_degree_level_name_friendly();