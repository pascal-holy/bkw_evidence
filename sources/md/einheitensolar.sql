select p.Stadtteil as stadtteil, p.Bezirk as bezirk1, e.Postleitzahl,  cast(e.Registrierungsdatum as timestamp) as reg_date
from main.einheitensolar e
left join main.plz_berlin p on e.Postleitzahl = p.PLZ
where Ort = 'Berlin'
and cast(Nettonennleistung as double) < 1
