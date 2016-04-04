#! /bin/env python

import vim
import subprocess
import os
import re

sdir = vim.eval('l:sdir')

def find(header, folder):
    if not os.path.exists(folder):
        return ''
    loc = subprocess.check_output(['find', folder, '-name', header])
    return loc

def includes(fname):
    content = open(fname).read().split('\n')
    incld = []
    regx = re.compile('^#include')
    for i in content:
        if re.search(regx, i) is not None:
            i.replace("#include ", "")
            s = 0
            while (i[s] != "<") and (i[s] != '"'):
                s += 1
            e = s + 1
            while (i[e] != ">") and (i[e] != '"'):
                e += 1
            i = i[s:e+1]
            incld.append(i)

    home = os.environ['HOME']
    regx = re.compile('^' + home)
    regspec = re.compile('/stdcpp$')
    cachedir = home + '/.cache/tagvim'
    content = open(cachedir + '/filelist').read().split('\n')
    content = content[:-1]
    system = []
    local = []
    for i in content:
        if (re.search(regspec, i) is None) and (re.search(regx, i) is not None):
            local.append(i)
        else:
            system.append(i)

    for i in incld:
        s = i[0]
        i = i[1:-1]
        if s == "<":
            for k in system:
                loc = find(os.path.basename(i), cachedir + '/system' + k)
                print(i)
                if loc != '':
                    if re.search(regspec, k) is None:
                        loc.replace(cachedir + "/system", "")
                    taglist.append(loc)
                    break
        else:
            for k in local:
                loc = find(os.path.basename(i), cachedir + '/local' + k)
                if loc != '':
                    loc.replace(cachedir + "/local", "")
                    taglist.append(loc)
                    break
    return taglist

taglist = [vim.current.buffer.name]

new = []
while 1:
    new = []
    for i in taglist:
        new += includes(i)
    new = set(new)
    diff = list(set(taglist) - new)
    if len(diff) == 0:
        break

vim.command('set tags=""')
for i in taglist:
    vim.command('set tags+=' + i)

