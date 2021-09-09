FROM ubuntu:16.04

ENV TZ America/Chicago
ENV DEBIAN_FRONTEND noninteractive
ENV LC_ALL C.UTF-8
ENV LANG C.UTF-8
ENV LANGUAGE C.UTF-8
ENV PATH="/opt/pasta-code/pasta:${PATH}"

#basic packages
RUN ln -fs /usr/share/zoneinfo/America/Chicago /etc/localtime \
 && apt-get -y update \
 && apt-get install -y software-properties-common \
 && apt-get install -y build-essential \
 && apt-get install -y gcc \
 && apt-get install -y cmake \
 && apt-get install -y gdb \
 && apt-get install -y tar \
 && apt-get install -y wget \
 && apt-get install -y git \
 && apt-get install -y default-jre \
 && apt-get install -y default-jdk \
 && apt-get install -y flex \
 && apt-get install -y bison \
 && apt-get install -y libgmp3-dev \
 && apt-get install -y time

#python packages
RUN add-apt-repository ppa:deadsnakes/ppa \
 && apt-get -y update \
 && apt-get install -y python2.7 \
 && apt-get install -y python-pip \
 && apt-get install -y python3.7 \
 && apt-get install -y python3-pip \
 && apt-get install -y python3-setuptools \
 && apt-get install -y python3.7-tk \
 && apt-get install -y python3.7-venv \
 && apt-get install -y python3.7-dev \
 && apt-get install -y python3.7-distutils \
 && python2.7 -m pip install --upgrade 'pip==20.3.4' \
 && python3.7 -m pip install --upgrade pip \
 && python2.7 -m pip install virtualenv \
 && python3.7 -m pip install virtualenv \
 && python2.7 -m pip install click \
 && python3.7 -m pip install click \
 && python3.7 -m pip install --upgrade setuptools

# quick scripts
RUN cd /opt/ \
 && git clone "https://git.minhyukpark.com/MinhyukPark/QuickScripts.git" \
 && cd /opt/QuickScripts \
 && python3.7 -m venv --system-site-packages env \
 && . env/bin/activate \
 && python3.7 -m pip install pip==18.1 \
 && python3.7 -m pip install dendropy \
 && python3.7 -m pip install numpy \
 && python3.7 -m pip install treeswift \
 && python3.7 -m pip install pyvolve \
 && python3.7 -m pip install scipy \
 && python3.7 -m pip install scikit-learn \
 && python3.7 -m pip install scikit-bio \
 && deactivate

# Simulators
RUN apt-get install -y indelible \
 && mkdir /opt/simphy \
 && cd /opt/simphy \
 && wget "https://github.com/adamallo/SimPhy/releases/download/v1.0.2/SimPhy_1.0.2.tar.gz" \
 && tar -xzf ./SimPhy_1.0.2.tar.gz \
 && chmod +x ./SimPhy_1.0.2/bin/simphy_lnx64 \
 && ln -s /opt/simphy/SimPhy_1.0.2/bin/simphy_lnx64 /usr/bin/simphy

# Sequence Alignment
RUN apt-get install -y \
 && cd /opt \
 && mkdir /opt/pasta-code \
 && cd /opt/pasta-code \
 && python3.7 -m venv --system-site-packages env \
 && . env/bin/activate \
 && python3.7 -m pip install dendropy \
 && python3.7 -m pip install setuptools \
 && git clone https://github.com/smirarab/pasta.git \
 && git clone https://github.com/smirarab/sate-tools-linux.git \
 && cd pasta \
 && python3.7 setup.py develop \
 && deactivate \
 && export PATH="/opt/pasta-code/pasta:${PATH}" \
 && cd /opt/ \
 && git clone https://github.com/gillichu/sepp.git \
 && cd sepp \
 && python3.7 -m venv --system-site-packages env \
 && . env/bin/activate \
 && pip3 install dendropy \
 && python3.7 setup.py config -c \
 && python3.7 setup.py install \
 && python3.7 setup.py upp -c \
 && deactivate \
 && cd /opt/ \
 && git clone https://github.com/scapella/trimal.git \
 && cd /opt/trimal/source \
 && make \
 && chmod +x ./trimal \
 && ln -s /opt/trimal/source/trimal /usr/bin/trimal \
 && mkdir /opt/mafft \
 && cd /opt/mafft \
 && wget "https://mafft.cbrc.jp/alignment/software/mafft-7.487-with-extensions-src.tgz" \
 && tar -xzf ./mafft-7.487-with-extensions-src.tgz \
 && cd ./mafft-7.487-with-extensions/core/ \
 && make clean \
 && make \
 && make install

# Tree Inference
RUN apt-get install -y phyml \
 && mkdir /opt/fasttree \
 && cd /opt/fasttree \
 && wget "http://www.microbesonline.org/fasttree/FastTree-2.1.11.c" \
 && gcc -DUSE_DOUBLE -DOPENMP -fopenmp -O3 -finline-functions -funroll-loops -Wall -o FastTreeMP FastTree-2.1.11.c -lm \
 && chmod +x ./FastTreeMP \
 && ln -s /opt/fasttree/FastTreeMP /usr/bin/fasttree \
 && mkdir /opt/paup \
 && cd /opt/paup \
 && wget "http://phylosolutions.com/paup-test/paup4a168_ubuntu64.gz" \
 && gunzip ./paup4a168_ubuntu64.gz \
 && chmod +x ./paup4a168_ubuntu64 \
 && ln -s /opt/paup/paup4a168_ubuntu64 /usr/bin/paup \
 && mkdir /opt/astrid \
 && cd /opt/astrid \
 && wget "https://github.com/pranjalv123/ASTRID-1/releases/download/v1.4/ASTRID-linux" \
 && chmod +x ./ASTRID-linux \
 && ln -s /opt/astrid/ASTRID-linux /usr/bin/astrid \
 && mkdir /opt/raxmlng \
 && cd /opt/raxmlng \
 && wget "https://github.com/amkozlov/raxml-ng/releases/download/1.0.1/raxml-ng_v1.0.1_linux_x86_64.zip" \
 && unzip ./raxml-ng_v1.0.1_linux_x86_64.zip \
 && ln -s /opt/raxmlng/raxml-ng /usr/bin/raxmlng \
 && mkdir /opt/raxml_7_2_4 \
 && cd /opt/raxml_7_2_4 \
 && wget "https://cme.h-its.org/exelixis/resource/download/software/RAxML-7.2.4.tar.bz2" \
 && tar -xjf ./RAxML-7.2.4.tar.bz2 \
 && cd RAxML-7.2.4 \
 && make -f Makefile.SSE3.PTHREADS.gcc \
 && ln -s raxmlHPC-PTHREADS-SSE3 /usr/bin/raxml \
 && mkdir /opt/iqtree \
 && cd /opt/iqtree \
 && wget "https://github.com/Cibiv/IQ-TREE/releases/download/v1.6.12/iqtree-1.6.12-Linux.tar.gz" \
 && tar -xzf ./iqtree-1.6.12-Linux.tar.gz \
 && ln -s /opt/iqtree/iqtree-1.6.12-Linux/bin/iqtree /usr/bin/iqtree \
 && mkdir /opt/iqtree2 \
 && cd /opt/iqtree2 \
 && wget "https://github.com/Cibiv/IQ-TREE/releases/download/v2.0.6/iqtree-2.0.6-Linux.tar.gz" \
 && tar -xzf ./iqtree-2.0.6-Linux.tar.gz \
 && ln -s /opt/iqtree2/iqtree-2.0.6-Linux/bin/iqtree2 /usr/bin/iqtree2 \
 && mkdir /opt/fastme \
 && cd /opt/fastme \
 && wget "https://gite.lirmm.fr/atgc/FastME/-/raw/master/tarball/fastme-2.1.6.2.tar.gz" \
 && tar -xzf ./fastme-2.1.6.2.tar.gz \
 && ln -s /opt/fastme/fastme-2.1.6.2/binaries/fastme-2.1.6.2-linux64-omp /usr/bin/fastme


# Tree Mergers
RUN cd /opt/ \
 && git clone "https://github.com/ekmolloy/treemerge.git" \
 && cd /opt/treemerge \
 && python2.7 -m virtualenv --system-site-packages env \
 && . env/bin/activate \
 && python2.7 -m pip install 'networkx==1.11' \
 && python2.7 -m pip install 'dendropy==4.3.0' \
 && python2.7 -m pip install numpy \
 && deactivate \
 && cd /opt/ \
 && git clone "https://github.com/MinhyukPark/INC.git" \
 && cd /opt/INC \
 && make constraint_inc \
 && chmod +x ./constraint_inc \
 && ln -s /opt/INC/constraint_inc /usr/bin/constraint_inc \
 && mkdir /opt/newtreemerge \
 && cd /opt/newtreemerge \
 && git clone "https://github.com/MinhyukPark/treemerge.git"

RUN cd /opt/ \
 && git clone "https://github.com/vlasmirnov/GTM.git" \
 && cd /opt/GTM \
 && python3.7 -m venv --system-site-packages env \
 && . env/bin/activate \
 && python3.7 -m pip install dendropy \
 && python3.7 -m pip install argparse \
 && deactivate

# Tree Comparison
RUN mkdir /opt/erin_tools \
 && cd /opt/erin_tools \
 && wget "https://databank.illinois.edu/datafiles/ice5b/download" \
 && unzip download \
 && rm download \
 && rm -r __MACOSX \
 && mv tools/* ./ \
 && rm -r tools \
 && cd /opt/ \
 && git clone "https://github.com/smirarab/binning.git" \
 && cd binning \
 && python2.7 -m virtualenv --system-site-packages env \
 && . env/bin/activate \
 && python2.7 -m pip install 'dendropy==3.12.2' \
 && deactivate
