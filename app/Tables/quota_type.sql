CREATE TABLE IF NOT EXISTS app.quota_type (
    quota_type_id            SERIAL,
    quota_type_code          VARCHAR(50) NOT NULL,
    quota_type_desc_pt       TEXT NOT NULL,
    quota_type_desc_short_pt TEXT,
    quota_explain            TEXT,
    is_deaf                   BOOLEAN DEFAULT FALSE,
    public_high_school        BOOLEAN DEFAULT FALSE,
    is_black                   BOOLEAN DEFAULT FALSE,
    is_native                  BOOLEAN DEFAULT FALSE,
    one_salary                 BOOLEAN DEFAULT FALSE,
    one_half_salary            BOOLEAN DEFAULT FALSE,
    is_quilombola             BOOLEAN DEFAULT FALSE,
    is_disabled                BOOLEAN DEFAULT FALSE,
    is_trans                   BOOLEAN DEFAULT FALSE,
    is_refugee                 BOOLEAN DEFAULT FALSE,
    is_ampla_concorrencia      BOOLEAN DEFAULT FALSE,
    economic_vulnerable        BOOLEAN DEFAULT FALSE,
    is_child_dead_public_servant BOOLEAN DEFAULT FALSE,
    is_public_teacher          BOOLEAN DEFAULT FALSE,
    is_agriculture_school      BOOLEAN DEFAULT FALSE,
    is_agro_reform             BOOLEAN DEFAULT FALSE,
    is_cigano                  BOOLEAN DEFAULT FALSE,
    is_prisoner                BOOLEAN DEFAULT FALSE,
    is_paraiba                 BOOLEAN DEFAULT FALSE,
    is_rural_productor         BOOLEAN DEFAULT FALSE,
    is_4_salaries              BOOLEAN DEFAULT FALSE,
    is_efa                     BOOLEAN DEFAULT FALSE,
    created_by               INTEGER NOT NULL DEFAULT 1,  -- system user_login_id or assign as needed
    created_on               TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    modified_by              INTEGER,
    modified_on              TIMESTAMPTZ,
    CONSTRAINT pk_quota_type_id PRIMARY KEY (quota_type_id),
    CONSTRAINT uq_quota_type_code UNIQUE (quota_type_code),
    CONSTRAINT fk_quota_type_created_by FOREIGN KEY (created_by) REFERENCES app.user_login(user_login_id),
    CONSTRAINT fk_quota_type_modified_by FOREIGN KEY (modified_by) REFERENCES app.user_login(user_login_id)
);

-- Table comment
COMMENT ON TABLE app.quota_type IS 'Defines quota or affirmative action types, with detailed and short Portuguese descriptions, explanation, and audit fields.';

-- Field comments (one-liners)
COMMENT ON COLUMN app.quota_type.quota_type_id IS 'Chave primária da tabela';
COMMENT ON COLUMN app.quota_type.quota_type_code IS 'Código único identificador da modalidade de cota';
COMMENT ON COLUMN app.quota_type.quota_type_desc_pt IS 'Descrição completa da modalidade em Português';
COMMENT ON COLUMN app.quota_type.quota_type_desc_short_pt IS 'Descrição curta/resumida da modalidade em Português';
COMMENT ON COLUMN app.quota_type.quota_explain IS 'Texto explicativo do funcionamento da modalidade';
COMMENT ON COLUMN app.quota_type.is_deaf IS 'True se a modalidade é para pessoas surdas (auditiva)';
COMMENT ON COLUMN app.quota_type.public_high_school IS 'True se exige escolaridade em escola pública ou conveniada';
COMMENT ON COLUMN app.quota_type.is_black IS 'True se é voltado a autodeclarados negros (pretos ou pardos)';
COMMENT ON COLUMN app.quota_type.is_native IS 'True se é voltado a autodeclarados indígenas';
COMMENT ON COLUMN app.quota_type.one_salary IS 'True se exige renda per capita ≤ 1 salário‑mínimo';
COMMENT ON COLUMN app.quota_type.one_half_salary IS 'True se exige renda per capita ≤ 1,5 salários‑mínimos';
COMMENT ON COLUMN app.quota_type.is_quilombola IS 'True se é destinado a candidatos quilombolas';
COMMENT ON COLUMN app.quota_type.is_disabled IS 'True se é destinado a pessoas com deficiência (PcD)';
COMMENT ON COLUMN app.quota_type.is_trans IS 'True se é destinado a pessoas transgênero';
COMMENT ON COLUMN app.quota_type.is_refugee IS 'True se é destinado a refugiados ou solicitantes de refúgio';
COMMENT ON COLUMN app.quota_type.is_ampla_concorrencia IS 'True se a modalidade permite ampla concorrência ou bonificação';
COMMENT ON COLUMN app.quota_type.economic_vulnerable IS 'True se considera vulnerabilidade econômica (baixa renda)';
COMMENT ON COLUMN app.quota_type.is_child_dead_public_servant IS 'True se é para filho(a) de policial morto ou incapacitado no serviço';
COMMENT ON COLUMN app.quota_type.is_public_teacher IS 'True se o candidato já foi docente da rede pública de ensino';
COMMENT ON COLUMN app.quota_type.is_agriculture_school IS 'True se é egresso de escola de agricultura familiar ou assentamento';
COMMENT ON COLUMN app.quota_type.is_agro_reform IS 'True se vinculado à reforma agrária (família assentada, PRONAF)';
COMMENT ON COLUMN app.quota_type.is_cigano IS 'True se pertence à comunidade cigana';
COMMENT ON COLUMN app.quota_type.is_prisoner IS 'True se é pessoa presa ou egressa do sistema prisional';
COMMENT ON COLUMN app.quota_type.is_paraiba IS 'True se modalidade específica da Lei estadual da Paraíba';
COMMENT ON COLUMN app.quota_type.is_rural_productor IS 'True se é filho(a) de agricultor familiar ou membro de família PRONAF';
COMMENT ON COLUMN app.quota_type.is_4_salaries IS 'True se exige renda per capita ≤ 4 salários‑mínimos';
COMMENT ON COLUMN app.quota_type.is_efa IS 'True se é egresso da Escola Família Agrícola (EFA)';
COMMENT ON COLUMN app.quota_type.created_by IS 'ID do usuário que criou o registro';
COMMENT ON COLUMN app.quota_type.created_on IS 'Data e hora de criação do registro';
COMMENT ON COLUMN app.quota_type.modified_by IS 'ID do usuário que modificou o registro por último';
COMMENT ON COLUMN app.quota_type.modified_on IS 'Data e hora da última modificação';

