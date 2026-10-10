{#
  NBA の gameId は「00 + 試合の種類 1 桁 + シーズン開始年の下 2 桁 + 連番 5 桁」（例: 0022500001）。
  データ上は先頭の 0 が落ちた数値（例: 22500001）なので、100000 で割った下 2 桁がシーズン開始年の下 2 桁になる。
  BAA 発足の 1946 年より前のシーズンはないので、46 以上を 1900 年代とみなす。
  // を CASE の THEN・ELSE に書くと、dbt v2 の --static-analysis strict が CASE の結果を文字列型と推論する。
  その結果、`>= 2000` などの整数との比較が型の不一致のエラー（dbt0407）になる。
  そのため 1900 + 下 2 桁を CASE の外で求め、THEN・ELSE では足す値（2000 年代なら 100、1900 年代なら 0）だけを返す。
  WHEN の条件の // は問題ない。
  dbt 2.0.6 で再現した。解消されたら、CASE の THEN・ELSE で年を返す形に戻してよい。
#}
{% macro season_start_year(game_id) -%}
    {%- set yy = '(CAST(' ~ game_id ~ ' AS BIGINT) // 100000) % 100' -%}
    (1900 + {{ yy }} + CASE WHEN {{ yy }} < 46 THEN 100 ELSE 0 END)
{%- endmacro %}

{# シーズン開始年を 'YYYY-YY' の表記にする（2025 -> '2025-26'） #}
{% macro season_label(season_start_year) -%}
    CAST({{ season_start_year }} AS VARCHAR) || '-' || RIGHT(CAST({{ season_start_year }} + 1 AS VARCHAR), 2)
{%- endmacro %}

{#
  先頭の 0 が落ちた gameId の先頭の桁が試合の種類を表す。gameType 列は表記揺れがあるため、こちらを使う。
  `CASE <式> WHEN` の <式> に // を書くと、dbt v2 の --static-analysis strict が <式> をリスト型と推論する。
  その結果、WHEN の整数との比較が型の不一致のエラー（dbt0415）になる。
  そのため WHEN の条件に // を書く形にする。dbt 2.0.6 で再現した。解消されたら `CASE <式> WHEN` に戻してよい。
#}
{% macro game_type(game_id) -%}
    {%- set digit = 'CAST(' ~ game_id ~ ' AS BIGINT) // 10000000' -%}
    CASE
        WHEN {{ digit }} = 1 THEN 'Preseason'
        WHEN {{ digit }} = 2 THEN 'Regular Season'
        WHEN {{ digit }} = 3 THEN 'All-Star'
        WHEN {{ digit }} = 4 THEN 'Playoffs'
        WHEN {{ digit }} = 5 THEN 'Play-In'
        WHEN {{ digit }} = 6 THEN 'NBA Cup Final'
    END
{%- endmacro %}
