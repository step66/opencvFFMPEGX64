#!/bin/bash -x

# http://mukeshchomu.blogspot.sg/2013/06/most-complete-guide-for-installing.html?m=1

# 1. Remove old ffmpeg and x264
sudo apt-get remove ffmpeg x264 libx264-dev libav-tools libvpx-dev

# 2. Install all dependencies for ffmpeg and x264
sudo apt-get install build-essential checkinstall git cmake libfaac-dev libjack-jackd2-dev libmp3lame-dev libopencore-amrnb-dev libopencore-amrwb-dev libsdl1.2-dev libtheora-dev libva-dev libvdpau-dev libvorbis-dev libx11-dev libxfixes-dev libxvidcore-dev texi2html yasm zlib1g-dev pkg-config

# Download and install yasm 1.2.0 from here
./configure --prefix=/usr
make
sudo make install

# Image I/O
sudo apt-get install libtiff4-dev libjpeg-dev libjasper-dev

# Video I/O
sudo apt-get install libavcodec-dev libavformat-dev libswscale-dev libdc1394-22-dev libxine-dev libgstreamer0.10-dev libgstreamer-plugins-base0.10-dev libv4l-dev

# Python
sudo apt-get install python-dev python-numpy

# Download and install libjpeg
sudo apt-get install libjpeg8 libjpeg8-dev

# Other third-party libraries
sudo apt-get install libtbb-dev 

# GUI
sudo apt-get install libqt4-dev libgtk2.0-dev

# 3. Install x.264 and ffmpeg
# In install x264 and ffmpeg, I mainly follow the guide given at [3]. Below are the main steps.
# X264
# Download and install latest x264 from videolan.org.
git clone --depth 1 git://git.videolan.org/x264
cd x264
./configure --enable-static --enable-shared
make
sudo checkinstall --pkgname=x264 --pkgversion="3:$(./version.sh | awk -F'[" ]' '/POINT/{print $4"+git"$5}')" --backup=no --deldoc=yes --fstrans=no --default

# libvpx

git clone --depth 1 http://git.chromium.org/webm/libvpx.git
cd libvpx
./configure --enable-shared
make
sudo checkinstall --pkgname=libvpx --pkgversion="1:$(date +%Y%m%d%H%M)-git" --backup=no \--deldoc=yes --fstrans=no --default


#If you get some error like "relocation R_X86_64_32 against `a local symbol' can not be used when making a shared object; recompile with -fPIC",  compile libvpx with  "fPIC" option. You can do it with the following modified configure command": CFLAGS=-fPIC ./configure --enable-shared


# Install librtmp
apt-get install librtmp-dev
# FFMPEG
# Downlaod latest ffmpeg 1.2.1 from here. Go to the download folder and run the following commands:
tar -xvf ffmpeg-1.2.1.tar.bz2
cd ffmpeg-1.2.1/
./configure --enable-gpl --enable-libfaac --enable-libmp3lame --enable-libopencore-amrnb   --enable-libopencore-amrwb --enable-librtmp --enable-libtheora --enable-libvorbis   --enable-libvpx --enable-libx264 --enable-nonfree --enable-version3 --enable-x11grab --enable-shared --enable-pic
make
sudo make install

# 4. Install OpenCV
# Get a copy of the latest source code here for OpenCV 2.4.5. Open a terminal and go to the directory where you have downloaded the tar file, and run the following commands:
tar -xvf opencv-2.4.5.tar.gz
cd opencv-2.4.5/
mkdir build
cd build/
cmake -D WITH_QT=ON -D WITH_XINE=ON -D WITH_OPENGL=ON -D WITH_TBB=ON -D BUILD_EXAMPLES=ON CMAKE_BUILD_TYPE=RELEASE -D BUILD_NEW_PYTHON_SUPPORT=ON -D CMAKE_INSTALL_PREFIX=/usr/local ..
make
sudo make install

# 5. Configure OpenCV
# We need to tell linux where the shared libraries for OpenCV are located by entering the following shell command:
export LD_LIBRARY_PATH=/usr/local/lib

# Add the command to your .bashrc file so that you don’t have to enter every time your start a new terminal.
# Alternatively, you can configure the system wide library search path. Using your favorite editor, add a single line containing the text /usr/local/lib to the end of a file named/etc/ld.so.conf.d/opencv.conf. In the standard Ubuntu install, the opencv.conf file does not exist; you need to create it. Using vi, for example, enter the following commands:

## sudo vi /etc/ld.so.conf.d/opencv.conf
# G
# o
# /usr/local/lib
# :wq!

# After editing the opencv.conf file, enter the following command:
sudo ldconfig /etc/ld.so.conf

## Using your favorite editor, add the following two lines to the end of /etc/bash.bashrc:

# PKG_CONFIG_PATH=$PKG_CONFIG_PATH:/usr/local/lib/pkgconfig
# export PKG_CONFIG_PATH

# After completing the previous steps, your system should be ready to compile code that uses the OpenCV libraries. The following example shows one way to compile code for OpenCV:
g++ `pkg-config opencv --cflags` my_code.cpp  -o my_code `pkg-config opencv --libs` 

# If you are using a Makefile, append CFLAGS and LDFLAGS as follows:
#Compiler flags
CFLAGS=-c `pkg-config opencv --cflags`
#Linker flags
LDFLAGS= `pkg-config opencv --libs`
# Note: Sometimes Makefile does not include libraries if you put LDFLAGS in the middle of link command, i.e.
g++ $(OBJECTS) $(LDFLAGS) -o output
# It is better to put $(LDFLAGS) at the end of the command after specifying output file, i.e. 
g++ $(OBJECTS) -o output $(LDFLAGS)
