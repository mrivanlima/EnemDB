
DROP TABLE IF EXISTS imp.brazil_states CASCADE;
CREATE TABLE IF NOT EXISTS imp.brazil_states (
    ibge_code  TEXT ,   -- COD
    name       TEXT NOT NULL,      -- NOME
    uf         TEXT NOT NULL       -- SIGLA
);

