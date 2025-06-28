DROP TRIGGER IF EXISTS trg_set_response_friendly_fields ON app.response;

CREATE TRIGGER trg_set_response_friendly_fields
BEFORE INSERT OR UPDATE
ON app.response
FOR EACH ROW
EXECUTE FUNCTION app.set_response_friendly_fields();
