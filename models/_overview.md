{% docs __overview__ %}
# nba-dbt-playground

NBA のデータを使った dbt のサンプルプロジェクト。データベースは DuckDB（ローカルのファイル `nba.duckdb`）。

## データ

- Kaggle の [NBA Dataset: Box Scores and Stats (1947 - Today)](https://www.kaggle.com/datasets/eoinamoore/historical-nba-data-and-player-box-scores)（Eoin A. Moore, CC0）を raw スキーマに読み込んだもの。元の統計データは [NBA.com](https://www.nba.com/) 由来
- 既定で 2000-01 シーズン以降に絞る。`dbt_project.yml` の変数 `start_season_year` で変えられる

## モデルと seed

- staging: raw スキーマのテーブルごとに 1 モデル。列名の統一・型の変換、シーズンや試合の種類の付与、行の絞り込み（期間、`stg_shots` ではシュートの行だけ、など）を行う。結合はしない
- intermediate: staging を結合して、元データの欠けを補う（`int_player_game_stats` の所属チーム）
- marts: dbt Charts や Lightdash のグラフなど、利用者が読むモデル。利用者向けの加工が必要なときは、この層で行う
  - すべての mart に、Semantic Layer の semantic model を定義している。metric は `team_games`（1 試合平均得点・勝率・3P 成功率など）、`player_games`（選手の得点）、`shots`（シュート本数）、`games`（試合数・平均観客数）に定義している
  - semantic model は entity でつないでいる。`game`（`games` と、`team_games`・`player_games`・`shots`）と `arena`（`arenas` と `games`）
  - mart の全カラムを columns に宣言し、説明を書いている。どのモデルでも同じ説明になるカラムは、staging と共有する doc block（`models/staging/_docs.md`）を使う。モデルによって意味や注意点が違うカラム（`points`・`minutes` など）は、モデルごとに直書きする
  - metric の名前: カラムをそのまま合計する metric は `total_<カラム名>`（例: `total_points`）にする。ほかのモデルの metric と名前がぶつかるときは、モデルを表す接頭辞を付ける（例: `player_total_points`）。カラム名がすでに `total_` で始まるとき（`total_rebounds` など。今は該当する metric はない）は、カラムと同じ名前にならないよう `sum_<カラム名>` にする
    - `shots` の metric には、シュートの記録の集計だと分かるよう `shot_` を付けている（`shot_count` など）。`free_throw_points` は、2P・3P の得点の内訳と名前をそろえるため `total_` を付けていない
    - metric の名前はプロジェクト全体で一意にする必要がある。また、Lightdash では、metric と同じ名前のカラムを宣言すると、その metric を参照する ratio の metric を組み立てられなくなる（Lightdash 3.179.0 で確認）
  - `arenas` は、seed の `nba_arenas` を直接読む（列名を付け直すだけのため）
  - Lightdash は semantic model の entity を読まない（[Lightdash のドキュメント](https://docs.lightdash.com/integrations/dbt/metricflow)）ので、`games` と `arenas` の結合は、`games` の `config.meta.joins` にも書いている
  - staging と intermediate は access を private にしている。exposures は group に属さないため、private のモデルを参照できない。dbt Charts のグラフは exposures に登録しているので、marts を読む
- seeds: 本拠地アリーナの座標など、元データにない小さな表（[Wikidata](https://www.wikidata.org/) から取得）

データの注意点は、各モデルと列の説明に書いている。
{% enddocs %}
