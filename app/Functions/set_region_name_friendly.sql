CREATE OR REPLACE FUNCTION app.set_region_name_friendly()
RETURNS TRIGGER AS $$
BEGIN
    NEW.region_name_friendly := unaccent(NEW.region_name);
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;