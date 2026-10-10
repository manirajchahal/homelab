#!/bin/bash
# POST_BEPINEX_CONFIG_HOOK (runs inside the container): the image only syncs
# /config/bepinex/plugins into the BepInEx install; mirror /config/bepinex/patchers too,
# into whichever install tree exists (bepinex.tmp during a merge, bepinex at boot).
for d in /opt/valheim/bepinex.tmp /opt/valheim/bepinex; do
    [ -d "$d/BepInEx" ] || continue
    mkdir -p "$d/BepInEx/patchers"
    rsync -a /config/bepinex/patchers/ "$d/BepInEx/patchers/"
done
