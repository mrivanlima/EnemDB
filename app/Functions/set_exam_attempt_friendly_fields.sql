CREATE OR REPLACE FUNCTION app.set_exam_attempt_friendly_fields()
RETURNS TRIGGER AS $$
BEGIN
    NEW.booklet_color_friendly := LOWER(unaccent(COALESCE(NEW.booklet_color, '')));
    NEW.notes_friendly := LOWER(unaccent(COALESCE(NEW.notes, '')));
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;