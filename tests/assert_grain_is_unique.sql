-- 複数列で一意になるはずのモデルの粒度を確かめる。重複があれば行を返す。
-- int_player_game_stats の照合に使うキー（game_id・team_city・team_name）が一意であることも確かめる。
-- dbt_utils.unique_combination_of_columns を使えば各モデルの YAML に書けるが、
-- パッケージを増やさないために singular test にしている。
WITH team_game_keys AS (
    SELECT
        game_id,
        team_city,
        team_name,
        COUNT(*) AS n
    FROM {{ ref('stg_team_game_stats') }}
    GROUP BY ALL
    HAVING COUNT(*) > 1
)

SELECT
    'stg_team_game_stats' AS model_name,
    game_id,
    team_id AS entity_id,
    COUNT(*) AS n
FROM {{ ref('stg_team_game_stats') }}
GROUP BY ALL
HAVING COUNT(*) > 1

UNION ALL

SELECT
    'stg_player_game_stats' AS model_name,
    game_id,
    player_id AS entity_id,
    COUNT(*) AS n
FROM {{ ref('stg_player_game_stats') }}
GROUP BY ALL
HAVING COUNT(*) > 1

UNION ALL

SELECT
    'stg_shots' AS model_name,
    game_id,
    action_number AS entity_id,
    COUNT(*) AS n
FROM {{ ref('stg_shots') }}
GROUP BY ALL
HAVING COUNT(*) > 1

UNION ALL

-- 試合の粒度ではないため game_id は NULL。重複していれば team_id が entity_id に出る
SELECT
    'stg_team_histories (team_id, first_season_start_year)' AS model_name,
    NULL AS game_id,
    team_id AS entity_id,
    COUNT(*) AS n
FROM {{ ref('stg_team_histories') }}
GROUP BY team_id, first_season_start_year
HAVING COUNT(*) > 1

UNION ALL

SELECT
    'int_player_game_stats' AS model_name,
    game_id,
    player_id AS entity_id,
    COUNT(*) AS n
FROM {{ ref('int_player_game_stats') }}
GROUP BY ALL
HAVING COUNT(*) > 1

UNION ALL

SELECT
    'stg_team_game_stats (game_id, team_city, team_name)' AS model_name,
    game_id,
    NULL AS entity_id,
    n
FROM team_game_keys
