if not exist %2 (
    echo Cloning http://github.com/%1/%2.git...
    git --help>NUL
    if not %ERRORLEVEL%==9009 (
        git clone http://github.com/%1/%2.git -q
    ) else (echo ERROR: could not find git.exe)
) else (
    echo %2 Already exists, updating...
    cd %2
    git pull origin master
    cd ..
)
