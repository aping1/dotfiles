#!/bin/bash

nc -l 5556 | /usr/local/bin//reattach-to-user-namespace pbcopy
# [[ -e ~/Library/LaunchAgents/com.workflow.paste.plist ]] || cat >> ~/Library/LaunchAgents/com.workflow.paste.plist  << _EOF
# <?xml version="1.0" encoding="UTF-8"?>
# <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
# <plist version="1.0">
# <dict>
#     <key>Label</key>
#     <string>com.workflow.paste</string>
#     <key>Program</key>
#     <string>/Users/aping1/.dotfiles/remote_copy.sh</string>
#     <key>KeepAlive</key>
#     <true/>
#     <key>RunAtLoad</key>
#     <true/>
# </dict>
# </plist>
# _EOF
# launctl load ~/Library/LaunchAgents/com.workflow.paste.plist
