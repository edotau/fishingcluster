#!/bin/bash


conda create -n fishingcluster -c conda-forge -c bioconda -c defaults -c conda-forge/osx-64 -c pkgs/r/noarch bash=5.0.018 python=3.7
markdown=3 pygments=2.6 pymdown-extensions=7.1
r-base=3.6 r-optparse=1.6 r-rcolorbrewer=1.1 r-reshape2=1 r-ggplot2=3 r-tidyr=1.1.0 r-scales=1.1.1 r-pheatmap=1.0 r-lattice=0.20 r-upsetr=1.4.0 r-xfun=0.15
gawk=5.1.0 pigz=2.3
nextflow=20.10.0
htslib bwa=0.7.17 bwa-mem2 samtools=1.12 ucsc-bedgraphtobigwig=357
macs2=2.2.7 homer=4.11 ataqv=1.1.1
trim-galore=0.6.5 picard multiqc=1.9 bamtools pysam ucsc-bedgraphtobigwig=357
deeptools=3.4.3 subread=2.0.1 preseq=2.0.3
bioconductor-biocparallel=1.20.0 bioconductor-deseq2=1.26.0 bioconductor-vsn=3.54.0
