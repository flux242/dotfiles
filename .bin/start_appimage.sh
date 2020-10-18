#/bin/sh

[ -n "$APP_NAME" ] || exit 1

appbin=$(find ~/Applications/ -maxdepth 1 -iname "$APP_NAME"'*' -exec sh -c '[ -x "{}" -a ! -d "{}" ] && echo "{}"' \;)

if [ -n "$appbin" ]; then
  if [ -n "$(which firejail)" ]; then
    profilename="${HOME}/.config/firejail/${APP_NAME}.profile"
    [ -s "$profilename" ] || profilename="/etc/firejail/${APP_NAME}.profile"
    [ -s "$profilename" ] || profilename='/etc/firejail/default.profile'
    if [ "$PRIVATE_HOME" = "yes" ]; then
      privatehomedir="$HOME/Applications/privatehome/$APP_NAME"
      [ -n "$PRIVATE_HOME_DIR" ] && privatehomedir="$PRIVATE_HOME_DIR/$APP_NAME"
      [ -d  "$privatehomedir" ] || mkdir -p "$privatehomedir"
      firejail --private="$privatehomedir" --profile="$profilename" --appimage "$appbin" $APP_ARGS
    else
      firejail --profile="$profilename" --appimage "$appbin" $APP_ARGS
    fi
  else
    "$appbin"
  fi
fi

