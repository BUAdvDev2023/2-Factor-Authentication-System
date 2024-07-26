#!/usr/bin/env bash
#   Use this script to test if a given TCP host/port are available

# The MIT License (MIT)
# Copyright (c) 2016 Vincent Demeester

# Permission is hereby granted, free of charge, to any person obtaining a copy of
# this software and associated documentation files (the "Software"), to deal in
# the Software without restriction, including without limitation the rights to
# use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
# the Software, and to permit persons to whom the Software is furnished to do so,
# subject to the following conditions:

# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.

# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
# FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
# COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
# IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
# CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

set -e

TIMEOUT=15
QUIET=0
STRICT=0
CHILD=0
HOST=""
PORT=""

usage()
{
    cat << USAGE >&2
Usage:
    $0 host:port [-t timeout] [-- command args]
    -q | --quiet                        Do not output any status messages
    -s | --strict                       Only execute subcommand if the test succeeds
    -t TIMEOUT | --timeout=timeout      Timeout in seconds, zero for no timeout
    -- COMMAND ARGS                     Execute command with args after the test finishes
USAGE
    exit 1
}

wait_for()
{
    if ! command -v nc > /dev/null; then
        echo 'nc command is required'
        exit 1
    fi

    for i in `seq $TIMEOUT` ; do
        if echo > /dev/tcp/$HOST/$PORT ; then
            if [ $QUIET -ne 1 ]; then
                echo "$HOST:$PORT is available after $i seconds"
            fi
            return 0
        fi
        sleep 1
    done
    if [ $QUIET -ne 1 ]; then
        echo "Timeout occurred after waiting $TIMEOUT seconds for $HOST:$PORT"
    fi
    return 1
}

while [ $# -gt 0 ]
do
    case "$1" in
        *:* )
        HOST=$(printf "%s\n" "$1"| cut -d : -f 1)
        PORT=$(printf "%s\n" "$1"| cut -d : -f 2)
        shift 1
        ;;
        -q | --quiet)
        QUIET=1
        shift 1
        ;;
        -s | --strict)
        STRICT=1
        shift 1
        ;;
        -t)
        TIMEOUT="$2"
        if [ "$TIMEOUT" = "" ]; then break; fi
        shift 2
        ;;
        --timeout=*)
        TIMEOUT=$(printf "%s" "$1" | cut -d = -f 2)
        shift 1
        ;;
        --)
        shift
        CHILD=1
        break
        ;;
        -*)
        usage
        ;;
        *)
        usage
        ;;
    esac
done

if [ "$HOST" = "" -o "$PORT" = "" ]; then
    usage
fi

if [ $CHILD -gt 0 ]; then
    if [ $STRICT -eq 1 ]; then
        wait_for || exit 1
        exec "$@"
    else
        wait_for
        exec "$@"
    fi
else
    wait_for
fi
