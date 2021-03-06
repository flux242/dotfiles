#!/bin/bash

. $HOME/bin/shellcolors.sh

IFS=$'\n'

# list of upgradable packages
upgradable=$(apt list --upgradable 2>/dev/null | awk -F/ '/[^\/]*\//{print $1}')

# get versions of the installed packages
for package in ${upgradable[@]}; do
  version=$(dpkg -l "$package" | awk -F\  '/^ii/{print $3}' | head -n1)
  [[ -n "$version" ]] && {
    # Ubuntu packagers could prepend a package version with a 'digit:'
    # For example for bsdutils version is '1:2.30.1-0ubuntu4' but internally
    # they have util-linux package with 2.30.1-ubuntu4. Whatever they need it
    # for but it should be removed first
    version="${version/[[:digit:]]:/}"
    # some characters in the version string should be escaped. Such
    # chars have special meaning in regular expressions. Currently
    # only the '+' char is escaped but God only knows what other chars
    # these freak&fucks could use in the vesion string 
    version="${version/+/\\\\+}" # plus should be prepended with \\ for awk
    echo "$version"
    echo -e "${LIGHTRED}Package: ${LIGHTGREEN}${package}${NC}"
    apt-get -q changelog "$package" | awk -v ver="$version" '{if($0 ~ "[^(]*\\(.*"ver"\\).*"){found=1};if(found!=1)print $0}'
  }
done

exit 0

