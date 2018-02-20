#
# pcl dockerfile

# Pull base image.
FROM ubuntu:16.04

# Install.
RUN apt-get update

RUN apt-get install -y software-properties-common
RUN apt-get install -y ca-certificates
RUN apt-get install -y wget 
RUN apt-get install -y curl 
RUN apt-get install -y ssh 

RUN wget -O - http://apt.llvm.org/llvm-snapshot.gpg.key | apt-key add -
RUN apt-add-repository "deb http://apt.llvm.org/xenial/ llvm-toolchain-xenial-4.0 main"

RUN apt-get update
RUN apt-get install -y build-essential


RUN apt-get install -y  \
  mc \
  lynx \
  libvtk5.10 libvtk5-dev \
  libqhull* \
  pkg-config \
  python2.7-dev \
  --no-install-recommends --fix-missing


RUN apt-get install -y  \
  mesa-common-dev \
  cmake  \
  git  \
  mercurial \
  freeglut3-dev \
  libflann-dev \
  --no-install-recommends --fix-missing


RUN apt-get autoremove

RUN wget -O boost_1_58_0.tar.gz http://sourceforge.net/projects/boost/files/boost/1.58.0/boost_1_58_0.tar.gz/download
RUN tar xzvf boost_1_58_0.tar.gz && rm boost_1_58_0.tar.gz
RUN cd boost_1_58_0 && ./bootstrap.sh --prefix=/usr/
RUN cd boost_1_58_0 && ./b2 install

RUN cd /opt && hg clone -r 3.2 https://bitbucket.org/eigen/eigen eigen
RUN mkdir -p /opt/eigen/build
RUN cd /opt/eigen/build && cmake ..
RUN cd /opt/eigen/build && make install
RUN cd /opt && git clone https://github.com/PointCloudLibrary/pcl.git pcl
RUN cd /opt/pcl && git checkout tags/pcl-1.7.2
RUN mkdir -p /opt/pcl/build
RUN cd /opt/pcl/build && cmake ..
RUN cd /opt/pcl/build && make -j 4
RUN cd /opt/pcl/build && make install
RUN cd /opt/pcl/build && make clean