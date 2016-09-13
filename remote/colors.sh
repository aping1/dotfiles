#  Customize BASH PS1 prompt to show current GIT repository and branch.
#  by Mike Stewart - http://MediaDoneRight.com

#  SETUP CONSTANTS
#  Bunch-o-predefined colors.  Makes reading code easier than escape sequences.
##  I don't remember where I found this.  o_O

# 
# tput Color Capabilities:
# 
# tput setab [1-7] – Set a background color using ANSI escape
# tput setb [1-7] – Set a background color
# tput setaf [1-7] – Set a foreground color using ANSI escape
# tput setf [1-7] – Set a foreground color
# tput Text Mode Capabilities:
# 
# tput bold – Set bold mode
# tput dim – turn on half-bright mode
# tput smul – begin underline mode
# tput rmul – exit underline mode
# tput rev – Turn on reverse mode
# tput smso – Enter standout mode (bold on rxvt)
# tput rmso – Exit standout mode
# tput sgr0 – Turn off all attributes
# Color Code for tput:
# 
# 0 – Black
# 1 – Red
# 2 – Green
# 3 – Yellow
# 4 – Blue
# 5 – Magenta
# 6 – Cyan
# 7 – White

export ESCCHAR='\x1b'
# Reset
#Color_Off="$ESCCHAR[0m$ESCEND"       # Text Reset
Color_Off='\x1b[0;m'
# $ESCEND='[\]'
# Regular Colors
Black="$ESCCHAR[0;30m$ESCEND"        # Black
Red="$ESCCHAR[0;31m$ESCEND"          # Red
Green="$ESCCHAR[0;32m$ESCEND"        # Green
Yellow="$ESCCHAR[0;33m$ESCEND"       # Yellow
Blue="$ESCCHAR[0;34m$ESCEND"         # Blue
Purple="$ESCCHAR[0;35m$ESCEND"       # Purple
Cyan="$ESCCHAR[0;36m$ESCEND"         # Cyan
White="$ESCCHAR[0;37m$ESCEND"        # White

# Bold
BBlack="$ESCCHAR[1;30m$ESCEND"       # Black
BRed="$ESCCHAR[1;31m$ESCEND"         # Red
bGreen="$ESCCHAR[1;32m$ESCEND"       # Green
BYellow="$ESCCHAR[1;33m$ESCEND"      # Yellow
BBlue="$ESCCHAR[1;34m$ESCEND"        # Blue
BPurple="$ESCCHAR[1;35m$ESCEND"      # Purple
BCyan="$ESCCHAR[1;36m$ESCEND"        # Cyan
BWhite="$ESCCHAR[1;37m$ESCEND"       # White

# Underline
UBlack="$ESCCHAR[4;30m$ESCEND"       # Black
URed="$ESCCHAR[4;31m$ESCEND"         # Red
UGreen="$ESCCHAR[4;32m$ESCEND"       # Green
UYellow="$ESCCHAR[4;33m$ESCEND"      # Yellow
UBlue="$ESCCHAR[4;34m$ESCEND"        # Blue
UPurple="$ESCCHAR[4;35m$ESCEND"      # Purple
UCyan="$ESCCHAR[4;36m$ESCEND"        # Cyan
UWhite="$ESCCHAR[4;37m$ESCEND"       # White

# Background
On_Black="$ESCCHAR[40m$ESCEND"       # Black
On_Red="$ESCCHAR[41m$ESCEND"         # Red
On_Green="$ESCCHAR[42m$ESCEND"       # Green
On_Yellow="$ESCCHAR[43m$ESCEND"      # Yellow
On_Blue="$ESCCHAR[44m$ESCEND"        # Blue
On_Purple="$ESCCHAR[45m$ESCEND"      # Purple
On_Cyan="$ESCCHAR[46m$ESCEND"        # Cyan
On_White="$ESCCHAR[47m$ESCEND"       # White

# High Intensty
IBlack="$ESCCHAR[0;90m$ESCEND"       # Black
IRed="$ESCCHAR[0;91m$ESCEND"         # Red
IGreen="$ESCCHAR[0;92m$ESCEND"       # Green
IYellow="$ESCCHAR[0;93m$ESCEND"      # Yellow
IBlue="$ESCCHAR[0;94m$ESCEND"        # Blue
IPurple="$ESCCHAR[0;95m$ESCEND"      # Purple
ICyan="$ESCCHAR[0;96m$ESCEND"        # Cyan
IWhite="$ESCCHAR[0;97m$ESCEND"       # White

# Bold High Intensty
BIBlack="$ESCCHAR[1;90m$ESCEND"      # Black
BIRed="$ESCCHAR[1;91m$ESCEND"        # Red
BIGreen="$ESCCHAR[1;92m$ESCEND"      # Green
BIYellow="$ESCCHAR[1;93m$ESCEND"     # Yellow
BIBlue="$ESCCHAR[1;94m$ESCEND"       # Blue
BIPurple="$ESCCHAR[1;95m$ESCEND"     # Purple
BICyan="$ESCCHAR[1;96m$ESCEND"       # Cyan
BIWhite="$ESCCHAR[1;97m$ESCEND"      # White

# High Intensty backgrounds
On_IBlack="$ESCCHAR[0;100m$ESCEND"   # Black
On_IRed="$ESCCHAR[0;101m$ESCEND"     # Red
On_IGreen="$ESCCHAR[0;102m$ESCEND"   # Green
On_IYellow="$ESCCHAR[0;103m$ESCEND"  # Yellow
On_IBlue="$ESCCHAR[0;104m$ESCEND"    # Blue
On_IPurple="$ESCCHAR[10;95m$ESCEND"  # Purple
On_ICyan="$ESCCHAR[0;106m$ESCEND"    # Cyan
On_IWhite="$ESCCHAR[0;107m$ESCEND"   # White


color_text () {
    local COLOR=${1:-"$Color_Off"}; shift
    [[ ${#} == 0 ]] || echo -ne "${COLOR}${@}${Color_Off}"
 }
