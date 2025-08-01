CREATE OR REPLACE PROCEDURE imp.batch_create_special_quota(
  IN p_created_by INTEGER DEFAULT 1
)
LANGUAGE plpgsql
AS $$
DECLARE
  rec RECORD;
  out_msg TEXT;
BEGIN
  -- Itera sobre todos os tp_cota = 'V' ou 'B', juntando com o quota_type_id correspondente
  FOR rec IN
    SELECT DISTINCT
      qt.quota_type_id,
      TRIM(sso.ds_mod_concorrencia) AS special_desc
    FROM imp.sisu_spot_offer sso
    JOIN app.quota_type qt
      ON qt.quota_type_code = TRIM(sso.tp_cota)
    WHERE TRIM(sso.tp_cota) IN ('V', 'B')
    ORDER BY 1
  LOOP
    -- Chama a rotina que insere ou ignora conforme verificação interna
    CALL app.usp_api_special_quota_create(
      rec.quota_type_id,
      rec.special_desc,
      p_created_by,
      out_msg
    );

    -- Log opcional: avisa se a inserção foi bem-sucedida ou motivo da falha
    RAISE NOTICE 'Quota [%]: % -> %', rec.quota_type_id, rec.special_desc, out_msg;
  END LOOP;
END;
$$;
