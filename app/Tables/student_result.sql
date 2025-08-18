CREATE TABLE app.student_result (
    student_result_id  BIGSERIAL,
    university_id      INTEGER NOT NULL,
    campus_id          INTEGER NOT NULL,
    shift_id           INTEGER NOT NULL,
    published_degree   TEXT NOT NULL,
    degree_id          INTEGER NOT NULL,
    quota_type_id      INTEGER NOT NULL,
    special_quota_id   INTEGER,
    subscription_no    TEXT NOT NULL,
    student_name       TEXT NOT NULL,
    quota              TEXT,
    student_score      NUMERIC(10,2),
    cutoff_score       NUMERIC(10,2),
    classification     INTEGER,
    year_id            INTEGER NOT NULL,
    year               INTEGER NOT NULL,
    created_by         INTEGER NOT NULL DEFAULT 1,
    created_on         TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    modified_by        INTEGER,
    modified_on        TIMESTAMPTZ,

    -- Constraints
    CONSTRAINT pk_student_result PRIMARY KEY (year,student_result_id),
    CONSTRAINT fk_student_result_university FOREIGN KEY (university_id) REFERENCES app.university(university_id),
    CONSTRAINT fk_student_result_campus FOREIGN KEY (campus_id) REFERENCES app.campus(campus_id),
    CONSTRAINT fk_student_result_shift FOREIGN KEY (shift_id) REFERENCES app.shift(shift_id),
    CONSTRAINT fk_student_result_degree FOREIGN KEY (degree_id) REFERENCES app.degree(degree_id),
    CONSTRAINT fk_student_result_quota_type FOREIGN KEY (quota_type_id) REFERENCES app.quota_type(quota_type_id),
    CONSTRAINT fk_student_result_special_quota FOREIGN KEY (special_quota_id) REFERENCES app.special_quota(special_quota_id),
    CONSTRAINT fk_student_result_year FOREIGN KEY (year_id) REFERENCES app.year(year_id),
    CONSTRAINT fk_student_result_created_by FOREIGN KEY (created_by) REFERENCES app.user_login(user_login_id),
    CONSTRAINT fk_student_result_modified_by FOREIGN KEY (modified_by) REFERENCES app.user_login(user_login_id)
) PARTITION BY RANGE (year);

-- Partition tables (2020–2030)
CREATE TABLE IF NOT EXISTS app.student_result_y2020 PARTITION OF app.student_result FOR VALUES FROM (2020) TO (2021);
CREATE TABLE IF NOT EXISTS app.student_result_y2021 PARTITION OF app.student_result FOR VALUES FROM (2021) TO (2022);
CREATE TABLE IF NOT EXISTS app.student_result_y2022 PARTITION OF app.student_result FOR VALUES FROM (2022) TO (2023);
CREATE TABLE IF NOT EXISTS app.student_result_y2023 PARTITION OF app.student_result FOR VALUES FROM (2023) TO (2024);
CREATE TABLE IF NOT EXISTS app.student_result_y2024 PARTITION OF app.student_result FOR VALUES FROM (2024) TO (2025);
CREATE TABLE IF NOT EXISTS app.student_result_y2025 PARTITION OF app.student_result FOR VALUES FROM (2025) TO (2026);
CREATE TABLE IF NOT EXISTS app.student_result_y2026 PARTITION OF app.student_result FOR VALUES FROM (2026) TO (2027);
CREATE TABLE IF NOT EXISTS app.student_result_y2027 PARTITION OF app.student_result FOR VALUES FROM (2027) TO (2028);
CREATE TABLE IF NOT EXISTS app.student_result_y2028 PARTITION OF app.student_result FOR VALUES FROM (2028) TO (2029);
CREATE TABLE IF NOT EXISTS app.student_result_y2029 PARTITION OF app.student_result FOR VALUES FROM (2029) TO (2030);
CREATE TABLE IF NOT EXISTS app.student_result_y2030 PARTITION OF app.student_result FOR VALUES FROM (2030) TO (2031);

-- Table comment
COMMENT ON TABLE app.student_result IS 'Student results imported from SISU, partitioned by year.';

-- Column comments
COMMENT ON COLUMN app.student_result.student_result_id IS 'Primary key.';
COMMENT ON COLUMN app.student_result.university_id IS 'FK to app.university.';
COMMENT ON COLUMN app.student_result.campus_id IS 'FK to app.campus.';
COMMENT ON COLUMN app.student_result.shift_id IS 'FK to app.shift (morning, evening, etc).';
COMMENT ON COLUMN app.student_result.published_degree IS 'Degree name published in SISU file.';
COMMENT ON COLUMN app.student_result.degree_id IS 'Normalized degree FK (app.degree).';
COMMENT ON COLUMN app.student_result.quota_type_id IS 'FK to app.quota_type.';
COMMENT ON COLUMN app.student_result.special_quota_id IS 'FK to app.special_quota (optional).';
COMMENT ON COLUMN app.student_result.subscription_no IS 'ENEM subscription number.';
COMMENT ON COLUMN app.student_result.student_name IS 'Candidate name.';
COMMENT ON COLUMN app.student_result.quota IS 'Quota description as provided in SISU file.';
COMMENT ON COLUMN app.student_result.student_score IS 'Candidate score (NUMERIC, converted from string).';
COMMENT ON COLUMN app.student_result.cutoff_score IS 'Cutoff score (NUMERIC, converted from string).';
COMMENT ON COLUMN app.student_result.classification IS 'Candidate classification/ranking.';
COMMENT ON COLUMN app.student_result.year_id IS 'FK to app.year (normalized year dimension).';
COMMENT ON COLUMN app.student_result.year IS 'Year (used for partitioning).';
COMMENT ON COLUMN app.student_result.created_by IS 'FK to app.user_login; user who created this record.';
COMMENT ON COLUMN app.student_result.created_on IS 'Timestamp when the record was created.';
COMMENT ON COLUMN app.student_result.modified_by IS 'FK to app.user_login; user who last modified this record.';
COMMENT ON COLUMN app.student_result.modified_on IS 'Timestamp of last modification.';
