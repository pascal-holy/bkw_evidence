---
title: Balkonkraftwerke im Markstammdatenregister
---

# Balkonkraftwerke im Markstammdatenregister

```sql total
select count(*) as total from {{ /queries/md/einheitensolar }}
```
Es gibt {% value data="total" value="sum(total)" fmt="id" /%} Balkonkraftwerke in Berlin.

{% range_calendar id="date_range_name" value_column="reg_date" default_range="last 3 months" /%}

Zeitraum: {{ date_range_name.range }}

{% big_value
    data={{ /queries/md/einheitensolar }}
    value="sum(bruttoleistung)"
    title="Bruttoleistung"
    fmt="[<1000]0\" W\";[<1000000]0.0,\" kW\";0.00,\" MW\""
    filters=["date_range_name"]
    comparison={ compare_vs="prior period" text="zum Vormonat" }
/%}

{% big_value
    data={{ /queries/md/einheitensolar }}
    value="sum(nettonennleistung)"
    title="Nettonennleistung"
    fmt="[<1000]0\" W\";[<1000000]0.0,\" kW\";0.00,\" MW\""
    filters=["date_range_name"]
    comparison={ compare_vs="prior period" text="zum Vormonat" }
/%}

```sql solar
  select
      date_trunc('month', reg_date) as month, bezirk1, count(*) as count
  from {{ /queries/md/einheitensolar }}
  where {{ date_range_name.filter }}
  group by 1,2
  order by 1,2
```

{% bar_chart data="solar" x="month" y="sum(count)" series="bezirk1" title="Registrierungen pro Monat nach Bezirk" /%}

```sql solar_map
  select
      Plz as plz, count(*) as count
  from {{ /queries/md/einheitensolar }}
  group by 1
  order by 1
```

{% map height=400 %}
    {% area_layer
        data="solar_map"
        area_id="plz"
        geojson_url="plz.geojson"
        geojson_id="plz"
        value="sum(count)"
        color_scale=["#DFDFDF", "#FFEF00"]
    /%}
{% /map %}

```sql last_update
select max(updated_at) as updated_at
from {{ /queries/md/einheitensolar }}
```

Letztes Update: {% value data="last_update" value="max(updated_at)" fmt="fulldate" /%}