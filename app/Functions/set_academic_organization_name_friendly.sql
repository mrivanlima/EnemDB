CREATE OR REPLACE FUNCTION app.set_academic_organization_name_friendly()
RETURNS TRIGGER AS $$
BEGIN
    NEW.academic_organization_name_friendly := unaccent(NEW.academic_organization_name);
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;