{# +schema で指定したスキーマ名を、ターゲットのスキーマ名と連結せずにそのまま使う。 #}
{% macro generate_schema_name(custom_schema_name, node) -%}
    {{ custom_schema_name if custom_schema_name is not none else target.schema }}
{%- endmacro %}
