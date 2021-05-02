#!/Users/ericau/src/github.com/fishingcluster




def helpMessage() {
  log.info """
        BWA Index
        Usage:
            ./bwa [options] \$fasta
        Mandatory arguments:
         --fasta                      Reference fasta file of your genome

       Optional arguments:
        --outdir                       Output directory to place final BLAST output
        --help                         This usage statement.
        """
}
/*
def installBWA() {
            conda (params.enable_conda ? "bioconda::bwa=0.7.17 bioconda::samtools=1.12" : null)
    if (workflow.containerEngine == 'singularity' && !params.singularity_pull_docker_container) {
        container "https://depot.galaxyproject.org/singularity/mulled-v2-fe8faa35dbf6dc65a0f7f5d4ea12e31a79f73e40:66ed1b38d280722529bb8a0167b0cf02f8a0b488-0"
    } else {
        container "quay.io/biocontainers/mulled-v2-fe8faa35dbf6dc65a0f7f5d4ea12e31a79f73e40:66ed1b38d280722529bb8a0167b0cf02f8a0b488-0"
    }


}*/

fasta = params.fasta


channel
  .fromPath( params.fasta )
  .ifEmpty { error "Cannot find any fasta files matching: ${params.fasta}" }
  .set { fasta_ch }
/*
 * Parse software version numbers
 */

process INDEX_BWA {
    tag "$fasta"
    label 'process_medium'

    publishDir path: { params.save_reference ? "${baseDir}/genomes" : params.outdir },
        saveAs: { params.save_reference ? it : null }, mode: params.publish_dir_mode

    input:
    path fasta

    output:
    path 'BWAIndex'

    script:

    """
    #!/bin/bash

    conda /Users/ericau/src/github.com/fishingcluster/conda.yaml
        
    bwa index \$fasta

    mkdir BWAIndex && mv \${fasta}* BWAIndex

    echo \"indexing genome is complete\"
    echo \$(./bwa--version 2>&1)

    """
}

process get_software_versions {
    publishDir "${params.outdir}/pipeline_info", mode: params.publish_dir_mode,
        saveAs: { filename ->
                      if (filename.indexOf('.csv') > 0) filename
                      else null
                }

    output:
    path 'software_versions_mqc.yaml' into ch_software_versions_mqc
    path 'software_versions.csv'

    script:
    """
    echo $workflow.manifest.version > v_pipeline.txt
    echo $workflow.nextflow.version > v_nextflow.txt
    fastqc --version > v_fastqc.txt
    trim_galore --version > v_trim_galore.txt
    echo \$(bwa 2>&1) > v_bwa.txt
    samtools --version > v_samtools.txt
    bedtools --version > v_bedtools.txt
    echo \$(bamtools --version 2>&1) > v_bamtools.txt
    echo \$(plotFingerprint --version 2>&1) > v_deeptools.txt || true
    picard MarkDuplicates --version &> v_picard.txt  || true
    echo \$(R --version 2>&1) > v_R.txt
    python -c "import pysam; print(pysam.__version__)" > v_pysam.txt
    echo \$(macs2 --version 2>&1) > v_macs2.txt
    touch v_homer.txt
    echo \$(ataqv --version 2>&1) > v_ataqv.txt
    echo \$(featureCounts -v 2>&1) > v_featurecounts.txt
    preseq &> v_preseq.txt
    multiqc --version > v_multiqc.txt
    scrape_software_versions.py &> software_versions_mqc.yaml
    """
}

