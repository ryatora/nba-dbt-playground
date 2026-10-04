"""Kaggle の NBA データセットをダウンロードして data/raw/ に置く。

事前に Kaggle CLI の認証を設定しておくこと（手順は AUTH_DOC_URL）。
取得済みのファイルは飛ばす。取り直すときは --force を付ける。
"""

import argparse
import subprocess
import sys
from pathlib import Path

DATASET = "eoinamoore/historical-nba-data-and-player-box-scores"
RAW_DIR = Path(__file__).resolve().parent.parent / "data" / "raw"
AUTH_DOC_URL = "https://github.com/Kaggle/kaggle-cli/blob/main/docs/README.md#authentication"

FILES = [
    "Games.csv",
    "Players.csv",
    "TeamHistories.csv",
    "TeamStatistics.csv",
    "PlayerStatistics.csv",
    "PlayByPlay.parquet",
]


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--force", action="store_true", help="取得済みのファイルも取り直す")
    args = parser.parse_args()

    RAW_DIR.mkdir(parents=True, exist_ok=True)
    for file_name in FILES:
        if (RAW_DIR / file_name).exists() and not args.force:
            print(f"skip {file_name} (already exists)")
            continue
        print(f"downloading {file_name} ...")
        # PATH に依存しないよう、このスクリプトを動かしている Python の kaggle を使う
        result = subprocess.run(
            [
                sys.executable, "-m", "kaggle", "datasets", "download", DATASET,
                "--file", file_name,
                "--path", str(RAW_DIR),
                "--unzip",
            ],
        )
        if result.returncode != 0:
            sys.exit(
                f"failed to download {file_name} (see the error above). "
                f"If it is an authentication error, see: {AUTH_DOC_URL}"
            )


if __name__ == "__main__":
    main()
