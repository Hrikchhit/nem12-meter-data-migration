CREATE OR REPLACE VIEW `arrears-analytics.arrears.vw_daily_consumption` AS
SELECT
   n.nmi,
   m.meter,
   m.suffix,
   CASE m.suffix
      WHEN 'E1' THEN 'General Consumption'
      WHEN 'B1' THEN 'Solar Generation'
      WHEN 'E2' THEN 'Controlled Load'
      WHEN 'Q1' THEN 'Reactive Power'
      ELSE 'Other'
    END AS register_type,
    PARSE_DATE('%Y%m%d', f.date) AS reading_date,
    COUNT(*)                     AS intervals_recorded,
    ROUND(SUM(f.reading_num),3)  AS daily_kwh
FROM `arrears-analytics.arrears.fact_reading` f
JOIN `arrears-analytics.arrears.dim_meter` m ON f.meter_id = m.meter_id
JOIN `arrears-analytics.arrears.dim_nmi` n ON n.nmi_id = m.nmi_id
GROUP BY n.nmi, m.meter, m.suffix,f.date


-- ============================================================
-- Data quality view: completeness status per meter-day
-- ============================================================
CREATE OR REPLACE VIEW `arrears-analytics.arrears.vw_data_quality` AS
SELECT
    m.suffix,
    CASE m.suffix
        WHEN 'E1' THEN 'General Consumption'
        WHEN 'B1' THEN 'Solar Generation'
        WHEN 'E2' THEN 'Controlled Load'
        WHEN 'Q1' THEN 'Reactive Power'
        ELSE 'Other'
    END AS register_type,
    n.nmi,
    m.meter,
    PARSE_DATE('%Y%m%d', f.date) AS reading_date,
    COUNT(*) AS intervals_recorded,
    CASE
        WHEN COUNT(*) IN (48, 96) THEN 'Complete'
        ELSE 'Incomplete'
    END AS completeness_status
FROM `arrears-analytics.arrears.fact_reading` f
JOIN `arrears-analytics.arrears.dim_meter` m ON f.meter_id = m.meter_id
JOIN `arrears-analytics.arrears.dim_nmi`   n ON m.nmi_id = n.nmi_id
GROUP BY n.nmi, m.meter, m.suffix, f.date