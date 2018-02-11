#!/bin/bash

fetchmail -s -f "$HOME/fetchmail/.fetchmailrc" --mda "$HOME/bin/catmail.sh %T %F" 2>>/tmp/fetchmail.err
