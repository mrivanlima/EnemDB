drop table if exists app.account cascade;
drop table if exists app.address cascade;
drop table if exists app.error_log cascade;

drop table if exists imp.enem_dictionary cascade;
drop table if exists imp.enem_cutoff_scores_2010_2018 cascade;
drop table if exists imp.enem_cutoff_scores_2019_2024 cascade;




DROP FUNCTION IF EXISTS app.usp_api_state_read_by_id;
DROP FUNCTION IF EXISTS app.usp_api_state_read_all();
