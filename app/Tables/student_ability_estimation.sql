CREATE TABLE app.student_ability_estimation (
    estimation_id          SERIAL PRIMARY KEY,
    student_id             INTEGER NOT NULL,            -- FK to your user/student table
    year_id                INTEGER NOT NULL REFERENCES app.year(year_id),
    exam_day               SMALLINT NOT NULL,
    subject                TEXT NOT NULL,               -- e.g., 'Math', 'Humanities'
    theta                  NUMERIC(8,5) NOT NULL,       -- Ability estimate (latent trait)
    standard_error         NUMERIC(8,5),                -- Standard error of theta estimate
    estimation_method      TEXT NOT NULL,               -- e.g., 'MLE', 'Bayesian', 'EAP'
    response_pattern       TEXT,                         -- Optionally store student's answers pattern (mapped)
    created_by             TEXT NOT NULL,
    created_on             TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    modified_by            TEXT,
    modified_on            TIMESTAMPTZ
);
