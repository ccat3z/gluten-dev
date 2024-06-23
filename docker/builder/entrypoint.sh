#! /bin/sh

set -ex

if [ -n "$BUILDER_UID" ] && [ "$BUILDER_UID" != 0 ]; then
    if [ -n "$BUILDER_GID" ]; then
        getent group "$BUILDER_GID" || groupadd -g "$BUILDER_GID" builder
    else
        echo "BUILDER_GID is required if BUILDER_UID is provide" >&2
        exit 1
    fi

    id -u builder &>/dev/null || useradd -m -u "$BUILDER_UID" -g "$BUILDER_GID" builder

    chown "$BUILDER_UID:$BUILDER_GID" "/home/builder"
fi

exec "$@"