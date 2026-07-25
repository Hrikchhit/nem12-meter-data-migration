# NEM12 Meter Data Migration & Cleanse

A data cleansing and migration pipeline for Australian electricity interval
meter data (NEM12 format), modelling the meter-data cleanse for a
**Gentrack → Kraken** retail platform migration.

## Problem

NEM12 is the AEMO standard for interval meter data. Files are *semi-structured*:
headerless, with multiple record types (100 header, 200 NMI/meter details,
300 interval readings, 900 end) — each with a different column structure.
Standard `pd.read_csv` fails on them. Before this data can migrate to a new
platform, it must be parsed, cleansed, validated, and normalised.

## Pipeline

Raw NEM12 → Python parser → cleanse & validate → 3NF normalised tables →
BigQuery → star schema → Power BI dashboard.

## Data

- `raw/real_sample_aemo_NEM12.csv` — real AEMO sample file (parser validated against this)
- `raw/extract_2025*.csv` — synthetic records in NEM12 format, scaled for volume

> Parser validated against real NEM12 samples; dataset scaled with synthetic
> records in the same format for demonstration. Real customer meter data is
> privacy-protected and not publicly available.

## Status

- [x] NEM12 parser (record-type-aware, handles variable structure)
- [x] Cleanse layer (invalid NMIs, interval-count validation, negatives, duplicates)
- [ ] Normalisation to 3NF
- [ ] BigQuery load
- [ ] SQL star schema
- [ ] Power BI dashboard

## Tech

Python (pandas) · SQL · Google BigQuery · Power BI
