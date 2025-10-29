WITH product_cast AS (
  SELECT
    products_id,
    -- normalize commas (e.g., "12,34" → "12.34"), strip symbols, cast
    SAFE_CAST(REGEXP_REPLACE(REPLACE(purchase_price, ',', '.'), r'[^0-9.\-]', '') AS NUMERIC) AS purchase_price
  FROM {{ ref("stg_raw_data__product_data") }}
),
sales AS (
  SELECT
    date_date,
    orders_id,
    pdt_id as product_id,
    revenue,
    quantity
  FROM {{ ref("stg_raw_data__sales_data") }}
)
SELECT
  p.products_id,
  s.date_date,
  s.orders_id,
  s.revenue,
  s.quantity,
  p.purchase_price,
  ROUND(s.quantity * p.purchase_price, 2) AS purchase_cost,
  ROUND(s.revenue - s.quantity * p.purchase_price, 2) AS margin
FROM sales s
LEFT JOIN product_cast p
  ON p.products_id = s.pdt_id












