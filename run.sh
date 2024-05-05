#!/bin/sh
TMPFILE=$(mktemp)
echo "$CODE" > $TMPFILE
elixir $TMPFILE
