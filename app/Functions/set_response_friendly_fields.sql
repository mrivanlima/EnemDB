CREATE OR REPLACE FUNCTION app.set_response_friendly_fields()
RETURNS TRIGGER AS $$
BEGIN
    NEW.notes_friendly := LOWER(unaccent(COALESCE(NEW.notes, '')));
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;
