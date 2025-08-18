--DROP TABLE IF EXISTS imp.sisu_past_waitlist;
CREATE TABLE if not exists  imp.sisu_past_waitlist (
  imp_id                      BIGSERIAL PRIMARY KEY,

  ano                         TEXT,
  edicao                      TEXT,
  etapa                       INT,
  ds_etapa                    TEXT,

  codigo_ies                  INT,
  nome_ies                    TEXT,
  sigla_ies                   TEXT,
  uf_ies                      TEXT,

  codigo_campus               TEXT,
  nome_campus                 TEXT,
  uf_campus                   TEXT,
  municipio_campus            TEXT,

  codigo_curso                TEXT,
  nome_curso                  TEXT,
  grau                        TEXT,
  turno                       TEXT,
  ds_periodicidade            TEXT,

  tp_cota                     TEXT,
  tipo_mod_concorrencia       TEXT,
  mod_concorrencia            TEXT,

  qt_vagas_concorrencia       TEXT,
  percentual_bonus            TEXT,

  peso_l                      TEXT,
  peso_ch                     TEXT,
  peso_cn                     TEXT,
  peso_m                      TEXT,
  peso_r                      TEXT,

  nota_minima_l_raw           TEXT,
  nota_minima_ch_raw          TEXT,
  nota_minima_cn_raw          TEXT,
  nota_minima_m_raw           TEXT,
  nota_minima_r_raw           TEXT,
  media_minima_raw            TEXT,

  cpf                         TEXT,
  inscricao_enem              TEXT,
  inscrito                    TEXT,
  sexo                        TEXT,
  dt_nascimento               TEXT,
  uf_candidato                TEXT,
  municipio_candidato         TEXT,

  opcao                       TEXT,

  nota_l_raw                  TEXT,
  nota_ch_raw                 TEXT,
  nota_cn_raw                 TEXT,
  nota_m_raw                  TEXT,
  nota_r_raw                  TEXT,

  nota_l_com_peso_raw         TEXT,
  nota_ch_com_peso_raw        TEXT,
  nota_cn_com_peso_raw        TEXT,
  nota_m_com_peso_raw         TEXT,
  nota_r_com_peso_raw         TEXT,

  nota_candidato_raw          TEXT,
  nota_corte_raw              TEXT,
  classificacao               INT,
  aprovado                    TEXT,
  matricula                   TEXT,

  src_url                     TEXT,
  loaded_on                   TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
