#!/usr/bin/python
"""
Set up aliases for dotfiles and folders.
"""
from __future__ import print_function
import sys, os

base = os.path.dirname(os.path.realpath(__file__))
home = os.environ['HOME']

print("Base Dir: {}".format(base))
print("home Dir: {}".format(home))

for destfile in os.listdir(base):
    if destfile.startswith('dot.'):
        srcfile = ".%s" % destfile[4:]
        dest = os.path.join(base, destfile)
        src = os.path.join(home, srcfile)
        print("[+] Linking {} -> {}".format(src, dest))
        try:
            os.symlink(dest, src)
        except OSError:
            print("[-] WARNING: Skipping! file already exists")

