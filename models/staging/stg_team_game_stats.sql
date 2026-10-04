WITH source AS (
    SELECT
        *,
        {{ season_start_year('gameId') }} AS season_start_year
    FROM {{ source('raw', 'team_statistics') }}
)

SELECT
    gameId AS game_id,
    teamId AS team_id,
    season_start_year,
    {{ season_label('season_start_year') }} AS season,
    {{ game_type('gameId') }} AS game_type,
    CAST(gameDateTimeEst AS DATE) AS game_date,
    teamCity AS team_city,
    teamName AS team_name,
    opponentTeamId AS opponent_team_id,
    opponentTeamCity AS opponent_team_city,
    opponentTeamName AS opponent_team_name,
    home = 1 AS is_home,
    win = 1 AS is_win,
    teamScore AS points,
    opponentScore AS opponent_points,
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
    plusMinusPoints AS plus_minus,
    numMinutes AS minutes,
    q1Points AS q1_points,
    q2Points AS q2_points,
    q3Points AS q3_points,
    q4Points AS q4_points,
    otAllPoints AS overtime_points,
    benchPoints AS bench_points,
    pointsInThePaint AS points_in_the_paint,
    pointsFastBreak AS fast_break_points,
    pointsSecondChance AS second_chance_points,
    pointsFromTurnovers AS points_off_turnovers,
    biggestLead AS biggest_lead,
    leadChanges AS lead_changes,
    timesTied AS times_tied,
    -- この試合を終えた時点でのシーズン通算成績
    seasonWins AS season_wins,
    seasonLosses AS season_losses,
    seed AS playoff_seed
FROM source
WHERE season_start_year >= {{ var('start_season_year') }}
