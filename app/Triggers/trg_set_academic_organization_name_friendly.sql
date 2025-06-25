DROP TRIGGER IF EXISTS trg_set_academic_organization_name_friendly ON app.academic_organization;

CREATE TRIGGER trg_set_academic_organization_name_friendly
BEFORE INSERT OR UPDATE
ON app.academic_organization
FOR EACH ROW
EXECUTE FUNCTION app.set_academic_organization_name_friendly();
