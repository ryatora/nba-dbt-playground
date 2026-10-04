-- gameId から求めたシーズンが、試合日と矛盾しないことを確かめる。矛盾する試合があれば行を返す。
-- シーズンは 10 月ごろ（プレシーズンを含む）に始まり、翌年 6 月ごろに終わる。
-- 終わりは 2019-20 が 2020 年 10 月までずれ込んだため翌年の 10/31 とし、始まりは余裕を持たせて開始年の 7/1 とする。
SELECT
    game_id,
    season,
    game_date
FROM {{ ref('stg_games') }}
WHERE
    game_date < MAKE_DATE(season_start_year, 7, 1)
    OR game_date > MAKE_DATE(season_start_year + 1, 10, 31)
