DROP TYPE IF EXISTS app.account_record cascade;
CREATE TYPE app.account_record AS 
(
    user_id int,
	user_unique_id uuid,
	username varchar(100),
    email varchar(100),
	password_hash varchar(100),
	password_salt varchar(100),
	is_verified boolean,
	is_active boolean,
	is_locked boolean,
	password_attempts smallint,
	changed_initial_password boolean
)
