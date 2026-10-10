-- stg_games の winner_team_id が、その試合の home_team_id か away_team_id のどちらかであることを確かめる。
-- どちらでもない行があれば返す。NOT IN は null の行を返さないため、null は各列の not_null テストで見つける。
SELECT
    game_id,
    home_team_id,
    away_team_id,
    winner_team_id
FROM {{ ref('stg_games') }}
WHERE winner_team_id NOT IN (home_team_id, away_team_id)
