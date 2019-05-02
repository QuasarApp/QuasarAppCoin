TEMPLATE = aux	

autogen.commands = $$PWD/autogen.sh

CORES = $$system(nproc)

Linux.commands = make -C $$PWD/depends HOST=x86_64-pc-linux-gnu -j$$CORES
Windows.commands = make -C $$PWD/depends HOST=x86_64-w64-mingw32 -j$$CORES

configureWin.depends += autogen
configureWin.depends += Windows
configureWin.commands = ./configure --prefix=`pwd`/depends/x86_64-w64-mingw32

configureLinux.depends += autogen
configureLinux.depends += Linux
configureLinux.commands = ./configure --prefix=`pwd`/depends/x86_64-pc-linux-gnu

buildWin.depends += configureWin
buildWin.commands = make clean && make -j$$CORES

buildLinux.depends += configureLinux
buildLinux.commands = make clean && make -j$$CORES

build.depends += buildLinux
build.depends += copyLinux
build.depends += buildWin
build.depends += copyWin
build.depends += strip

mkDir.commands = mkdir -p $$PWD/Distro/Win64 && mkdir -p $$PWD/Distro/Linux

copyWin.depends = mkDir
copyWin.commands = find $$PWD/src/ -name '*.exe' -type f -exec cp {} $$PWD/Distro/Win64  \;
copyLinux.depends = mkDir
copyLinux.commands = cp $$PWD/src/qt/bitcoin-qt $$PWD/Distro/Linux && \
                     cp $$PWD/src/bitcoind $$PWD/Distro/Linux && \
                     cp $$PWD/src/bitcoin-cli $$PWD/Distro/Linux && \
                     cp $$PWD/src/bench/bench_bitcoin $$PWD/Distro/Linux && \
                     cp $$PWD/src/bitcoin-tx $$PWD/Distro/Linux && \
                     cp $$PWD/src/bitcoin-wallet $$PWD/Distro/Linux

deploy.depends += build

strip.commands = strip $$PWD/Distro/Win64/* && strip $$PWD/Distro/Linux/*

QMAKE_EXTRA_TARGETS += \
 autogen \
 mkDir \
 strip \
 Linux \
 Windows \
 configureWin \
 buildWin \
 configureLinux \
 buildLinux \
 build \
 copyWin \
 copyLinux \
 deploy
