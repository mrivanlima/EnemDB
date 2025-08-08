CREATE OR REPLACE FUNCTION app.set_area_name_friendly()
RETURNS TRIGGER AS $$
BEGIN
    NEW.area_name_friendly := unaccent(NEW.area_name);
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;
