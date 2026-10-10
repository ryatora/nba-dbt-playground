"""Kaggle の NBA データセットをダウンロードして data/raw/ に置く。

事前に Kaggle CLI の認証を設定しておくこと（手順は AUTH_DOC_URL）。
取得済みのファイルは飛ばす。取り直すときは --force を付ける。
一時ディレクトリに取得してから data/raw/ に移すため、途中で失敗しても不完全なファイルは data/raw/ に残らない。
"""

import argparse
import subprocess
import sys
import tempfile
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
        # 移すときに同じファイルシステム内の名前の変更で済むよう、一時ディレクトリは data/raw/ の中に作る
        with tempfile.TemporaryDirectory(dir=RAW_DIR, prefix=".download-") as tmp_dir:
            # PATH に依存しないよう、このスクリプトを動かしている Python の kaggle を使う
            result = subprocess.run(
                [
                    sys.executable, "-m", "kaggle", "datasets", "download", DATASET,
                    "--file", file_name,
                    "--path", tmp_dir,
                    "--unzip",
                ],
            )
            if result.returncode != 0:
                sys.exit(
                    f"failed to download {file_name} (see the error above). "
                    f"If it is an authentication error, see: {AUTH_DOC_URL}"
                )
            # kaggle の終了コードだけに頼らず、移す前にファイルがあることも確かめる
            downloaded = Path(tmp_dir) / file_name
            if not downloaded.exists():
                sys.exit(f"{file_name} was not found in the downloaded files (see the output above)")
            downloaded.replace(RAW_DIR / file_name)


if __name__ == "__main__":
    main()
