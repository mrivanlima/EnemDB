DROP TRIGGER IF EXISTS trg_set_booklet_color_name_friendly
    ON app.booklet_color;

CREATE TRIGGER trg_set_booklet_color_name_friendly
    BEFORE INSERT OR UPDATE
    ON app.booklet_color
    FOR EACH ROW
    EXECUTE FUNCTION app.set_booklet_color_name_friendly();
