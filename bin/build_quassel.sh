#!/bin/bash

export QTDIR=/opt/local/qt-5.12.1-gui
export QMAKESPEC=$QTDIR/mkspecs/linux-g++-64
export QT_PLUGIN_PATH=$QTDIR/plugins
export PATH=$QTDIR/bin:$PATH
export QT_QMAKE_EXECUTABLE=$QTDIR/bin/qmake

env | grep 'qt-'
which qmake

LINGUAS="en_US" cmake .. \
	-DWANT_CORE=ON -DWANT_MONO=OFF -DWANT_QTCLIENT=ON \
	-DEMBED_DATA=ON -DWITH_WEBENGINE=OFF \
	-DCMAKE_BUILD_TYPE=Release  -DCMAKE_PREFIX_PATH=/opt/src/qt-everywhere-src-5.12.1 && \
	make
