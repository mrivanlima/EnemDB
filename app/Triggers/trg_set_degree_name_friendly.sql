-- Trigger
DROP TRIGGER IF EXISTS trg_set_degree_name_friendly ON app.degree;

CREATE TRIGGER trg_set_degree_name_friendly
BEFORE INSERT OR UPDATE
ON app.degree
FOR EACH ROW
EXECUTE FUNCTION app.set_degree_name_friendly();