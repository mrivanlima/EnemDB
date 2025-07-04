DROP PROCEDURE IF EXISTS stg.usp_transform_university;
CREATE OR REPLACE PROCEDURE stg.usp_transform_university()
AS $$
BEGIN

	-- Step 1: Log start
    RAISE NOTICE 'Starting procedure execution...';

    -- Step 2: Truncate the target table
    TRUNCATE TABLE stg.school RESTART IDENTITY;
    RAISE NOTICE 'Table truncated successfully.';

    -- Step 3: Insert distinct records
    RAISE NOTICE 'Inserting distinct records...';

	DROP TABLE IF EXISTS test;
	CREATE TEMP TABLE test AS
	SELECT
		e.co_ies AS school_code,
		UPPER(COALESCE(s.school_name_corrected, e.no_ies)) AS school_name,
		UPPER(UNACCENT(COALESCE(s.school_name_corrected, e.no_ies))) AS school_name_ascii,
		UPPER(COALESCE(s.school_abrv_corrected, e.sg_ies)) AS school_abrv,
		UPPER(UNACCENT(COALESCE(s.school_abrv_corrected, e.sg_ies))) AS school_abrv_ascii
	FROM imp.enem_cutoff_scores_2019_2024 e
	LEFT JOIN imp.school_mapping s
		ON s.school_code = e.co_ies;
	
	
	INSERT INTO stg.school
	(
		school_code,
		school_name,
	    school_name_ascii,
		school_abrv,
		school_abrv_ascii
	)
	SELECT
		e.co_ies AS school_code,
		UPPER(COALESCE(s.school_name_corrected, e.no_ies)) AS school_name,
		UPPER(UNACCENT(COALESCE(s.school_name_corrected, e.no_ies))) AS school_name_ascii,
		UPPER(COALESCE(s.school_abrv_corrected, e.sg_ies)) AS school_abrv,
		UPPER(UNACCENT(COALESCE(s.school_abrv_corrected, e.sg_ies))) AS school_abrv_ascii
	FROM imp.enem_cutoff_scores_2019_2024 e
	LEFT JOIN imp.school_mapping s
		ON s.school_code = e.co_ies
		
	UNION
	
	SELECT
		ec.cod_ies,
		ec.nome_ies AS school_name,
		UNACCENT(ec.nome_ies) AS school_name_ascii,
		ec.sigla_ies AS school_abrv,
		UNACCENT(ec.sigla_ies) AS school_abrv_ascii
	FROM imp.enem_cutoff_scores_2010_2018 ec
	WHERE NOT EXISTS(SELECT * FROM test te WHERE te.school_code = ec.cod_ies)
	ORDER BY 1;

	-- Step 4: Log the number of rows inserted
    RAISE NOTICE 'Number of rows inserted: %', (SELECT COUNT(*) FROM stg.school);

    RAISE NOTICE 'Procedure execution completed successfully.';
END;
$$ LANGUAGE plpgsql;