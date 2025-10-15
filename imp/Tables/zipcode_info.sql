--DROP TABLE IF EXISTS imp.zipcode_info;

CREATE TABLE IF NOT EXISTS imp.zipcode_info
(
    cepid        integer     , 
    cidadenome   varchar(150),
    ibge         integer,
    ddd          varchar(10),
    estadosigla  char(2),
    altitude     double precision,
    longitude    numeric(10,7),
    bairro       TEXT,
    complemento  TEXT,
    cep          varchar(9),
    logradouro   TEXT,
    latitude     numeric(10,7)
);

