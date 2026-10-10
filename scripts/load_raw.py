"""data/raw/ のファイルを DuckDB (nba.duckdb) の raw スキーマに読み込む。

先に scripts/download_data.py でデータを取得しておくこと。
テーブルは 1 つずつ消してから作り直すため、途中で失敗すると、失敗したテーブルは raw スキーマからなくなる。
その場合は、原因を直してからもう一度実行する。
"""

from pathlib import Path

import duckdb

ROOT = Path(__file__).resolve().parent.parent
RAW_DIR = ROOT / "data" / "raw"
DB_PATH = ROOT / "nba.duckdb"

# raw スキーマのテーブル名 -> data/raw/ のファイル名
TABLES = {
    "games": "Games.csv",
    "players": "Players.csv",
    "team_histories": "TeamHistories.csv",
    "team_statistics": "TeamStatistics.csv",
    "player_statistics": "PlayerStatistics.csv",
    "play_by_play": "PlayByPlay.parquet",
}


def source_query(path: Path) -> str:
    # SQL の文字列リテラルに埋め込むため、パスに含まれる ' をエスケープする
    quoted = str(path).replace("'", "''")
    if path.suffix == ".parquet":
        return f"READ_PARQUET('{quoted}')"
    # 値の中にカンマを含む行があり、引用符の自動検出に失敗するため明示する。
    # 型推論が途中の行で崩れないよう、全行を見て型を決める。
    return f"READ_CSV('{quoted}', header = TRUE, quote = '\"', escape = '\"', sample_size = -1)"


def main() -> None:
    missing = [name for name in TABLES.values() if not (RAW_DIR / name).exists()]
    if missing:
        raise FileNotFoundError(
            f"not found in data/raw/: {', '.join(missing)}. Run scripts/download_data.py first."
        )

    with duckdb.connect(str(DB_PATH)) as con:
        con.execute("CREATE SCHEMA IF NOT EXISTS raw")
        for table, file_name in TABLES.items():
            query = source_query(RAW_DIR / file_name)
            # CREATE OR REPLACE は新しいテーブルを書いてから古いテーブルを消すため、
            # 読み込むたびにファイルが元の 2 倍まで広がる。先に消して確定させ、空いた領域を再利用させる
            con.execute(f"DROP TABLE IF EXISTS raw.{table}")
            con.execute("CHECKPOINT")
            con.execute(f"CREATE TABLE raw.{table} AS SELECT * FROM {query}")
            count = con.execute(f"SELECT COUNT(*) FROM raw.{table}").fetchone()[0]
            print(f"raw.{table}: {count:,} rows")


if __name__ == "__main__":
    main()
