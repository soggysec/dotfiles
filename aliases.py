#!/usr/bin/python
"""
Set up aliases for dotfiles and folders.
"""
from __future__ import print_function
import sys, os
import shutil

base = os.path.dirname(os.path.realpath(__file__))
home = os.environ['HOME']

print("Base Dir: {}".format(base))
print("home Dir: {}".format(home))

for srcfile in os.listdir(base):
    if srcfile.startswith('dot.'):
        destfile = ".%s" % srcfile[4:]
        src = os.path.join(base, srcfile)
        dest = os.path.join(home, destfile)
        print("[+] Linking {} -> {}".format(src, dest))
        overwrite = False
        if os.path.exists(dest):
            while True:
                resp = raw_input("\t{} - already exists, would you like to overwrite? [Y/n]? ".format(dest))
                if resp in ['', 'y','Y']:
                    overwrite = True
                    break
                elif resp == "n":
                    # skip - don't overwrite
                    break

        try:
            if overwrite:
                backup = "{}.orig".format(dest)
                shutil.move(dest, backup)
                print("\tBacked up {} to {}".format(dest, backup))
            os.symlink(src, dest)
        except OSError:
            print("[-] WARNING: File already exists, skipping: {}".format(dest))

