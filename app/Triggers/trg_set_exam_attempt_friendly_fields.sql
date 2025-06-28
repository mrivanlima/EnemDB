DROP TRIGGER IF EXISTS trg_set_exam_attempt_friendly_fields ON app.exam_attempt;

CREATE TRIGGER trg_set_exam_attempt_friendly_fields
BEFORE INSERT OR UPDATE
ON app.exam_attempt
FOR EACH ROW
EXECUTE FUNCTION app.set_exam_attempt_friendly_fields();
