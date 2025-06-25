-- Trigger function
CREATE OR REPLACE FUNCTION app.set_degree_name_friendly()
RETURNS TRIGGER AS $$
BEGIN
    NEW.degree_name_friendly := unaccent(NEW.degree_name);
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;