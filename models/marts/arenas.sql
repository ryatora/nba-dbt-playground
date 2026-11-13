-- games.arena_name と結合できるよう、会場の名前を arena_name にする
SELECT
    arena AS arena_name,
    team_name AS home_team_name,
    latitude,
    longitude,
    state_abbr
FROM {{ ref('nba_arenas') }}
