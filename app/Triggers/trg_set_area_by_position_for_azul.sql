DROP TRIGGER IF EXISTS trg_set_area_by_position_for_azul ON app.question_current;

CREATE TRIGGER trg_set_area_by_position_for_azul
BEFORE INSERT OR UPDATE OF question_position, booklet_color_id
ON app.question_current
FOR EACH ROW
EXECUTE FUNCTION app.fn_set_area_by_position_for_azul();
