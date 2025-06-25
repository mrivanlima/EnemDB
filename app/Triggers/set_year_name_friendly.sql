CREATE TRIGGER trg_set_year_name_friendly
BEFORE INSERT OR UPDATE
ON app.year
FOR EACH ROW
EXECUTE FUNCTION app.set_year_name_friendly();


CREATE OR REPLACE FUNCTION app.set_year_name_friendly()
RETURNS TRIGGER AS $$
BEGIN
    NEW.year_name_friendly := unaccent(NEW.year_name);
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;
