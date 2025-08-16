CREATE OR REPLACE FUNCTION app.fn_set_area_by_position_for_azul()
RETURNS trigger
LANGUAGE plpgsql
AS $$
DECLARE
  v_azul_id  INT;
  v_id_lc    SMALLINT;
  v_id_mt    SMALLINT;
  v_id_cn    SMALLINT;
  v_id_ch    SMALLINT;
BEGIN
  -- Só atua se tiver posição de questão
  IF NEW.question_position IS NULL THEN
    RETURN NEW;
  END IF;

  -- Confere se é caderno AZUL (base)
  SELECT bc.booklet_color_id
    INTO v_azul_id
  FROM app.booklet_color bc
  WHERE bc.booklet_color_name = 'AZUL';

  IF NEW.booklet_color_id IS DISTINCT FROM v_azul_id THEN
    RETURN NEW;  -- não é AZUL: não mexe em area_id
  END IF;

  -- Busca os IDs das áreas pelos códigos criados via usp_api_area_create
  SELECT
    MAX(CASE WHEN a.area_code = 'LC' THEN a.area_id END),
    MAX(CASE WHEN a.area_code = 'MT' THEN a.area_id END),
    MAX(CASE WHEN a.area_code = 'CN' THEN a.area_id END),
    MAX(CASE WHEN a.area_code = 'CH' THEN a.area_id END)
  INTO v_id_lc, v_id_mt, v_id_cn, v_id_ch
  FROM app.area a;

  -- Aplica a regra de ranges do caderno AZUL
  IF NEW.question_position BETWEEN 1 AND 45 THEN
    NEW.area_id := v_id_lc;  -- Linguagens
  ELSIF NEW.question_position BETWEEN 46 AND 90 THEN
    NEW.area_id := v_id_ch;  -- Humanas
  ELSIF NEW.question_position BETWEEN 91 AND 135 THEN
    NEW.area_id := v_id_cn;  -- Natureza
  ELSIF NEW.question_position BETWEEN 136 AND 180 THEN
    NEW.area_id := v_id_mt;  -- Matemática
  ELSE
    -- fora do range conhecido → mantém o valor atual (ou defina NULL se preferir)
    -- NEW.area_id := NULL;
  END IF;

  RETURN NEW;
END;
$$;
