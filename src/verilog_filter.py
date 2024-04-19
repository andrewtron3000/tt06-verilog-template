#!/usr/bin/env python3

import sys

if __name__ == "__main__":
   skipping = False

   with open(sys.argv[1], 'r') as f:
      lines = [line for line in f]

   with open(sys.argv[1], 'w') as f:
      for l in lines:
         if '// synopsys translate_off' in l:
            skipping = True
         elif '// synopsys translate_on' in l:
            skipping = False
         elif not skipping:
            f.write(l)
