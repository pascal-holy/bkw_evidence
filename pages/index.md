---
title: Balkonkraftwerke in Berlin
---

<Details title='Registrierungen pro Woche'>

Anzahl aller registrierten Balkonkraftwerke
</Details>

```sql total
select count(*) as total from md.einheitensolar
```
<BigValue 
  data={total} 
  value=total
  fmt=num1k
/>


```sql solar_dates
  select
      reg_date
  from md.einheitensolar
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
  group by 1,2
  order by 1,2
```

<BarChart 
    data={solar}
    x=month
    y=count
    series=bezirk1
    title="BKW pro Monat"
/>

```sql solar_map
  select
      Postleitzahl as plz, count(*) as count
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

