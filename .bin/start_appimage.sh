#/bin/sh

[ -n "$APP_NAME" ] || exit 1

appbin=$(find ~/Applications/ -iname "$APP_NAME"'*' -exec sh -c '[ -x "{}" -a ! -d "{}" ] && echo "{}"' \;)
if [ -n "$appbin" ]; then
  if [ -n "$(which firejail)" ]; then
    [ -d ~/Applications/privatehome/"$APP_NAME" ] || mkdir -p ~/Applications/privatehome/"$APP_NAME"
    profilename="${HOME}/.config/firejail/${APP_NAME}.profile"
    [ -s "$profilename" ] || profilename="/etc/firejail/${APP_NAME}.profile"
    [ -s "$profilename" ] || profilename='/etc/firejail/default.profile'
    if [ "$PRIVATE_HOME" = "yes" ]; then
      firejail --private=~/Applications/privatehome/"$APP_NAME" --profile="$profilename" --appimage "$appbin" $APP_ARGS
    else
      firejail --profile="$profilename" --appimage "$appbin" $APP_ARGS
    fi
  else
    "$appbin"
  fi
fi

