# Berlin solar pipeline

This Bruin pipeline prepares the existing MotherDuck solar registry data for
the Evidence dashboard. It uses the `md` connection and reads `bkw.main.mast`.
The source table is maintained externally; this pipeline does not fetch new
registry records.

## Outputs

| Table | Contents |
| --- | --- |
| `bkw.analytics.berlin_solar_units` | One row per Berlin registration, with ID, postal code, parsed registration timestamp, capacities, and source update timestamp. |
| `bkw.analytics.berlin_solar_monthly` | Registration counts and capacity totals by UTC registration month. |
| `bkw.analytics.berlin_solar_postcodes` | Registration counts and capacity totals by postal code. |

The two summary assets depend on the registration asset and its blocking
quality checks. Checks cover unique IDs, complete fields, valid postcodes,
non-negative capacities, source row counts, and summary registration totals.
Malformed registration dates become NULL and fail the date completeness check
instead of being silently removed. No records are deduplicated or dropped.

All tables are rebuilt from the current source snapshot on each run. This
keeps late registrations, corrections, and source deletions in sync and makes
reruns idempotent. Capacity values retain the source's units; this pipeline
does not apply a watts-to-kilowatts conversion or change the dashboard's
existing conversion. The Berlin filter matches the dashboard's existing query
and does not introduce an additional installation-size or operating-status
filter.

## Validate and run

Install the Bruin CLI and configure a MotherDuck connection named `md` using
Bruin's normal connection configuration. Keep credentials out of Git.
Bruin discovers its configuration automatically.

From the repository root:

```bash
bruin validate pipelines/berlin-solar
bruin run --workers 4 pipelines/berlin-solar
npm run sources
```

Run the pipeline before refreshing Evidence sources: the dashboard's
`sources/md/einheitensolar.sql` query now reads the prepared registration table.
The Evidence MotherDuck connection must have access to the `bkw` database.

## Scheduling

`pipeline.yml` declares a daily schedule with catchup disabled because each run
rebuilds the complete snapshot. This declaration needs an orchestrator such as
Bruin Cloud to execute automatically. Merely running the CLI or adding these
files does not activate a recurring job. When deploying the pipeline, make the
`md` connection available to the orchestrator and arrange for the upstream
`mast` refresh to finish before this pipeline runs. Refresh Evidence sources
after a successful pipeline run.
