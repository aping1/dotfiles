#!/usr/bin/zsh

deferred_log () {
    DATE=$(unow)
    MESSAGE=${2}
}

START=$(mktemp .start-XXXX)
FIFO=$(mktemp .fifo-XXXX)
FIFO_LOCK=$(mktemp .fifo-lock-XXXX)
START_LOCK=$(mktemp .start-lock-XXXX)

rm $FIFO && mkfio $FIFO
[[ -p $FIFO ]] || exit 2

cleanup() {
    rm -f "$FIFO" "$START" "$FIFO_LOCK" "$START_LOCK"
}
trap cleanup SIGKILL EXIT

work() {
    ID=$1
    exec 3<$FIFO
    exec 4<$FIFO_LOCK
    exec 5<$START_LOCK

    flock 5 || exit 1
    echo ${ID} >> $START
    flock -u 5 || exit 1
    # Close FD 5
    exec 5<&- || exit 1

    while true; do
        flock 4
        read -su 3 work_id work_item
        status=$?
        flock -u 4
        if [[ ${status} == 0 ]]; then
            echo "$ID got work_id=\"$work_id\" work_item=\"$work_item\""
            ( job "$work_id" "$work_item" )
        else;
            break
    done
    exec 3<&-
    exec 4<&-
}

#Open fifo
exec 3>$FIFO
exec 4>$START_LOCK

start_working () {

    local WORKERS=4
    for ((i=1;i<=$WORKERS;i++)); do
        work $i &
    done

    while true; do
        flock 4
        started=$(wc -l $START | cut -d \ -f 1)
        flock -u 4
        [[ $STARTED == $WORKERS ]] && break || exit 4
    done
    exec 4 <&-
}

send () {
    work_id=$1
    work_item=$2
    echo "$work_id" "$work_item" 1>&3
}

jobs_to_run=""
i=0
for item in datasets; do
   send $i item
    i=$((i+1))
done

exec 3<&-

push:
alias push='array=(“${array[@]}” $new_element)'
alias pop='array=(${array[@]:0:$((${#array[@]}-1))})'
alias shift='array=(${array[@]:1})'
alias unshift='array=($new_element “${array[@]}”)'
