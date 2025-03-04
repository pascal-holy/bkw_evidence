select 
    p.Stadtteil as stadtteil,
    p.Bezirk as bezirk1,
    e.Plz,
    to_timestamp(substring(EinheitRegistrierungsdatum, 7, 10)::BIGINT) as reg_date,
    bruttoleistung,
    nettonennleistung,
    updated_at
from main.mast e
left join main.plz_berlin_new p on e.Plz = p.PLZ
