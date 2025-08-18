

-- (2) Tabela final tipada
CREATE TABLE IF NOT EXISTS imp.sisu_past_results (
    -- Identificação do processo
    ano                    TEXT,                         -- ex: 2023
    edicao                 TEXT,                         -- 1, 2...
    etapa                  TEXT,                         -- código da etapa
    ds_etapa               TEXT,                             -- "CHAMADA REGULAR", "LISTA DE ESPERA", etc.

    -- IES / Campus / Curso
    codigo_ies             TEXT,
    nome_ies               TEXT,
    sigla_ies              TEXT,
    uf_ies                 TEXT,

    codigo_campus          TEXT,
    nome_campus            TEXT,
    uf_campus              TEXT,
    municipio_campus       TEXT,

    codigo_curso           TEXT,
    nome_curso             TEXT,
    grau                   TEXT,                             -- Bacharelado, Licenciatura...
    turno                  TEXT,                             -- Matutino/Noturno/etc.
    ds_periodicidade       TEXT,                             -- Semestral/Anual...

    -- Concorrência / Vagas
    tp_cota                TEXT,                             -- código da cota (quando houver)
    tipo_mod_concorrencia  TEXT,                             -- texto do tipo
    mod_concorrencia       TEXT,                             -- texto do modo
    qt_vagas_concorrencia  TEXT,
    percentual_bonus       TEXT,                     -- ex: 0–100 (use duas ou três casas se necessário)

    -- Pesos
    peso_l                 TEXT,
    peso_ch                TEXT,
    peso_cn                TEXT,
    peso_m                 TEXT,
    peso_r                 TEXT,

    -- Notas mínimas / média mínima
    nota_minima_l          TEXT,
    nota_minima_ch         TEXT,
    nota_minima_cn         TEXT,
    nota_minima_m          TEXT,
    nota_minima_r          TEXT,
    media_minima           TEXT,

    -- Dados do candidato (muitos vêm mascarados)
    cpf                    TEXT,                             -- manter TEXT por conta de máscara (XXX.***-XX)
    inscricao_enem         TEXT,
    inscrito               TEXT,                             -- nome
    sexo                   TEXT,                          -- M/F (quando presente)
    dt_nascimento          TEXT,
    uf_candidato           TEXT,
    municipio_candidato    TEXT,

    -- Opção e notas (brutas e ponderadas)
    opcao                  TEXT,                         -- 1, 2...
    nota_l                 TEXT,
    nota_ch                TEXT,
    nota_cn                TEXT,
    nota_m                 TEXT,
    nota_r                 TEXT,

    nota_l_com_peso        TEXT,
    nota_ch_com_peso       TEXT,
    nota_cn_com_peso       TEXT,
    nota_m_com_peso       TEXT,
    nota_r_com_peso        TEXT,

    nota_candidato         TEXT,                    -- pode passar de 1000 por causa de pesos
    nota_corte             TEXT,
    classificacao          TEXT,
    aprovado               TEXT,                          -- "S"/"N" (quando houver)
    matricula              TEXT,                             -- "PENDENTE"/"CONFIRMADA"/etc.

    -- Auditoria
    created_on             TIMESTAMPTZ NOT NULL DEFAULT NOW()
);


