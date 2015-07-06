#!/bin/bash

pushd $HOME;
find "$HOME" -maxdepth 2 -ipath "*/.dotfiles/*" -print | while read line ; do
	
	[[ "$(basename "$line")" =~ ^(\.*|.git)$ ]] && continue	
	[[ -e "$(basename "$line")" && -e "$line" ]] && echo rm -rf "$HOME/$(basename "$line")";
	[[ ! -e "$HOME/$line" ]] && echo ln -s "$line"
done

popd
