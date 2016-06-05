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
    userdir = os.environ['USERPROFILE'] #path.join("C:\\", "User", "Trond")
    vimdir = path.join(userdir, 'vimfiles')
    if not path.isdir(vimdir):
        os.mkdir(vimdir)

vimrc = path.join(userdir, '.vimrc')
currtime = str(datetime.now().strftime('%Y%m%d_%H%M'))
olddir = path.join(currdir, 'old_' + currtime)
os.mkdir(olddir)

print "Fetching submodules..."

call(['git', 'submodule', '-q', 'update'])

if path.isdir(vimdir) and not path.isfile(path.join(vimdir, 'trond.txt')):
    print "Vim directory already exists, moving it to a temporary location."
    shutil.move(vimdir, olddir)
    os.mkdir(vimdir)

with open(path.join(vimdir, 'trond.txt'), 'w') as f:
    f.write('Trond was here. Last update: ' + currtime)

if path.isfile(vimrc):
    shutil.move(vimrc, path.join(olddir, '.vimrc'))

#if len(os.listdir(olddir)) == 0:
    #os.remove(olddir)

print "Making directories..."
if not path.isdir(vimdir):
    os.mkdir(vimdir)
if not path.isdir(path.join(vimdir, 'autoload')):
    os.mkdir(path.join(vimdir, 'autoload'))

print "Linking vimfiles..."
link(path.join(currdir, '.vimrc'), vimrc)
if not os.path.isfile(path.join(vimdir, 'autoload', 'pathogen.vim')):
    link(path.join(currdir, 'vim-pathogen', 'autoload', 'pathogen.vim'), path.join(vimdir, 'autoload', 'pathogen.vim'))

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

