SELECT * FROM {{ref('stg_gz_raw_data__raw_gz_adwords')}}
UNION ALL
SELECT * FROM {{ref('stg_gz_raw_data__raw_gz_bing')}}
UNION ALL
SELECT * FROM {{ref('stg_gz_raw_data__raw_gz_criteo')}}
UNION ALL
SELECT * FROM {{ref('stg_gz_raw_data__raw_gz_facebook')}}