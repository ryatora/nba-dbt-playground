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
  - mart の全カラムを columns に宣言し、説明を書いている。説明は、staging と mart で同じ文を2回書かないよう、doc block（`models/staging/_docs.md`）で共有する
    - 同じ名前のカラムがいくつかのモデルにあり、どれも同じ説明になるときは、カラム名と同じ名前の doc block を使う（例: `season`）。意味が違う同名のカラム（チームの `points` と選手の `points` など）には使わない
    - 1 つの mart と、その上流の staging・intermediate だけで共有する説明は、`<mart 名>_<カラム名>` の doc block を使う（例: `team_games_minutes`）。共通の doc block の後に続ける追記だけの doc block もある（例: `player_games_game_date` は `game_date` の後に続ける）
    - いくつかのカラムで共有する注記は、カラム名を含まない名前の doc block にする（例: `scoreless_games_note`）
    - mart の利用者が使えない staging のモデルへの案内（例: `stg_players` との結合）は、`<カラム名>_join_hint` の doc block に分け、staging と intermediate からだけ参照する。案内先のモデル自身（`stg_players` など）には付けない
    - mart の説明には、staging・intermediate のモデル名を書かない（private のモデルで、mart の利用者は使えないため）
  - metric の名前: カラムをそのまま合計する metric は `total_<カラム名>`（例: `total_points`）にする。ほかのモデルの metric と名前がぶつかるときは、モデルを表す接頭辞を付ける（例: `player_total_points`）。カラム名がすでに `total_` で始まるとき（`total_rebounds` など。今は該当する metric はない）は、カラムと同じ名前にならないよう `sum_<カラム名>` にする
    - `shots` の metric には、シュートの記録の集計だと分かるよう `shot_` を付けている（`shot_count` など）。`free_throw_points` は、2P・3P の得点の内訳と名前をそろえるため `total_` を付けていない
    - metric の名前はプロジェクト全体で一意にする必要がある。また、Lightdash では、metric と同じ名前のカラムを宣言すると、その metric を参照する ratio の metric を組み立てられなくなる（Lightdash 3.179.0 で確認）
  - `arenas` は、seed の `nba_arenas` を直接読む（列名を付け直すだけのため）
  - Lightdash は semantic model の entity を読まない（[Lightdash のドキュメント](https://docs.lightdash.com/integrations/dbt/metricflow)）ので、`games` と `arenas` の結合は、`games` の `config.meta.joins` にも書いている
  - staging と intermediate は access を private にしている。exposures は group に属さないため、private のモデルを参照できない。dbt Charts のグラフは exposures に登録しているので、marts を読む
- seeds: 本拠地アリーナの座標など、元データにない小さな表（[Wikidata](https://www.wikidata.org/) から取得）

データの注意点は、各モデルと列の説明に書いている。
{% enddocs %}
