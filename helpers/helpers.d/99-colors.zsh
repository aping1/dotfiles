# This file is literally just for ls_colors
# | Key         | LSCOLORS (darkwi) | /etc/DIR_COLORS name  | Notes                                                                                                              |
# | no          | -                 | NORMAL  NORM          | Global default  although everything should be something                                                            |
# | fi          | -                 | FILE                  | Normal file                                                                                                        |
# | di          | 1                 | DIR                   | Directory                                                                                                          |
# | ln          | 2                 | SYMLINK  LINK  LNK    | Symbolic link. If you set this to 'target' instead of a numerical value  the colour is as for the file pointed to. |
# | so          | 3                 | SOCK                  | Socket                                                                                                             |
# | pi          | 4                 | FIFO  PIPE            | Named pipe                                                                                                         |
# | ex          | 8                 | EXEC                  | Executable file (i.e. has 'x' set in permissions)                                                                  |
# | bd          | 6                 | BLOCK  BLK            | Block device                                                                                                       |
# | cd          | 7                 | CHAR  CHR             | Character device                                                                                                   |
# | su          | 8                 | SETUID                | File that is setuid (u+s)                                                                                          |
# | sg          | 9                 | SETGID                | File that is setgid (g+s)                                                                                          |
# | tw          | 10                | STICKY_OTHER_WRITABLE | Directory that is sticky and other-writable (+t o+w)                                                               |
# | ow          | 11                | OTHER_WRITABLE        | Directory that is other-writable (o+w) and not sticky                                                              |
# | do          | -                 | DOOR                  | Door                                                                                                               |
# | or          | -                 | ORPHAN                | Symbolic link pointing to a non-existent file                                                                      |
# | st          | -                 | STICKY                | Directory with the sticky bit set (+t) and not other-writable                                                      |
# | mi          | -                 | MISSING               | Non-existent file pointed to by a symbolic link (visible when you type ls -l)                                      |
# | lc          | -                 | LEFTCODE  LEFT        | Opening terminal code                                                                                              |
# | rc          | -                 | RIGHTCODE  RIGHT      | Closing terminal code                                                                                              |
# | ec          | -                 | ENDCODE  END          | Non-filename text                                                                                                  |
# | *.extension | -                 |                       | Every file using this extension e.g. *.jpg                                                                         |
# 
LS_DEFAULT=0 # 0   = default colour
LS_BOLD=1 # 1   = bold
LS_DIM=2 # 2   = diim 
LS_UNDERLINE=4 # 4   = underlined
LS_FLASHING=5 # 5   = flashing text
LS_ITALIC=7 # 7   = reverse field

typeset -gA LS_FORGROUND=(
BLACK 30
RED 31
GREEN 32
ORANGE 33
BLUE 34
PURPLE 35
CYAN 36
GREY 37
WHITE 38
)

typeset -gA LS_BACKGROUND=(
BLACK 40
RED 41
GREEN 42
ORANGE 43
BLUE 44
PURPLE 45
CYAN 46
GREY 47
WHITE 48
)

# https://geoff.greer.fm/lscolors/
# 31  = red
# 32  = green
# 33  = orange
# 34  = blue
# 35  = purple
# 36  = cyan
# 37  = grey
# 40  = black background
# 41  = red background
# 42  = green background
# 43  = orange background
# 44  = blue background
# 45  = purple background
# 46  = cyan background
# 47  = grey background
# 90  = dark grey
# 91  = light red
# 92  = light green
# 93  = yellow
# 94  = light blue
# 95  = light purple
# 96  = turquoise
# 100 = dark grey background
# 101 = light red background
# 102 = light green background
# 103 = yellow background
typeset -gA LS_GROUPS=(
BINARY "${LS_FORGROUND[WHITE]};${LS_FLASHING};241"
INFO "${LS_FORGROUND[WHITE]};${LS_FLASHING};220;${LS_BOLD}"
PYSOURCE "${LS_FORGROUND[WHITE]};${LS_FLASHING};070"
HEADERS "${LS_FORGROUND[WHITE]};${LS_FLASHING};110"
DATA "${LS_FORGROUND[WHITE]};${LS_FLASHING};178"
VECTORIMG "${LS_FORGROUND[WHITE]};${LS_FLASHING};99"
MOVIE "${LS_FORGROUND[WHITE]};${LS_FLASHING};114"
LOSSLESS "${LS_FORGROUND[WHITE]};${LS_FLASHING};115"
WEB "${LS_FORGROUND[WHITE]};${LS_FLASHING};116"
SUBTITLES "${LS_FORGROUND[WHITE]};${LS_FLASHING};117"
LOSSLESSAUDIO "${LS_FORGROUND[WHITE]};${LS_FLASHING};136"
AUDIO "${LS_FORGROUND[WHITE]};${LS_FLASHING};137"
DOCUMENT "${LS_FORGROUND[WHITE]};${LS_FLASHING};184"
BOOKS "${LS_FORGROUND[WHITE]};${LS_FLASHING};141"
RTF "${LS_FORGROUND[WHITE]};${LS_FLASHING};111"
PRESENTATION "${LS_FORGROUND[WHITE]};${LS_FLASHING};166"
SCRIPT "${LS_FORGROUND[WHITE]};${LS_FLASHING};172"
CSOURCE "${LS_FORGROUND[WHITE]};${LS_FLASHING};81"
HTML "${LS_FORGROUND[WHITE]};${LS_FLASHING};125"
PICTURE "${LS_FORGROUND[WHITE]};${LS_FLASHING};97"
FONT "${LS_FORGROUND[WHITE]};${LS_FLASHING};66"
PKG "${LS_FORGROUND[WHITE]};${LS_FLASHING};215"
CERTS "${LS_FORGROUND[WHITE]};${LS_FLASHING};192"
ROMS "${LS_FORGROUND[WHITE]};${LS_FLASHING};213"
GCODE "${LS_FORGROUND[WHITE]};${LS_FLASHING};216"
DISKIMG "${LS_FORGROUND[WHITE]};${LS_FLASHING};124"
SQL "${LS_FORGROUND[WHITE]};${LS_FLASHING};222"
MACROFILE "${LS_FORGROUND[WHITE]};${LS_FLASHING};242"
SPREADSHEET "${LS_FORGROUND[WHITE]};${LS_FLASHING};112"
)

K_COLOR_DI="${LS_BOLD};${LS_FORGROUND[GREY]}"               # 1.   di directory
K_COLOR_LN="${LS_FLASHING};target"                          # 2.   ln symbolic link
K_COLOR_SO="${LS_FORGROUND[WHITE]};${LS_FLASHING};197"      # 3.   so socket
K_COLOR_PI="${LS_FORGROUND[WHITE]};${LS_FLASHING};126"      # 4.   pi pipe
K_COLOR_EX="${LS_FORGROUND[PURPLE]};${LS_FLASHING};208;${LS_BOLD}" # 5.   ex executable
K_COLOR_BD="${LS_FORGROUND[WHITE]};${LS_FLASHING};68"           # 6.   bd block special
K_COLOR_CD="${LS_FORGROUND[WHITE]};${LS_FLASHING};113;${LS_BOLD}" # 7.   cd character special
K_COLOR_SU="${LS_GROUPS[INFO]};3;100;${LS_BOLD}" # 8.   executable with setuid bit set
K_COLOR_SG="${LS_BACKGROUND[WHITE]};${LS_FLASHING};3;" # 9.   executable with setgid bit set
K_COLOR_TW="${LS_BACKGROUND[WHITE]};${LS_FLASHING};235;139;3" # 10.  directory writable to others, with sticky bit
K_COLOR_OW="${LS_GROUPS[INFO]}" # 11.  directory writable to others, without sticky bit

export LS_COLORS="\
bd=${K_COLOR_BD}:\
cd=${K_COLOR_CD}:\
di=${K_COLOR_DI}:\
ex=${K_COLOR_EX}:\
pi=${K_COLOR_PI}:\
fi=${LS_BOLD}:\
ln=${K_COLOR_LN}:\
no=${LS_BOLD}:\
ow=${K_COLOR_OW}:\
sg=${K_COLOR_SG}:\
su=${K_COLOR_SU}:\
so=${K_COLOR_SO}:\
tw=${K_COLOR_TW}:\
ca=${LS_FORGROUND[WHITE]};${LS_FLASHING};17:\
do=${LS_FORGROUND[GREEN]};${LS_FLASHING};127:\
mh=${LS_GROUPS[SQL]};${LS_BOLD}:\
or=${LS_BACKGROUND[WHITE]};${LS_FLASHING};196;${LS_FORGROUND[WHITE]};${LS_FLASHING};232;${LS_BOLD}:\
st=${LS_FORGROUND[WHITE]};${LS_FLASHING};86;${LS_BACKGROUND[WHITE]};${LS_FLASHING};234:\
*LS_COLORS=${LS_BACKGROUND[WHITE]};${LS_FLASHING};89;${LS_FORGROUND[WHITE]};${LS_FLASHING};197;${LS_BOLD};3;${LS_UNDERLINE};${LS_ITALIC}:\
*README=${LS_GROUPS[INFO]}:\
*README.rst=${LS_GROUPS[INFO]}:\
*README.md=${LS_GROUPS[INFO]}:\
*LICENSE=${LS_GROUPS[INFO]}:\
*COPYING=${LS_GROUPS[INFO]}:\
*INSTALL=${LS_GROUPS[INFO]}:\
*COPYRIGHT=${LS_GROUPS[INFO]}:\
*AUTHORS=${LS_GROUPS[INFO]}:\
*HISTORY=${LS_GROUPS[INFO]}:\
*CONTRIBUTORS=${LS_GROUPS[INFO]}:\
*PATENTS=${LS_GROUPS[INFO]}:\
*VERSION=${LS_GROUPS[INFO]}:\
*NOTICE=${LS_GROUPS[INFO]}:\
*CHANGES=${LS_GROUPS[INFO]}:\
*.log=${LS_FORGROUND[WHITE]};${LS_FLASHING};190:\
*.txt=${LS_FORGROUND[WHITE]};${LS_FLASHING};253:\
*.etx=${LS_FORGROUND[GREY]};${LS_FLASHING};184:\
*.info=${LS_GROUPS[DOCUMENT]}:\
*.markdown=${LS_GROUPS[DOCUMENT]}:\
*.md=${LS_GROUPS[DOCUMENT]}:\
*.mkd=${LS_GROUPS[DOCUMENT]}:\
*.nfo=${LS_FORGROUND[GREY]};${LS_FLASHING};184:\
*.pod=${LS_FORGROUND[GREY]};${LS_FLASHING};184:\
*.rst=${LS_GROUPS[DOCUMENT]}:\
*.tex=${LS_GROUPS[DOCUMENT]}:\
*.textile=${LS_GROUPS[DOCUMENT]}:\
*.bib=${LS_GROUPS[DATA]}:\
*.json=${LS_GROUPS[DATA]}:\
*.jsonl=${LS_GROUPS[DATA]}:\
*.ndjson=${LS_GROUPS[DATA]}:\
*.msg=${LS_GROUPS[DATA]}:\
*.pgn=${LS_GROUPS[DATA]}:\
*.rss=${LS_GROUPS[DATA]}:\
*.plist=${LS_BOLD}:\
*.xml=${LS_GROUPS[DATA]}:\
*.fxml=${LS_GROUPS[DATA]}:\
*.toml=${LS_GROUPS[DATA]}:\
*.yaml=${LS_GROUPS[DATA]}:\
*.yml=${LS_GROUPS[DATA]}:\
*.RData=${LS_GROUPS[DATA]}:\
*.rdata=${LS_GROUPS[DATA]}:\
*.xsd=${LS_GROUPS[DATA]}:\
*.dtd=${LS_GROUPS[DATA]}:\
*.sgml=${LS_GROUPS[DATA]}:\
*.rng=${LS_GROUPS[DATA]}:\
*.rnc=${LS_GROUPS[DATA]}:\
*.cbr=${LS_GROUPS[BOOKS]}:\
*.cbz=${LS_GROUPS[BOOKS]}:\
*.chm=${LS_GROUPS[BOOKS]}:\
*.djvu=${LS_GROUPS[BOOKS]}:\
*.pdf=${LS_GROUPS[BOOKS]}:\
*.PDF=${LS_GROUPS[BOOKS]}:\
*.mobi=${LS_GROUPS[BOOKS]}:\
*.epub=${LS_GROUPS[BOOKS]}:\
*.docm=${LS_GROUPS[RTF]};${LS_UNDERLINE}:\
*.doc=${LS_GROUPS[RTF]}:\
*.docx=${LS_GROUPS[RTF]}:\
*.odb=${LS_GROUPS[RTF]}:\
*.odt=${LS_GROUPS[RTF]}:\
*.rtf=${LS_GROUPS[RTF]}:\
*.odp=${LS_GROUPS[PRESENTATION]}:\
*.pps=${LS_GROUPS[PRESENTATION]}:\
*.ppt=${LS_GROUPS[PRESENTATION]}:\
*.pptx=${LS_GROUPS[PRESENTATION]}:\
*.ppts=${LS_GROUPS[PRESENTATION]}:\
*.pptxm=${LS_GROUPS[PRESENTATION]};${LS_UNDERLINE}:\
*.pptsm=${LS_GROUPS[PRESENTATION]};${LS_UNDERLINE}:\
*.csv=${LS_FORGROUND[WHITE]};${LS_FLASHING};78:\
*.tsv=${LS_FORGROUND[WHITE]};${LS_FLASHING};78:\
*.ods=${LS_GROUPS[SPEADSHEET]}:\
*.xla=${LS_FORGROUND[WHITE]};${LS_FLASHING};76:\
*.xls=${LS_GROUPS[SPEADSHEET]}:\
*.xlsx=${LS_GROUPS[SPEADSHEET]}:\
*.xlsxm=${LS_GROUPS[SPEADSHEET]};${LS_UNDERLINE}:\
*.xltm=${LS_FORGROUND[WHITE]};${LS_FLASHING};73;${LS_UNDERLINE}:\
*.xltx=${LS_FORGROUND[WHITE]};${LS_FLASHING};73:\
*.pages=${LS_GROUPS[RTF]}:\
*.numbers=${LS_GROUPS[SPEADSHEET]}:\
*.key=${LS_GROUPS[PRESENTATION]}:\
*config=${LS_BOLD}:*cfg=${LS_BOLD}:*conf=${LS_BOLD}:*rc=${LS_BOLD}:*.ini=${LS_BOLD}:\
*authorized_keys=${LS_BOLD}:*known_hosts=${LS_BOLD}:\
*.viminfo=${LS_BOLD}:\
*.pcf=${LS_BOLD}:\
*.psf=${LS_BOLD}:\
*.hidden-color-scheme=${LS_BOLD}:\
*.hidden-tmTheme=${LS_BOLD}:\
*.tmTheme=${LS_BOLD}:\
*.last-run=${LS_BOLD}:\
*.sublime-build=${LS_BOLD}:*.sublime-commands=${LS_BOLD}:*.sublime-keymap=${LS_BOLD}:*.sublime-settings=${LS_BOLD}:\
*.sublime-snippet=${LS_BOLD}:*.sublime-project=${LS_BOLD}:*.sublime-workspace=${LS_BOLD}:\
*.merged-ca-bundle=${LS_BOLD}:*.user-ca-bundle=${LS_BOLD}:\
*.epf=${LS_BOLD}:\
*.git=${LS_FORGROUND[WHITE]};${LS_FLASHING};197:\
*.gitignore=${LS_FORGROUND[WHITE]};${LS_FLASHING};240:\
*.gitattributes=${LS_FORGROUND[WHITE]};${LS_FLASHING};240:\
*.gitmodules=${LS_FORGROUND[WHITE]};${LS_FLASHING};240:\
*.bat=${LS_GROUPS[SCRIPT]}:\
*.awk=${LS_GROUPS[SCRIPT]}:\
*.sed=${LS_GROUPS[SCRIPT]}:\
*.sh=${LS_GROUPS[SCRIPT]}:\
*.zsh=${LS_GROUPS[SCRIPT]}:\
*.vim=${LS_GROUPS[SCRIPT]}:\
*.kak=${LS_GROUPS[SCRIPT]}:\
*.ahk=${LS_GROUPS[FLASHRED]}:\
*.pyc=${LS_FORGROUND[WHITE]};${LS_FLASHING};240:\
*.py=${LS_GROUPS[PYSOURCE]}:\
*.ipynb=${LS_GROUPS[PYSOURCE]}:\
*.rb=${LS_FORGROUND[WHITE]}:\
*.gemspec=${LS_FORGROUND[WHITE]}:\
*.pl=${LS_FORGROUND[GREY]};${LS_FLASHING};208:\
*.PL=${LS_FORGROUND[GREY]};${LS_FLASHING};160:\
*.t=${LS_GROUPS[MOVIE]}:\
*.msql=${LS_FORGROUND[WHITE]};${LS_DIM};222:*.mysql=${LS_GROUPS[SQL]}:\
*.sql=${LS_GROUPS[SQL]}:*.pgsql=${LS_GROUPS[SQL]}:\
*.tcl=${LS_FORGROUND[WHITE]};${LS_FLASHING};64;${LS_BOLD}:\
*.r=${LS_FORGROUND[WHITE]};${LS_FLASHING};49:*.R=${LS_FORGROUND[WHITE]};${LS_FLASHING};49:\
*.gs=${LS_GROUPS[CSOURCE]}:\
*.clj=${LS_GROUPS[FLASHRED]}:\
*.cljs=${LS_GROUPS[FLASHRED]}:\
*.cljc=${LS_GROUPS[FLASHRED]}:\
*.cljw=${LS_GROUPS[FLASHRED]}:\
*.scala=${LS_GROUPS[FLASHRED]}:\
*.dart=${LS_FORGROUND[WHITE]};${LS_FLASHING};51:\
*.asm=${LS_GROUPS[CSOURCE]}:\
*.cl=${LS_GROUPS[CSOURCE]}:\
*.lisp=${LS_GROUPS[CSOURCE]}:\
*.rkt=${LS_GROUPS[CSOURCE]}:\
*.lua=${LS_GROUPS[CSOURCE]}:\
*.moon=${LS_GROUPS[CSOURCE]}:\
*.c=${LS_GROUPS[CSOURCE]}:*.C=${LS_GROUPS[CSOURCE]}:\
*.h=${LS_GROUPS[HEADERS]}:*.H=${LS_GROUPS[HEADERS]}:\
*.tcc=${LS_GROUPS[HEADERS]}:*.c++=${LS_GROUPS[CSOURCE]}:\
*.h++=${LS_GROUPS[HEADERS]}:*.hpp=${LS_GROUPS[HEADERS]}:*.hxx=${LS_GROUPS[HEADERS]}:\
*.ii=${LS_GROUPS[HEADERS]}:\
*.M=${LS_GROUPS[HEADERS]}:*.m=${LS_GROUPS[HEADERS]}:\
*.cc=${LS_GROUPS[CSOURCE]}:\
*.cs=${LS_GROUPS[CSOURCE]}:\
*.cp=${LS_GROUPS[CSOURCE]}:\
*.cpp=${LS_GROUPS[CSOURCE]}:\
*.cxx=${LS_GROUPS[CSOURCE]}:\
*.cr=${LS_GROUPS[CSOURCE]}:\
*.go=${LS_GROUPS[CSOURCE]}:\
*.f=${LS_GROUPS[CSOURCE]}:\
*.F=${LS_GROUPS[CSOURCE]}:\
*.for=${LS_GROUPS[CSOURCE]}:\
*.ftn=${LS_GROUPS[CSOURCE]}:\
*.f90=${LS_GROUPS[CSOURCE]}:\
*.F90=${LS_GROUPS[CSOURCE]}:\
*.f95=${LS_GROUPS[CSOURCE]}:\
*.F95=${LS_GROUPS[CSOURCE]}:\
*.f03=${LS_GROUPS[CSOURCE]}:\
*.F03=${LS_GROUPS[CSOURCE]}:\
*.f08=${LS_GROUPS[CSOURCE]}:\
*.F08=${LS_GROUPS[CSOURCE]}:\
*.nim=${LS_GROUPS[CSOURCE]}:\
*.nimble=${LS_GROUPS[CSOURCE]}:\
*.s=${LS_GROUPS[HEADERS]}:\
*.S=${LS_GROUPS[HEADERS]}:\
*.rs=${LS_GROUPS[CSOURCE]}:\
*.scpt=${LS_FORGROUND[WHITE]};${LS_FLASHING};219:\
*.swift=${LS_FORGROUND[WHITE]};${LS_FLASHING};219:\
*.sx=${LS_GROUPS[CSOURCE]}:\
*.vala=${LS_GROUPS[CSOURCE]}:\
*.vapi=${LS_GROUPS[CSOURCE]}:\
*.hi=${LS_GROUPS[HEADERS]}:\
*.hs=${LS_GROUPS[CSOURCE]}:\
*.lhs=${LS_GROUPS[CSOURCE]}:\
*.agda=${LS_GROUPS[CSOURCE]}:\
*.lagda=${LS_GROUPS[CSOURCE]}:\
*.lagda.tex=${LS_GROUPS[CSOURCE]}:\
*.lagda.rst=${LS_GROUPS[CSOURCE]}:\
*.lagda.md=${LS_GROUPS[CSOURCE]}:\
*.agdai=${LS_GROUPS[HEADERS]}:\
*.zig=${LS_GROUPS[CSOURCE]}:\
*.v=${LS_GROUPS[CSOURCE]}:\
*.tf=${LS_FORGROUND[WHITE]};${LS_FLASHING};168:*.tfstate=${LS_FORGROUND[WHITE]};${LS_FLASHING};168:\
*.tfvars=${LS_FORGROUND[WHITE]};${LS_FLASHING};168:\
*.css=${LS_GROUPS[HTML]};${LS_BOLD}:*.less=${LS_GROUPS[HTML]};${LS_BOLD}:\
*.sass=${LS_GROUPS[HTML]};${LS_BOLD}:\
*.scss=${LS_GROUPS[HTML]};${LS_BOLD}:\
*.htm=${LS_GROUPS[HTML]};${LS_BOLD}:\
*.html=${LS_GROUPS[HTML]};${LS_BOLD}:\
*.jhtm=${LS_GROUPS[HTML]};${LS_BOLD}:\
*.mht=${LS_GROUPS[HTML]};${LS_BOLD}:\
*.eml=${LS_GROUPS[HTML]};${LS_BOLD}:\
*.mustache=${LS_GROUPS[HTML]};${LS_BOLD}:\
*.coffee=${LS_FORGROUND[WHITE]};${LS_FLASHING};074;${LS_BOLD}:\
*.java=${LS_FORGROUND[WHITE]};${LS_FLASHING};074;${LS_BOLD}:\
*.js=${LS_FORGROUND[WHITE]};${LS_FLASHING};074;${LS_BOLD}:\
*.mjs=${LS_FORGROUND[WHITE]};${LS_FLASHING};074;${LS_BOLD}:\
*.jsm=${LS_FORGROUND[WHITE]};${LS_FLASHING};074;${LS_BOLD}:\
*.jsp=${LS_FORGROUND[WHITE]};${LS_FLASHING};074;${LS_BOLD}:\
*.php=${LS_GROUPS[CSOURCE]}:\
*.ctp=${LS_GROUPS[CSOURCE]}:\
*.twig=${LS_GROUPS[CSOURCE]}:\
*.vb=${LS_GROUPS[CSOURCE]}:\
*.vba=${LS_GROUPS[CSOURCE]}:\
*.vbs=${LS_GROUPS[CSOURCE]}:\
*Dockerfile=${LS_FORGROUND[WHITE]};${LS_FLASHING};155:\
*.dockerignore=${LS_FORGROUND[WHITE]};${LS_FLASHING};240:\
*Makefile=${LS_FORGROUND[WHITE]};${LS_FLASHING};155:\
*MANIFEST=${LS_FORGROUND[WHITE]};${LS_FLASHING};243:\
*pm_to_blib=${LS_FORGROUND[WHITE]};${LS_FLASHING};240:\
*.nix=${LS_FORGROUND[WHITE]};${LS_FLASHING};155:\
*.dhall=${LS_GROUPS[DATA]}:\
*.rake=${LS_FORGROUND[WHITE]};${LS_FLASHING};155:\
*.am=${LS_FORGROUND[WHITE]};${LS_FLASHING};242:\
*.in=${LS_FORGROUND[WHITE]};${LS_FLASHING};242:\
*.hin=${LS_FORGROUND[WHITE]};${LS_FLASHING};242:\
*.scan=${LS_FORGROUND[WHITE]};${LS_FLASHING};242:\
*.m4=${LS_FORGROUND[WHITE]};${LS_FLASHING};242:\
*.old=${LS_FORGROUND[WHITE]};${LS_FLASHING};242:\
*.out=${LS_FORGROUND[WHITE]};${LS_FLASHING};242:\
*.SKIP=${LS_FORGROUND[WHITE]};${LS_FLASHING};244:\
*.diff=${LS_BACKGROUND[WHITE]};${LS_FLASHING};197;${LS_FORGROUND[WHITE]};${LS_FLASHING};232:\
*.patch=${LS_BACKGROUND[WHITE]};${LS_FLASHING};197;${LS_FORGROUND[WHITE]};${LS_FLASHING};232;${LS_BOLD}:\
*.bmp=${LS_GROUPS[PICTURE]}:\
*.dicom=${LS_GROUPS[PICTURE]}:\
*.tiff=${LS_GROUPS[PICTURE]}:\
*.tif=${LS_GROUPS[PICTURE]}:\
*.TIFF=${LS_GROUPS[PICTURE]}:\
*.cdr=${LS_GROUPS[PICTURE]}:\
*.flif=${LS_GROUPS[PICTURE]}:\
*.gif=${LS_GROUPS[PICTURE]}:\
*.icns=${LS_GROUPS[PICTURE]}:\
*.ico=${LS_GROUPS[PICTURE]}:\
*.jpeg=${LS_GROUPS[PICTURE]}:\
*.JPG=${LS_GROUPS[PICTURE]}:\
*.jpg=${LS_GROUPS[PICTURE]}:\
*.nth=${LS_GROUPS[PICTURE]}:\
*.png=${LS_GROUPS[PICTURE]}:\
*.psd=${LS_GROUPS[PICTURE]}:\
*.pxd=${LS_GROUPS[PICTURE]}:\
*.pxm=${LS_GROUPS[PICTURE]}:\
*.xpm=${LS_GROUPS[PICTURE]}:\
*.webp=${LS_GROUPS[PICTURE]}:\
*.ai=${LS_GROUPS[VECTORIMG]}:\
*.eps=${LS_GROUPS[VECTORIMG]}:\
*.epsf=${LS_GROUPS[VECTORIMG]}:\
*.drw=${LS_GROUPS[VECTORIMG]}:\
*.ps=${LS_GROUPS[VECTORIMG]}:\
*.svg=${LS_GROUPS[VECTORIMG]}:\
*.avi=${LS_GROUPS[MOVIE]}:\
*.divx=${LS_GROUPS[MOVIE]}:\
*.IFO=${LS_GROUPS[MOVIE]}:\
*.m2v=${LS_GROUPS[MOVIE]}:\
*.m4v=${LS_GROUPS[MOVIE]}:\
*.mkv=${LS_GROUPS[MOVIE]}:\
*.MOV=${LS_GROUPS[MOVIE]}:\
*.mov=${LS_GROUPS[MOVIE]}:\
*.mp4=${LS_GROUPS[MOVIE]}:\
*.mpeg=${LS_GROUPS[MOVIE]}:\
*.mpg=${LS_GROUPS[MOVIE]}:\
*.ogm=${LS_GROUPS[MOVIE]}:\
*.rmvb=${LS_GROUPS[MOVIE]}:\
*.sample=${LS_GROUPS[MOVIE]}:\
*.wmv=${LS_GROUPS[MOVIE]}:\
*.3g2=${LS_GROUPS[LOSSLESS]}:\
*.3gp=${LS_GROUPS[LOSSLESS]}:\
*.gp3=${LS_GROUPS[LOSSLESS]}:\
*.webm=${LS_GROUPS[LOSSLESS]}:\
*.gp4=${LS_GROUPS[LOSSLESS]}:\
*.asf=${LS_GROUPS[LOSSLESS]}:\
*.flv=${LS_GROUPS[LOSSLESS]}:\
*.ts=${LS_GROUPS[LOSSLESS]}:\
*.ogv=${LS_GROUPS[LOSSLESS]}:\
*.f4v=${LS_GROUPS[LOSSLESS]}:\
*.VOB=${LS_GROUPS[LOSSLESS]};${LS_BOLD}:\
*.vob=${LS_GROUPS[LOSSLESS]};${LS_BOLD}:\
*.ass=${LS_GROUPS[SUBTITLES]}:\
*.srt=${LS_GROUPS[SUBTITLES]}:\
*.ssa=${LS_GROUPS[SUBTITLES]}:\
*.sub=${LS_GROUPS[SUBTITLES]}:\
*.sup=${LS_GROUPS[SUBTITLES]}:\
*.vtt=${LS_GROUPS[SUBTITLES]}:\
*.3ga=${LS_GROUPS[AUDIO]};${LS_BOLD}:\
*.S3M=${LS_GROUPS[AUDIO]};${LS_BOLD}:\
*.aac=${LS_GROUPS[AUDIO]};${LS_BOLD}:\
*.amr=${LS_GROUPS[AUDIO]};${LS_BOLD}:\
*.au=${LS_GROUPS[AUDIO]};${LS_BOLD}:\
*.caf=${LS_GROUPS[AUDIO]};${LS_BOLD}:\
*.dat=${LS_GROUPS[AUDIO]};${LS_BOLD}:\
*.dts=${LS_GROUPS[AUDIO]};${LS_BOLD}:\
*.fcm=${LS_GROUPS[AUDIO]};${LS_BOLD}:\
*.m4a=${LS_GROUPS[AUDIO]};${LS_BOLD}:\
*.mid=${LS_GROUPS[AUDIO]};${LS_BOLD}:\
*.mod=${LS_GROUPS[AUDIO]};${LS_BOLD}:\
*.mp3=${LS_GROUPS[AUDIO]};${LS_BOLD}:\
*.mp4a=${LS_GROUPS[AUDIO]};${LS_BOLD}:\
*.oga=${LS_GROUPS[AUDIO]};${LS_BOLD}:\
*.ogg=${LS_GROUPS[AUDIO]};${LS_BOLD}:\
*.opus=${LS_GROUPS[AUDIO]};${LS_BOLD}:\
*.s3m=${LS_GROUPS[AUDIO]};${LS_BOLD}:\
*.sid=${LS_GROUPS[AUDIO]};${LS_BOLD}:\
*.wma=${LS_GROUPS[AUDIO]};${LS_BOLD}:\
*.ape=${LS_GROUPS[LOSSLESSAUDIO]};${LS_BOLD}:\
*.aiff=${LS_GROUPS[LOSSLESSAUDIO]};${LS_BOLD}:\
*.cda=${LS_GROUPS[LOSSLESSAUDIO]};${LS_BOLD}:\
*.flac=${LS_GROUPS[LOSSLESSAUDIO]};${LS_BOLD}:\
*.alac=${LS_GROUPS[LOSSLESSAUDIO]};${LS_BOLD}:\
*.midi=${LS_GROUPS[LOSSLESSAUDIO]};${LS_BOLD}:\
*.pcm=${LS_GROUPS[LOSSLESSAUDIO]};${LS_BOLD}:\
*.wav=${LS_GROUPS[LOSSLESSAUDIO]};${LS_BOLD}:\
*.wv=${LS_GROUPS[LOSSLESSAUDIO]};${LS_BOLD}:\
*.wvc=${LS_GROUPS[LOSSLESSAUDIO]};${LS_BOLD}:\
*.afm=${LS_GROUPS[FONT]}:\
*.fon=${LS_GROUPS[FONT]}:\
*.fnt=${LS_GROUPS[FONT]}:\
*.pfb=${LS_GROUPS[FONT]}:\
*.pfm=${LS_GROUPS[FONT]}:\
*.ttf=${LS_GROUPS[FONT]}:\
*.otf=${LS_GROUPS[FONT]}:\
*.woff=${LS_GROUPS[FONT]}:\
*.woff2=${LS_GROUPS[FONT]}:\
*.PFA=${LS_GROUPS[FONT]}:\
*.pfa=${LS_GROUPS[FONT]}:\
*.7z=${LS_FORGROUND[WHITE]};${LS_FLASHING};${LS_BACKGROUND[BLACK]}:\
*.a=${LS_FORGROUND[WHITE]};${LS_FLASHING};${LS_BACKGROUND[BLACK]}:\
*.arj=${LS_FORGROUND[WHITE]};${LS_FLASHING};${LS_BACKGROUND[BLACK]}:\
*.bz2=${LS_FORGROUND[WHITE]};${LS_FLASHING};${LS_BACKGROUND[BLACK]}:\
*.cpio=${LS_FORGROUND[WHITE]};${LS_FLASHING};${LS_BACKGROUND[BLACK]}:\
*.gz=${LS_FORGROUND[WHITE]};${LS_FLASHING};${LS_BACKGROUND[BLACK]}:\
*.lrz=${LS_FORGROUND[WHITE]};${LS_FLASHING};${LS_BACKGROUND[BLACK]}:\
*.lz=${LS_FORGROUND[WHITE]};${LS_FLASHING};${LS_BACKGROUND[BLACK]}:\
*.lzma=${LS_FORGROUND[WHITE]};${LS_FLASHING};${LS_BACKGROUND[BLACK]}:\
*.lzo=${LS_FORGROUND[WHITE]};${LS_FLASHING};${LS_BACKGROUND[BLACK]}:\
*.rar=${LS_FORGROUND[WHITE]};${LS_FLASHING};${LS_BACKGROUND[BLACK]}:\
*.s7z=${LS_FORGROUND[WHITE]};${LS_FLASHING};${LS_BACKGROUND[BLACK]}:\
*.sz=${LS_FORGROUND[WHITE]};${LS_FLASHING};${LS_BACKGROUND[BLACK]}:\
*.tar=${LS_FORGROUND[WHITE]};${LS_FLASHING};${LS_BACKGROUND[BLACK]}:\
*.tgz=${LS_FORGROUND[WHITE]};${LS_FLASHING};${LS_BACKGROUND[BLACK]}:\
*.xz=${LS_FORGROUND[WHITE]};${LS_FLASHING};${LS_BACKGROUND[BLACK]}:\
*.z=${LS_FORGROUND[WHITE]};${LS_FLASHING};${LS_BACKGROUND[BLACK]}:\
*.zip=${LS_FORGROUND[WHITE]};${LS_FLASHING};${LS_BACKGROUND[BLACK]}:\
*.zipx=${LS_FORGROUND[WHITE]};${LS_FLASHING};${LS_BACKGROUND[BLACK]}:\
*.zoo=${LS_FORGROUND[WHITE]};${LS_FLASHING};${LS_BACKGROUND[BLACK]}:\
*.zpaq=${LS_FORGROUND[WHITE]};${LS_FLASHING};${LS_BACKGROUND[BLACK]}:\
*.zst=${LS_FORGROUND[WHITE]};${LS_FLASHING};${LS_BACKGROUND[BLACK]}:\
*.zstd=${LS_FORGROUND[WHITE]};${LS_FLASHING};${LS_BACKGROUND[BLACK]}:\
*.zz=${LS_FORGROUND[WHITE]};${LS_FLASHING};${LS_BACKGROUND[BLACK]}:\
*.apk=${LS_GROUPS[PKG]}:\
*.ipa=${LS_GROUPS[PKG]}:\
*.deb=${LS_GROUPS[PKG]}:\
*.rpm=${LS_GROUPS[PKG]}:\
*.jad=${LS_GROUPS[PKG]}:\
*.jar=${LS_GROUPS[PKG]}:\
*.cab=${LS_GROUPS[PKG]}:\
*.pak=${LS_GROUPS[PKG]}:\
*.pk3=${LS_GROUPS[PKG]}:\
*.vdf=${LS_GROUPS[PKG]}:\
*.vpk=${LS_GROUPS[PKG]}:\
*.bsp=${LS_GROUPS[PKG]}:\
*.dmg=${LS_GROUPS[PKG]}:\
*.r[0-9]{0,2}=${LS_FORGROUND[WHITE]};${LS_FLASHING};239:\
*.zx[0-9]{0,2}=${LS_FORGROUND[WHITE]};${LS_FLASHING};239:\
*.z[0-9]{0,2}=${LS_FORGROUND[WHITE]};${LS_FLASHING};239:\
*.part=${LS_FORGROUND[WHITE]};${LS_FLASHING};239:\
*.iso=${LS_FORGROUND[WHITE]};${LS_FLASHING};124:\
*.bin=${LS_FORGROUND[WHITE]};${LS_FLASHING};124:\
*.nrg=${LS_FORGROUND[WHITE]};${LS_FLASHING};124:\
*.qcow=${LS_FORGROUND[WHITE]};${LS_FLASHING};124:\
*.sparseimage=${LS_FORGROUND[WHITE]};${LS_FLASHING};124:\
*.toast=${LS_FORGROUND[WHITE]};${LS_FLASHING};124:\
*.vcd=${LS_FORGROUND[WHITE]};${LS_FLASHING};124:\
*.vmdk=${LS_FORGROUND[WHITE]};${LS_FLASHING};124:\
*.accdb=${LS_FORGROUND[WHITE]};${LS_FLASHING};60:\
*.accde=${LS_FORGROUND[WHITE]};${LS_FLASHING};60:\
*.accdr=${LS_FORGROUND[WHITE]};${LS_FLASHING};60:\
*.accdt=${LS_FORGROUND[WHITE]};${LS_FLASHING};60:\
*.db=${LS_FORGROUND[WHITE]};${LS_FLASHING};60:\
*.fmp12=${LS_FORGROUND[WHITE]};${LS_FLASHING};60:\
*.fp7=${LS_FORGROUND[WHITE]};${LS_FLASHING};60:\
*.localstorage=${LS_FORGROUND[WHITE]};${LS_FLASHING};60:\
*.mdb=${LS_FORGROUND[WHITE]};${LS_FLASHING};60:\
*.mde=${LS_FORGROUND[WHITE]};${LS_FLASHING};60:\
*.sqlite=${LS_FORGROUND[WHITE]};${LS_FLASHING};60:\
*.typelib=${LS_FORGROUND[WHITE]};${LS_FLASHING};60:\
*.nc=${LS_FORGROUND[WHITE]};${LS_FLASHING};60:\
*.pacnew=${LS_FORGROUND[WHITE]};${LS_FLASHING};${LS_FORGROUND[ORANGE]}:\
*.un~=${LS_GROUPS[BINARY]}:\
*.orig=${LS_GROUPS[BINARY]}:\
*.BUP=${LS_GROUPS[BINARY]}:\
*.bak=${LS_GROUPS[BINARY]}:\
*.o=${LS_GROUPS[BINARY]}:\
*core=${LS_GROUPS[BINARY]}:\
*.mdump=${LS_GROUPS[BINARY]}:\
*.rlib=${LS_GROUPS[BINARY]}:\
*.dll=${LS_GROUPS[BINARY]}:\
*.swp=${LS_FORGROUND[WHITE]};${LS_FLASHING};244:\
*.swo=${LS_FORGROUND[WHITE]};${LS_FLASHING};244:\
*.tmp=${LS_FORGROUND[WHITE]};${LS_FLASHING};244:\
*.sassc=${LS_FORGROUND[WHITE]};${LS_FLASHING};244:\
*.pid=${LS_FORGROUND[WHITE]};${LS_FLASHING};248:\
*.state=${LS_FORGROUND[WHITE]};${LS_FLASHING};248:\
*lockfile=${LS_FORGROUND[WHITE]};${LS_FLASHING};248:\
*lock=${LS_FORGROUND[WHITE]};${LS_FLASHING};248:\
*.err=${LS_FORGROUND[WHITE]};${LS_FLASHING};160;${LS_BOLD}:\
*.error=${LS_FORGROUND[WHITE]};${LS_FLASHING};160;${LS_BOLD}:\
*.stderr=${LS_FORGROUND[WHITE]};${LS_FLASHING};160;${LS_BOLD}:\
*.aria2=${LS_GROUPS[BINARY]}:\
*.dump=${LS_GROUPS[BINARY]}:\
*.stackdump=${LS_GROUPS[BINARY]}:\
*.zcompdump=${LS_GROUPS[BINARY]}:\
*.zwc=${LS_GROUPS[BINARY]}:\
*.pcap=${LS_FORGROUND[WHITE]};${LS_FLASHING};29:\
*.cap=${LS_FORGROUND[WHITE]};${LS_FLASHING};29:\
*.dmp=${LS_FORGROUND[WHITE]};${LS_FLASHING};29:\
*.DS_Store=${LS_FORGROUND[WHITE]};${LS_FLASHING};239:\
*.localized=${LS_FORGROUND[WHITE]};${LS_FLASHING};239:\
*.CFUserTextEncoding=${LS_FORGROUND[WHITE]};${LS_FLASHING};239:\
*.allow=${LS_GROUPS[SPEADSHEET]}:\
*.deny=${LS_FORGROUND[WHITE]};${LS_FLASHING};196:\
*.service=${LS_FORGROUND[WHITE]};${LS_FLASHING};${LS_BACKGROUND[PURPLE]}:\
*@.service=${LS_FORGROUND[WHITE]};${LS_FLASHING};${LS_BACKGROUND[PURPLE]}:\
*.socket=${LS_FORGROUND[WHITE]};${LS_FLASHING};${LS_BACKGROUND[PURPLE]}:\
*.swap=${LS_FORGROUND[WHITE]};${LS_FLASHING};${LS_BACKGROUND[PURPLE]}:\
*.device=${LS_FORGROUND[WHITE]};${LS_FLASHING};${LS_BACKGROUND[PURPLE]}:\
*.mount=${LS_FORGROUND[WHITE]};${LS_FLASHING};${LS_BACKGROUND[PURPLE]}:\
*.automount=${LS_FORGROUND[WHITE]};${LS_FLASHING};${LS_BACKGROUND[PURPLE]}:\
*.target=${LS_FORGROUND[WHITE]};${LS_FLASHING};${LS_BACKGROUND[PURPLE]}:\
*.path=${LS_FORGROUND[WHITE]};${LS_FLASHING};${LS_BACKGROUND[PURPLE]}:\
*.timer=${LS_FORGROUND[WHITE]};${LS_FLASHING};${LS_BACKGROUND[PURPLE]}:\
*.snapshot=${LS_FORGROUND[WHITE]};${LS_FLASHING};${LS_BACKGROUND[PURPLE]}:\
*.application=${LS_GROUPS[WEB]}:\
*.cue=${LS_GROUPS[WEB]}:\
*.description=${LS_GROUPS[WEB]}:\
*.directory=${LS_GROUPS[WEB]}:\
*.m3u=${LS_GROUPS[WEB]}:\
*.m3u8=${LS_GROUPS[WEB]}:\
*.md5=${LS_GROUPS[WEB]}:\
*.properties=${LS_GROUPS[WEB]}:\
*.sfv=${LS_GROUPS[WEB]}:\
*.theme=${LS_GROUPS[WEB]}:\
*.torrent=${LS_GROUPS[WEB]}:\
*.urlview=${LS_GROUPS[WEB]}:\
*.webloc=${LS_GROUPS[WEB]}:\
*.lnk=${LS_FORGROUND[WHITE]};${LS_FLASHING};39:\
*CodeResources=${LS_FORGROUND[WHITE]};${LS_FLASHING};239:\
*PkgInfo=${LS_FORGROUND[WHITE]};${LS_FLASHING};239:\
*.nib=${LS_FORGROUND[WHITE]};${LS_FLASHING};57:\
*.car=${LS_FORGROUND[WHITE]};${LS_FLASHING};57:\
*.dylib=${LS_GROUPS[BINARY]}\
*.entitlements=${LS_BOLD}:\
*.pbxproj=${LS_BOLD}:\
*.strings=${LS_BOLD}:\
*.storyboard=${LS_FORGROUND[WHITE]};${LS_FLASHING};196:\
*.xcconfig=${LS_BOLD}:\
*.xcsettings=${LS_BOLD}:\
*.xcuserstate=${LS_BOLD}:\
*.xcworkspacedata=${LS_BOLD}:\
*.xib=${LS_FORGROUND[WHITE]};${LS_FLASHING};208:\
*.asc=${LS_GROUPS[CERTS]};3:\
*.bfe=${LS_GROUPS[CERTS]};3:\
*.enc=${LS_GROUPS[CERTS]};3:\
*.gpg=${LS_GROUPS[CERTS]};3:\
*.signature=${LS_GROUPS[CERTS]};3:\
*.sig=${LS_GROUPS[CERTS]};3:\
*.p12=${LS_GROUPS[CERTS]};3:\
*.pem=${LS_GROUPS[CERTS]};3:\
*.pgp=${LS_GROUPS[CERTS]};3:\
*.p7s=${LS_GROUPS[CERTS]};3:\
*id_dsa=${LS_GROUPS[CERTS]};3:\
*id_rsa=${LS_GROUPS[CERTS]};3:\
*id_ecdsa=${LS_GROUPS[CERTS]};3:\
*id_ed25519=${LS_GROUPS[CERTS]};3:\
*.32x=${LS_GROUPS[ROMS]}:\
*.cdi=${LS_GROUPS[ROMS]}:\
*.fm2=${LS_GROUPS[ROMS]}:\
*.rom=${LS_GROUPS[ROMS]}:\
*.sav=${LS_GROUPS[ROMS]}:\
*.st=${LS_GROUPS[ROMS]}:\
*.a00=${LS_GROUPS[ROMS]}:\
*.a52=${LS_GROUPS[ROMS]}:\
*.A64=${LS_GROUPS[ROMS]}:\
*.a64=${LS_GROUPS[ROMS]}:\
*.a78=${LS_GROUPS[ROMS]}:\
*.adf=${LS_GROUPS[ROMS]}:\
*.atr=${LS_GROUPS[ROMS]}:\
*.gb=${LS_GROUPS[ROMS]}:\
*.gba=${LS_GROUPS[ROMS]}:\
*.gbc=${LS_GROUPS[ROMS]}:\
*.gel=${LS_GROUPS[ROMS]}:\
*.gg=${LS_GROUPS[ROMS]}:\
*.ggl=${LS_GROUPS[ROMS]}:\
*.ipk=${LS_GROUPS[ROMS]}:\
*.j64=${LS_GROUPS[ROMS]}:\
*.nds=${LS_GROUPS[ROMS]}:\
*.nes=${LS_GROUPS[ROMS]}:\
*.sms=${LS_GROUPS[ROMS]}:\
*.8xp=${LS_FORGROUND[WHITE]};${LS_FLASHING};121:\
*.8eu=${LS_FORGROUND[WHITE]};${LS_FLASHING};121:\
*.82p=${LS_FORGROUND[WHITE]};${LS_FLASHING};121:\
*.83p=${LS_FORGROUND[WHITE]};${LS_FLASHING};121:\
*.8xe=${LS_FORGROUND[WHITE]};${LS_FLASHING};121:\
*.stl=${LS_GROUPS[GCODE]}:\
*.dwg=${LS_GROUPS[GCODE]}:\
*.ply=${LS_GROUPS[GCODE]}:\
*.wrl=${LS_GROUPS[GCODE]}:\
*.pot=${LS_FORGROUND[WHITE]};${LS_FLASHING};${LS_ITALIC}:\
*.pcb=${LS_FORGROUND[WHITE]};${LS_FLASHING};${LS_ITALIC}:\
*.mm=${LS_FORGROUND[WHITE]};${LS_FLASHING};${LS_ITALIC}:\
*.gbr=${LS_FORGROUND[WHITE]};${LS_FLASHING};${LS_ITALIC}:\
*.scm=${LS_FORGROUND[WHITE]};${LS_FLASHING};${LS_ITALIC}:\
*.xcf=${LS_FORGROUND[WHITE]};${LS_FLASHING};${LS_ITALIC}:\
*.spl=${LS_FORGROUND[WHITE]};${LS_FLASHING};${LS_ITALIC}:\
*.Rproj=${LS_FORGROUND[WHITE]};${LS_FLASHING};11:\
*.sis=${LS_FORGROUND[WHITE]};${LS_FLASHING};${LS_ITALIC}:\
*.1p=${LS_FORGROUND[WHITE]};${LS_FLASHING};${LS_ITALIC}:\
*.3p=${LS_FORGROUND[WHITE]};${LS_FLASHING};${LS_ITALIC}:\
*.cnc=${LS_FORGROUND[WHITE]};${LS_FLASHING};${LS_ITALIC}:\
*.def=${LS_FORGROUND[WHITE]};${LS_FLASHING};${LS_ITALIC}:\
*.ex=${LS_FORGROUND[WHITE]};${LS_FLASHING};${LS_ITALIC}:\
*.example=${LS_FORGROUND[WHITE]};${LS_FLASHING};${LS_ITALIC}:\
*.feature=${LS_FORGROUND[WHITE]};${LS_FLASHING};${LS_ITALIC}:\
*.ger=${LS_FORGROUND[WHITE]};${LS_FLASHING};${LS_ITALIC}:\
*.ics=${LS_FORGROUND[WHITE]};${LS_FLASHING};${LS_ITALIC}:\
*.map=${LS_FORGROUND[WHITE]};${LS_FLASHING};${LS_ITALIC}:\
*.mf=${LS_FORGROUND[WHITE]};${LS_FLASHING};${LS_ITALIC}:\
*.mfasl=${LS_FORGROUND[WHITE]};${LS_FLASHING};${LS_ITALIC}:\
*.mi=${LS_FORGROUND[WHITE]};${LS_FLASHING};${LS_ITALIC}:\
*.mtx=${LS_FORGROUND[WHITE]};${LS_FLASHING};${LS_ITALIC}:\
*.pc=${LS_FORGROUND[WHITE]};${LS_FLASHING};${LS_ITALIC}:\
*.pi=${LS_FORGROUND[WHITE]};${LS_FLASHING};${LS_ITALIC}:\
*.plt=${LS_FORGROUND[WHITE]};${LS_FLASHING};${LS_ITALIC}:\
*.pm=${LS_FORGROUND[WHITE]};${LS_FLASHING};${LS_ITALIC}:\
*.rdf=${LS_FORGROUND[WHITE]};${LS_FLASHING};${LS_ITALIC}:\
*.ru=${LS_FORGROUND[WHITE]};${LS_FLASHING};${LS_ITALIC}:\
*.sch=${LS_FORGROUND[WHITE]};${LS_FLASHING};${LS_ITALIC}:\
*.sty=${LS_FORGROUND[WHITE]};${LS_FLASHING};${LS_ITALIC}:\
*.sug=${LS_FORGROUND[WHITE]};${LS_FLASHING};${LS_ITALIC}:\
*.tdy=${LS_FORGROUND[WHITE]};${LS_FLASHING};${LS_ITALIC}:\
*.tfm=${LS_FORGROUND[WHITE]};${LS_FLASHING};${LS_ITALIC}:\
*.tfnt=${LS_FORGROUND[WHITE]};${LS_FLASHING};${LS_ITALIC}:\
*.tg=${LS_FORGROUND[WHITE]};${LS_FLASHING};${LS_ITALIC}:\
*.vcard=${LS_FORGROUND[WHITE]};${LS_FLASHING};${LS_ITALIC}:\
*.vcf=${LS_FORGROUND[WHITE]};${LS_FLASHING};${LS_ITALIC}:\
*.xln=${LS_FORGROUND[WHITE]};${LS_FLASHING};${LS_ITALIC}:\
*.iml=${LS_GROUPS[PRESENTATION]}"

# TODO: darwin for ls-g will use this color table
# [[ $(uname) =~ Darwin  ]] && {
# typdate -A 
# # The color designators are as follows:
# a     black
# b     red
# c     green
# d     brown
# e     blue
# f     magenta
# g     cyan
# h     light grey
# A     bold black, usually shows up as dark grey
# B     bold red
# C     bold green
# D     bold brown, usually shows up as yellow
# E     bold blue
# F     bold magenta
# G     bold cyan
# H     bold light grey; looks like bright white
# x     default foreground or background
#

function lsgroups () {
  for k v in ${(kv)LS_GROUPS[@]}; do print -n -- "${(l:32:: :)k} ${(l:5:: :)v}"; LS_COLORS="di=${v}" gls --color=always -a . | head -n 2 | tr -d '\n'; echo ; done
}
