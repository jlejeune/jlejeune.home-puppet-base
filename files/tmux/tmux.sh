#!/bin/bash

SESSION="$1"

# Set title of terminator
echo -ne "\033]0;$SESSION\007"

CONFIG=/etc/tmux/tmux.conf

# Check if SESSION exits, if not, create it without connecting to it
check=$(tmux -L root ls -F "#{session_name}" | egrep "^$SESSION\$")
if [ "Z${check}" = "Z" ] ; then
    tmux -L root -f $CONFIG new -s $SESSION -d
fi

tmux -L root -f $CONFIG attach -t $SESSION
