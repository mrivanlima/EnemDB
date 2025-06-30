DROP TABLE IF EXISTS imp.enem_microdata;

CREATE TABLE IF NOT EXISTS imp.enem_microdata (
    enem_microdata_id           SERIAL,
    enem_registration           VARCHAR(20)    NOT NULL,
    exam_year                   SMALLINT       NOT NULL,

    age_group_code              SMALLINT,
    gender                      VARCHAR(10),
    marital_status_code         SMALLINT,
    race_code                   SMALLINT,
    nationality_code            SMALLINT,
    completion_status_code      SMALLINT,
    year_completed              SMALLINT,
    school_type_code            SMALLINT,
    school_teaching_type        SMALLINT,
    is_treineiro                SMALLINT,

    school_city_code            INTEGER,
    school_city_name            TEXT,
    school_state_code           SMALLINT,
    school_state_abbr           VARCHAR(10),
    school_dependency_code      SMALLINT,
    school_location_code        SMALLINT,
    school_status_code          SMALLINT,

    exam_city_code              INTEGER,
    exam_city_name              TEXT,
    exam_state_code             SMALLINT,
    exam_state_abbr             VARCHAR(10),

    present_sciences            SMALLINT,
    present_humanities          SMALLINT,
    present_languages           SMALLINT,
    present_math                SMALLINT,

    prova_code_sciences         VARCHAR(10),
    prova_code_humanities       VARCHAR(10),
    prova_code_languages        VARCHAR(10),
    prova_code_math             VARCHAR(10),

    score_sciences              NUMERIC(6,2),
    score_humanities            NUMERIC(6,2),
    score_languages             NUMERIC(6,2),
    score_math                  NUMERIC(6,2),

    answers_sciences            TEXT,
    answers_humanities          TEXT,
    answers_languages           TEXT,
    answers_math                TEXT,

    language_choice_code        SMALLINT,

    gabarito_sciences           TEXT,
    gabarito_humanities         TEXT,
    gabarito_languages          TEXT,
    gabarito_math               TEXT,

    essay_status_code           SMALLINT,
    essay_comp1_score           NUMERIC(5,2),
    essay_comp2_score           NUMERIC(5,2),
    essay_comp3_score           NUMERIC(5,2),
    essay_comp4_score           NUMERIC(5,2),
    essay_comp5_score           NUMERIC(5,2),
    essay_total_score           NUMERIC(6,2),

    -- Socioeconomic questions
    q001 VARCHAR(10), q002 VARCHAR(10), q003 VARCHAR(10), q004 VARCHAR(10),
    q005 VARCHAR(10), q006 VARCHAR(10), q007 VARCHAR(10), q008 VARCHAR(10),
    q009 VARCHAR(10), q010 VARCHAR(10), q011 VARCHAR(10), q012 VARCHAR(10),
    q013 VARCHAR(10), q014 VARCHAR(10), q015 VARCHAR(10), q016 VARCHAR(10),
    q017 VARCHAR(10), q018 VARCHAR(10), q019 VARCHAR(10), q020 VARCHAR(10),
    q021 VARCHAR(10), q022 VARCHAR(10), q023 VARCHAR(10), q024 VARCHAR(10),
    q025 VARCHAR(10), q026 VARCHAR(10), q027 VARCHAR(10), q028 VARCHAR(10),
    q029 VARCHAR(10), q030 VARCHAR(10), q031 VARCHAR(10), q032 VARCHAR(10),
    q033 VARCHAR(10), q034 VARCHAR(10), q035 VARCHAR(10), q036 VARCHAR(10),
    q037 VARCHAR(10), q038 VARCHAR(10), q039 VARCHAR(10), q040 VARCHAR(10),
    q041 VARCHAR(10), q042 VARCHAR(10), q043 VARCHAR(10), q044 VARCHAR(10),
    q045 VARCHAR(10), q046 VARCHAR(10), q047 VARCHAR(10), q048 VARCHAR(10),
    q049 VARCHAR(10), q050 VARCHAR(10), q051 VARCHAR(10), q052 VARCHAR(10),
    q053 VARCHAR(10), q054 VARCHAR(10), q055 VARCHAR(10), q056 VARCHAR(10),
    q057 VARCHAR(10), q058 VARCHAR(10), q059 VARCHAR(10), q060 VARCHAR(10),
    q061 VARCHAR(10), q062 VARCHAR(10), q063 VARCHAR(10), q064 VARCHAR(10),
    q065 VARCHAR(10), q066 VARCHAR(10), q067 VARCHAR(10), q068 VARCHAR(10),
    q069 VARCHAR(10), q070 VARCHAR(10), q071 VARCHAR(10), q072 VARCHAR(10),
    q073 VARCHAR(10), q074 VARCHAR(10), q075 VARCHAR(10), q076 VARCHAR(10),

    in_certificado                  SMALLINT,
    no_entidade_certificacao        TEXT,
    co_uf_entidade_certificacao     SMALLINT,
    sg_uf_entidade_certificacao     VARCHAR(10),

    -- Constraints
    CONSTRAINT pk_enem_microdata_id PRIMARY KEY (enem_microdata_id, exam_year),
    CONSTRAINT uq_enem_microdata    UNIQUE (enem_registration, exam_year)

) PARTITION BY RANGE (exam_year);

-- Year partitions
CREATE TABLE imp.enem_microdata_2010 PARTITION OF imp.enem_microdata FOR VALUES FROM (2010) TO (2011);
CREATE TABLE imp.enem_microdata_2011 PARTITION OF imp.enem_microdata FOR VALUES FROM (2011) TO (2012);
CREATE TABLE imp.enem_microdata_2012 PARTITION OF imp.enem_microdata FOR VALUES FROM (2012) TO (2013);
CREATE TABLE imp.enem_microdata_2013 PARTITION OF imp.enem_microdata FOR VALUES FROM (2013) TO (2014);
CREATE TABLE imp.enem_microdata_2014 PARTITION OF imp.enem_microdata FOR VALUES FROM (2014) TO (2015);
CREATE TABLE imp.enem_microdata_2015 PARTITION OF imp.enem_microdata FOR VALUES FROM (2015) TO (2016);
CREATE TABLE imp.enem_microdata_2016 PARTITION OF imp.enem_microdata FOR VALUES FROM (2016) TO (2017);
CREATE TABLE imp.enem_microdata_2017 PARTITION OF imp.enem_microdata FOR VALUES FROM (2017) TO (2018);
CREATE TABLE imp.enem_microdata_2018 PARTITION OF imp.enem_microdata FOR VALUES FROM (2018) TO (2019);
CREATE TABLE imp.enem_microdata_2019 PARTITION OF imp.enem_microdata FOR VALUES FROM (2019) TO (2020);
CREATE TABLE imp.enem_microdata_2020 PARTITION OF imp.enem_microdata FOR VALUES FROM (2020) TO (2021);
CREATE TABLE imp.enem_microdata_2021 PARTITION OF imp.enem_microdata FOR VALUES FROM (2021) TO (2022);
CREATE TABLE imp.enem_microdata_2022 PARTITION OF imp.enem_microdata FOR VALUES FROM (2022) TO (2023);
CREATE TABLE imp.enem_microdata_2023 PARTITION OF imp.enem_microdata FOR VALUES FROM (2023) TO (2024);
CREATE TABLE imp.enem_microdata_2024 PARTITION OF imp.enem_microdata FOR VALUES FROM (2024) TO (2025);
CREATE TABLE imp.enem_microdata_2025 PARTITION OF imp.enem_microdata FOR VALUES FROM (2025) TO (2026);
CREATE TABLE imp.enem_microdata_2026 PARTITION OF imp.enem_microdata FOR VALUES FROM (2026) TO (2027);
CREATE TABLE imp.enem_microdata_2027 PARTITION OF imp.enem_microdata FOR VALUES FROM (2027) TO (2028);
CREATE TABLE imp.enem_microdata_2028 PARTITION OF imp.enem_microdata FOR VALUES FROM (2028) TO (2029);
CREATE TABLE imp.enem_microdata_2029 PARTITION OF imp.enem_microdata FOR VALUES FROM (2029) TO (2030);
CREATE TABLE imp.enem_microdata_2030 PARTITION OF imp.enem_microdata FOR VALUES FROM (2030) TO (2031);
