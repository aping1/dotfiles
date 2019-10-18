# Put aliases here
#

# Date shortcuts
alias now='date "+%F-%H%M"'
alias unow='date -u "+%F-%H%M"'

alias flushdns='sudo dscacheutil -flushcache && sudo killall -HUP mDNSResponder'

alias vmware-dhcp-restart='sudo /Applications/VMware\ Fusion.app/Contents/Library/vmnet-cli --configure && \
sudo /Applications/VMware\ Fusion.app/Contents/Library/vmnet-cli --stop && \
sudo /Applications/VMware\ Fusion.app/Contents/Library/vmnet-cli --start'

alias vimlog='vim -nr'
alias jsosascript='osascript -l JavaScript'

gen_tags() {
    find . -name "*.py" | etags --output TAGS - 
    }

last_dir () {
    dir_stack 0
}

dir_stack (){
    d | grep '^'"$1" | cut -f2 
}


alias lst='ls -R | grep ":$" | sed -e '"'"'s/:$//'"'"' -e '"'"'s/[^-][^\/]*\//--/g'"'"' -e '"'"'s/^/   /'"'"' -e '"'"'s/-/|/'"'"
alias sync_dotfiles='rsync -avz ${HOME}/.dotfiles/plugins/fbtools dev:.dotfiles/plugins/'
