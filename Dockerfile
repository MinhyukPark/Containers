FROM ubuntu:16.04

ENV TZ America/Chicago
ENV DEBIAN_FRONTEND noninteractive
ENV LC_ALL C.UTF-8
ENV LANG C.UTF-8
ENV LANGUAGE C.UTF-8

#basic packages
RUN ln -fs /usr/share/zoneinfo/America/Chicago /etc/localtime \
 && apt-get -y update \
 && apt-get install -y software-properties-common \
 && apt-get install -y build-essential \
 && apt-get install -y cmake \
 && apt-get install -y gdb \
 && apt-get install -y tar \
 && apt-get install -y wget \
 && apt-get install -y git \
 && apt-get install -y default-jre \
 && apt-get install -y default-jdk \
 && apt-get install -y flex \
 && apt-get install -y bison \
 && apt-get install -y libgmp3-dev

#python packages
RUN add-apt-repository ppa:deadsnakes/ppa \
 && apt-get -y update \
 && apt-get install -y python2.7 \
 && apt-get install -y python-pip \
 && apt-get install -y python3.7 \
 && apt-get install -y python3-pip \
 && apt-get install -y python3.7-tk \
 && apt-get install -y python3.7-venv \
 && python2.7 -m pip install --upgrade pip \
 && python3.7 -m pip install --upgrade pip \
 && python2.7 -m pip install virtualenv \
 && python3.7 -m pip install virtualenv \
 && python2.7 -m pip install click \
 && python3.7 -m pip install click

# quick scripts
RUN cd /opt/ \
 && git clone "https://git.minhyukpark.com/MinhyukPark/QuickScripts.git" \
 && cd /opt/QuickScripts \
 && python3.7 -m venv --system-site-packages env \
 && . env/bin/activate \
 && python3.7 -m pip install dendropy \
 && python3.7 -m pip install numpy \
 && python3.7 -m pip install treeswift \
 && python3.7 -m pip install pyvolve \
 && python3.7 -m pip install scikit-learn \
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
RUN apt-get install -y mafft \
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
 && deactivate

# Tree Inference
RUN apt-get install -y phyml raxml fasttree \
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
 && cd /opt/ \
 && git clone --recursive https://github.com/amkozlov/raxml-ng \
 && cd raxml-ng \
 && mkdir build \
 && cd build \
 && cmake .. \
 && make \
 && ln -s /opt/raxml-ng/bin/raxml-ng /usr/bin/raxmlng \
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
 && ln -s /opt/INC/constraint_inc /usr/bin/constraint_inc

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
