-- Play-by-Play からシュート（フィールドゴールの試投）だけを取り出す。フリースローは含まない。
-- play_by_play は ID や日時が文字列で入っているため、他のモデルに合わせて型を変換する。
WITH source AS (
    SELECT
        *,
        {{ season_start_year('gameId') }} AS season_start_year
    FROM {{ source('raw', 'play_by_play') }}
    WHERE isFieldGoal
)

SELECT
    CAST(gameId AS BIGINT) AS game_id,
    actionNumber AS action_number,
    season_start_year,
    {{ season_label('season_start_year') }} AS season,
    {{ game_type('gameId') }} AS game_type,
    -- 2025-26 シーズンの一部の試合は gameDateTimeEst が空で、gameDateTimeEst_g に入っている
    CAST(CAST(COALESCE(gameDateTimeEst, gameDateTimeEst_g) AS TIMESTAMP) AS DATE) AS game_date,
    period,
    clock,
    -- 同じく teamId が空の試合は playerteamId に入っている
    CAST(COALESCE(teamId, playerteamId) AS BIGINT) AS team_id,
    teamTricode AS team_abbreviation,
    CAST(personId AS BIGINT) AS player_id,
    playerFullName AS player_name,
    subType AS shot_type,
    shotResult = 'Made' AS is_made,
    -- 2019-20 シーズンの途中で記録の形式が変わり、新しい形式では shotValue が空で actionType が '2pt'・'3pt' になる。
    -- actionType は古い形式では 'Made Shot' などで形式が揃わないため、出力せず shot_value・is_made に置き換える。
    -- 古い形式に 0 が入っている行は誤りとみなして null にする
    CASE
        WHEN shotValue IN (2, 3) THEN shotValue
        WHEN actionType = '3pt' THEN 3
        WHEN actionType = '2pt' THEN 2
    END AS shot_value,
    -- 0〜94 フィート（コートの長さ）の範囲外の値は誤りとみなして null にする
    CASE WHEN shotDistance BETWEEN 0 AND 94 THEN shotDistance END AS shot_distance_ft,
    area,
    areaDetail AS area_detail,
    -- コート上の位置。2019-20 シーズンの途中より前は null
    x,
    y,
    description
FROM source
WHERE season_start_year >= {{ var('start_season_year') }}
