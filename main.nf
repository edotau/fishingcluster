#!/usr/scripts/env nextflow
/*
========================================================================================
                         nf-core/atacseq
========================================================================================
 nf-core/atacseq Analysis Pipeline.
 #### Homepage / Documentation
 https://github.com/nf-core/atacseq
----------------------------------------------------------------------------------------
*/

def helpMessage() {
    log.info nfcoreHeader()
    log.info"""
    Usage:

    The typical command for running the pipeline is as follows:

      nextflow run nf-core/atacseq --input design.csv --genome GRCh37 -profile docker

    Mandatory arguments:
      --input [file]                  Comma-separated file containing information about the samples in the experiment (see docs/usage.md) (Default: './design.csv')
      --fasta [file]                  Path to Fasta reference. Not mandatory when using reference in iGenomes config via --genome (Default: false)
      --gtf [file]                    Path to GTF file. Not mandatory when using reference in iGenomes config via --genome (Default: false)
      -profile [str]                  Configuration profile to use. Can use multiple (comma separated)
                                      Available: conda, docker, singularity, awsbatch, test

    Generic
      --single_end [bool]             Specifies that the input is single-end reads (Default: false)
      --seq_center [str]              Sequencing center information to be added to read group of BAM files (Default: false)
      --fragment_size [int]           Estimated fragment size used to extend single-end reads (Default: 0)
      --fingerprint_scriptss [int]        Number of genomic scriptss to use when calculating fingerprint plot (Default: 500000)

    References                        If not specified in the configuration file or you wish to overwrite any of the references
      --genome [str]                  Name of iGenomes reference (Default: false)
      --bwa_index [file]              Full path to directory containing BWA index including base name i.e. /path/to/index/genome.fa (Default: false)
      --gene_bed [file]               Path to BED file containing gene intervals (Default: false)
      --tss_bed [file]                Path to BED file containing transcription start sites (Default: false)
      --macs_gsize [str]              Effective genome size parameter required by MACS2. If using iGenomes config, values have only been provided when --genome is set as GRCh37, GRCm38, hg19, mm10, BDGP6 and WBcel235 (Default: false)
      --blacklist [file]              Path to blacklist regions (.BED format), used for filtering alignments (Default: false)
      --mito_name [str]               Name of Mitochondrial chomosome in genome fasta (e.g. chrM). Reads aligning to this contig are filtered out (Default: false)
      --save_reference [bool]         If generated by the pipeline save the BWA index in the results directory (Default: false)

    Trimming
      --clip_r1 [int]                 Instructs Trim Galore to remove bp from the 5' end of read 1 (or single-end reads) (Default: 0)
      --clip_r2 [int]                 Instructs Trim Galore to remove bp from the 5' end of read 2 (paired-end reads only) (Default: 0)
      --three_prime_clip_r1 [int]     Instructs Trim Galore to remove bp from the 3' end of read 1 AFTER adapter/quality trimming has been performed (Default: 0)
      --three_prime_clip_r2 [int]     Instructs Trim Galore to remove bp from the 3' end of read 2 AFTER adapter/quality trimming has been performed (Default: 0)
      --trim_nextseq [int]            Instructs Trim Galore to apply the --nextseq=X option, to trim based on quality after removing poly-G tails (Default: 0)
      --skip_trimming [bool]          Skip the adapter trimming step (Default: false)
      --save_trimmed [bool]           Save the trimmed FastQ files in the results directory (Default: false)

    Alignments
      --bwa_min_score [int]           Don’t output BWA MEM alignments with score lower than this parameter (Default: false)
      --keep_mito [bool]              Reads mapping to mitochondrial contig are not filtered from alignments (Default: false)
      --keep_dups [bool]              Duplicate reads are not filtered from alignments (Default: false)
      --keep_multi_map [bool]         Reads mapping to multiple locations are not filtered from alignments (Default: false)
      --skip_merge_replicates [bool]  Do not perform alignment merging and downstream analysis by merging replicates i.e. only do this by merging resequenced libraries (Default: false)
      --save_align_intermeds [bool]   Save the intermediate BAM files from the alignment step - not done by default (Default: false)

    Peaks
      --narrow_peak [bool]            Run MACS2 in narrowPeak mode (Default: false)
      --broad_cutoff [float]          Specifies broad cutoff value for MACS2. Only used when --narrow_peak isnt specified (Default: 0.1)
      --macs_fdr [float]              Minimum FDR (q-value) cutoff for peak detection, --macs_fdr and --macs_pvalue are mutually exclusive (Default: false)
      --macs_pvalue [float]           p-value cutoff for peak detection, --macs_fdr and --macs_pvalue are mutually exclusive (Default: false)
      --min_reps_consensus [int]      Number of biological replicates required from a given condition for a peak to contribute to a consensus peak (Default: 1)
      --save_macs_pileup [bool]       Instruct MACS2 to create bedGraph files normalised to signal per million reads (Default: false)
      --skip_peak_qc [bool]           Skip MACS2 peak QC plot generation (Default: false)
      --skip_peak_annotation [bool]   Skip annotation of MACS2 and consensus peaks with HOMER (Default: false)
      --skip_consensus_peaks [bool]   Skip consensus peak generation (Default: false)

    Differential analysis
      --deseq2_vst [bool]             Use vst transformation instead of rlog with DESeq2 (Default: false)
      --skip_diff_analysis [bool]     Skip differential accessibility analysis (Default: false)

    QC
      --skip_fastqc [bool]            Skip FastQC (Default: false)
      --skip_picard_metrics [bool]    Skip Picard CollectMultipleMetrics (Default: false)
      --skip_preseq [bool]            Skip Preseq (Default: false)
      --skip_plot_profile [bool]      Skip deepTools plotProfile (Default: false)
      --skip_plot_fingerprint [bool]  Skip deepTools plotFingerprint (Default: false)
      --skip_ataqv [bool]             Skip Ataqv (Default: false)
      --skip_igv [bool]               Skip IGV (Default: false)
      --skip_multiqc [bool]           Skip MultiQC (Default: false)

    Other
      --outdir [file]                 The output directory where the results will be saved (Default: './results')
      --publish_dir_mode [str]        Mode for publishing results in the output directory. Available: symlink, rellink, link, copy, copyNoFollow, move (Default: copy)
      --email [email]                 Set this parameter to your e-mail address to get a summary e-mail with details of the run sent to you when the workflow exits (Default: false)
      --email_on_fail [email]         Same as --email, except only send mail if the workflow is not successful (Default: false)
      --max_multiqc_email_size [str]  Threshold size for MultiQC report to be attached in notification email. If file generated by pipeline exceeds the threshold, it will not be attached (Default: 25MB)
      -name [str]                     Name for the pipeline run. If not specified, Nextflow will automatically generate a random mnemonic (Default: false)

    AWSBatch
      --awsqueue [str]                The AWSBatch JobQueue that needs to be set when running on AWSBatch
      --awsregion [str]               The AWS Region for your AWS Batch job to run on
      --awscli [str]                  Path to the AWS CLI tool
    """.stripIndent()
}

///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
/* --                                                                     -- */
/* --                SET UP CONFIGURATION VARIABLES                       -- */
/* --                                                                     -- */
///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////

// Show help message
if (params.help) {
    helpMessage()
    exit 0
}


////////////////////////////////////////////////////
/* --         DEFAULT PARAMETER VALUES         -- */
////////////////////////////////////////////////////

// Check if genome exists in the config file
if (params.genomes && params.genome && !params.genomes.containsKey(params.genome)) {
    exit 1, "The provided genome '${params.genome}' is not available in the iGenomes file. Currently the available genomes are ${params.genomes.keySet().join(", ")}"
}

// Configurable variables
params.fasta = params.genome ? params.genomes[ params.genome ].fasta ?: false : false
params.bwa_index = params.genome ? params.genomes[ params.genome ].bwa ?: false : false
params.gtf = params.genome ? params.genomes[ params.genome ].gtf ?: false : false
params.gene_bed = params.genome ? params.genomes[ params.genome ].bed12 ?: false : false
params.mito_name = params.genome ? params.genomes[ params.genome ].mito_name ?: false : false
params.macs_gsize = params.genome ? params.genomes[ params.genome ].macs_gsize ?: false : false
params.blacklist = params.genome ? params.genomes[ params.genome ].blacklist ?: false : false
params.anno_readme = params.genome ? params.genomes[ params.genome ].readme ?: false : false

// Global variables
def PEAK_TYPE = params.narrow_peak ? 'narrowPeak' : 'broadPeak'

////////////////////////////////////////////////////
/* --          CONFIG FILES                    -- */
////////////////////////////////////////////////////


if (params.bwa_index) {
    lastPath = params.bwa_index.lastIndexOf(File.separator)
    bwa_dir =  params.bwa_index.substring(0,lastPath+1)
    bwa_base = params.bwa_index.substring(lastPath+1)
    Channel
        .fromPath(bwa_dir, checkIfExists: true)
        .set { ch_bwa_index }
}


/*
 * PREPROCESSING: Reformat design file and check validitiy
 */
process CHECK_DESIGN {
    tag "$design"
    publishDir "${params.outdir}/pipeline_info", mode: params.publish_dir_mode

    input:
    path design from ch_input

    output:
    path '*.csv' into ch_design_reads_csv

    script:  // This script is bundled with the pipeline, in nf-core/atacseq/scripts/
    """
    check_design.py $design design_reads.csv
    """
}

/*
 * Create channels for input fastq files
 */
if (params.single_end) {
    ch_design_reads_csv
        .splitCsv(header:true, sep:',')
        .map { row -> [ row.sample_id, [ file(row.fastq_1, checkIfExists: true) ] ] }
        .into { ch_raw_reads_fastqc;
                ch_raw_reads_trimgalore;
                design_replicates_exist;
                design_multiple_samples }
} else {
    ch_design_reads_csv
        .splitCsv(header:true, sep:',')
        .map { row -> [ row.sample_id, [ file(row.fastq_1, checkIfExists: true), file(row.fastq_2, checkIfExists: true) ] ] }
        .into { ch_raw_reads_fastqc;
                ch_raw_reads_trimgalore;
                design_replicates_exist;
                design_multiple_samples }
}

// Boolean value for replicates existing in design
replicatesExist = design_replicates_exist
                      .map { it -> it[0].split('_')[-2].replaceAll('R','').toInteger() }
                      .flatten()
                      .max()
                      .val > 1

// Boolean value for multiple groups existing in design
multipleGroups = design_multiple_samples
                     .map { it -> it[0].split('_')[0..-3].join('_') }
                     .flatten()
                     .unique()
                     .count()
                     .val > 1

///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
/* --                                                                     -- */
/* --                     PREPARE ANNOTATION FILES                        -- */
/* --                                                                     -- */
///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////

/*
 * PREPROCESSING: Build BWA index
 */
if (!params.bwa_index) {
    process BWA_INDEX {
        tag "$fasta"
        label 'process_high'
        publishDir path: { params.save_reference ? "${params.outdir}/genome" : params.outdir },
            saveAs: { params.save_reference ? it : null }, mode: params.publish_dir_mode

        input:
        path fasta from ch_fasta

        output:
        path 'BWAIndex' into ch_bwa_index

        script:
        """
        bwa index -a bwtsw $fasta
        mkdir BWAIndex && mv ${fasta}* BWAIndex
        """
    }
}

/*
 * PREPROCESSING: Generate gene BED file
 */
// If --gtf is supplied along with --genome
// Make gene bed from supplied --gtf instead of using iGenomes one automatically
def MAKE_BED = false
if (!params.gene_bed) {
    MAKE_BED = true
} else if (params.genome && params.gtf) {
    if (params.genomes[ params.genome ].gtf != params.gtf) {
        MAKE_BED = true
    }
}
if (MAKE_BED) {
    process MAKE_GENE_BED {
        tag "$gtf"
        label 'process_low'
        publishDir "${params.outdir}/genome", mode: params.publish_dir_mode

        input:
        path gtf from ch_gtf

        output:
        path '*.bed' into ch_gene_bed

        script: // This script is bundled with the pipeline, in nf-core/atacseq/scripts/
        """
        gtf2bed $gtf > ${gtf.baseName}.bed
        """
    }
}

/*
 * PREPROCESSING: Generate TSS BED file
 */
if (!params.tss_bed) {
    process MAKE_TSS_BED {
        tag "$bed"
        publishDir "${params.outdir}/genome", mode: params.publish_dir_mode

        input:
        path bed from ch_gene_bed

        output:
        path '*.bed' into ch_tss_bed

        script:
        """
        cat $bed | awk -v FS='\t' -v OFS='\t' '{ if(\$6=="+") \$3=\$2+1; else \$2=\$3-1; print \$1, \$2, \$3, \$4, \$5, \$6;}' > ${bed.baseName}.tss.bed
        """
    }
}

/*
 * PREPROCESSING: Prepare genome intervals for filtering
 */
process MAKE_GENOME_FILTER {
    tag "$fasta"
    publishDir "${params.outdir}/genome", mode: params.publish_dir_mode

    input:
    path fasta from ch_fasta
    path blacklist from ch_blacklist.ifEmpty([])

    output:
    path "$fasta"                                      // FASTA FILE FOR IGV
    path '*.fai'                                       // FAI INDEX FOR REFERENCE GENOME
    path '*.bed' into ch_genome_filter_regions         // BED FILE WITHOUT BLACKLIST REGIONS & MITOCHONDRIAL CONTIG FOR FILTERING
    path '*.txt' into ch_genome_autosomes              // TEXT FILE CONTAINING LISTING OF AUTOSOMAL CHROMOSOMES FOR ATAQV
    path '*.sizes' into ch_genome_sizes_mlib_bigwig,   // CHROMOSOME SIZES FILE FOR BEDTOOLS
                        ch_genome_sizes_mrep_bigwig

    script:
    blacklist_filter = params.blacklist ? "sortBed -i $blacklist -g ${fasta}.sizes | complementBed -i stdin -g ${fasta}.sizes" : "awk '{print \$1, '0' , \$2}' OFS='\t' ${fasta}.sizes"
    name_filter = params.mito_name ? "| awk '\$1 !~ /${params.mito_name}/ {print \$0}'": ''
    mito_filter = params.keep_mito ? '' : name_filter
    """
    samtools faidx $fasta
    get_autosomes.py ${fasta}.fai ${fasta}.autosomes.txt
    cut -f 1,2 ${fasta}.fai > ${fasta}.sizes
    $blacklist_filter $mito_filter > ${fasta}.include_regions.bed
    """
}

///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
/* --                                                                     -- */
/* --                        FASTQ QC                                     -- */
/* --                                                                     -- */
///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////

/*
 * STEP 1: FastQC
 */
process FASTQC {
    tag "$name"
    label 'process_medium'
    publishDir "${params.outdir}/fastqc", mode: params.publish_dir_mode,
        saveAs: { filename ->
                      filename.endsWith('.zip') ? "zips/$filename" : filename
                }

    when:
    !params.skip_fastqc

    input:
    tuple val(name), path(reads) from ch_raw_reads_fastqc

    output:
    path '*.{zip,html}' into ch_fastqc_reports_mqc

    script:
    // Added soft-links to original fastqs for consistent naming in MultiQC
    if (params.single_end) {
        """
        [ ! -f  ${name}.fastq.gz ] && ln -s $reads ${name}.fastq.gz
        fastqc -q -t $task.cpus ${name}.fastq.gz
        """
    } else {
        """
        [ ! -f  ${name}_1.fastq.gz ] && ln -s ${reads[0]} ${name}_1.fastq.gz
        [ ! -f  ${name}_2.fastq.gz ] && ln -s ${reads[1]} ${name}_2.fastq.gz
        fastqc -q -t $task.cpus ${name}_1.fastq.gz
        fastqc -q -t $task.cpus ${name}_2.fastq.gz
        """
    }
}

///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
/* --                                                                     -- */
/* --                        ADAPTER TRIMMING                             -- */
/* --                                                                     -- */
///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////

/*
 * STEP 2: Trim Galore!
 */
if (params.skip_trimming) {
    ch_trimmed_reads = ch_raw_reads_trimgalore
    ch_trimgalore_results_mqc = Channel.empty()
    ch_trimgalore_fastqc_reports_mqc = Channel.empty()
} else {
    process TRIMGALORE {
        tag "$name"
        label 'process_high'
        publishDir "${params.outdir}/trim_galore", mode: params.publish_dir_mode,
            saveAs: { filename ->
                          if (filename.endsWith('.html')) "fastqc/$filename"
                          else if (filename.endsWith('.zip')) "fastqc/zips/$filename"
                          else if (filename.endsWith('trimming_report.txt')) "logs/$filename"
                          else params.save_trimmed ? filename : null
                    }

        input:
        tuple val(name), path(reads) from ch_raw_reads_trimgalore

        output:
        tuple val(name), path('*.fq.gz') into ch_trimmed_reads
        path '*.txt' into ch_trimgalore_results_mqc
        path '*.{zip,html}' into ch_trimgalore_fastqc_reports_mqc

        script:
        // Calculate number of --cores for TrimGalore based on value of task.cpus
        // See: https://github.com/FelixKrueger/TrimGalore/blob/master/Changelog.md#version-060-release-on-1-mar-2019
        // See: https://github.com/nf-core/atacseq/pull/65
        def cores = 1
        if (task.cpus) {
            cores = (task.cpus as int) - 4
            if (params.single_end) cores = (task.cpus as int) - 3
            if (cores < 1) cores = 1
            if (cores > 4) cores = 4
        }

        // Added soft-links to original fastqs for consistent naming in MultiQC
        c_r1 = params.clip_r1 > 0 ? "--clip_r1 ${params.clip_r1}" : ''
        c_r2 = params.clip_r2 > 0 ? "--clip_r2 ${params.clip_r2}" : ''
        tpc_r1 = params.three_prime_clip_r1 > 0 ? "--three_prime_clip_r1 ${params.three_prime_clip_r1}" : ''
        tpc_r2 = params.three_prime_clip_r2 > 0 ? "--three_prime_clip_r2 ${params.three_prime_clip_r2}" : ''
        nextseq = params.trim_nextseq > 0 ? "--nextseq ${params.trim_nextseq}" : ''

        // Added soft-links to original fastqs for consistent naming in MultiQC
        if (params.single_end) {
            """
            [ ! -f  ${name}.fastq.gz ] && ln -s $reads ${name}.fastq.gz
            trim_galore --cores $cores --fastqc --gzip $c_r1 $tpc_r1 $nextseq ${name}.fastq.gz
            """
        } else {
            """
            [ ! -f  ${name}_1.fastq.gz ] && ln -s ${reads[0]} ${name}_1.fastq.gz
            [ ! -f  ${name}_2.fastq.gz ] && ln -s ${reads[1]} ${name}_2.fastq.gz
            trim_galore --cores $cores --paired --fastqc --gzip $c_r1 $c_r2 $tpc_r1 $tpc_r2 $nextseq ${name}_1.fastq.gz ${name}_2.fastq.gz
            """
        }
    }
}

///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
/* --                                                                     -- */
/* --                        ALIGN                                        -- */
/* --                                                                     -- */
///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////

/*
 * STEP 3.1: Map read(s) with bwa mem
 */
process BWA_MEM {
    tag "$name"
    label 'process_high'

    input:
    tuple val(name), path(reads) from ch_trimmed_reads
    path index from ch_bwa_index.collect()

    output:
    tuple val(name), path('*.bam') into ch_bwa_bam

    script:
    prefix = "${name}.Lb"
    rg = "\'@RG\\tID:${name}\\tSM:${name.split('_')[0..-2].join('_')}\\tPL:ILLUMINA\\tLB:${name}\\tPU:1\'"
    if (params.seq_center) {
        rg = "\'@RG\\tID:${name}\\tSM:${name.split('_')[0..-2].join('_')}\\tPL:ILLUMINA\\tLB:${name}\\tPU:1\\tCN:${params.seq_center}\'"
    }
    score = params.bwa_min_score ? "-T ${params.bwa_min_score}" : ''
    """
    bwa mem \\
        -t $task.cpus \\
        -M \\
        -R $rg \\
        $score \\
        ${index}/${bwa_base} \\
        $reads \\
        | samtools view -@ $task.cpus -b -h -F 0x0100 -O BAM -o ${prefix}.bam -
    """
}

/*
 * STEP 3.2: Convert BAM to coordinate sorted BAM
 */
process SORT_BAM {
    tag "$name"
    label 'process_medium'
    if (params.save_align_intermeds) {
        publishDir path: "${params.outdir}/bwa/library", mode: params.publish_dir_mode,
            saveAs: { filename ->
                          if (filename.endsWith('.flagstat')) "samtools_stats/$filename"
                          else if (filename.endsWith('.idxstats')) "samtools_stats/$filename"
                          else if (filename.endsWith('.stats')) "samtools_stats/$filename"
                          else filename
                    }
    }

    input:
    tuple val(name), path(bam) from ch_bwa_bam

    output:
    tuple val(name), path('*.sorted.{bam,bam.bai}') into ch_sort_bam_merge
    path '*.{flagstat,idxstats,stats}' into ch_sort_bam_flagstat_mqc

    script:
    prefix = "${name}.Lb"
    """
    samtools sort -@ $task.cpus -o ${prefix}.sorted.bam -T $name $bam
    samtools index ${prefix}.sorted.bam
    samtools flagstat ${prefix}.sorted.bam > ${prefix}.sorted.bam.flagstat
    samtools idxstats ${prefix}.sorted.bam > ${prefix}.sorted.bam.idxstats
    samtools stats ${prefix}.sorted.bam > ${prefix}.sorted.bam.stats
    """
}
