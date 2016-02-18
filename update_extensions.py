import os
from os import path, environ
import sys
from datetime import datetime
from subprocess import call
import subprocess
import shutil
import signal

def link(old, new):
    if not path.isfile(old):
        print "Cannot find file " + str(old)
        exit(0)
    if sys.platform is 'linux32':
        os.link(old, new)
    else:
        call(['MKLINK', '/H', str(new), str(old)], shell = True, stdout = open(os.devnull, 'wb'))

def cloneorupdate(url):
    reponame = url.split('/')[-1]
    if '.git' in reponame:
        reponame = reponame[:-4]
    if path.isdir(reponame):
        print "\tUpdating " + reponame + "..."
        os.chdir(reponame)
        call(['git', 'pull', '-q', 'origin', 'master'])
        os.chdir('..')
    else:
        print "\tCloning " + reponame + "..."
        call(['git', 'clone', '-q', url])


currdir = os.getcwd()

#find vimdir
if sys.platform is 'linux32':
    userdir = path.join('~')
    vimdir = path.join('~', '.vim')
else:
    userdir = path.join("C:\\", "Program Files (x86)", "Vim")
    vimdir = path.join(userdir, 'vimfiles')
    if not path.isdir(vimdir):
        os.mkdir(vimdir)

vimrc = path.join(userdir, '.vimrc')
currtime = str(datetime.now().strftime('%Y%m%d_%H%M'))

with open(path.join(vimdir, 'trond.txt'), 'w') as f:
    f.write('Trond was here. Last update: ' + currtime)

print "Entering " + str(vimdir) + "..."
os.chdir(vimdir)

if not path.isdir('bundle'):
    os.mkdir('bundle')
os.chdir('bundle')
print "Cloning repos..."
with open(path.join(currdir, 'plugins.txt'), 'r') as f:
    for line in f:
        cloneorupdate(line.split()[0])
print "Install complete."
os.chdir(currdir)

