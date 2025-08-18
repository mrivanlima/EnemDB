--drop table if exists imp.sisu_results;
CREATE TABLE IF NOT EXISTS imp.sisu_results (
  imp_id                       BIGSERIAL PRIMARY KEY,

  co_ies                       INT,
  no_ies                       TEXT,
  sg_ies                       TEXT,
  sg_uf_ies                    TEXT,
  no_campus                    TEXT,
  co_ies_curso                 BIGINT,
  no_curso                     TEXT,
  ds_turno                     TEXT,
  ds_formacao                  TEXT,
  qt_vagas_concorrencia        INT,
  co_inscricao_enem            TEXT,
  no_inscrito                  TEXT,
  no_modalidade_concorrencia   TEXT,
  st_bonus_perc                TEXT,
  qt_bonus_perc                TEXT,   -- pode vir vazio ou com %, manter como texto no imp
  no_acao_afirmativa_bonus     TEXT,

  nu_nota_candidato_raw        TEXT,   -- ex.: "683\t31" (mantém do jeito que veio)
  nu_notacorte_concorrida_raw  TEXT,   -- ex.: "568\t81"
  nu_classificacao             INT,

  ensino_medio                 TEXT,   -- "S"/"N"
  quilombola                   TEXT,   -- "S"/"N"
  deficiente                   TEXT,   -- "S"/"N"
  tipo_concorrencia            TEXT,   -- ex.: "AC"

  src_url                      TEXT,   -- opcional: de onde veio o CSV
  loaded_on                    TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
