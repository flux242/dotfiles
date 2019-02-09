#!/bin/bash

#######################################################################
# doc-base debian package is used to create a database for package
# documentation that is installed additionally to the man pages. Such
# documentation is installed into the /usr/share/doc and doc-base
# creates its database in the /usr/share/doc-base. This database
# can be used by programs like dwww to create an indexed documentation
# which can be opened in a browser. 
# Beside the fact that dwww has apache2 dependency I find this approach
# a bit over engineered and as alternative I've written this simple script
# that creates an html with all html|htm|txt pages linked.
# This allows me to purge the doc-base and its dependent perl packages!
#
# Note: Content of the /usr/share/doc can be purged without affecting the system.
#       See https://wiki.ubuntu.com/ReducingDiskFootprint#Documentation
#
# Usage example:
# 1) Generate a temp file and open it
#     ./docit.sh > /tmp/docs.html && xdg-open /tmp/docs.html
# 2) Serve the file on the port 8080. Note: lynx works, firefox won' follow the links
#    socat tcp-listen:8080,crlf,fork,reuseaddr system:"echo HTTP/1.1 200; echo Content-Type\: text/html; echo; ./docit.sh"
#######################################################################

docpath='/usr/share/doc'                      # where to search for documentation
doctypes=('html' 'htm' 'txt' 'pdf' 'md' 'gz') # add or remove file types to search for
excludes=('changelog.Debian.gz' 'changelog.gz' 'NEWS.gz' 'NEWS.Debian.gz') # files to exclude

print_head()
{
cat <<HEREDOC
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 3.2//EN">
<html><head>
<meta name="GENERATOR" content="docit.sh script">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>doc-base index</title>

</head>
<body bgcolor="#c0c0c0">
<script>
function toggle_visible(eid)
{
  var el = document.getElementById(eid);
  el.style.display = el.style.display === 'none' ? '' : 'none';
}
</script>
HEREDOC
}

print_tail()
{
cat <<HEREDOC
</body>
</html>
HEREDOC
}

print_table_head()
{
cat <<HEREDOC
<p onclick="toggle_visible('ENTRY')">ENTRY</p>
<table id="ENTRY" border="0" cellpadding="15" style="display: none">
HEREDOC
}

print_table_tail()
{
cat <<HEREDOC
</table>
HEREDOC
}

print_table_row()
{
cat <<HEREDOC
<tr><td><a href="file://LINK">LINK</a></td></tr>
HEREDOC
}

print_head

searchregex=$(for ft in ${doctypes[@]}; do printf ".*\\.$ft\\|"; done)
excludepath=$(for excl in ${excludes[@]};do printf " ! -path '*/$excl'"; done)
execstr="find '$docpath' -iregex '$searchregex' -a \( $excludepath \)"
allinks=$(eval $execstr | sort -t'/' -k4,5 | uniq)

# dbouble loop implementation but works faster
entries=$(printf "$allinks" | sed -nr 's|/usr/share/doc/([^/]+).*|\1|p' | sort | uniq)
for entry in $entries; do
  links=$(printf "$allinks" | sed -ne '/\/usr\/share\/doc\/'"$entry"'\//p')
  print_table_head | sed  's|ENTRY|'"$entry"'|g'
  for link in $links; do
    print_table_row  | sed  's|LINK|'"$link"'|g'
  done
  print_table_tail
done

: <<COMMENTED_OUT
# one loop implementation works slower
for link in $allinks; do
  entry=$(echo "$link" | sed -nr 's|/usr/share/doc/([^/]+).*|\1|p')
  if [ ! "$oldentry"  = "$entry" ]; then
    if [ -n "$oldentry" ]; then
      print_table_tail
    fi
    print_table_head | sed  's|ENTRY|'"$entry"'|g'
    oldentry="$entry"
  fi 
  print_table_row  | sed  's|LINK|'"$link"'|g'
done
[ -n "$oldentry" ] && {
  print_table_tail
} 
COMMENTED_OUT

print_tail

