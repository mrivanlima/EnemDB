
DROP TABLE IF EXISTS imp.degree_mapping CASCADE;
CREATE TABLE imp.degree_mapping (
    published_degree TEXT NOT NULL,
    area             TEXT NOT NULL,
    context          TEXT NOT NULL,
    similarity       TEXT NOT NULL,
    equivalent       TEXT NOT NULL
);

-- Comentários opcionais
COMMENT ON TABLE imp.degree_mapping IS 'Tabela de mapeamento de cursos (nomes publicados, áreas, contexto, similaridade e equivalência).';
COMMENT ON COLUMN imp.degree_mapping.published_degree IS 'Nome publicado do curso (ex: ADMINISTRAÇÃO).';
COMMENT ON COLUMN imp.degree_mapping.area             IS 'Área do conhecimento (ex: HUMANAS).';
COMMENT ON COLUMN imp.degree_mapping.context          IS 'Nome do curso no contexto institucional.';
COMMENT ON COLUMN imp.degree_mapping.similarity          IS 'Curso considerado similar.';
COMMENT ON COLUMN imp.degree_mapping.equivalent       IS 'Curso considerado equivalente.';
