SELECT * FROM {{ ref('stg_team_game_stats') }}
-- team_id が 0 の行を除く。2025-26 シーズンの一部の試合にある、チーム名が null で得点が 0 の行で、実在のチームではないとみなす
WHERE team_id <> 0
