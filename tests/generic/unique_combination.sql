{#
  複数の列の組み合わせで一意になることを確かめる。重複している組み合わせと、その件数を返す。
  dbt_utils.unique_combination_of_columns と同じことを、パッケージを増やさずに generic test として定義している。
#}
{% test unique_combination(model, columns) %}
SELECT
    {{ columns | join(', ') }},
    COUNT(*) AS n
FROM {{ model }}
GROUP BY {{ columns | join(', ') }}
HAVING COUNT(*) > 1
{% endtest %}
