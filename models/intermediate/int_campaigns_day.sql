{{ config(
    materialized='table'
) }}

SELECT
    date_date,
    
    -- Aggregate the metrics across all platforms for the day
    SUM(ads_cost) AS daily_spend_usd,
    SUM(impression) AS daily_impressions,
    SUM(click) AS daily_clicks

FROM
    {{ ref('int_campaigns') }}

GROUP BY
    date_date

ORDER BY
    date_date DESC