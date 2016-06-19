import os
from os import path, environ
import sys
from threading import Thread
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
        sys.stdout.write("Updating " + reponame + "...\n")
        os.chdir(reponame)
        try:
            print("\t" + subprocess.check_output(['git', 'pull', '-n', 'origin', 'master'], stderr=subprocess.STDOUT).splitlines()[-1])
        finally:
            os.chdir('..')
    else:
        sys.stdout.write("Cloning " + reponame + "...\n")
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
threads = []
with open(path.join(currdir, 'plugins.txt'), 'r') as f:
    for line in f:
        thread = Thread(target=cloneorupdate, args=(line.split()[0],))
        threads.append(thread)
        thread.start()
        if not "--async" in sys.argv:
            thread.join()
for thread in threads:
    thread.join()
print "Install complete."
os.chdir(currdir)

