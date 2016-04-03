#! /bin/env python

import vim
import subproccess
import os
import re

sdir = vim.eval('l:sdir')

def find(header, folder):
    os.chdir(folder)
    loc = subproccess.check_output(['find', '-name', header]).split('\n')
    return !(len(lock) == 1)

def includes(fname):
    content = []
    with open(fname) as f:
        content = f.readlines()
    includes = []
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
            includes.append(i)


    home = os.environ['HOME']
    regx = re.compile('^' . home)
    cchdir = home . '/.cache/tagvim'
    with open(cchdir . '/filelist') as f:
        content = f.readlines()
    system = []
    local = []
    for i in content:
        if re.search(regx, i) is not None:
            local.append(i)
        else:
            system.append(i)

    for i in includes:
        s = i[0]
        i = i[1:-1]
        if s == "<":
            for k in system:
                if find(i, k):
                    taglist.append(cchdir . "/system/" . i)
                    break
        else
            for k in local:
                if find(i, k):
                    taglist.append(cchdir . "/local/" . i)
                    break



taglist = [vim.buffer.name]

