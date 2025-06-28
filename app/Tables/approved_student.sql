CREATE TABLE IF NOT EXISTS app.approved_student (
    approved_student_id         SERIAL,
    enem_registration           VARCHAR(20) NOT NULL,
    student_name                TEXT NOT NULL,
    year                        SMALLINT NOT NULL,
    institution_id              INTEGER NOT NULL,  -- FK to normalized institution table
    institution_name            TEXT NOT NULL,
    institution_abbr            TEXT,
    institution_state_abbr      TEXT,
    campus_name                 TEXT,
    course_id                   INTEGER,           -- FK to normalized course table
    course_code                 TEXT,
    course_name                 TEXT,
    shift                       TEXT,
    degree_type                 TEXT,
    vagas_concorrencia          INTEGER,
    no_inscricao_enem           TEXT,              -- Original ENEM registration (for archival)
    no_modalidade_concorrencia  TEXT,
    st_bonus_perc               TEXT,
    qt_bonus_perc               TEXT,
    no_acao_afirmativa_bonus    TEXT,
    enem_score                  NUMERIC(6,2),
    cutoff_score                NUMERIC(6,2),
    classification              INTEGER,
    high_school_type            TEXT,
    quilombola                  TEXT,
    disabled                    TEXT,
    tipo_concorrencia           TEXT,
    user_id                     INTEGER,           -- Nullable FK to app.account(user_id)
    created_by                  TEXT NOT NULL,
    created_on                  TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    modified_by                 TEXT,
    modified_on                 TIMESTAMPTZ,
    -- Constraints
    CONSTRAINT pk_approved_student_id PRIMARY KEY (approved_student_id),
    CONSTRAINT uq_approved_student UNIQUE (enem_registration, year, institution_id, course_code),
    CONSTRAINT fk_approved_student_institution_id FOREIGN KEY (institution_id) REFERENCES app.institution(institution_id),
    CONSTRAINT fk_approved_student_course_id FOREIGN KEY (course_id) REFERENCES app.course(course_id),
    CONSTRAINT fk_approved_student_user_id FOREIGN KEY (user_id) REFERENCES app.account(user_id)
);
