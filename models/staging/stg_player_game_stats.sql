WITH source AS (
    SELECT
        *,
        {{ season_start_year('gameId') }} AS season_start_year,
        -- 一部のプレシーズンの行は '6:05' のような分:秒の形式なので、分に換算する
        CASE
            WHEN CAST(numMinutes AS VARCHAR) LIKE '%:%'
                THEN
                    TRY_CAST(SPLIT_PART(CAST(numMinutes AS VARCHAR), ':', 1) AS DOUBLE)
                    + TRY_CAST(SPLIT_PART(CAST(numMinutes AS VARCHAR), ':', 2) AS DOUBLE) / 60
            ELSE TRY_CAST(numMinutes AS DOUBLE)
        END AS parsed_minutes
    FROM {{ source('raw', 'player_statistics') }}
)

SELECT
    gameId AS game_id,
    personId AS player_id,
    season_start_year,
    {{ season_label('season_start_year') }} AS season,
    {{ game_type('gameId') }} AS game_type,
    CAST(gameDateTimeEst AS DATE) AS game_date,
    CONCAT_WS(' ', firstName, lastName) AS player_name,
    playerteamId AS team_id,
    playerteamCity AS team_city,
    playerteamName AS team_name,
    opponentteamId AS opponent_team_id,
    opponentteamCity AS opponent_team_city,
    opponentteamName AS opponent_team_name,
    home = 1 AS is_home,
    win = 1 AS is_win,
    startingPosition AS starting_position,
    startingPosition IS NOT NULL AS is_starter,
    comment AS status_comment,
    -- 負の値は誤りとみなして null にする
    CASE WHEN parsed_minutes >= 0 THEN parsed_minutes END AS minutes,
    points,
    fieldGoalsMade AS field_goals_made,
    fieldGoalsAttempted AS field_goals_attempted,
    threePointersMade AS three_pointers_made,
    threePointersAttempted AS three_pointers_attempted,
    freeThrowsMade AS free_throws_made,
    freeThrowsAttempted AS free_throws_attempted,
    reboundsOffensive AS offensive_rebounds,
    reboundsDefensive AS defensive_rebounds,
    reboundsTotal AS total_rebounds,
    assists,
    steals,
    blocks,
    turnovers,
    foulsPersonal AS personal_fouls,
    plusMinusPoints AS plus_minus
FROM source
WHERE
    season_start_year >= {{ var('start_season_year') }}
    -- 2007-08〜2013-14 のプレシーズンに、選手ではなくチーム合計の行が混ざっている
    AND personId IS NOT NULL
