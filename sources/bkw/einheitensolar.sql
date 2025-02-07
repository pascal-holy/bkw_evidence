select Postleitzahl, NetzbetreiberpruefungStatus,  cast(Registrierungsdatum as timestamp) as reg_date, EinheitBetriebsstatus
from main.einheitensolar
where Ort = 'Berlin'
and cast(Nettonennleistung as double) < 1
