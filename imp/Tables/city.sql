drop table if exists imp.city cascade;
-- Criação da tabela para armazenar municípios com código de UF e IBGE
CREATE TABLE IF NOT EXISTS imp.city (
    state_code TEXT NOT NULL,    -- COD UF
    city_code  TEXT PRIMARY KEY, -- COD (IBGE completo do município)
    name       TEXT NOT NULL     -- NOME
);

-- Comentários opcionais
COMMENT ON TABLE imp.city IS 'Tabela de municípios brasileiros com códigos IBGE e código da unidade federativa.';
COMMENT ON COLUMN imp.city.state_code IS 'Código da UF (ex: 52 para Goiás).';
COMMENT ON COLUMN imp.city.city_code  IS 'Código IBGE do município (ex: 5201702 para Aragarças).';
COMMENT ON COLUMN imp.city.name       IS 'Nome do município.';