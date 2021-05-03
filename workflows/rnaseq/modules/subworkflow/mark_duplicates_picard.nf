/*
 * Picard MarkDuplicates, sort, index BAM file and run samtools stats, flagstat and idxstats
 */

params.markduplicates_options = [:]
params.samtools_options       = [:]

include { PICARD_MARKDUPLICATES } from '../software/picard/markduplicates/main' addParams( options: params.markduplicates_options )
include { SAMTOOLS_INDEX        } from '../software/samtools/index/main'        addParams( options: params.samtools_options       )
include { BAM_STATS_SAMTOOLS    } from './bam_stats_samtools'                   addParams( options: params.samtools_options       )

workflow MARK_DUPLICATES_PICARD {
    take:
    bam // channel: [ val(meta), [ bam ] ]

    main:
    /*
     * Picard MarkDuplicates
     */
    PICARD_MARKDUPLICATES ( bam )

    /*
     * Index BAM file and run samtools stats, flagstat and idxstats
     */
    SAMTOOLS_INDEX     ( PICARD_MARKDUPLICATES.out.bam )
    BAM_STATS_SAMTOOLS ( PICARD_MARKDUPLICATES.out.bam.join(SAMTOOLS_INDEX.out.bai, by: [0]) )

    emit:
    bam              = PICARD_MARKDUPLICATES.out.bam     // channel: [ val(meta), [ bam ] ]
    metrics          = PICARD_MARKDUPLICATES.out.metrics // channel: [ val(meta), [ metrics ] ]
    picard_version   = PICARD_MARKDUPLICATES.out.version //    path: *.version.txt

    bai              = SAMTOOLS_INDEX.out.bai            // channel: [ val(meta), [ bai ] ]
    stats            = BAM_STATS_SAMTOOLS.out.stats      // channel: [ val(meta), [ stats ] ]
    flagstat         = BAM_STATS_SAMTOOLS.out.flagstat   // channel: [ val(meta), [ flagstat ] ]
    idxstats         = BAM_STATS_SAMTOOLS.out.idxstats   // channel: [ val(meta), [ idxstats ] ]
    samtools_version = SAMTOOLS_INDEX.out.version        //    path: *.version.txt
}
