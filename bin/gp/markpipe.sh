#!/bin/bash

awk -v c="$1" '$0 ~ /^.+$/ {print c":"$0;fflush()}' -

