-- Trigger function
CREATE OR REPLACE FUNCTION app.set_city_name_friendly()
RETURNS TRIGGER AS $$
BEGIN
    NEW.city_name_friendly := unaccent(NEW.city_name);
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;