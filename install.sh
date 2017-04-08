#!/bin/bash -x

# taken from: http://blog.mycodesite.com/compile-opencv-with-ffmpeg-for-ubuntudebian/

# The first step is to add the ffmpeg ppa with some of the required dependencies:

sudo add-apt-repository ppa:jon-severinsson/ffmpeg  

# Installing FFMPEG dependencies
sudo apt-get install build-essential checkinstall git cmake libfaac-dev libjack-jackd2-dev libmp3lame-dev libopencore-amrnb-dev libopencore-amrwb-dev libsdl1.2-dev libtheora-dev libva-dev libvdpau-dev libvorbis-dev libx11-dev libxfixes-dev libxvidcore-dev texi2html yasm zlib1g-dev libsdl1.2-dev libvpx-dev

# Installing Gstreamer
sudo apt-get install libgstreamer0.10-0 libgstreamer0.10-dev gstreamer0.10-tools gstreamer0.10-plugins-base libgstreamer-plugins-base0.10-dev gstreamer0.10-plugins-good gstreamer0.10-plugins-ugly gstreamer0.10-plugins-bad gstreamer0.10-ffmpeg

# Installing libgtk2
sudo apt-get install libgtk2.0-0 libgtk2.0-dev  
# Installing libjpeg
sudo apt-get install libjpeg8 libjpeg8-dev  

# Compile required libraries
# Now we need to compile some packages from source.

# IMPORTANT!! The following commands are for 64bits OS. If you have 32 bits remove --enable-pic from all ./configure

# Create a folder with the source code of all required packages:

mkdir ~/source  
mkdir ~/source/x264  
mkdir ~/source/v4l  
mkdir ~/source/opencv  
mkdir ~/source/ffmpeg  

# Compile X264
cd ~/source/x264  
wget ftp://ftp.videolan.org/pub/videolan/x264/snapshots/x264-snapshot-20120528-2245-stable.tar.bz2  
tar xvf x264-snapshot-20120528-2245-stable.tar.bz2  
cd x264-snapshot-20120528-2245-stable  
./configure --enable-shared --enable-pic
make  
sudo make install  

# Compile ffmpeg
cd ~/source/ffmpeg  
wget http://ffmpeg.org/releases/ffmpeg-0.11.1.tar.bz2  
tar xvf ffmpeg-0.11.1.tar.bz2  
cd ffmpeg-0.11.1  

# Now we've to configure it with the flags of the dependencies installed before. Don't forget to remove --enable-pic if you have a 32bit system.

./configure --enable-gpl --enable-libfaac --enable-libmp3lame --enable-libopencore-amrnb --enable-libopencore-amrwb --enable-libtheora --enable-libvorbis --enable-libx264 --enable-libxvid --enable-nonfree --enable-postproc --enable-version3 --enable-x11grab --enable-shared --enable-libvpx --enable-pic

# Compilation will take some time...be patient.

make  
sudo make install  

# Compile v4l
cd ~/source/v4l  
wget http://www.linuxtv.org/downloads/v4l-utils/v4l-utils-0.8.8.tar.bz2  
tar xvf v4l-utils-0.8.8.tar.bz2  
cd v4l-utils-0.8.8  
make  
sudo make install  

# Compile OpenCV
cd ~/source/opencv  

# Download last version source code. You can get it from here. I'll use version 2.4.9

wget http://kent.dl.sourceforge.net/project/opencvlibrary/opencv-unix/2.4.9/opencv-2.4.9.zip  
unzip opencv-2.4.9.zip  
cd opencv-2.4.9  
mkdir release  
cd release  
cmake -D CMAKE_BUILD_TYPE=RELEASE -D CMAKE_INSTALL_PREFIX=/usr/local -D BUILD_NEW_PYTHON_SUPPORT=ON .. 

# After this step you will see the installation summary. Make sure the Video I/O section has ffmpeg, gstreamer, etc enabled! Finally we just need to compile and install it!

make  
sudo make install  
