#!/bin/bash -x
existing=~/.config/coc/extensions/node_modules/coc-ccls/node_modules/ws/lib/extension.js
missing=~/.config/coc/extensions/node_modules/coc-ccls/lib/extension.js
if command -v gln; then
LN=gln
fi
if [[ -e "$existing" && ! -e "$missing" ]]; then
  mkdir -p "$(dirname "$missing")"
  ${LN:-ln} -rs "$existing" "$missing" 2>/dev/null || ${LN} -s "$existing" "$missing" 
fi
set +x
