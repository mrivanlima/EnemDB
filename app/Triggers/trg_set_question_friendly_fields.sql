DROP TRIGGER IF EXISTS trg_set_question_friendly_fields ON app.question;

CREATE TRIGGER trg_set_question_friendly_fields
BEFORE INSERT OR UPDATE
ON app.question
FOR EACH ROW
EXECUTE FUNCTION app.set_question_friendly_fields();
