CREATE OR REPLACE FUNCTION app.set_question_friendly_fields()
RETURNS TRIGGER AS $$
BEGIN
    NEW.booklet_color_friendly := LOWER(unaccent(COALESCE(NEW.booklet_color, '')));
    NEW.subject_area_friendly := LOWER(unaccent(COALESCE(NEW.subject_area, '')));
    NEW.thematic_area_friendly := LOWER(unaccent(COALESCE(NEW.thematic_area, '')));
    NEW.question_text_friendly := LOWER(unaccent(COALESCE(NEW.question_text, '')));
    NEW.notes_friendly := LOWER(unaccent(COALESCE(NEW.notes, '')));
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;
