---
title: Balkonkraftwerke im Markstammdatenregister
---

# Balkonkraftwerke im Markstammdatenregister

```sql total
select count(*) as total from {{ /sources/md/einheitensolar }}
```
Es gibt {% value data="total" value="sum(total)" fmt="id" /%} Balkonkraftwerke in Berlin.

{% range_calendar id="date_range_name" value_column="reg_date" default_range="last 3 months" /%}

Zeitraum: {{ date_range_name.range }}

{% big_value
    data="/sources/md/einheitensolar"
    value="sum(bruttoleistung)/1000"
    title="Bruttoleistung (kW)"
    fmt="num0"
    filters=["date_range_name"]
    comparison={ compare_vs="prior period" text="zum Vormonat" }
/%}

{% big_value
    data="/sources/md/einheitensolar"
    value="sum(nettonennleistung)/1000"
    title="Nettonennleistung (kW)"
    fmt="num0"
    filters=["date_range_name"]
    comparison={ compare_vs="prior period" text="zum Vormonat" }
/%}

```sql solar
  select
      date_trunc('month', reg_date) as month, count(*) as count
  from {{ /sources/md/einheitensolar }}
  where {{ date_range_name.filter }}
  group by 1
  order by 1
```



```sql solar_map
  select
      Plz as plz, count(*) as count
  from {{ /sources/md/einheitensolar }}
  group by 1
  order by 1
```

{% map height=400 %}
    {% area_layer
        data="solar_map"
        area_id="plz"
        geojson_url="https://tsb-opendata.s3.eu-central-1.amazonaws.com/plz/plz.geojson"
        geojson_id="plz"
        value="sum(count)"
        color_scale=["#DFDFDF", "#FFEF00"]
    /%}
{% /map %}

```sql last_update
select max(updated_at) as updated_at
from {{ /sources/md/einheitensolar }}
```

Letztes Update: {% value data="last_update" value="max(updated_at)" fmt="fulldate" /%}