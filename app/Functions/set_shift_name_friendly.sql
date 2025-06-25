-- Trigger function
CREATE OR REPLACE FUNCTION app.set_shift_name_friendly()
RETURNS TRIGGER AS $$
BEGIN
    NEW.shift_name_friendly := unaccent(NEW.shift_name);
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;