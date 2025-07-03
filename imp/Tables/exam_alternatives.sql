CREATE TABLE IF NOT EXISTS imp.exam_alternatives (
    exam_alternative_id SERIAL PRIMARY KEY,
    year INTEGER,
    color VARCHAR(40),
    alternatives JSONB NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ
);

COMMENT ON TABLE imp.exam_alternatives IS 'Tabela para armazenar alternativas do exame em formato JSON, com ano e cor da prova.';
COMMENT ON COLUMN imp.exam_alternatives.year IS 'Ano do exame (ex: 2024).';
COMMENT ON COLUMN imp.exam_alternatives.color IS 'Cor do caderno da prova (ex: Azul, Amarelo).';
COMMENT ON COLUMN imp.exam_alternatives.alternatives IS 'JSON contendo as alternativas das questões.';
COMMENT ON COLUMN imp.exam_alternatives.created_at IS 'Data e hora de criação do registro.';
COMMENT ON COLUMN imp.exam_alternatives.updated_at IS 'Data e hora da última atualização do registro.';
