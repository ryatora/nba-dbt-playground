SELECT
    teamId AS team_id,
    teamCity AS team_city,
    teamName AS team_name,
    TRIM(teamAbbrev) AS team_abbreviation,
    league,
    seasonFounded AS first_season_start_year,
    -- 現存するチームは 2100 が入っている
    NULLIF(seasonActiveTill, 2100) AS last_season_start_year,
    seasonActiveTill = 2100 AS is_current
FROM {{ source('raw', 'team_histories') }}
