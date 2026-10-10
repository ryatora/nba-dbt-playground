{% docs game_id %}
試合 ID。NBA の gameId（「00 + 試合の種類 1 桁 + シーズン開始年の下 2 桁 + 連番 5 桁」、例: 0022500001）から
先頭の 0 が落ちた数値（例: 22500001）。
{% enddocs %}

{% docs season_start_year %}
シーズンの開始年（2025-26 シーズンなら 2025）。game_id の 2〜3 桁目（22500001 なら 25）から求める。
{% enddocs %}

{% docs season %}
シーズンの表記（例: 2025-26）。season_start_year から作る。
{% enddocs %}

{% docs game_type %}
試合の種類。game_id の先頭の桁（22500001 なら 2）から求める。元データの gameType 列は表記が揃っていないため使わない。

- Preseason: プレシーズン
- Regular Season: レギュラーシーズン。NBA Cup のグループステージ・準々決勝・準決勝を含む
- All-Star: オールスター
- Playoffs: プレーオフ
- Play-In: プレーイン・トーナメント
- NBA Cup Final: NBA Cup の決勝。レギュラーシーズンの成績には含まれない
{% enddocs %}

{% docs player_id %}
選手 ID。stg_players と結合して名前などを取れるが、一部の選手は stg_players にない。
{% enddocs %}

{% docs team_id %}
チーム ID。移転・改名しても同じ ID。stg_team_histories と結合して名称の履歴を取れるが、
オールスターのチームやプレシーズンで対戦した海外のチームなどは stg_team_histories にない。
{% enddocs %}

{% docs game_date %}
試合日。元データの試合開始日時（米国東部時間）の日付部分。
{% enddocs %}

{% docs start_season_year_filter %}
変数 start_season_year（dbt_project.yml で設定）以降のシーズンに絞る。
{% enddocs %}

{% docs game_id_not_in_games %}
オールスター・一部のプレシーズン・ごく一部のレギュラーシーズンの試合は、元データの Games に入っておらず、stg_games と結合できない。
そのため stg_games への relationships テストは、失敗ではなく warn にしている。
{% enddocs %}

{% docs team_city %}
チームの都市名（例: Philadelphia）。
{% enddocs %}

{% docs team_name %}
チーム名から都市名を除いた部分（例: 76ers）。
{% enddocs %}

{% docs opponent_team_city %}
対戦相手のチームの都市名。
{% enddocs %}

{% docs opponent_team_name %}
対戦相手のチーム名（都市名を除いた部分）。
{% enddocs %}

{% docs is_home %}
ホームの試合か。
{% enddocs %}

{% docs is_win %}
勝ったか。
{% enddocs %}

{% docs field_goals_made %}
フィールドゴール（フリースロー以外のシュート）の成功数。3P を含む。
{% enddocs %}

{% docs field_goals_attempted %}
フィールドゴールの試投数。3P を含む。
{% enddocs %}

{% docs three_pointers_made %}
3P の成功数。
{% enddocs %}

{% docs three_pointers_attempted %}
3P の試投数。3P ラインは 1979-80 シーズンに導入されたが、元データでは 1984-85 シーズンまで
ほぼ 0 で記録されている。start_season_year を 1985 より前にする場合に注意する。
{% enddocs %}

{% docs free_throws_made %}
フリースローの成功数。
{% enddocs %}

{% docs free_throws_attempted %}
フリースローの試投数。
{% enddocs %}

{% docs offensive_rebounds %}
オフェンスリバウンドの数。
{% enddocs %}

{% docs defensive_rebounds %}
ディフェンスリバウンドの数。
{% enddocs %}

{% docs total_rebounds %}
リバウンドの合計（オフェンスとディフェンス）。
{% enddocs %}

{% docs assists %}
アシストの数。
{% enddocs %}

{% docs steals %}
スティールの数。
{% enddocs %}

{% docs blocks %}
ブロックの数。
{% enddocs %}

{% docs turnovers %}
ターンオーバーの数。
{% enddocs %}

{% docs personal_fouls %}
パーソナルファウルの数。
{% enddocs %}

{% docs plus_minus %}
出場中の得失点差（自チームの得点 − 相手の得点）。チームの行では、一部の行を除いて試合の得失点差と同じ。
{% enddocs %}
