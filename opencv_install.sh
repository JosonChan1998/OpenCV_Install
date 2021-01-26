#!/bin/bash

echo -e "
+-------------------------------------------------------+
@@@ Welcome to OpenCV4.x Installation Toolkit @@@@
+-------------------------------------------------------+
"

param()
{   
    # set opencv version
    read -p '[BASH]  Choose the OpenCV Version # here:(Enter:default 4.2.0) ' OPENCV_VERSION
    if [ -z "$OPENCV_VERSION" ];then
        OPENCV_VERSION=4.2.0
    fi
    echo ' OpenCV Version:' $OPENCV_VERSION

    # set opencv install path
    read -p '[BASH]  Change the path which OpenCV will be installed:(Enter:default /usr/local)' INSTALL_DIR
    if [ -z "$INSTALL_DIR"  ];then
        INSTALL_DIR=/usr/local
    fi
    echo ' OpenCV will be installed in:' $INSTALL_DIR

    # set opencv download source path
    read -p '[BASH]  Change the path which OpenCV Source path:(Enter:default $HOME)' OPENCV_SOURCE_DIR
    if [ -z "$OPENCV_SOURCE_DIR"  ];then
        OPENCV_SOURCE_DIR=$HOME
    fi
    echo ' OpenCV source be downloaded in:' $OPENCV_SOURCE_DIR

    # build with cuda or not 
    read -p '[BASH]  Do you want to build with Cuda ? (y/n): ' WITH_CUDA
    if [ "$WITH_CUDA" == "y" ];then
        read -p ' What is your arch_bin : ' ARCH_BIN
    fi

    # python path
    read -p '[BASH]  where is your python path ? (default: /usr): ' VIRTUAL_PYTHON_PATH
    if [ -z "$VIRTUAL_PYTHON_PATH"  ];then
        VIRTUAL_PYTHON_PATH=/usr
    fi

    # python version
    read -p '[BASH]  what is your python version ? (default: python3.6): ' PYTHON_VERSION
    if [ -z "$PYTHON_VERSION"  ];then
        PYTHON_VERSION=python3.6
    fi

    # Print out the current configuration
    echo "[BASH]  Build configuration: "
    echo " OpenCV binaries will be installed in: $INSTALL_DIR"
    echo " OpenCV Source will be installed in: $OPENCV_SOURCE_DIR"
    echo " OpenCV build with Cuda or not: $WITH_CUDA"
    echo " Cuda ARCH_BIN: $ARCH_BIN"
    echo " Python path: $VIRTUAL_PYTHON_PATH"
    echo " Python version: $PYTHON_VERSION"
    read -p '[BASH]  Do you wish to continue? (y/n) ' VAL
    if [ "$VAL" == "y" ]; then
        echo -e "[BASH]  Installation will start in 3 seconds."
		sleep 3
        start
    else
        echo "[BASH]  Installation ends..."
        exit 0
    fi
}

start()
{   
    CMAKE_INSTALL_PREFIX=$INSTALL_DIR

    #  Install dependencies
    echo "[BASH]  Install dependencies ..."
    sleep 2
    sudo apt-get update
    # sudo apt-get upgrade
    sudo apt-get install -y build-essential cmake unzip pkg-config
    sudo apt-get install -y libjpeg-dev libpng-dev libtiff-dev
    sudo apt-get install -y libavcodec-dev libavformat-dev libswscale-dev
    sudo apt-get install -y libv4l-dev libxvidcore-dev libx264-dev
    sudo apt-get install -y libgtk-3-dev
    sudo apt-get install -y libatlas-base-dev gfortran
    sudo apt-get install -y python3-dev

    echo "[BASH]  Download sources ..."
    sleep 2
    cd $OPENCV_SOURCE_DIR
    git clone --branch "$OPENCV_VERSION" https://github.com/opencv/opencv.git
    git clone --branch "$OPENCV_VERSION" https://github.com/opencv/opencv_contrib.git

    # Create the build directory and start cmake
    echo "[BASH]  Build from sources ..."
    sleep 2
    cd $OPENCV_SOURCE_DIR/opencv
    if [ ! -d "build/" ];then
        mkdir build
    else
        rm -rf build
        mkdir build
    fi
    cd build


    echo $PWD
    time cmake -D CMAKE_BUILD_TYPE=RELEASE \
	-D CMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX} \
	-D INSTALL_PYTHON_EXAMPLES=ON \
	-D INSTALL_C_EXAMPLES=OFF \
	-D OPENCV_ENABLE_NONFREE=ON \
	-D WITH_CUDA=ON \
	-D WITH_CUDNN=ON \
	-D OPENCV_DNN_CUDA=ON \
	-D ENABLE_FAST_MATH=1 \
	-D CUDA_FAST_MATH=1 \
	-D CUDA_ARCH_BIN=${ARCH_BIN} \
	-D WITH_CUBLAS=1 \
	-D OPENCV_EXTRA_MODULES_PATH=../../opencv_contrib/modules \
    -D BUILD_opencv_python2=OFF \
	-D BUILD_opencv_python3=ON \
    -D PYTHON_DEFAULT_EXECUTABLE=${VIRTUAL_PYTHON_PATH}/bin/python3 \
	-D PYTHON3_EXCUTABLE=${VIRTUAL_PYTHON_PATH}/bin/python3 \
    -D PYTHON3_LIBRARY=${VIRTUAL_PYTHON_PATH}/lib/lib${PYTHON_VERSION}m.so.1.0 \
    -D PYTHON_NUMPY_PATH=${VIRTUAL_PYTHON_PATH}/lib/${PYTHON_VERSION}/site-packages \
	-D BUILD_EXAMPLES=ON ../

    # -D __INSTALL_PATH_PYTHON3=${VIRTUAL_PYTHON_PATH}/lib/${PYTHON_VERSION}/site-packages \ 
    if [ $? -eq 0 ] ; then
        echo "[BASH]  CMake configuration make successful"
    else
        echo "[BASH]  CMake issues " >&2
        echo "[BASH]  Please check the configuration being used"
        exit 1
    fi

    read -p '[BASH]  Do you wish to continue? (y/n) ' VAL
    if [ "$VAL" == "y" ]; then
        echo -e "[BASH]  make will start in 3 seconds."
		sleep 3
    else
        echo "[BASH]  Installation ends..."
        exit 0
    fi


    NUM_JOBS=$(nproc)
    time make -j$NUM_JOBS
    if [ $? -eq 0 ] ; then
        echo "[BASH]  OpenCV make successful"
    else
        echo "[BASH]  Make did not successfully build" >&2
        echo "[BASH]  Please fix issues and retry build"
        exit 1
    fi

    echo "[BASH]  Installing ... "
    time sudo make install
    sudo ldconfig
    if [ $? -eq 0 ] ; then
        echo "[BASH]  OpenCV installed in: $CMAKE_INSTALL_PREFIX"
    else
        echo "[BASH]  There was an issue with the final installation"
        exit 1
    fi

    exit 0
    # echo "[BASH]  Linking cv2.so to virtual python envs"
    # cd $VIRTUAL_PYTHON_PATH/
}

param