CREATE OR REPLACE FUNCTION imp.fix_campus_prefix()
RETURNS TRIGGER
LANGUAGE plpgsql AS $$
DECLARE
  clean text := trim(NEW.no_campus);
BEGIN
  -- If the trimmed text starts case-insensitively with 'CÂMPUS '
  IF upper(clean) LIKE 'CÂMPUS %' THEN
    -- Replace just that prefix, keep what's after it
    NEW.no_campus := 'CAMPUS' || substr(clean, length('CÂMPUS') + 1);
  ELSE
    -- Otherwise just store the trimmed version
    NEW.no_campus := clean;
  END IF;
  RETURN NEW;
END;
$$;
