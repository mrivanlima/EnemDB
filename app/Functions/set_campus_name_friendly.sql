CREATE OR REPLACE FUNCTION app.set_campus_name_friendly()
RETURNS TRIGGER AS $$
BEGIN
  NEW.campus_name_friendly := unaccent(NEW.campus_name);
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;