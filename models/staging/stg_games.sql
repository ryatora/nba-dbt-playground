WITH source AS (
    SELECT
        *,
        {{ season_start_year('gameId') }} AS season_start_year
    FROM {{ source('raw', 'games') }}
)

SELECT
    gameId AS game_id,
    season_start_year,
    {{ season_label('season_start_year') }} AS season,
    {{ game_type('gameId') }} AS game_type,
    gameLabel AS game_label,
    gameSubLabel AS game_sub_label,
    gameDateTimeEst AS game_started_at_est,
    CAST(gameDateTimeEst AS DATE) AS game_date,
    hometeamId AS home_team_id,
    hometeamCity AS home_team_city,
    hometeamName AS home_team_name,
    awayteamId AS away_team_id,
    awayteamCity AS away_team_city,
    awayteamName AS away_team_name,
    homeScore AS home_score,
    awayScore AS away_score,
    winner AS winner_team_id,
    attendance,
    arenaId AS arena_id,
    arenaName AS arena_name,
    arenaCity AS arena_city,
    arenaState AS arena_state
FROM source
WHERE season_start_year >= {{ var('start_season_year') }}
