CREATE OR REPLACE FUNCTION app.set_booklet_color_name_friendly()
RETURNS TRIGGER AS $$
BEGIN
    NEW.booklet_color_name_friendly := unaccent(NEW.booklet_color_name);
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;
