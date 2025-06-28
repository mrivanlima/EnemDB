README – ENEM/SiSU Higher Education Database
Project Purpose
This database models, tracks, and analyzes higher education seat offerings in Brazil—focusing on the national entrance system (ENEM/SiSU), quotas, cutoffs, seat allocation, and institutional metadata. It enables reporting, analytics, and longitudinal studies on seat availability, quota policy, and university programs.

Main Schema: app
Key Entities and Relationships
Dimension Tables: Universities, campuses, states, cities, regions, degree types, academic organizations, degree levels, quotas, and years.

Fact Table: seats – captures granular details about each seat offering, quotas, cutoffs, and scoring criteria.

Account Tables: For managing system user logins, addresses, and auditing.

Logging: error_log for system and ETL errors.

Data Dictionary
Below is a summary of each table and all its fields, including data types, constraints, and a brief description.

1. app.academic_organization
Column	Type	Constraints	Description
academic_organization_id	SERIAL	PK	Unique identifier
academic_organization_name	TEXT	Unique, NotNull	Name (official)
academic_organization_name_friendly	TEXT	Unique, NotNull	Name (friendly for UI)
created_by	TEXT	NotNull	Creator
created_on	TIMESTAMPTZ	NotNull	Creation timestamp
modified_by	TEXT		Last modifier
modified_on	TIMESTAMPTZ		Last modified timestamp

2. app.account
Column	Type	Constraints	Description
user_id	SERIAL	PK	User account ID
user_unique_id	UUID	Unique	UUID for integration
username	VARCHAR(100)	Unique, NotNull	User login name
email	VARCHAR(100)	NotNull	User email
password_hash	VARCHAR(100)	NotNull	Hashed password
password_salt	VARCHAR(100)	NotNull	Password salt
is_verified	BOOLEAN	Default: false	Email verified?
is_active	BOOLEAN	Default: true	Active account
is_locked	BOOLEAN	Default: false	Locked after failed attempts
password_attempts	SMALLINT	Default: 0	Consecutive failed attempts
changed_initial_password	BOOLEAN	Default: true	Changed first password?
locked_time	TIMESTAMP WITH TZ		Time locked
created_by	INTEGER	FK (self)	Who created
created_on	TIMESTAMP WITH TZ	Default: now	Creation timestamp
modified_by	INTEGER	FK (self)	Last modifier
modified_on	TIMESTAMP WITH TZ	Default: now	Last modified

3. app.address
Column	Type	Constraints	Description
address_id	SERIAL	PK	Address ID
city	VARCHAR(100)	NotNull	City name
state	VARCHAR(100)	NotNull	State name
street	VARCHAR(100)	NotNull	Street
number	VARCHAR(100)	NotNull	Number
complement	VARCHAR(100)	NotNull	Complement
neighborhood	VARCHAR(100)	NotNull	Neighborhood
zipcode	VARCHAR(100)	NotNull	Postal code
created_on	TIMESTAMP WITH TZ	Default: now	Creation timestamp
modified_on	TIMESTAMP WITH TZ	Default: now	Last modified
created_by	INTEGER		Who created
modified_by	INTEGER		Who modified

4. app.city
Column	Type	Constraints	Description
city_id	SERIAL	PK	City ID
state_id	INT	FK -> app.state	State reference
city_name	TEXT	Unique (state), NotNull	Official name
city_name_friendly	TEXT	Unique (state), NotNull	Friendly name
created_by	TEXT	NotNull	Who created
created_on	TIMESTAMPTZ	NotNull, Default: now	Creation timestamp
modified_by	TEXT		Who modified
modified_on	TIMESTAMPTZ		Last modified

5. app.degree_level
Column	Type	Constraints	Description
degree_level_id	SERIAL	PK	Degree level ID
degree_level_name	TEXT	Unique, NotNull	Official degree level name
degree_level_name_friendly	TEXT	Unique, NotNull	Friendly name for UI
created_by	TEXT	NotNull	Who created
created_on	TIMESTAMPTZ	NotNull, Default: now	Creation timestamp
modified_by	TEXT		Who modified
modified_on	TIMESTAMPTZ		Last modified

6. app.degree
Column	Type	Constraints	Description
degree_id	SERIAL	PK	Degree ID
degree_name	TEXT	Unique, NotNull	Degree/course name
degree_name_friendly	TEXT	Unique, NotNull	Friendly name for UI
created_by	TEXT	NotNull	Who created
created_on	TIMESTAMPTZ	NotNull, Default: now	Creation timestamp
modified_by	TEXT		Who modified
modified_on	TIMESTAMPTZ		Last modified

7. app.error_log
Column	Type	Constraints	Description
error_log_id	SERIAL	PK	Log entry ID
table_name	TEXT	NotNull	Table where error occurred
process	TEXT	NotNull	Procedure or function name
operation	TEXT	NotNull	INSERT, UPDATE, DELETE, etc.
command	TEXT		SQL or command attempted
error_message	TEXT	NotNull	Error message
error_code	TEXT		Error code
context_info	TEXT		Extra info/context (JSON or text)
user_name	TEXT		Who ran it
created_on	TIMESTAMPTZ	NotNull, Default: now	Timestamp of error

8. app.frequency
Column	Type	Constraints	Description
frequency_id	SERIAL	PK	Frequency ID
frequency_name	TEXT	Unique, NotNull	Frequency name (official)
frequency_name_friendly	TEXT	Unique, NotNull	Friendly name for UI
created_by	TEXT	NotNull	Who created
created_on	TIMESTAMPTZ	NotNull, Default: now	Creation timestamp
modified_by	TEXT		Who modified
modified_on	TIMESTAMPTZ		Last modified

9. app.quota_type
Column	Type	Constraints	Description
quota_type_id	SERIAL	PK	Quota type ID
quota_type_code	TEXT	Unique, NotNull	Code for quota
quota_type_desc_pt	TEXT	NotNull	Description (Portuguese)
quota_type_desc_short_pt	TEXT	Unique, NotNull	Short description
quota_explain	TEXT	NotNull	Detailed explanation
created_by	TEXT	Default: 'system'	Who created
created_on	TIMESTAMPTZ	Default: now	Creation timestamp
modified_by	TEXT		Who modified
modified_on	TIMESTAMPTZ		Last modified

10. app.region
Column	Type	Constraints	Description
region_id	SERIAL	PK	Region ID
region_name	TEXT	Unique, NotNull	Region name (official)
region_name_friendly	TEXT	Unique, NotNull	Friendly name for UI
created_by	TEXT	NotNull	Who created
created_on	TIMESTAMPTZ	NotNull, Default: now	Creation timestamp
modified_by	TEXT		Who modified
modified_on	TIMESTAMPTZ		Last modified

11. app.seats
Column	Type	Constraints	Description
seats_id	SERIAL	PK	Unique identifier for seat offering
year_id	INTEGER	FK	Academic year (FK: app.year)
university_id	INTEGER	FK	University (FK: app.university)
academic_organization_id	INTEGER	FK	Academic org (FK: app.academic_organization)
university_category_id	INTEGER	FK	University category (FK: app.university_category)
university_campus_id	INTEGER	FK	Campus (FK: app.university_campus)
state_id	INTEGER	FK	State (FK: app.state)
city_id	INTEGER	FK	City (FK: app.city)
region_id	INTEGER	FK	Region (FK: app.region)
degree_id	INTEGER	FK	Degree/course (FK: app.degree)
degree_level_id	INTEGER	FK	Degree level (FK: app.degree_level)
shift_id	INTEGER	FK	Shift (FK: app.shift)
frequency_id	INTEGER	FK	Frequency (FK: app.frequency)
quota_type_id	INTEGER	FK	Quota type (FK: app.quota_type)
special_quota_id	INTEGER	FK	Special quota (FK: app.special_quota)
edition	TEXT		Edition/year string (e.g., 2025)
score_bonus_percent	NUMERIC(5,2)	NULLABLE	Bonus score percent (for eligible candidates)
seats_offered	INTEGER	NULLABLE	Number of seats actually offered
cutoff_score	NUMERIC(6,2)	NULLABLE	Cutoff score for that seat/quota
num_applicants	INTEGER	NULLABLE	Number of applicants for the seat/quota
seats_authorized	INTEGER		Number of seats legally authorized
weight_essay	NUMERIC(5,2)		ENEM essay weight
min_score_essay	NUMERIC(5,2)		Minimum essay score required
weight_language	NUMERIC(5,2)		ENEM language weight
min_score_language	NUMERIC(5,2)		Minimum language score required
weight_math	NUMERIC(5,2)		ENEM math weight
min_score_math	NUMERIC(5,2)		Minimum math score required
weight_humanities	NUMERIC(5,2)		ENEM humanities weight
min_score_humanities	NUMERIC(5,2)		Minimum humanities score required
weight_sciences	NUMERIC(5,2)		ENEM sciences weight
min_score_sciences	NUMERIC(5,2)		Minimum sciences score required
min_avg_score_enem	NUMERIC(5,2)		Minimum ENEM average required
pct_state_ppi_ibge	NUMERIC(5,2)		% PPI (black, brown, indigenous) in state (IBGE)
pct_state_pp_ibge	NUMERIC(5,2)		% PP (black, brown) in state (IBGE)
pct_state_indigenous_ibge	NUMERIC(5,2)		% indigenous in state (IBGE)
pct_state_quilombola_ibge	NUMERIC(5,2)		% quilombola in state (IBGE)
pct_state_pcd_ibge	NUMERIC(5,2)		% PCD (disabilities) in state (IBGE)
pct_quota_law	NUMERIC(5,2)		% seats reserved by law
pct_quota_ppi	NUMERIC(5,2)		% PPI quota reserved
pct_quota_pp	NUMERIC(5,2)		% PP quota reserved
pct_quota_indigenous	NUMERIC(5,2)		% indigenous quota reserved
pct_quota_quilombola	NUMERIC(5,2)		% quilombola quota reserved
pct_quota_pcd	NUMERIC(5,2)		% PCD quota reserved
created_by	TEXT		Who created
created_on	TIMESTAMP	Default: now	Creation timestamp
modified_by	TEXT		Who modified
modified_on	TIMESTAMP		Last modified

12. app.shift
Column	Type	Constraints	Description
shift_id	SERIAL	PK	Shift ID
shift_name	TEXT	Unique, NotNull	Shift name (e.g., "Noturno")
shift_name_friendly	TEXT	Unique, NotNull	Friendly name
created_by	TEXT	NotNull	Who created
created_on	TIMESTAMPTZ	NotNull, Default: now	Creation timestamp
modified_by	TEXT		Who modified
modified_on	TIMESTAMPTZ		Last modified

13. app.special_quota
Column	Type	Constraints	Description
special_quota_id	SERIAL	PK	Special quota ID
quota_type_id	INTEGER	FK	Quota type reference
special_quota_desc_pt	TEXT	NotNull	Description (Portuguese)
special_quota_desc_short	TEXT	Unique, NotNull	Short description
quota_explain	TEXT	NotNull	Explanation
created_by	TEXT	Default: 'system'	Who created
created_on	TIMESTAMPTZ	Default: now	Creation timestamp
modified_by	TEXT		Who modified
modified_on	TIMESTAMPTZ		Last modified

14. app.state
Column	Type	Constraints	Description
state_id	SERIAL	PK	State ID
region_id	INT	FK	Region reference
state_abbr	TEXT	Unique, NotNull	State abbreviation
state_name	TEXT	Unique, NotNull	State name (official)
state_name_friendly	TEXT	Unique, NotNull	Friendly name
created_by	TEXT	NotNull	Who created
created_on	TIMESTAMPTZ	NotNull, Default: now	Creation timestamp
modified_by	TEXT		Who modified
modified_on	TIMESTAMPTZ		Last modified

15. app.university_campus
Column	Type	Constraints	Description
university_campus_id	SERIAL	PK	Campus ID
university_campus_name	TEXT	Unique, NotNull	Campus name (official)
university_campus_name_friendly	TEXT	Unique, NotNull	Friendly campus name
created_by	TEXT	NotNull	Who created
created_on	TIMESTAMPTZ	NotNull, Default: now	Creation timestamp
modified_by	TEXT		Who modified
modified_on	TIMESTAMPTZ		Last modified

16. app.university_category
Column	Type	Constraints	Description
university_category_id	SERIAL	PK	University category ID
university_category_name	TEXT	Unique, NotNull	Category name (official)
university_category_name_friendly	TEXT	Unique, NotNull	Friendly category name
created_by	TEXT	NotNull	Who created
created_on	TIMESTAMPTZ	NotNull, Default: now	Creation timestamp
modified_by	TEXT		Who modified
modified_on	TIMESTAMPTZ		Last modified

17. app.university
Column	Type	Constraints	Description
university_id	SERIAL	PK	University ID
university_code	INT	Unique, NotNull	External code (e.g., MEC code)
university_name	TEXT	Unique, NotNull	Name of the university
university_abbr	TEXT	NotNull	University abbreviation
university_name_friendly	TEXT	Unique, NotNull	Friendly name for UI
created_by	TEXT	NotNull	Who created
created_on	TIMESTAMPTZ	NotNull, Default: now	Creation timestamp
modified_by	TEXT		Who modified
modified_on	TIMESTAMPTZ		Last modified

18. app.year
Column	Type	Constraints	Description
year_id	SERIAL	PK	Academic year ID
year	SMALLINT	Unique, NotNull	Year (e.g., 2024)
year_name	TEXT	Unique, NotNull	Year name string (e.g., "2024/1")
year_name_friendly	TEXT	Unique, NotNull	Friendly name
created_by	TEXT	NotNull	Who created
created_on	TIMESTAMPTZ	NotNull, Default: now	Creation timestamp
modified_by	TEXT		Who modified
modified_on	TIMESTAMPTZ		Last modified

How to Use This README
Upload this README before a session so the assistant understands the data warehouse context, tables, naming, and goals.

Update as schema changes—add or alter table/column summaries as needed.



Recommended Next Table Options
1. User/Account Profile Extension
If you want to track user details beyond account_id (name, school, city, gender, birthdate, etc.).

Example: app.account_profile

2. Exam Catalog Table
Normalize all official exams you might support (for ENEM, “exam_year”, “title”, “reference”, etc.).

Example: app.exam

3. Subject/Skill Dictionary
A table to hold all valid subject areas or skills for normalization/reference (enables mapping, better reporting, filtering, and translation).

Example: app.subject_area, app.skill

4. Question Analytics Table
Aggregate statistics: percent correct, usage, etc.—for dashboards and adaptive learning.

Example: app.question_stats

5. Import/Source Control
Track data loads from ENEM microdata, PDF versions, etc. Useful for data lineage/auditing.

Example: app.data_import_control

