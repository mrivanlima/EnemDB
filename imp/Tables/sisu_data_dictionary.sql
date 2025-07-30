-- 1) CREATE TABLE with SERIAL primary key
CREATE TABLE IF NOT EXISTS imp.sisu_data_dictionary (
  sisu_data_dictionary_id SERIAL,
  data                  TEXT,
  meaning               TEXT,
  CONSTRAINT pk_sisu_dictionary PRIMARY KEY (sisu_data_dictionary_id)
);

-- 2) COMMENT ON COLUMN statements
COMMENT ON COLUMN imp.sisu_data_dictionary.sisu_data_dictionary_id IS 'Identificador sequencial único';
COMMENT ON COLUMN imp.sisu_data_dictionary.data IS 'Ano e edição do processo seletivo único do Sisu';
COMMENT ON COLUMN imp.sisu_data_dictionary.meaning IS 'Código da instituição de ensino superior conforme informações do cadastro e‑MEC';
