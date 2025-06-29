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
    user_id                     INTEGER,           -- Nullable FK to app.user_login(user_login_id)
    created_by                  INTEGER NOT NULL,
    created_on                  TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    modified_by                 INTEGER,
    modified_on                 TIMESTAMPTZ,

    -- Constraints
    CONSTRAINT pk_approved_student_id PRIMARY KEY (approved_student_id),
    CONSTRAINT uq_approved_student UNIQUE (enem_registration, year, institution_id, course_code),
    --CONSTRAINT fk_approved_student_institution_id FOREIGN KEY (institution_id) REFERENCES app.institution(institution_id),
    --CONSTRAINT fk_approved_student_course_id FOREIGN KEY (course_id) REFERENCES app.course(course_id),
    CONSTRAINT fk_approved_student_user_id FOREIGN KEY (user_id) REFERENCES app.user_login(user_login_id),
    CONSTRAINT fk_approved_student_created_by FOREIGN KEY (created_by) REFERENCES app.user_login(user_login_id),
    CONSTRAINT fk_approved_student_modified_by FOREIGN KEY (modified_by) REFERENCES app.user_login(user_login_id)
);

-- Table comment
COMMENT ON TABLE app.approved_student IS 'Stores data about students approved in selection processes, including their ENEM details, assigned institution/course, bonus and affirmative action info, and user link if applicable.';

-- Field comments (one-liners)
COMMENT ON COLUMN app.approved_student.approved_student_id IS 'Primary key.';
COMMENT ON COLUMN app.approved_student.enem_registration IS 'ENEM registration number (unique per year/institution/course).';
COMMENT ON COLUMN app.approved_student.student_name IS 'Full name of the student.';
COMMENT ON COLUMN app.approved_student.year IS 'Year of the selection process.';
COMMENT ON COLUMN app.approved_student.institution_id IS 'FK to app.institution; normalized ID for the educational institution.';
COMMENT ON COLUMN app.approved_student.institution_name IS 'Institution name as recorded for this entry (denormalized for history).';
COMMENT ON COLUMN app.approved_student.institution_abbr IS 'Abbreviation for the institution.';
COMMENT ON COLUMN app.approved_student.institution_state_abbr IS 'State abbreviation for the institution.';
COMMENT ON COLUMN app.approved_student.campus_name IS 'Name of the campus, if applicable.';
COMMENT ON COLUMN app.approved_student.course_id IS 'FK to app.course; normalized course ID (nullable).';
COMMENT ON COLUMN app.approved_student.course_code IS 'Course code as recorded for this entry (denormalized for history).';
COMMENT ON COLUMN app.approved_student.course_name IS 'Course name as recorded for this entry.';
COMMENT ON COLUMN app.approved_student.shift IS 'Shift of the course (e.g., morning, evening).';
COMMENT ON COLUMN app.approved_student.degree_type IS 'Type of degree (e.g., Bachelor, Technologist).';
COMMENT ON COLUMN app.approved_student.vagas_concorrencia IS 'Number of seats available in this category.';
COMMENT ON COLUMN app.approved_student.no_inscricao_enem IS 'Original ENEM registration (archival).';
COMMENT ON COLUMN app.approved_student.no_modalidade_concorrencia IS 'Type of competition or seat modality.';
COMMENT ON COLUMN app.approved_student.st_bonus_perc IS 'String representation of bonus percentage status.';
COMMENT ON COLUMN app.approved_student.qt_bonus_perc IS 'String or value for the bonus percentage quantity.';
COMMENT ON COLUMN app.approved_student.no_acao_afirmativa_bonus IS 'Type of affirmative action bonus.';
COMMENT ON COLUMN app.approved_student.enem_score IS 'Student''s ENEM score (numeric, 2 decimals).';
COMMENT ON COLUMN app.approved_student.cutoff_score IS 'Minimum cutoff score for approval (numeric, 2 decimals).';
COMMENT ON COLUMN app.approved_student.classification IS 'Classification/ranking of the student.';
COMMENT ON COLUMN app.approved_student.high_school_type IS 'Type of high school attended by the student.';
COMMENT ON COLUMN app.approved_student.quilombola IS 'Indicates if student is quilombola (yes/no).';
COMMENT ON COLUMN app.approved_student.disabled IS 'Indicates if student has a disability (yes/no).';
COMMENT ON COLUMN app.approved_student.tipo_concorrencia IS 'Type of competition or seat for this record.';
COMMENT ON COLUMN app.approved_student.user_id IS 'Nullable FK to app.user_login (if linked to a user account).';
COMMENT ON COLUMN app.approved_student.created_by IS 'FK to app.user_login; who created this record.';
COMMENT ON COLUMN app.approved_student.created_on IS 'Timestamp when the record was created.';
COMMENT ON COLUMN app.approved_student.modified_by IS 'FK to app.user_login; who last modified this record.';
COMMENT ON COLUMN app.approved_student.modified_on IS 'Timestamp of the most recent modification.';
