CREATE TABLE IF NOT EXISTS imp.exam_gabaritos (
    gabarito_id    SERIAL PRIMARY KEY,
    exam_year      INTEGER              NOT NULL,
    exam_day       INTEGER,  -- Or DATE or VARCHAR, depending on your use case
    color          VARCHAR(40)          NOT NULL,
    file_name      VARCHAR(255)         NOT NULL,
    questions      JSONB                NOT NULL,
    created_at     TIMESTAMPTZ          NOT NULL DEFAULT NOW(),
    updated_at     TIMESTAMPTZ
);

COMMENT ON TABLE imp.exam_gabaritos IS 'Tabela para armazenar gabaritos do exame em formato JSON, incluindo ano, dia, cor, e nome do arquivo original.';
COMMENT ON COLUMN imp.exam_gabaritos.exam_year IS 'Ano do exame (ex: 2024).';
COMMENT ON COLUMN imp.exam_gabaritos.exam_day IS 'Dia do exame (ex: 1, 2, ou data completa).';
COMMENT ON COLUMN imp.exam_gabaritos.color IS 'Cor do caderno da prova (ex: Azul, Amarelo).';
COMMENT ON COLUMN imp.exam_gabaritos.file_name IS 'Nome do arquivo PDF de origem.';
COMMENT ON COLUMN imp.exam_gabaritos.questions IS 'JSON contendo o gabarito (respostas das questões).';
