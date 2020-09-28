FROM ubuntu:18.04

ENV TZ=America/Chicago
ENV DEBIAN_FRONTEND=noninteractive
ENV LC_ALL=C.UTF-8
ENV LANG=C.UTF-8

#basic packages
RUN ln -fs /usr/share/zoneinfo/America/Chicago /etc/localtime \
 && apt-get -y update \
 && apt-get install -y software-properties-common \
 && apt-get install -y build-essential \
 && apt-get install -y gcc-8 \
 && apt-get install -y g++-8 \
 && update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-8 800 --slave /usr/bin/g++ g++ /usr/bin/g++-8 \
 && apt-get install -y cmake \
 && apt-get install -y gdb \
 && apt-get install -y tar \
 && apt-get install -y wget \
 && apt-get install -y git \
 && apt-get install -y default-jre \
 && apt-get install -y default-jdk \

# R packages
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E298A3A825C0D65DFD57CBB651716619E084DAB9 \
 && add-apt-repository -y 'deb https://cloud.r-project.org/bin/linux/ubuntu bionic-cran40/' \
 && apt-get -y update \
 && apt-get install -y r-base \
 && echo "install.packages(\"sirt\", repos=\"https://cran.rstudio.com\")" | R --no-save \

# system wide python packages
RUN apt-get install -y python-pip \
 && apt-get install -y python-tk \
 && apt-get install -y libpython2.7 \
 && apt-get install -y python3 \
 && apt-get install -y python3-tk \
 && apt-get install -y python3-venv python3-pip \
 && pip install virtualenv \
 && pip3 install virtualenv \
 && pip install click \
 && pip3 install click \
 && pip install matplotlib \
 && pip3 install matplotlib \
 && pip install numpy \
 && pip3 install numpy \
 && pip install dendropy \
 && pip3 install dendropy \
 && pip3 install pyvolve \

# Simulators
RUN apt-get install -y indelible \
 && mkdir /opt/simphy \
 && cd /opt/simphy \
 && wget "https://github.com/adamallo/SimPhy/releases/download/v1.0.2/SimPhy_1.0.2.tar.gz" \
 && tar -xzf ./SimPhy_1.0.2.tar.gz \
 && chmod +x ./SimPhy_1.0.2/bin/simphy_lnx64 \
 && ln -s /opt/simphy/SimPhy_1.0.2/bin/simphy_lnx64 /usr/bin/simphy \

# Sequence Alignment
RUN apt-get install -y mafft \

# Tree Inference
RUN apt-get install -y phyml raxml iqtree fasttree \
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

# Tree Mergers
RUN cd /opt/ \
 && git clone "https://github.com/ekmolloy/treemerge.git" \
 && cd /opt/treemerge \
 && python -m virtualenv --system-site-packages env \
 && . env/bin/activate \
 && pip install 'networkx==1.11' \
 && pip install 'dendropy==4.3.0' \
 && deactivate \

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
 && python -m virtualenv --system-site-packages env \
 && . env/bin/activate \
 && pip install 'dendropy==3.12.2' \
 && deactivate \
