select p.Stadtteil as stadtteil, p.Bezirk as bezirk1, e.Postleitzahl,  cast(e."Registrierungsdatum der Einheit" as timestamp) as reg_date
from main.bkw_20250225 e
left join main.plz_berlin_new p on e.Postleitzahl = p.PLZ
