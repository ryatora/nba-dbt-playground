{% docs __overview__ %}
# nba-dbt-playground

NBA のデータを使った dbt のサンプルプロジェクト。データベースは DuckDB（ローカルのファイル `nba.duckdb`）。

## データ

- Kaggle の [NBA Dataset: Box Scores and Stats (1947 - Today)](https://www.kaggle.com/datasets/eoinamoore/historical-nba-data-and-player-box-scores)（Eoin A. Moore, CC0）を raw スキーマに読み込んだもの。元の統計データは [NBA.com](https://www.nba.com/) 由来
- 既定で 2000-01 シーズン以降に絞る。`dbt_project.yml` の変数 `start_season_year` で変えられる

## モデルと seed

- staging: raw スキーマのテーブルごとに 1 モデル。列名の統一・型の変換、シーズンや試合の種類の付与、行の絞り込み（期間、`stg_shots` ではシュートの行だけ、など）を行う。結合はしない
- intermediate: staging を結合して、元データの欠けを補う（`int_player_game_stats` の所属チーム）
- seeds: 本拠地アリーナの座標など、元データにない小さな表（[Wikidata](https://www.wikidata.org/) から取得）

データの注意点は、各モデルと列の説明に書いている。
{% enddocs %}
