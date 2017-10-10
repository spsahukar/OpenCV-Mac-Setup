#!/usr/bin/env bash
#xcode-select --install

#brew update
#brew install install libjpeg8-dev libtiff4-dev libjasper-dev libpng12-dev
#brew install libjpeg8-dev libtiff4-dev libjasper-dev libpng12-dev
#brew install jpeg libpng libtiff openexr
#install eigen tbb
#brew install eigen tbb
#brew upgrade tbb

#cd /usr/local/lib
#mv libjpeg.dylib libjpeg.dylib.backup
#ln -s /System/Library/Frameworks/ImageIO.framework/Resources/libJPEG.dylib libJPEG.dylib
#mv libtiff.dylib libtiff.dylib.backup
#ln -s /System/Library/Frameworks/ImageIO.framework/Resources/libTIFF.dylib libTIFF.dylib
#mv libpng.dylib libpng.dylib.backup
#ln -s /System/Library/Frameworks/ImageIO.framework/Resources/libPng.dylib libPNG.dylib
#cd -
DIR=$(date +"%m_%d_%Y")
echo $DIR
mkdir opencv_$DIR
cd opencv_$DIR
echo $(pwd)
git clone https://github.com/opencv/opencv.git opencv
git clone https://github.com/opencv/opencv_contrib.git opencv_contrib
#git clone --depth 1 --branch 3.2.0 https://github.com/opencv/opencv.git opencv
#git clone --depth 1 --branch 3.2.0 https://github.com/opencv/opencv_contrib.git opencv_contrib
NUMPY_PATH=$(python3 -c "import numpy;print(str(numpy.__path__)[2:-2] + '/core/include/')")
echo "NUMPY Path = $NUMPY_PATH"
PYTHON36_DYLIB=$(python3 -c "from distutils.sysconfig import get_python_lib;print(str(get_python_lib()[:-14]) + '/config-3.6m-darwin/libpython3.6.dylib')")
echo "PYTHON36_Library = $PYTHON36_DYLIB"
OPENCV_CONTRIB_MODULES="$(pwd)/opencv_contrib/modules"
echo "OPENCV_CONTRIB_MODULES = $OPENCV_CONTRIB_MODULES"

mkdir opencv/build
cd opencv/build
echo "Change to build directory"
echo $(pwd)

cmake   -DBUILD_TIFF=ON\
        -DBUILD_opencv_java=OFF\
        -DWITH_CUDA=OFF\
        -DENABLE_AVX=ON\
        -DWITH_OPENGL=ON\
        -DWITH_OPENCL=ON\
        -DWITH_IPP=ON\
        -DWITH_TBB=ON\
        -DWITH_EIGEN=ON\
        -DWITH_V4L=ON\
        -DWITH_VTK=OFF\
        -DBUILD_TESTS=OFF\
        -DBUILD_PERF_TESTS=OFF\
        -DCMAKE_BUILD_TYPE=RELEASE\
        -DBUILD_opencv_python2=OFF\
        -DCMAKE_INSTALL_PREFIX=$(python3 -c "import sys; print(sys.prefix)")\
        -DPYTHON3_EXECUTABLE=$(which python3) -DPYTHON3_INCLUDE_DIR=$(python3 -c "from distutils.sysconfig import get_python_inc; print(get_python_inc())")\
        -DPYTHON3_PACKAGES_PATH=$(python3 -c "from distutils.sysconfig import get_python_lib; print(get_python_lib())")\
        -DINSTALL_C_EXAMPLES=ON\
        -DINSTALL_PYTHON_EXAMPLES=ON\
        -DBUILD_EXAMPLES=ON\
        -DPYTHON3_NUMPY_INCLUDE_DIRS=$NUMPY_PATH \
        -DOPENCV_EXTRA_MODULES_PATH=$OPENCV_CONTRIB_MODULES \
        -DPYTHON3_LIBRARY=$PYTHON36_DYLIB  ..

make -j8

#cp lib/python3/cv2.cpython-36m-darwin.so /usr/local/Cellar/python3/3.6.2/Frameworks/Python.framework/Versions/3.6/lib/python3.6/site-packages
#cp lib/python3/cv2.cpython-36m-darwin.so /Users/suryasahukar/Library/Python/3.6/lib/python/site-packages/cv2/cv2.cpython-36m-darwin.so




