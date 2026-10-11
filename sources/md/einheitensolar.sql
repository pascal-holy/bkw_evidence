select
    Plz,
    to_timestamp(substring(EinheitMeldeDatum, 7, 10)::BIGINT) AS reg_date,
    bruttoleistung,
    nettonennleistung,
    updated_at
from main.mast
where Ort = 'Berlin'