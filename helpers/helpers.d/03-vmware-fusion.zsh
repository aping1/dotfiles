# VMWare Fusion 8 helper to restart vmware
#export VMWARE_LIB='/Applications/VMWare Fusion.app/Contents/Library'
export VMWARE_LIB="/Library/Preferences/VMware Fusion"
alias vm_restartdhcpd='sudo /Applications/VMware\ Fusion.app/Contents/Library/vmnet-cli --configure ;
sudo /Applications/VMware\ Fusion.app/Contents/Library/vmnet-cli --stop;
sudo /Applications/VMware\ Fusion.app/Contents/Library/vmnet-cli --start'

path+=(
"/Applications/VMware Fusion.app/Contents/Library"
)

function vmstart () {
"/Library/Application Support/VMware Fusion/vmrun" -T fusion start $1 nogui

}

