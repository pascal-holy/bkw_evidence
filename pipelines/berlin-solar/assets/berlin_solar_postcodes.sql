/* @bruin
name: bkw.analytics.berlin_solar_postcodes
type: duckdb.sql
description: Berlin solar registration counts and capacity totals by postal code, in the original source units.

depends:
  - bkw.analytics.berlin_solar_units

materialization:
  type: table
  strategy: create+replace

columns:
  - name: Plz
    type: VARCHAR
    primary_key: true
    checks:
      - name: not_null
      - name: unique
      - name: pattern
        value: "^[0-9]{5}$"
  - name: registration_count
    type: BIGINT
    checks:
      - name: positive
  - name: bruttoleistung
    type: DOUBLE
    checks:
      - name: non_negative
  - name: nettonennleistung
    type: DOUBLE
    checks:
      - name: non_negative
  - name: updated_at
    type: TIMESTAMPTZ
    checks:
      - name: not_null

custom_checks:
  - name: registration_totals_match
    query: |
      SELECT
        (SELECT SUM(registration_count) FROM bkw.analytics.berlin_solar_postcodes) =
        (SELECT COUNT(*) FROM bkw.analytics.berlin_solar_units)
    value: 1
@bruin */

SELECT
    Plz,
    COUNT(*) AS registration_count,
    SUM(bruttoleistung) AS bruttoleistung,
    SUM(nettonennleistung) AS nettonennleistung,
    MAX(updated_at) AS updated_at
FROM bkw.analytics.berlin_solar_units
GROUP BY 1
