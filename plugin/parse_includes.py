#! /bin/env python

import vim
import subprocess
import os
import re

globinclds = []

def find(header, folder):
    if not os.path.exists(folder):
        return ''
    loc = subprocess.check_output(['find', folder, '-name', header])
    return loc[:-1]

def includes(fname):
    content = open(fname).read().split('\n')
    incld = []
    regx = re.compile('^#include')
    global globinclds
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
            if i not in globinclds:
                incld.append(i)

    globinclds += incld
    home = os.environ['HOME']
    regx = re.compile('^' + home)
    regspec = re.compile('/stdcpp$')
    cachedir = home + '/.cache/tagvim'
    regloc = re.compile('^' + cachedir)
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
                if loc != '':
                    if re.search(regspec, k) is None:
                        loc = loc[len(cachedir + "/system"):]
                    else:
                        loc = cachedir + "/cpp_src/" +  os.path.basename(loc)
                    taglist.append(loc)
                    break
        else:
            for k in local:
                loc = ""
                if os.path.isdir(k):
                    loc = find(os.path.basename(i), cachedir + "/local" + k)
                else:
                    loc = os.path.abspath( os.path.dirname(k) + "/" + i )
                    if not os.path.isfile(loc):
                        continue
                if loc != '':
                    if re.match(regloc, loc) is not None:
                        loc = loc[len(cachedir + "/local"):]
                    taglist.append(loc)
                    break
    return taglist

taglist = [vim.current.buffer.name]

prev = 1
new = []
while 1:
    new = []
    for i in taglist:
        new += includes(i)
    for i in new:
        if i not in taglist:
            taglist.append(i)
    if len(taglist) == prev:
        break
    prev = len(taglist)

cachedir = os.environ['HOME'] + '/.cache/tagvim'
reg = re.compile('^' + os.environ['HOME'])
regspec = re.compile('^' + cachedir + "/cpp_src")
vim.command('set tags=""')
newtag = ""
for i in taglist:
    if re.search(reg, i) is not None:
        if re.search(regspec, i) is None:
            newtag = cachedir + '/local' + i
        else:
            newtag = cachedir + '/system/stdcpp/' + os.path.basename(i)
    else:
        newtag = cachedir + '/system' + i
    if not os.path.isfile(newtag):
        print(newtag + " not found. Please call UpdateTags()")
    vim.command("setlocal tags+=" + newtag)
