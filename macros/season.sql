{#
  NBA の gameId は「00 + 試合の種類 1 桁 + シーズン開始年の下 2 桁 + 連番 5 桁」（例: 0022500001）。
  データ上は先頭の 0 が落ちた数値（例: 22500001）なので、100000 で割った下 2 桁がシーズン開始年の下 2 桁になる。
  BAA 発足の 1946 年より前のシーズンはないので、46 以上を 1900 年代とみなす。
#}
{% macro season_start_year(game_id) -%}
    CASE
        WHEN (CAST({{ game_id }} AS BIGINT) // 100000) % 100 >= 46
            THEN 1900 + (CAST({{ game_id }} AS BIGINT) // 100000) % 100
        ELSE 2000 + (CAST({{ game_id }} AS BIGINT) // 100000) % 100
    END
{%- endmacro %}

{# シーズン開始年を 'YYYY-YY' の表記にする（2025 -> '2025-26'） #}
{% macro season_label(season_start_year) -%}
    CAST({{ season_start_year }} AS VARCHAR) || '-' || RIGHT(CAST({{ season_start_year }} + 1 AS VARCHAR), 2)
{%- endmacro %}

{# 先頭の 0 が落ちた gameId の先頭の桁が試合の種類を表す。gameType 列は表記揺れがあるため、こちらを使う。 #}
{% macro game_type(game_id) -%}
    CASE CAST({{ game_id }} AS BIGINT) // 10000000
        WHEN 1 THEN 'Preseason'
        WHEN 2 THEN 'Regular Season'
        WHEN 3 THEN 'All-Star'
        WHEN 4 THEN 'Playoffs'
        WHEN 5 THEN 'Play-In'
        WHEN 6 THEN 'NBA Cup Final'
    END
{%- endmacro %}
