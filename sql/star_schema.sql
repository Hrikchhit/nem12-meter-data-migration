CREATE OR REPLACE VIEW `arrears-analytics.arrears.vw_daily_consumption` AS
SELECT
   n.nmi,
   m.meter,
   m.suffix,
   CASE m.suffix
      WHEN 'E1' THEN 'General Consumption'
      WHEN 'B1' THEN 'Solar Generation '
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