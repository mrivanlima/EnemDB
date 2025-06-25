-- Trigger function
CREATE OR REPLACE FUNCTION app.set_degree_level_name_friendly()
RETURNS TRIGGER AS $$
BEGIN
    NEW.degree_level_name_friendly := unaccent(NEW.degree_level_name);
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;