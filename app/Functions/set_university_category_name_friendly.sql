-- Create trigger function
CREATE OR REPLACE FUNCTION app.set_university_category_name_friendly()
RETURNS TRIGGER AS $$
BEGIN
    NEW.university_category_name_friendly := unaccent(NEW.university_category_name);
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;