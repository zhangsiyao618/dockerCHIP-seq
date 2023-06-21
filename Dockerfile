FROM centos7.2
MAINTAINER Jiayi Yang <monmon1006@sjtu.edu.cn>  
MAINTAINER Siyao Zhang <zhangsiyao618@163.com> 
MAINTAINER Haoran Liu <3116451397@qq.com>

LABEL \
    description="Image for tools used in Chip-seq"

RUN apt-get update -y && apt-get install -y \
    build-essential \
    bzip2 \
    cmake \
    default-jdk \
    git \
    libnss-sss \
    libtbb2 \
    libtbb-dev \
    ncurses-dev \
    nodejs \
    python-dev \
    python-pip \
    tzdata \
    unzip \
    wget \
    zlib1g \
    zlib1g-dev

##############
#Anaconda3#
##############
RUN wget https://mirrors.tuna.tsinghua.edu.cn/anaconda/archive/Anaconda3-2023.03-1-Linux-x86_64.sh  \  --n
o-check-certificate  && \
    echo 'ssl_verify: true' >> ~/.bashrc  && \
    echo 'show_channel_urls: true' >> ~/.bashrc  && \
    echo 'default_channels:' >> ~/.bashrc  && \
    echo '  - https://mirror.sjtu.edu.cn/anaconda/pkgs/main/' >> ~/.bashrc  && \
    echo '  - https://mirror.sjtu.edu.cn/anaconda/pkgs/r/' >> ~/.bashrc  && \
    echo 'custom_channels:' >> ~/.bashrc  && \
    echo 'conda-forge: https://mirror.sjtu.edu.cn/anaconda/cloud/' >> ~/.bashrc  && \
    echo 'bioconda: https://mirror.sjtu.edu.cn/anaconda/cloud/' >> ~/.bashrc  && \
    echo ' pytorch: https://mirror.sjtu.edu.cn/anaconda/cloud/' >> ~/.bashrc  && \
   
##############
#axel#
##############
RUN sudo yum install axel

##############
#FastQC v0.12.1#
############## 
RUN mkdir -p /opt/FastQC && \
    cd /opt/FastQC && \
    wget http://cbb.sjtu.edu.cn/course/bio3505/soft/fastqc.zip && \
    unzip fastqc.zip && \
    echo 'export PATH= /opt/FastQC/bin'>> ~./bashrc && \
    source ~/.bashrc

##############
#cutadapt#
############## 
RUN pip install cutadapt

##############
#bowtie2#
##############
RUN conda install -c bioconda bowtie2

##############
#sratoolkit.2.10.8#
##############
RUN mkdir -p /opt/sratoolkit && \
    cd /opt/sratoolkit && \
    wget https://ftp-trace.ncbi.nlm.nih.gov/sra/sdk/2.10.8/sratoolkit.2.10.8-centos_linux64.tar.gz && \
    tar xzvf sratoolkit.2.10.8-centos_linux64.tar.gz && \
    echo 'export PATH=/root/usr/local/sratoolkit.2.10.8-centos_linux64/bin:$/opt/sratoolkit/bin' >> ~/.bashrc
    source ~/.bashrc

#################
#samtools v0.1.19#
#################
RUN conda install -c bioconda samtools
    cd ~/.conda/envs/bio/lib && \
    ln -s libcrypto.so.1.1 libcrypto.so.1.0.0 

##############
#trim-galore v0.6.10#
##############
RUN conda install -c bio trim-galore==0.6.10

#################
#macs2 v2.2.7.1#
#################
RUN mkdir -p /opt/macs2 && \
    cd /opt/macs2 && \
    wget https://files.pythonhosted.org/packages/e2/61/85d30ecdd34525113e28cb0c5a9f393f93578165f8d848be5925c0208dfb/MACS2-2.2.7.1.tar.gz && \
    tar zxvf MACS2-2.2.7.1.tar.gz && \
    cd MACS2-2.2.7.1 && \
    pip install umap-learn && \
    pip install scanpy && \
    pip install anndata && \
    pip install --upgrade 'setuptools<44' && \
    pip install --upgrade build && \
    python setup.py install

###############
#deeptools#
###############
RUN conda install -c bioconda deeptools


