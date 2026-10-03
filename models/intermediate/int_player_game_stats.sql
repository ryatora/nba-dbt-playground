-- 元データでは選手の所属チーム（team_id・opponent_team_id）が空の行があるため、
-- 同じ試合のチームのボックススコアから、チームの都市名とチーム名で照合して補う。
-- 照合のキー（game_id・team_city・team_name）で stg_team_game_stats は 1 行に決まるため、行は増えない。
WITH player_game_stats AS (
    SELECT * FROM {{ ref('stg_player_game_stats') }}
),

team_game_stats AS (
    SELECT
        game_id,
        team_id,
        team_city,
        team_name,
        opponent_team_id
    FROM {{ ref('stg_team_game_stats') }}
)

-- 列は stg_player_game_stats と同じにしたいので、* replace で 2 列だけ置き換える
SELECT
    player_game_stats.* REPLACE (  -- noqa: AM04
        COALESCE(player_game_stats.team_id, team_game_stats.team_id) AS team_id,
        COALESCE(player_game_stats.opponent_team_id, team_game_stats.opponent_team_id) AS opponent_team_id
    )
FROM player_game_stats
LEFT JOIN team_game_stats
    ON
        player_game_stats.game_id = team_game_stats.game_id
        AND player_game_stats.team_city = team_game_stats.team_city
        AND player_game_stats.team_name = team_game_stats.team_name
