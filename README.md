# Build OpenCV from sources in anaconda virtual envs with Cuda

This is the script for installing OpenCV4.x with cuda in anaconda or default python

## uninstall your old version OpenCV

if you can find the build folder, you can run:
```bash
cd build
sudo make uninstall
cd ../
rm -rf build
```
and remove all the opencv lib:

```bash
$  rm -r /usr/local/include/opencv2 /usr/local/include/opencv /usr/include/opencv /usr/include/opencv2 /usr/local/share/opencv /usr/local/share/OpenCV /usr/share/opencv /usr/share/OpenCV /usr/local/bin/opencv* /usr/local/lib/libopencv*
$  cd /usr
$  find . -name "*opencv*" | xargs sudo rm -rf
```
if you don't have the build folder , you can rebuild your old version follow next step , then try again.

## Build OpenCV in anaconda with Cuda

```bash
git clone 

cd opencv_install

bash ./opencv_install.sh
```

First of all ,you should set same parameters for installing OpenCV and cuda setting

- `INSTALL_DIR`: Where the OpenCV installed,default is /usr/local, recommand /usr/local
- `OPENCV_SOURCE_DIR`: Where the OpenCV sources code download,default is your home dir
- `WITH_CUDA`: With cuda or not
- `ARCH_BIN`: You should check your device arch_bin in [Nvidia Devices](https://developer.nvidia.com/cuda-gpus)
- `VIRTUAL_PYTHON_PATH`: Where is your python path,example: `/home/dnn/anaconda3/envs/opencv3`
- `PYTHON_VERSION`: which python version your virtual envs use for,example: `python3.6`

## Example

My test envs:

- OpenCV 4.5.0
- Ubuntu18.04
- GTX 1080
- Cuda 10.0
- Cudnn 7.6.3
- anaconda3
- virtual envs: movie
- make sure your virtual envs install numpy

```bash
[BASH]  Choose the OpenCV Version :(Enter:default 4.2.0) 4.5.0
 OpenCV Version: 4.5.0
[BASH]  Change the path which OpenCV will be installed:(Enter:default /usr/local)
 OpenCV will be installed in: /usr/local
[BASH]  Change the path which OpenCV Source path:(Enter:default $HOME)
 OpenCV source be downloaded in: /home/dnn
[BASH]  Do you want to build with Cuda ? (y/n): y
 What is your arch_bin : 6.1
[BASH]  where is your python path ? (default: /usr): /home/dnn/anaconda3/envs/movie
[BASH]  what is your python version ? (default: python3.6): 
[BASH]  Build configuration: 
 OpenCV binaries will be installed in: /usr/local
 OpenCV Source will be installed in: /home/dnn
 OpenCV build with Cuda or not: y
 Cuda ARCH_BIN: 6.1
 Python path: /home/dnn/anaconda3/envs/movie
 Python version: python3.6
[BASH]  Do you wish to continue? (y/n) y
```

**Please check your python install path!!!**

```bash
--   Python 3:
--     Interpreter:                 /home/dnn/anaconda3/envs/movie/bin/python3 (ver 3.6.12)
--     Libraries:                   /home/dnn/anaconda3/envs/movie/lib/libpython3.6m.so.1.0 (ver 3.6.12)
--     numpy:                       /home/dnn/anaconda3/envs/movie/lib/python3.6/site-packages/numpy/core/include (ver 1.19.2)
--     install path:                lib/python3.6/site-packages/cv2/python-3.6
```

you can see install_path :  `lib/python3.6/site-packages/cv2/python-3.6`

## Linking .so file to your envs

```bash
cd /usr/local/lib/python3.6/site-packages/cv2/python-3.6

ls -l
```

you will see like this:

```bash
cv2.cpython-36m-x86_64-linux-gnu.so
```

then link to your virtual envs:

```bash
cd /home/dnn/anaconda3/envs/movie/lib/python3.6/packages

sudo ln -s /usr/local/lib/python3.6/site-packages/cv2/cv2.cpython-36m-x86_64-linux-gnu.so cv2.so
```

## Test

```bash
conda activate movie

python

import cv2

cv2.__version__
```
