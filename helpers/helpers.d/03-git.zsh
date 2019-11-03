#!/bin/zsh 

git config --replace-all --global core.editor "${VISUAL}"
git config --replace-all --global core.page "${PAGER}"
