CREATE OR REPLACE FUNCTION app.set_alternative_friendly_fields()
RETURNS TRIGGER AS $$
BEGIN
    NEW.option_text_friendly := LOWER(unaccent(COALESCE(NEW.option_text, '')));
    NEW.notes_friendly := LOWER(unaccent(COALESCE(NEW.notes, '')));
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;