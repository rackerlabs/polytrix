#!/usr/bin/env bash
# This is a trick to force a pty and capture colored output,
# because Polytrix does not currently run command with a PTY.
script -q /dev/null "$@"
