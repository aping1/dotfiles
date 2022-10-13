#!zsh
emulate -L bash
_IMG_PLUGIN_NAME="${0:a:h:t}"
# tmux requires unrecognized OSC sequences to be wrapped with DCS tmux;
# <sequence> ST, and for all ESCs in <sequence> to be replaced with ESC ESC. It
# only accepts ESC backslash for ST.

function _img_check_dependency() {
  if ! (builtin command -V "$1" > /dev/null 2>& 1); then
    echo "$_IMG_PLUGIN_NAME ${0:t}: missing dependency: can't find $1" 1>& 2
    exit 1
  fi
}
function _img_b64_encode() {
    openssl base64
}
function _img_b64_decode() {
    openssl base64 -d
}

# print_image filename inline base64contents print_filename
#   filename: Filename to convey to client
#   inline: 0 or 1
#   base64contents: Base64-encoded contents
#   print_filename: If non-empty, print the filename 
#                   before outputting the image
function print_image() {
    emulate -L zsh
    setopt xtrace
    trap 'unsetopt xtrace' exit
    if [[ "${TMUX}" ]] ; then
        printf "\033Ptmux;\033\033]"
    else
        printf "\033]"
    fi
    if [[ -n "$1" ]]; then
        local fn=$1
        local B64ENCODED="$(openssl base64 < "${fn}")"
        print -- '1337;File=name='$(openssl base64 <<< "${fn}")';size='${#B64ENCODED}';inline=1;height=3;width=3;preserveAspectRatio=true:'"${B64ENCODED}"
    fi
    print -- "$3"
    if [[ "$TERM" == "screen*" && "${TMUX}" ]] ; then
        print -- "\a\033\\"
    else
        print -- "\a"
    fi
    if [ "$TERM" =~ "screen" ] ; then
      # This works in plain-old tmux but does the wrong thing in iTerm2's tmux
      # integration mode. tmux doesn't know that the cursor moves when the
      # image code is sent, while iTerm2 does. I had to pick one, since
      # integration mode is undetectable, so I picked the failure mode that at
      # least produces useful output (there is just too much whitespace in
      # integration mode). This could be fixed by not moving the cursor while
      # in integration mode. A better fix would be for tmux to interpret the
      # image sequence, though.
      # tl;dr: If you use tmux in integration mode, replace this with the printf
      # from the else clause.
      print -- '\033[4C\033[Bx\n'
    else
      print -- '\033[A\n'
    fi
}

if ! (( $+error )) ; then 
function error() {
    echo "ERROR: $*" 1>&2
}
fi

function imgcat() {
    ## https://iterm2.com/documentation-images.html 
    ## Main

    if [ -t 0 ]; then
        has_stdin=f
    else
        has_stdin=t
    fi

    # Show help if no arguments and no stdin.
    if [ $has_stdin = f -a $# -eq 0 ]; then
        show_help
        exit
    fi


    # Look for command line flags.
    while [ $# -gt 0 ]; do
        case "$1" in
        -h|--h|--help)
            show_help
            exit
            ;;
        -p|--p|--print)
            print_filename=1
            ;;
        -u|--u|--url)
            _img_check_dependency curl
            encoded_image=$(curl -s "$2" | _img_b64_encode) || (error "No such file or url $2"; exit 2)
            has_stdin=f
            print_image "$2" 1 "$encoded_image" "$print_filename"
            set -- ${@:1:1} "-u" ${@:3}
            if [ "$#" -eq 2 ]; then
                exit
            fi
            ;;
        -*)
            error "Unknown option flag: $1"
            show_help
            exit 1
        ;;
        *)
            if [ -r "$1" ] ; then
                has_stdin=f
                print_image "$1" 1 "$(_img_b64_encode < "$1")" "$print_filename"
            else
                error "$_IMG_PLUGIN_NAME: ${0:t} $1: No such file or directory"
                exit 2
            fi
            ;;
        esac
        shift
    done

    # Read and print stdin
    if [ $has_stdin = t ]; then
        print_image "" 1 "$(cat | _img_b64_encode)" ""
    fi

exit 0
}


function list_file() {
_img_check_dependency php || return 1
  fn=$1
  test -f "$fn" || return 0
  rc=$?
  if [[ $rc == 0 ]] ; then
    echo -n "$dims "
    ls -ld -- "$fn"
  else
    ls -ld -- "$fn"
  fi
}

function imgls() {
    if [ $# -eq 0 ]; then
        for fn in *
        do
            list_file "$fn"
        done < <(ls -ls)
    else
        for fn in "$@"
        do
            list_file "$fn"
        done
    fi
}

function img_line() {
if [ $# -eq 0 ]; then
  echo "Usage: divider file"
  exit 1
fi
printf '\033]1337;File=inline=1;width=100%%;height=1;preserveAspectRatio=0'
printf ":"
base64 < "$1"
printf '\a\n'
}
