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

{% docs arena_name %}
会場の名前（例: Xfinity Mobile Arena）。
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
出場中の得失点差（自チームの得点 − 相手の得点）。
{% enddocs %}

{% docs game_label %}
試合の区分の表示名（例: NBA Finals、East First Round）。プレーオフや特別な試合だけに入っている。表記揺れがあるため、集計には game_type を使う。
{% enddocs %}

{% docs game_sub_label %}
game_label の補足（例: Game 5）。
{% enddocs %}

{% docs game_started_at_est %}
試合開始日時（米国東部時間）。
{% enddocs %}

{% docs home_team_id %}
ホームチームの team_id。
{% enddocs %}

{% docs home_team_city %}
ホームチームの都市名。オールスターの一部の試合は null。
{% enddocs %}

{% docs home_team_name %}
ホームチームのチーム名（都市名を除いた部分）。
{% enddocs %}

{% docs away_team_id %}
アウェイチームの team_id。
{% enddocs %}

{% docs away_team_city %}
アウェイチームの都市名。オールスターの一部の試合は null。
{% enddocs %}

{% docs away_team_name %}
アウェイチームのチーム名（都市名を除いた部分）。
{% enddocs %}

{% docs home_score %}
ホームチームの得点。
{% enddocs %}

{% docs away_score %}
アウェイチームの得点。
{% enddocs %}

{% docs winner_team_id %}
勝ったチームの team_id。home_team_id か away_team_id のどちらか（tests/assert_winner_is_home_or_away.sql で確かめる）。
{% enddocs %}

{% docs attendance %}
観客数。2025-26 シーズンの試合だけに入っていて、その中にも null の試合がある。
{% enddocs %}

{% docs arena_id %}
会場の ID。全試合に入っているが、2005-06 シーズンの 1 試合は 0。
{% enddocs %}

{% docs arena_city %}
会場の都市名。2025-26 シーズンの試合だけに入っている。
{% enddocs %}

{% docs arena_state %}
会場の州の略称（例: CA）。2025-26 シーズンの試合だけに入っていて、その中にも null の試合がある。
{% enddocs %}

{% docs opponent_points %}
対戦相手の得点。
{% enddocs %}

{% docs q1_points %}
第 1 クォーターの得点。
{% enddocs %}

{% docs q2_points %}
第 2 クォーターの得点。
{% enddocs %}

{% docs q3_points %}
第 3 クォーターの得点。
{% enddocs %}

{% docs q4_points %}
第 4 クォーターの得点。
{% enddocs %}

{% docs overtime_points %}
延長の得点の合計。延長がない試合はほとんどが null。
{% enddocs %}

{% docs bench_points %}
ベンチから出場した選手の得点の合計。
{% enddocs %}

{% docs points_in_the_paint %}
ペイントエリア（ゴール下の制限区域）での得点。
{% enddocs %}

{% docs fast_break_points %}
速攻での得点。
{% enddocs %}

{% docs second_chance_points %}
オフェンスリバウンドの後の攻撃での得点（セカンドチャンスポイント）。
{% enddocs %}

{% docs points_off_turnovers %}
相手のターンオーバーの後の攻撃での得点。
{% enddocs %}

{% docs biggest_lead %}
試合中の最大のリード（点差）。
{% enddocs %}

{% docs lead_changes %}
試合中にリードしているチームが入れ替わった回数。
{% enddocs %}

{% docs times_tied %}
試合中に同点になった回数。
{% enddocs %}

{% docs season_wins %}
この試合を終えた時点での、シーズンの通算勝利数。
{% enddocs %}

{% docs season_losses %}
この試合を終えた時点での、シーズンの通算敗戦数。
{% enddocs %}

{% docs playoff_seed %}
プレーオフ・プレーインのシード順位。それ以外の試合はほとんどが null。
{% enddocs %}

{% docs starting_position %}
先発したときのポジション（G・F・C）。ベンチから出場した場合と、出場しなかった場合は null。
{% enddocs %}

{% docs is_starter %}
先発したか。false にはベンチから出場した場合と、出場しなかった場合の両方を含む。
{% enddocs %}

{% docs status_comment %}
出場しなかった理由（例: DNP - Coach's Decision）。出場しなかった行でも null のことがある。
{% enddocs %}

{% docs action_number %}
試合の中でのプレーの通し番号。
{% enddocs %}

{% docs period %}
ピリオド。1〜4 が通常のクォーターで、5 以降は延長。
{% enddocs %}

{% docs clock %}
ピリオドの残り時間。ISO 8601 の期間の形式（例: PT11M56.00S は残り 11 分 56 秒）。
{% enddocs %}

{% docs shot_type %}
シュートの種類（例: Jump Shot、Layup Shot）。
{% enddocs %}

{% docs is_made %}
決まったか。
{% enddocs %}

{% docs shot_value %}
2 点か 3 点か。2019-20 シーズンの途中で元データの記録の形式が変わったため、新しい形式では actionType（'2pt'・'3pt'）から求める。元データの誤った値（0）は null にする。
{% enddocs %}

{% docs shot_distance_ft %}
リングからの距離（フィート）。コートの長さ（94 フィート）を超える誤った値は null にする。
{% enddocs %}

{% docs area %}
シュートしたエリア（例: Restricted Area、Left Corner 3）。2021-22 シーズンまでは null。
{% enddocs %}

{% docs area_detail %}
リングからの距離の帯（フィート）と方向（例: 16-24 Left）。area と同じく 2021-22 シーズンまでは null。
{% enddocs %}

{% docs description %}
プレーの説明文（例: MISS V. Wembanyama driving Layup）。
{% enddocs %}

{% docs x %}
コート上の横方向の位置。2019-20 シーズンより前は null。2019-20 も一部の試合は null。
{% enddocs %}

{% docs y %}
コート上の縦方向の位置。2019-20 シーズンより前は null。2019-20 も一部の試合は null。
{% enddocs %}
