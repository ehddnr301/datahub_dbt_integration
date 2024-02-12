{% macro delete_BaseDate(schema_name, table_name, target_date) %}
    DELETE FROM "{{ schema_name }}"."{{ table_name }}"
    WHERE BaseDate = '{{ target_date }}';
{% endmacro %}
