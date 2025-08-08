CREATE OR REPLACE PROCEDURE app.usp_quote_type_flags_update()
LANGUAGE plpgsql
AS $$
BEGIN
  UPDATE app.quota_type
  SET
    is_deaf = (
      UPPER(TRIM(quota_type_desc_pt)) ILIKE '%SURDOS%' OR
      UPPER(TRIM(quota_type_desc_pt)) ILIKE '%DEFICIENTES AUDITIVOS%' OR
      UPPER(TRIM(quota_type_desc_pt)) ILIKE '%DEFICIÊNCIA AUDITIVA%'
    ) AND NOT (
      UPPER(TRIM(quota_type_desc_pt)) ILIKE '%DOCENTES DE ESCOLA PÚBLICA%' OR
      UPPER(TRIM(quota_type_desc_pt)) ILIKE '%REDE DE ENSINO%' OR
      UPPER(TRIM(quota_type_desc_pt)) ILIKE '%PROFESSORES EM EXERCÍCIO%'
    ),

    public_high_school = (
      UPPER(TRIM(quota_type_desc_pt)) ILIKE '%INSTITUIÇÕES PÚBLICAS%' OR
      UPPER(TRIM(quota_type_desc_pt)) ILIKE '%ESCOLAS PÚBLICAS%' OR
      UPPER(TRIM(quota_type_desc_pt)) ILIKE '%REDE PÚBLICA%'
    ) AND NOT (
      UPPER(TRIM(quota_type_desc_pt)) ILIKE '%DOCENTES DE ESCOLA PÚBLICA%' OR
      UPPER(TRIM(quota_type_desc_pt)) ILIKE '%REDE DE ENSINO%' OR
      UPPER(TRIM(quota_type_desc_pt)) ILIKE '%PROFESSORES EM EXERCÍCIO%'
    ),

    is_black = (
      UPPER(TRIM(quota_type_desc_pt)) ILIKE '%PRETOS%' OR
      UPPER(TRIM(quota_type_desc_pt)) ILIKE '%NEGROS%' OR
      UPPER(TRIM(quota_type_desc_pt)) ILIKE '%PARDOS%' OR
      UPPER(TRIM(quota_type_desc_pt)) ILIKE '%COTAS SOCIAIS%' OR
      UPPER(TRIM(quota_type_desc_pt)) ILIKE '%NEGRAS%'
    ) AND NOT (
      UPPER(TRIM(quota_type_desc_pt)) ILIKE '%NÃO TENHAM SE DECLARADO PRETOS%' OR
      UPPER(TRIM(quota_type_desc_pt)) ILIKE '%NÃO-NEGROS%' OR
      UPPER(TRIM(quota_type_desc_pt)) ILIKE '%NÃO SE AUTODECLARAM ?NEGROS%'
    ),

    is_native = (
      UPPER(TRIM(quota_type_desc_pt)) ILIKE '%INDÍGENAS%' OR
      UPPER(TRIM(quota_type_desc_pt)) ILIKE '%ÍNDIOS%'
    ) AND NOT (
      UPPER(TRIM(quota_type_desc_pt)) ILIKE '%NÃO TENHAM SE DECLARADO PRETOS%' OR
      UPPER(TRIM(quota_type_desc_pt)) ILIKE '%NÃO SE AUTODECLARAM%'
    ),

    one_salary = (
      UPPER(TRIM(quota_type_desc_pt)) ILIKE '%1 SALÁRIO%' OR
      UPPER(TRIM(quota_type_desc_pt)) ILIKE '%1 (UM) SALÁRIO‑MÍNIMO%'
    ) AND NOT (
      UPPER(TRIM(quota_type_desc_pt)) ILIKE '%NÃO DECLAREM SER ORIUNDOS DE FAMÍLIAS COM RENDA IGUAL OU INFERIOR A 1 (UM) SALÁRIO‑MÍNIMO%'
    ),

    one_half_salary = (
      UPPER(TRIM(quota_type_desc_pt)) ILIKE '%1,5 SALÁRIOS MÍNIMOS%' OR
      UPPER(TRIM(quota_type_desc_pt)) ILIKE '%UM SALÁRIO‑MÍNIMO E MEIO%' OR
      UPPER(TRIM(quota_type_desc_pt)) ILIKE '%1,5 SALÁRIO MÍNIMO%'
    ),

    is_quilombola = (
      UPPER(TRIM(quota_type_desc_pt)) ILIKE '%QUILOMBOLA%'
    ),

    is_disabled = (
      (UPPER(TRIM(quota_type_desc_pt)) ILIKE '%DEFICIÊNCIA%' OR
       UPPER(TRIM(quota_type_desc_pt)) ILIKE '%PCD%' OR
       UPPER(TRIM(quota_type_desc_pt)) ILIKE '%AUTISTA%' OR
       UPPER(TRIM(quota_type_desc_pt)) ILIKE '%NECESSIDADES EDUCACIONAIS ESPECÍFICAS%')
    ) AND NOT (
      UPPER(TRIM(quota_type_desc_pt)) ILIKE '%DEFICIÊNCIA AUDITIVA%'
    ),

    is_trans = (
      UPPER(TRIM(quota_type_desc_pt)) ILIKE '%TRANSGÊNERAS%' OR
      UPPER(TRIM(quota_type_desc_pt)) ILIKE '%TRAVESTIS%' OR
      UPPER(TRIM(quota_type_desc_pt)) ILIKE '%TRANSEXUAIS%' OR
      UPPER(TRIM(quota_type_desc_pt)) ILIKE '%TRANSMASCULINAS%' OR
      UPPER(TRIM(quota_type_desc_pt)) ILIKE '%TRANSFEMININAS%' OR
      UPPER(TRIM(quota_type_desc_pt)) ILIKE '%NÃO BINÁRIAS%' OR
      UPPER(TRIM(quota_type_desc_pt)) ILIKE '%PESSOA TRANS%' OR
      UPPER(TRIM(quota_type_desc_pt)) ILIKE '%HOMENS TRANS%' OR
      UPPER(TRIM(quota_type_desc_pt)) ILIKE '%MULHERES TRANS%'
    ),

    is_refugee = (
      UPPER(TRIM(quota_type_desc_pt)) ILIKE '%REFUGIADOS%' OR
      UPPER(TRIM(quota_type_desc_pt)) ILIKE '%REFUGIADAS%'
    ),

    is_ampla_concorrencia = (
      UPPER(TRIM(quota_type_desc_pt)) ILIKE '%AMPLA CONCORRÊNCIA%'
    ),

    economic_vulnerable = (
      UPPER(TRIM(quota_type_desc_pt)) ILIKE '%VULNERABILIDADE ECONÔMICA%' OR
      UPPER(TRIM(quota_type_desc_pt)) ILIKE '%CARE?‍? SOCIOECONÔMICO%' OR
      UPPER(TRIM(quota_type_desc_pt)) ILIKE '%CARÊNCIA SOCIOECONÔMICA%'
    ),

    is_child_dead_public_servant = (
      UPPER(TRIM(quota_type_desc_pt)) ILIKE '%POLICIAIS%'
    ),

    is_public_teacher = (
      UPPER(TRIM(quota_type_desc_pt)) ILIKE '%DOCENTES DE ESCOLA PÚBLICA%' OR
      UPPER(TRIM(quota_type_desc_pt)) ILIKE '%PROFESSORES EM EXERCÍCIO DO MAGISTÉRIO%'
    ),

    is_agriculture_school = (
      UPPER(TRIM(quota_type_desc_pt)) ILIKE '%Agricultura%'
    ),

    is_agro_reform = (
      UPPER(TRIM(quota_type_desc_pt)) ILIKE '%AGRICULTURA FAMILIAR%' OR
      UPPER(TRIM(quota_type_desc_pt)) ILIKE '%REFORMA AGRÁRIA%'
    ),

    is_cigano = (
      UPPER(TRIM(quota_type_desc_pt)) ILIKE '%COMUNIDADE CIGANA%' OR
      UPPER(TRIM(quota_type_desc_pt)) ILIKE '%CIGANOS%' OR
      UPPER(TRIM(quota_type_desc_pt)) ILIKE '%ORIGEM CIGANA%'
    ),

    is_prisoner = (
      UPPER(TRIM(quota_type_desc_pt)) ILIKE '%SISTEMA PRISIONAL%'
    ),

    is_paraiba = (
      UPPER(TRIM(quota_type_desc_pt)) ILIKE '%ESTADO DA PARAÍBA%'
    ),

    is_rural_productor = (
      UPPER(TRIM(quota_type_desc_pt)) ILIKE '%PRODUTORES RURAIS%' OR
      UPPER(TRIM(quota_type_desc_pt)) ILIKE '%AGRICULTURA FAMILIAR%'
    ),

    is_4_salaries = (
      UPPER(TRIM(quota_type_desc_pt)) ILIKE '%04 SALÁRIOS MÍNIMOS%'
    ),

    is_efa = (
      UPPER(TRIM(quota_type_desc_pt)) ILIKE '%ESCOLAS FAMÍLIA AGRÍCOLA%'
    );
END;
$$;
