CREATE TABLE app.item_statistics (
    item_stat_id           SERIAL PRIMARY KEY,
    year_id                INTEGER NOT NULL REFERENCES app.year(year_id),
    exam_day               SMALLINT NOT NULL,
    subject                TEXT NOT NULL,                    -- e.g., 'Math', 'Humanities'
    base_question_no       INTEGER NOT NULL,                  -- Position in base booklet
    item_id                TEXT,                              -- Optional: official question ID if known
    a_parameter            NUMERIC(6,4) NOT NULL,             -- Discrimination
    b_parameter            NUMERIC(6,4) NOT NULL,             -- Difficulty
    c_parameter            NUMERIC(6,4) NOT NULL,             -- Guessing
    d_parameter            NUMERIC(6,4),                      -- Sometimes used (4PL)
    infit                  NUMERIC(6,4),                      -- Infit statistic
    outfit                 NUMERIC(6,4),                      -- Outfit statistic
    standard_error_a       NUMERIC(6,4),
    standard_error_b       NUMERIC(6,4),
    standard_error_c       NUMERIC(6,4),
    response_count         INTEGER NOT NULL,                   -- Number of responses for this item
    calibration_date       TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    created_by             INTEGER NOT NULL,
    created_on             TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    modified_by            INTEGER,
    modified_on            TIMESTAMPTZ,

    -- Constraints
    CONSTRAINT fk_item_statistics_created_by FOREIGN KEY (created_by) REFERENCES app.user_login(user_login_id),
    CONSTRAINT fk_item_statistics_modified_by FOREIGN KEY (modified_by) REFERENCES app.user_login(user_login_id)
);

-- Table comment
COMMENT ON TABLE app.item_statistics IS 'Stores psychometric and statistical parameters for each exam item/question per year, including IRT parameters and fit statistics.';

-- Field comments (one-liners)
COMMENT ON COLUMN app.item_statistics.item_stat_id IS 'Primary key.';
COMMENT ON COLUMN app.item_statistics.year_id IS 'FK to app.year; identifies the exam year.';
COMMENT ON COLUMN app.item_statistics.exam_day IS 'Exam day number (e.g., 1 or 2).';
COMMENT ON COLUMN app.item_statistics.subject IS 'Subject or area of the item (e.g., Math, Humanities).';
COMMENT ON COLUMN app.item_statistics.base_question_no IS 'Canonical base question number.';
COMMENT ON COLUMN app.item_statistics.item_id IS 'Official question ID if known.';
COMMENT ON COLUMN app.item_statistics.a_parameter IS 'Item discrimination parameter (a) from IRT.';
COMMENT ON COLUMN app.item_statistics.b_parameter IS 'Item difficulty parameter (b) from IRT.';
COMMENT ON COLUMN app.item_statistics.c_parameter IS 'Item guessing parameter (c) from IRT.';
COMMENT ON COLUMN app.item_statistics.d_parameter IS 'Item upper asymptote (d) parameter, if 4PL model is used.';
COMMENT ON COLUMN app.item_statistics.infit IS 'Infit statistic (model fit).';
COMMENT ON COLUMN app.item_statistics.outfit IS 'Outfit statistic (model fit).';
COMMENT ON COLUMN app.item_statistics.standard_error_a IS 'Standard error for a parameter.';
COMMENT ON COLUMN app.item_statistics.standard_error_b IS 'Standard error for b parameter.';
COMMENT ON COLUMN app.item_statistics.standard_error_c IS 'Standard error for c parameter.';
COMMENT ON COLUMN app.item_statistics.response_count IS 'Number of student responses used for statistics.';
COMMENT ON COLUMN app.item_statistics.calibration_date IS 'Date/time of item parameter calibration.';
COMMENT ON COLUMN app.item_statistics.created_by IS 'FK to app.user_login; user who created this record.';
COMMENT ON COLUMN app.item_statistics.created_on IS 'Timestamp when this record was created.';
COMMENT ON COLUMN app.item_statistics.modified_by IS 'FK to app.user_login; user who last modified this record.';
COMMENT ON COLUMN app.item_statistics.modified_on IS 'Timestamp of last modification.';
