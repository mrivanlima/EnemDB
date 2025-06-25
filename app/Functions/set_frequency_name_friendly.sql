-- Trigger function
CREATE OR REPLACE FUNCTION app.set_frequency_name_friendly()
RETURNS TRIGGER AS $$
BEGIN
    NEW.frequency_name_friendly := unaccent(NEW.frequency_name);
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;