-- Drop existing trigger on this table if it exists
DROP TRIGGER IF EXISTS trg_fix_campus_prefix_cutoff ON imp.sisu_spot_cutoff_score;

-- Create a new trigger using the existing function
CREATE TRIGGER trg_fix_campus_prefix_cutoff
BEFORE INSERT OR UPDATE ON imp.sisu_spot_cutoff_score
FOR EACH ROW
EXECUTE FUNCTION imp.fix_campus_prefix();
