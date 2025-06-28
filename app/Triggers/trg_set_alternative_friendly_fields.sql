DROP TRIGGER IF EXISTS trg_set_alternative_friendly_fields ON app.alternative;

CREATE TRIGGER trg_set_alternative_friendly_fields
BEFORE INSERT OR UPDATE
ON app.alternative
FOR EACH ROW
EXECUTE FUNCTION app.set_alternative_friendly_fields();
