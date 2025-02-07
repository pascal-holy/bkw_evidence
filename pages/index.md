---
title: Balkonkraftwerke in Berlin
---

<Details title='Registrierungen pro Woche'>

Anzahl aller registrierten Balkonkraftwerke
</Details>

```sql solar_dates
  select
      reg_date
  from memory.bkw.einheitensolar
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
      extract(week from reg_date) as kw, EinheitBetriebsstatus as status, count(*) as count
  from memory.bkw.einheitensolar
  where reg_date between '${inputs.date_range_name.start}' and '${inputs.date_range_name.end}'
  group by 1,2
  order by 1
```

<BarChart 
    data={solar}
    x=kw
    y=count
    title="BKW pro Kalenderwoche"
    series=status
/>

```sql solar_map
  select
      Postleitzahl as plz, count(*) as count
  from memory.bkw.einheitensolar
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
    opacity=0.5
    colorPalette={['#F3F9A7', '#CAC531']}
/>

