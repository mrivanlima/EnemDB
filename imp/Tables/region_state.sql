
DROP TABLE IF EXISTS imp.region_state CASCADE;
CREATE TABLE IF NOT EXISTS imp.region_state (
    region_name TEXT NOT NULL,
    state_name  TEXT NOT NULL
);

COMMENT ON TABLE imp.region_state IS 'Tabela bruta contendo os estados brasileiros e suas respectivas regiões.';
COMMENT ON COLUMN imp.region_state.region_name IS 'Nome da região geográfica (ex: Norte, Nordeste, etc).';
COMMENT ON COLUMN imp.region_state.state_name  IS 'Nome do estado brasileiro (ex: Goiás, Bahia, etc).';

-- Importação dos dados do CSV


