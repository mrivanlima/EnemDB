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
    created_by             TEXT NOT NULL,
    created_on             TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    modified_by            TEXT,
    modified_on            TIMESTAMPTZ
);
