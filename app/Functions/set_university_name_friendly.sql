CREATE OR REPLACE FUNCTION app.set_university_name_friendly()
RETURNS TRIGGER AS $$
BEGIN
    NEW.university_name_friendly := unaccent(NEW.university_name);
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;