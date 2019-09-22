#!/bin/bash
#ENABLED=0

if [[ $(uname -a) =~ [dD]rwin]]; then
ln -s "${HOME}/Library/Application Scripts/com.omnigroup.OmniFocus2.MacAppStore" ./.local/omnifocus-scripts
fi

