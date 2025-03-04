---
title: Balkonkraftwerke im Markstammdatenregister
---

```sql total
select count(*) as total from md.einheitensolar
```
Es gibt schon <Value data={total} column=total fmt=id /> Balkonkraftwerke in Berlin.

```sql brutto
WITH monthly AS (
  SELECT
    date_trunc('month', reg_date) AS registrierungsdatum,
    SUM(bruttoleistung) AS bruttoleistung, 
    SUM(nettonennleistung) AS nettonennleistung
  FROM md.einheitensolar
  GROUP BY 1
  ORDER BY 1
),
win AS (
  SELECT 
    registrierungsdatum, 
    SUM(nettonennleistung) OVER (ORDER BY registrierungsdatum) AS nettonennleistung, 
    SUM(bruttoleistung) OVER (ORDER BY registrierungsdatum) AS bruttoleistung
  FROM monthly
),
limit_last_2 AS (
  SELECT *, 
         ROW_NUMBER() OVER (ORDER BY registrierungsdatum DESC) AS rn 
  FROM win
  ORDER BY registrierungsdatum DESC
  LIMIT 2
),
pct as (
  SELECT 
      MAX(CASE WHEN rn = 1 THEN nettonennleistung END) AS nettoleistung,
      MAX(CASE WHEN rn = 2 THEN nettonennleistung END) AS nettonennleistung_vorletzter_monat,
      MAX(CASE WHEN rn = 1 THEN bruttoleistung END) AS bruttoleistung,
      MAX(CASE WHEN rn = 2 THEN bruttoleistung END) AS bruttoleistung_vorletzter_monat
  FROM limit_last_2;
)
  SELECT 
    nettoleistung,
    nettoleistung / nettonennleistung_vorletzter_monat / 100 as cmp_brutto,
    bruttoleistung,
    bruttoleistung / bruttoleistung_vorletzter_monat / 100 as cmp_netto
  FROM pct
```

<BigValue 
  data={brutto} 
  value=bruttoleistung
  fmt=watt
  comparison=cmp_brutto
  comparisonFmt=pct1
  comparisonTitle="zum Vormonat"
/>

<BigValue 
  data={brutto} 
  value=nettoleistung
  fmt=watt
  comparison=cmp_netto
  comparisonFmt=pct2
  comparisonTitle="zum Vormonat"
/>

```sql solar_dates
  select
      reg_date
  from md.einheitensolar
  where reg_date > '2022-01-01'
  group by 1
```

<DateRange
    name=date_range_name
    data={solar_dates}
    dates=reg_date
/>

From {inputs.date_range_name.start} to {inputs.date_range_name.end}

```sql solar
  select
      date_trunc('month', reg_date) as month, bezirk1, count(*) as count
  from md.einheitensolar
  where reg_date between '${inputs.date_range_name.start}' and '${inputs.date_range_name.end}'
    and reg_date > '2022-01-01'

  group by 1,2
  order by 1,2
```

<BarChart 
    data={solar}
    x=month
    y=count
    series=bezirk1
    title="Registrierungen pro Woche"
/>

```sql solar_map
  select
      Plz as plz, count(*) as count
  from md.einheitensolar
  group by 1
  order by 1
```

<AreaMap 
    data={solar_map} 
    areaCol=plz
    geoJsonUrl=plz.geojson
    geoId=plz
    value=count
    height=400
    opacity=0.8
    colorPalette={['#DFDFDF', '#FFEF00']}
/>

```sql last_update
select updated_at
from md.einheitensolar
limit 1
```

Letztes Update: <Value data={last_update} column=updated_at /> 
