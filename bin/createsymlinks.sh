#/bin/sh

# this script is only run once after system installation and pulling my
# dotfiles from the github. It creates necessary symbolic links

createSymbolicLink()
{
  [ -n "$1" ] || return

  [ -h "$HOME/$1" ] || {
    # -h means file exists and it's a symbolic link
    # remove the dir if it exists but not a symbolic link
    # rm -f "$HOME/$1" TODO add prompt before removing
    echo "creating symbolic link for: $1"
    ln -s "$HOME/dotfiles/$1" "$1"
  }

}

links=(".screenrc" ".bash_aliases" "bin" ".vim" ".vimrc" ".i3" ".highlight" ".grc" ".nticon.conf" ".dircolors" ".compton.conf" ".config/vifm" ".config/mpv" ".config/neofetch" ".config/pnmixer" ".gnokiirc")

for link in ${links[@]}; do createSymbolicLink $link; done

