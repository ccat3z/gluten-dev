#! /bin/sh

SCRIPT_DIR="$(realpath "$(dirname "$0")")"
GLUTEN_REPO="$(realpath "$SCRIPT_DIR/../gluten")"
VELOX_REPO="$(realpath "$SCRIPT_DIR/../velox")"

cat > "$SCRIPT_DIR/.env" <<EOF
DEV_REPO="${SCRIPT_DIR}"
GLUTEN_REPO="${GLUTEN_REPO}"
VELOX_REPO="${VELOX_REPO}"
UID=$(id -u)
GID=$(id -g)
EOF
