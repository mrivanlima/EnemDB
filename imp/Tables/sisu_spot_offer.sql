-- Create table to store SISU spot offer data with TEXT instead of VARCHAR
CREATE TABLE IF NOT EXISTS imp.sisu_spot_offer (
  sisu_spot_offer_id        SERIAL,
  edicao                    TEXT,
  co_ies                    TEXT,
  no_ies                    TEXT,
  sg_ies                    TEXT,
  ds_organizacao_academica TEXT,
  ds_categoria_adm         TEXT,
  no_campus                TEXT,
  sg_uf_campus             TEXT,
  no_municipio_campus      TEXT,
  ds_regiao                TEXT,
  co_ies_curso             TEXT,
  no_curso                 TEXT,
  ds_grau                  TEXT,
  ds_turno                 TEXT,
  ds_periodicidade         TEXT,
  qt_semestre              TEXT,
  nu_vagas_autorizadas     TEXT,
  qt_vagas_ofertadas       TEXT,
  nu_percentual_bonus      TEXT,
  tp_mod_concorrencia      TEXT,
  tp_cota                  TEXT,
  ds_mod_concorrencia      TEXT,
  peso_redacao             TEXT,
  nota_minima_redacao      TEXT,
  peso_linguagens          TEXT,
  nota_minima_linguagens   TEXT,
  peso_matematica          TEXT,
  nota_minima_matematica   TEXT,
  peso_ciencias_humanas    TEXT,
  nota_minima_ciencias_humanas TEXT,
  peso_ciencias_natureza   TEXT,
  nota_minima_ciencias_natureza TEXT,
  nu_media_minima_enem     TEXT,
  perc_uf_ibge_ppi         TEXT,
  perc_uf_ibge_pp          TEXT,
  perc_uf_ibge_i           TEXT,
  perc_uf_ibge_q           TEXT,
  perc_uf_ibge_pcd         TEXT,
  nu_perc_lei              TEXT,
  nu_perc_ppi              TEXT,
  nu_perc_pp               TEXT,
  nu_perc_i                TEXT,
  nu_perc_q                TEXT,
  nu_perc_pcd              TEXT,
  CONSTRAINT pk_sisu_spot_offer PRIMARY KEY (sisu_spot_offer_id)
);


-- Comments for each column
COMMENT ON COLUMN imp.sisu_spot_offer.edicao                    IS 'Ano e edição do processo seletivo único do Sisu';
COMMENT ON COLUMN imp.sisu_spot_offer.co_ies                    IS 'Código da instituição de ensino superior conforme cadastro e‑MEC';
COMMENT ON COLUMN imp.sisu_spot_offer.no_ies                    IS 'Nome da instituição de ensino superior conforme cadastro e‑MEC';
COMMENT ON COLUMN imp.sisu_spot_offer.sg_ies                    IS 'Sigla da instituição de ensino superior conforme cadastro e‑MEC';
COMMENT ON COLUMN imp.sisu_spot_offer.ds_organizacao_academica  IS 'Descrição da organização acadêmica da instituição conforme cadastro e‑MEC';
COMMENT ON COLUMN imp.sisu_spot_offer.ds_categoria_adm          IS 'Descrição da categoria administrativa da instituição conforme cadastro e‑MEC';
COMMENT ON COLUMN imp.sisu_spot_offer.no_campus                 IS 'Nome do campus da instituição conforme cadastro e‑MEC';
COMMENT ON COLUMN imp.sisu_spot_offer.sg_uf_campus              IS 'Sigla da unidade da federação do campus';
COMMENT ON COLUMN imp.sisu_spot_offer.no_municipio_campus       IS 'Município do campus da instituição conforme cadastro e‑MEC';
COMMENT ON COLUMN imp.sisu_spot_offer.ds_regiao                 IS 'Região geográfica do campus conforme cadastro e‑MEC';
COMMENT ON COLUMN imp.sisu_spot_offer.co_ies_curso              IS 'Código do curso conforme cadastro e‑MEC';
COMMENT ON COLUMN imp.sisu_spot_offer.no_curso                  IS 'Nome do curso conforme cadastro e‑MEC';
COMMENT ON COLUMN imp.sisu_spot_offer.ds_grau                   IS 'Grau do curso conforme cadastro e‑MEC';
COMMENT ON COLUMN imp.sisu_spot_offer.ds_turno                  IS 'Turno do curso conforme cadastro e‑MEC';
COMMENT ON COLUMN imp.sisu_spot_offer.ds_periodicidade          IS 'Periodicidade do curso conforme cadastro e‑MEC';
COMMENT ON COLUMN imp.sisu_spot_offer.qt_semestre               IS 'Quantidade de semestres do curso conforme cadastro e‑MEC';
COMMENT ON COLUMN imp.sisu_spot_offer.nu_vagas_autorizadas      IS 'Número de vagas autorizadas conforme cadastro e‑MEC';
COMMENT ON COLUMN imp.sisu_spot_offer.qt_vagas_ofertadas        IS 'Quantidade de vagas ofertadas naquela modalidade';
COMMENT ON COLUMN imp.sisu_spot_offer.nu_percentual_bonus       IS 'Percentual de bônus para ações afirmativas próprias das IES';
COMMENT ON COLUMN imp.sisu_spot_offer.tp_mod_concorrencia       IS 'Tipo da modalidade da oferta no processo seletivo';
COMMENT ON COLUMN imp.sisu_spot_offer.tp_cota                   IS 'Detalhamento da modalidade de reserva (cotas)';
COMMENT ON COLUMN imp.sisu_spot_offer.ds_mod_concorrencia       IS 'Descrição da modalidade de concorrência ofertada';
COMMENT ON COLUMN imp.sisu_spot_offer.peso_redacao              IS 'Peso atribuído para Redação do Enem';
COMMENT ON COLUMN imp.sisu_spot_offer.nota_minima_redacao       IS 'Nota mínima para Redação no Enem';
COMMENT ON COLUMN imp.sisu_spot_offer.peso_linguagens           IS 'Peso atribuído para Linguagens do Enem';
COMMENT ON COLUMN imp.sisu_spot_offer.nota_minima_linguagens    IS 'Nota mínima para Linguagens no Enem';
COMMENT ON COLUMN imp.sisu_spot_offer.peso_matematica           IS 'Peso atribuído para Matemática do Enem';
COMMENT ON COLUMN imp.sisu_spot_offer.nota_minima_matematica    IS 'Nota mínima para Matemática no Enem';
COMMENT ON COLUMN imp.sisu_spot_offer.peso_ciencias_humanas     IS 'Peso atribuído para Ciências Humanas do Enem';
COMMENT ON COLUMN imp.sisu_spot_offer.nota_minima_ciencias_humanas IS 'Nota mínima para Ciências Humanas no Enem';
COMMENT ON COLUMN imp.sisu_spot_offer.peso_ciencias_natureza    IS 'Peso atribuído para Ciências da Natureza do Enem';
COMMENT ON COLUMN imp.sisu_spot_offer.nota_minima_ciencias_natureza IS 'Nota mínima para Ciências da Natureza no Enem';
COMMENT ON COLUMN imp.sisu_spot_offer.nu_media_minima_enem      IS 'Média mínima do Enem (Redação, Linguagens, Matemática, CH e CN)';
COMMENT ON COLUMN imp.sisu_spot_offer.perc_uf_ibge_ppi          IS 'Percentual mínimo de pretas, pardas e indígenas por UF (IBGE)';
COMMENT ON COLUMN imp.sisu_spot_offer.perc_uf_ibge_pp           IS 'Percentual mínimo de pretas e pardas por UF (IBGE)';
COMMENT ON COLUMN imp.sisu_spot_offer.perc_uf_ibge_i            IS 'Percentual mínimo de indígenas por UF (IBGE)';
COMMENT ON COLUMN imp.sisu_spot_offer.perc_uf_ibge_q            IS 'Percentual mínimo de quilombolas por UF (IBGE)';
COMMENT ON COLUMN imp.sisu_spot_offer.perc_uf_ibge_pcd          IS 'Percentual mínimo de pessoas com deficiência por UF (IBGE)';
COMMENT ON COLUMN imp.sisu_spot_offer.nu_perc_lei               IS 'Percentual da lei de cotas registrado na oferta de vagas';
COMMENT ON COLUMN imp.sisu_spot_offer.nu_perc_ppi               IS 'Percentual PP‑PI registrado na oferta de vagas (se utilizado)';
COMMENT ON COLUMN imp.sisu_spot_offer.nu_perc_pp                IS 'Percentual PP registrado na oferta de vagas (se utilizado)';
COMMENT ON COLUMN imp.sisu_spot_offer.nu_perc_i                 IS 'Percentual I registrado na oferta de vagas (se utilizado)';
COMMENT ON COLUMN imp.sisu_spot_offer.nu_perc_q                 IS 'Percentual Q registrado na oferta de vagas (se utilizado)';
COMMENT ON COLUMN imp.sisu_spot_offer.nu_perc_pcd               IS 'Percentual PCD registrado na oferta de vagas (se utilizado)';
