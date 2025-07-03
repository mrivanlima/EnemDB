CREATE OR REPLACE FUNCTION app.set_language_name_friendly()
RETURNS TRIGGER AS $$
BEGIN
    -- Popula language_name_friendly com a versão capitalizada de language_name
    NEW.language_name_friendly := unaccent(NEW.language_name);
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;