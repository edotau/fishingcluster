#!/bin/bash
#SBATCH --mem=128G
#SBATCH --cpus-per-task=8
#SBATCH --ntasks=6
#SBATCH --nodes=1
set -eou pipefail
DIR=/data/lowelab/edotau/rabsTHREEspine/nextflow_atacseq
INPUT=$DIR/experiment.csv
export PATH=/data/lowelab/edotau/miniconda3/envs/nf-core-atacseq-1.2.1/bin:$PATH
nextflow run nf-core/atacseq -r 1.2.1 --input $INPUT --fasta /data/lowelab/edotau/rabsTHREEspine/index/rabsTHREEspine.fa --bwa_index /data/lowelab/edotau/rabsTHREEspine/index/rabsTHREEspine.fa --gtf ${DIR}/denovo.reference.transcrtipt.assembly.annotated.gtf --macs_gsize 4.2e8 --save_trimmed --mito_name chrM --save_trimmed --skip_fastqc --skip_igv --skip_preseq --max_cpus $SLURM_CPUS_ON_NODE -profile conda -resume ac646535-d15e-4c0b-8115-f946921ab886


