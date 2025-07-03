CREATE TABLE IF NOT EXISTS imp.exam_questions (
    exam_id SERIAL PRIMARY KEY,
    year INTEGER,
    color VARCHAR(40),
    questions JSONB NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ
);

COMMENT ON TABLE imp.exam_questions IS 'Tabela para armazenar questões do exame em formato JSON, com ano e cor da prova.';
COMMENT ON COLUMN imp.exam_questions.year IS 'Ano do exame (ex: 2024).';
COMMENT ON COLUMN imp.exam_questions.color IS 'Cor do caderno da prova (ex: Azul, Amarelo).';
COMMENT ON COLUMN imp.exam_questions.questions IS 'JSON contendo as questões e alternativas.';
COMMENT ON COLUMN imp.exam_questions.created_at IS 'Data e hora de criação do registro.';
COMMENT ON COLUMN imp.exam_questions.updated_at IS 'Data e hora da última atualização do registro.';

