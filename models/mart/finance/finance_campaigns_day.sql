{{ config(
    materialized='view'
) }}

WITH finance AS (
    SELECT
        date_date,
        average_basket,
        operational_margin,
        total_quantity_sold,
        total_revenue,
        total_purchase_cost,
        total_shipping_fees,
        total_log_costs
    FROM
        {{ ref('finance_days') }}
),

marketing AS (
    SELECT
        date_date,
        daily_spend_usd,
        daily_impressions,
        daily_clicks
    FROM
        {{ ref('int_campaigns_day') }}
)

SELECT
    -- Date should be from the Finance side as it's the core key, but we'll use COALESCE
    COALESCE(f.date_date, m.date_date) AS date_date,
    
    -- Compute the new metric
    (f.operational_margin - m.daily_spend_usd) AS ads_margin,
    
    -- Select all Finance columns
    f.average_basket,
    f.operational_margin,
    f.total_quantity_sold,
    f.total_revenue,
    f.total_purchase_cost,
    f.total_shipping_fees,
    f.total_log_costs,
    
    -- Select and rename Marketing columns to match the request
    m.daily_spend_usd,
    m.daily_impressions,
    m.daily_clicks
    
    
FROM
    finance f
FULL OUTER JOIN
    marketing m 
        ON f.date_date = m.date_date

ORDER BY
    date_date DESC