#!/usr/bin/env python3

import sys
import serial
from optparse import OptionParser
import humod

def main():
  p = OptionParser("usage: %prog [options]")
  p.add_option('-l', '--list', type='string', dest='list', default='all',
               help='list messages. Values supported: all,unread. Default - all')
  (opts, args) = p.parse_args()
  if opts.list=='all':
    smsType='ALL' 
  elif opts.list=='unread':
    smsType='REC UNREAD'
  else:
    p.print_help()
    exit(-1)  

  try:  
    m=humod.Modem()
    m.enable_textmode(True)
    print m.sms_list(smsType)
    #m.sms_read(i)
  except humod.errors.AtCommandError,e:
    print e
    exit(-1) 
  except serial.serialutil.SerialException, e:
    print e
    exit(-1)

  return 0

if __name__=='__main__':
  sys.exit(main())

