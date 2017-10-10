# Put aliases here
#

# Date shortcuts
alias now='date "+%F-%H%M"'
alias unow='date -u "+%F-%H%M"'

alias flushdns='sudo dscacheutil -flushcache && sudo killall -HUP mDNSResponder'

alias vmware-dhcp-restart='sudo /Applications/VMware\ Fusion.app/Contents/Library/vmnet-cli --configure && \
sudo /Applications/VMware\ Fusion.app/Contents/Library/vmnet-cli --stop && \
sudo /Applications/VMware\ Fusion.app/Contents/Library/vmnet-cli --start'

