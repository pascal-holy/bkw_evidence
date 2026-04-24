select 
    p.Stadtteil as stadtteil,
    p.Bezirk as bezirk1,
    e.Plz,
    to_timestamp(substring(EinheitMeldeDatum, 7, 10)::BIGINT) as reg_date,
    bruttoleistung,
    nettonennleistung,
    updated_at
from main.mast e
left join main.plz_berlin_final p on e.Plz = p.PLZ
