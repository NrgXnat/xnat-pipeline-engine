#!/bin/bash

# Author: Luis Gracia (lug2002 at med.cornell.edu)

# Find next available display
find_display() {
    # Start searching displays at first argument or 0 (default)
    # We set a maximum of 100 concurrent displays
    local -i display=${1:-0}
    local -i max_display=100
    while [ -f /tmp/.X${display}-lock ]; do
        display=$display+1
        if [ $display -gt $max_display ]; then
            display=-1
            break
        fi
    done
    echo $display
}

# Check command line
if [ $# -lt 1 ]; then
    echo "USAGE:   $0 <executable with its arguments>"
    echo "PURPOSE: For executables which are dependent on DISPLAY"
    echo "         $0 will set a DISPLAY using Xvfb"
    echo "         and launch the executable. $0 will kill Xvfb"
    echo "         the at the end"
    exit 1
fi

# Find a display
display=$(find_display)
if [ "$display" = '-1' ]; then
    echo "No available display"
    exit 1
fi

# Start Xvfb and check for a running Xvfb
# -nolisten local
Xvfb -auth @PIPELINE_DIR_PATH@/scripts/x.auth -screen 0 1200x1024x24 :$display &
pid=$!
if ! ps $pid >/dev/null; then
    echo "Error while starting Xvfb"
    exit 1
fi


# Run the executable under the new display
DISPLAY=:$display $@
RETVAL=$?

# Kill Xvfb
kill $pid

exit $RETVAL
