#! /bin/bash

# ----- パス定義 -----
# ドキュメント格納先
DOC_PATH=/tna/rocinante/doc
# プログラム格納先
PROGRAM_PATH=/tna/rocinante/

# ドキュメントの生成
rdoc ${PROGRAM_PATH} -o ${DOC_PATH}
