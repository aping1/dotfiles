function Pad_ag_output() {
command :v/^[a-zA-Z0-9\/\.\_\ ]*\.*:[0-9]*[\ :\-]/d
command :%s/^[a-zA-Z0-9\/\.\_\ ]*\.*:[0-9]*[\ :\-]/\= submatch(0) . ' ' . repeat(' ', (39 - len(submatch(0))))
}
