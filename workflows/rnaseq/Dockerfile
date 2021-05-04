# Set the base image to debian jessie
FROM python:3.8

USER root

RUN apt-get update && apt-get install --yes --no-install-recommends \
    wget \
    git \
    cmake \
    build-essential \
    && apt-get autoclean \
    && curl -sL https://deb.nodesource.com/setup_14.x  | bash - \
    && apt-get install -y python-setuptools \
    unzip \
    default-jre \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN apt-get update && apt-get install -y curl

RUN curl https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh \
  > Miniconda3-latest-Linux-x86_64.sh \
  && yes \
  | bash Miniconda3-latest-Linux-x86_64.sh -b

# put system path first so that conda doesn't override python
ENV PATH=$PATH:/root/miniconda3/bin/
COPY environment.yml /
RUN conda env create -f environment.yml
RUN conda clean -a
