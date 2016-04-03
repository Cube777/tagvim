#! /bin/env python

import vim
import subproccess
import os
import re

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
            includes.append(i)

    # TODO: strip header names, split 'local' and 'system' in setup


    cchdir = os.environ['HOME'] . '/.cache/tagvim'
    with open(chdir) as f:
        content = f.readlines()
    taglist []
    for inc in includes:
        for fol in content:
            if find(inc, fol)



taglist = [vim.buffer.name]

