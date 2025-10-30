{% macro margin_percent(revenue, purchase_cost, precision=2) %}
    ROUND(
        ( ({{ revenue }} - {{ purchase_cost }}) / NULLIF({{ revenue }}, 0) ) * 100, 
        {{ precision }}
    )
{% endmacro %}
