TEMPLATE = aux	

autogen.commands = ./autogen.sh

Linux.commands = make HOST=x86_64-pc-linux-gnu -j$(nproc)
Windows.commands = make HOST=x86_64-w64-mingw32 -j$(nproc)

#dependencies.depends += Linux
#dependencies.depends += Windows

configureWin.depends = Windows
configureWin.commands = ./configure --prefix=`pwd`/depends/x86_64-w64-mingw32

configureLinux.depends = Linux
configureLinux.commands = ./configure --prefix=`pwd`/depends/x86_64-pc-linux-gnu

buildWin.depends = configureWin
buildWin.commands = make -j$(nproc)

buildLinux.depends = configureLinux
buildLinux.commands = make -j$(nproc)

build.depends += buildLinux
build.depends += buildWin

QMAKE_EXTRA_TARGETS += \
 autogen \
 Linux \
 Windows \
 configureWin \
 buildWin \
 configureLinux \
 buildLinux \
 build
