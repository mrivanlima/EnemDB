CREATE OR REPLACE FUNCTION app.set_state_name_friendly()
RETURNS TRIGGER AS $$
BEGIN
    NEW.state_name_friendly := unaccent(lower(NEW.state_name));
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;
