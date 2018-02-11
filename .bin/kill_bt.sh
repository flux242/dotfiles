#!/bin/sh

logger "$(rfkill list bluetooth)"
rfkill block bluetooth
logger "$(rfkill list bluetooth)"
