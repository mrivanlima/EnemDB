DROP TRIGGER IF EXISTS trg_fix_campus_prefix ON imp.sisu_spot_offer;
CREATE TRIGGER trg_fix_campus_prefix
BEFORE INSERT OR UPDATE ON imp.sisu_spot_offer
FOR EACH ROW
EXECUTE FUNCTION imp.fix_campus_prefix();
