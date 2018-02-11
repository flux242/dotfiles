#!/usr/bin/python

# script doesn't work any longer

import sys
from optparse import OptionParser
import urllib2
import urllib
import re
import socket
from socket import error

##########################################################################
#
# @brief Fetches a weather information for a city
# @param city City name 
# @return tuple (error, fetched_page).error contains empy string if succeeded,
#         error description otherwise
#
##########################################################################
def fetchPage(city):
  dto = socket.getdefaulttimeout()
  socket.setdefaulttimeout(10)

  url = 'http://de.weather.com/search/search'
  data = urllib.urlencode({ 'where' : city, 'what' : ''})

  # fetching a page
  fetchedUrl = ''
  error = ""
  s = ""
  try:
    f = urllib2.urlopen(url, data)
    fetchedUrl = f.geturl()
    s = f.read()
    f.close()
  except IOError, e:
    if hasattr(e, 'reason'):
      error = 'Error: Failed to open URL ' + url + '\n' + 'Reason: ' + str(e.reason)
    elif hasattr(e, 'code'):                              
      error = 'Error: Server returned an error code: ', str(e.code)
  except socket.error, se:
    error = 'Error: Socket error: ' + str(se)
  except KeyboardInterrupt, ke:
    error = 'Error: Interrupted by user.'

  socket.setdefaulttimeout(dto)

  #print fetchedUrl
  if not error and -1==fetchedUrl.lower().find('gmxx') and -1==fetchedUrl.lower().find(city):
    error = 'Error: City ' + city + ' was not found on the server. Try a different name or PLZ'

  return (error,s)

##########################################################################
#
# @brief Parser for a grabbed page
# @param s grabbed page as a string 
# @return Empty string if succeeded, error descriotion otherwise
#
##########################################################################
def parseWeather(s):
  # get current temp first
  sc = s
  sc = re.sub(re.compile(r'.*(<a name="bbanner".*?<form name="Converter">).*', re.IGNORECASE+re.DOTALL), r'\1', sc)
  if not sc:
    return "Error: Parsing failed: Curren temp section is not found"
  sc = re.sub(re.compile(r'\n',     re.IGNORECASE+re.DOTALL), r'', sc)
  sc = re.sub(re.compile(r'<br>',   re.IGNORECASE), r'\t', sc)
  sc = re.sub(re.compile(r'<.+?>',  re.IGNORECASE), r'', sc)
  sc = re.sub(re.compile(r'^\s*',   re.IGNORECASE), r'', sc)
  sc = re.sub(re.compile(r'&nbsp;', re.IGNORECASE), r' ', sc)
  sc = re.sub(re.compile(r' {4,}',  re.IGNORECASE), r'\t', sc)
  sc = re.sub(re.compile(r'&deg;',  re.IGNORECASE), r"'", sc)
  sc = re.sub(re.compile(r'\t{2,}',  re.IGNORECASE), r'\n', sc)
  sc = re.sub(re.compile(r'(.*?)\t(.*?\t.*?)\t(.*?\t.*?)\t(.*?\t.*?)\t(.*?\t.*?)\t(.*)',  re.IGNORECASE),
                         r'\1\n\2\n\3\n\4\n\5\n\6', sc)
  sc = re.sub(re.compile(r'(UV-Index)\n(.*)',  re.IGNORECASE+re.DOTALL), r'\1:\t\2', sc)
  print sc

  # get forecast table
  s = re.sub(re.compile(r'.*<iframe name="tdI".*?(<table.*?)<\/iframe>.*', re.IGNORECASE+re.DOTALL), r'\1', s)
  if not s:
    return "Error: Parsing failed - iframe is not found."
  s = re.sub(re.compile(r'.*<tr.+?<tr.+?(<table.+?<\/table>).*', re.IGNORECASE+re.DOTALL), r'\1', s)
  if not s:
    return "Error: Parsing failed - table is not found."
  
  # now list all tr's in the table
  trs = re.findall(re.compile(r'<tr>.+?<\/tr>', re.IGNORECASE+re.DOTALL), s)
  if not trs:
    return "Error: Table is empty"
  for tr in trs:
    tmps = re.sub(re.compile(r'\n',     re.IGNORECASE+re.DOTALL), r'', str(tr))
    tmps = re.sub(re.compile(r'<br>',   re.IGNORECASE), r'\t', tmps)
    tmps = re.sub(re.compile(r'<.+?>',  re.IGNORECASE), r'', tmps)
    tmps = re.sub(re.compile(r'^\s*',   re.IGNORECASE), r'', tmps)
    tmps = re.sub(re.compile(r'&nbsp;', re.IGNORECASE), r' ', tmps)
    tmps = re.sub(re.compile(r' {4,}',  re.IGNORECASE), r'\t', tmps)
    tmps = re.sub(re.compile(r'&deg;',  re.IGNORECASE), r"'", tmps)
    tmps = re.sub(re.compile(r'\s*$',  re.IGNORECASE), r'', tmps)
    tmps = re.sub(re.compile(r'^(.*?)\t(.*?)\t(.*?)\t(.*?)\t(.*?)$'), r'\1\t\2\t\4\t\5\t\3', tmps)
    tmps = re.sub(re.compile(r'^Max \(C\)\tMin.*$',  re.IGNORECASE), r'\t\tMax\tMin', tmps)
    print tmps

  return "" # no problemo by parsing


##########################################################################
#
# @brief Main routine
##########################################################################
def main():
  usage = "usage: %prog [options] CityNameOrPLZ"
  p = OptionParser(usage)
  p.add_option('--debug', action='store_true', dest='debug', help='page is fed from stdin')
  (opts, args) = p.parse_args()

  if opts.debug:
    print 'Debugging'
    page = ''
    page = sys.stdin.read()
    if len(page)==0:
      sys.stderr.write('Error: Nothing has been read from the std input file.')
      return 1
  else:
    if len(args)!=1:
      p.error('incorrect number of arguments')

    city = args[0]
    (fres,page) = fetchPage(city)
    if fres:
      sys.stderr.write(fres + '\n')
      return 1

  fres = parseWeather(page)
  if fres:
    sys.stderr.write(fres + '\n')
    return 1

  return 0

if __name__=='__main__':
  sys.exit(main())

  

