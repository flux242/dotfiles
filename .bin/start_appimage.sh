#/bin/sh

[ -n "$APP_NAME" ] || exit 1

appbin=$(find ~/Applications/ -iname "$APP_NAME"'*' -exec sh -c '[ -x "{}" -a ! -d "{}" ] && echo "{}"' \;)
if [ -n "$appbin" ]; then
  if [ -n "$(which firejail)" ]; then
    [ -d ~/Applications/privatehome/"$APP_NAME" ] || mkdir ~/Applications/privatehome/"$APP_NAME"
    profilename="${HOME}/.config/firejail/${APP_NAME}.profile"
    [ -s "$profilename" ] || profilename="/etc/firejail/${APP_NAME}.profile"
    [ -s "$profilename" ] || profilename='/etc/firejail/default.profile'
echo "pname: $profilename"
    firejail --appimage --private=~/Applications/privatehome/"$APP_NAME" --profile="$profilename" "$appbin"
  else
    "$appbin"
  fi
fi

