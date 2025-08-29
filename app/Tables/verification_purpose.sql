
DROP TABLE IF EXISTS app.verification_purpose CASCADE;
CREATE TABLE IF NOT EXISTS app.verification_purpose (
    verification_purpose_id    SERIAL,
    purpose                    VARCHAR(255) NOT NULL,

    created_by                 INTEGER NOT NULL,
    created_on                 TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    modified_by                INTEGER,
    modified_on                TIMESTAMPTZ,

    CONSTRAINT pk_verification_purpose_id PRIMARY KEY (verification_purpose_id),
    CONSTRAINT uq_verification_purpose UNIQUE (purpose)
);

COMMENT ON TABLE app.verification_purpose IS 'Stores purposes for verification.';
COMMENT ON COLUMN app.verification_purpose.verification_purpose_id IS 'Primary key.';
COMMENT ON COLUMN app.verification_purpose.purpose IS 'Description of the verification purpose.';

