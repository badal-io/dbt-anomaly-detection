{% macro row_count(table_name) %}
  SELECT COUNT(*) as row_count
  FROM {{ table_name }}
{% endmacro %}
