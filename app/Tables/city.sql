CREATE TABLE IF NOT EXISTS app.city (
    city_id               SERIAL,
    state_id              INT NOT NULL,
    city_name             TEXT NOT NULL,
    city_name_friendly    TEXT NOT NULL,
    created_by            TEXT NOT NULL,
    created_on            TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    modified_by           TEXT,
    modified_on           TIMESTAMPTZ,
    -- Constraints
    CONSTRAINT pk_city_id PRIMARY KEY (city_id),
    CONSTRAINT fk_state_id FOREIGN KEY (state_id) REFERENCES app.state(state_id) ON DELETE CASCADE,
    CONSTRAINT uq_city_state UNIQUE (state_id, city_name),
    CONSTRAINT uq_city_state_friendly UNIQUE (state_id, city_name_friendly)
);
