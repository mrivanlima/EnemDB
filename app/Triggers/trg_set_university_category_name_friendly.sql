DROP TRIGGER IF EXISTS trg_set_university_category_name_friendly ON app.university_category;

CREATE TRIGGER trg_set_university_category_name_friendly
BEFORE INSERT OR UPDATE
ON app.university_category
FOR EACH ROW
EXECUTE FUNCTION app.set_university_category_name_friendly();