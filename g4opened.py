#!/usr/bin/python
import subprocess
import sys
import re
import os

if not os.getcwd().startswith('/google/src/cloud'):
  sys.exit()

use_regex = len(sys.argv) == 2


p = subprocess.Popen("g4 opened | sed 's/#.*//' | g4 -x - where | awk '/^\// {print $3}'", shell=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
res = p.communicate()

if p.returncode == 0 and (not 'prodaccess' in res[1]) and (not 'unknown' in res[1]):
  files = res[0].split()
  for file in files:
    #if not use_regex or (use_regex and re.search(sys.argv[1].replace(' ', '.+'), file, re.IGNORECASE)):
    print file
