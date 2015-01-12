FROM tleyden5iwx/ubuntu-cuda
MAINTAINER Ryan Baumann <ryan.baumann@gmail.com>

# Install dependencies
RUN apt-get update
RUN apt-get install -y libgtk2.0-dev glew-utils libglew-dev libmetis-dev libscotchparmetis-dev libdevil-dev libboost-all-dev libatlas-cpp-0.6-dev libatlas-dev imagemagick libatlas3gf-base libcminpack-dev libgfortran3 freeglut3-dev libgsl0-dev liblapack-dev unzip

WORKDIR /root

# Install VisualSFM
ADD http://ccwu.me/vsfm/download/VisualSFM_linux_64bit.zip /root/VisualSFM_linux_64bit.zip
RUN unzip VisualSFM_linux_64bit.zip
RUN cd vsfm; make

# Install SiftGPU
ADD http://wwwx.cs.unc.edu/~ccwu/cgi-bin/siftgpu.cgi /root/SiftGPU.zip
RUN unzip SiftGPU.zip
RUN cd SiftGPU; make; cp bin/libsiftgpu.so ../vsfm/bin

# Install PBA
ADD http://grail.cs.washington.edu/projects/mcba/pba_v1.0.5.zip /root/pba.zip
RUN unzip pba.zip
RUN cd pba; make; cp bin/libpba.so ../vsfm/bin

# Install pmvs2
# ADD http://www.di.ens.fr/pmvs/pmvs-2-fix0.tar.gz /root/pmvs-2.tar.gz
ADD http://www.di.ens.fr/pmvs/pmvs-2.tar.gz /root/pmvs-2.tar.gz
RUN tar xzf pmvs-2.tar.gz
RUN cd pmvs-2/program/main/; cp mylapack.o mylapack.o.backup; make clean; cp mylapack.o.backup mylapack.o; make depend; make; cp -v pmvs2 /root/vsfm/bin

# Install Graclus
ADD http://www.cs.utexas.edu/users/dml/Software/graclus1.2.tar.gz /root/graclus1.2.tar.gz
RUN tar xzf graclus1.2.tar.gz
ADD graclus.patch /root/graclus1.2/graclus.patch
RUN cd graclus1.2; patch -p0 < graclus.patch; make

# Install cmvs
# ADD http://www.di.ens.fr/cmvs/cmvs-fix2.tar.gz /root/cmvs.tar.gz

