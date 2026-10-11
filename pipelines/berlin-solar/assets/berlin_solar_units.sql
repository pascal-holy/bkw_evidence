/* @bruin
name: bkw.analytics.berlin_solar_units
type: duckdb.sql
description: Berlin solar registrations prepared for the Evidence dashboard, with capacities in the original source units.

materialization:
  type: table
  strategy: create+replace

columns:
  - name: id
    type: BIGINT
    primary_key: true
    checks:
      - name: not_null
      - name: unique
  - name: Plz
    type: VARCHAR
    description: Five-digit postal code, kept as text to preserve leading zeroes.
    checks:
      - name: not_null
      - name: pattern
        value: "^[0-9]{5}$"
  - name: reg_date
    type: TIMESTAMPTZ
    description: Registration timestamp parsed from the source's Unix milliseconds.
    checks:
      - name: not_null
  - name: bruttoleistung
    type: DOUBLE
    checks:
      - name: not_null
      - name: non_negative
  - name: nettonennleistung
    type: DOUBLE
    checks:
      - name: not_null
      - name: non_negative
  - name: updated_at
    type: TIMESTAMPTZ
    checks:
      - name: not_null

custom_checks:
  - name: source_row_count_matches
    description: Every Berlin source registration must be retained.
    query: |
      SELECT
        (SELECT COUNT(*) FROM bkw.analytics.berlin_solar_units) =
        (SELECT COUNT(*) FROM bkw.main.mast WHERE Ort = 'Berlin')
    value: 1
  - name: registrations_present
    query: SELECT COUNT(*) > 0 FROM bkw.analytics.berlin_solar_units
    value: 1
@bruin */

SELECT
    Id AS id,
    Plz,
    to_timestamp(
        TRY_CAST(
            regexp_extract(EinheitMeldeDatum, '^/Date\((-?[0-9]+)\)/$', 1)
            AS BIGINT
        ) / 1000.0
    ) AS reg_date,
    Bruttoleistung AS bruttoleistung,
    Nettonennleistung AS nettonennleistung,
    updated_at
FROM bkw.main.mast
WHERE Ort = 'Berlin'
