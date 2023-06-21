#!/bin/bash
wkd=$1 # set working path
file=$2 #set working file

cd $wkd
mkdir $wkd/rawdata
cat $file | while read id
do 
    prefetch ${id} && mv $wkd/${id}/*sra $wkd/rawdata/ && rm -r $wkd/${id}  # download raw reads
done
for i in $wkd/rawdata/*sra
do
    echo $i
    fastq-dump --split-3 --skip-technical --clip --gzip $i  # transform .sra to .fastq.gz
done

mv $wkd/*gz $wkd/rawdata # move .gz to rawdata/ 

ls $wkd/rawdata/*gz | xargs fastqc -t 5 # set 5 threads to produce quality report
multiqc ./ # integrate all 5 reports into a comprehensive one

mkdir $wkd/cleandata
cd $wkd/cleandata
ls $wkd/rawdata/*.fastq.gz > config
cat config | while read id
do
        arr=(${id})
        fq1=${arr[0]}
    trim_galore -q 25 --phred33 --length 36 --stringency 3 -o $wkd  $fq1  #trim the raw data
done

mkdir $wkd/align # for storing alignment results
mkdir $wkd/ref # for storing data of the reference mm10 genome
cd $wkd/ref
mkdir mouse
cd mouse
wget -c "ftp://ftp.ccb.jhu.edu/pub/data/bowtie2_indexes/mm10.zip" # download pre-built reference genome to ref
unzip mm10.zip.0

cd $wkd/cleandata
ls *gz|cut -d"_" -f 1 | sort -u | while read id;do
ls -lh ${id}_trimmed.fq.gz
bowtie2 -q -p 10 -x $wkd/ref/mouse/mm10 -U ${id}_trimmed.fq.gz -S $wkd/align/${id}.sam   # map raw reads to the reference genome sequence
done

cd $wkd/align
ls *.sam|cut -d"." -f 1 |while read id ;do
    samtools view -@ 8 -S $id.sam -1b -o $id.bam    # convert .sam to .bam
    samtools sort -@ 8 -l 5 -o $id.sort.bam $id.bam 
done

ls *.sort.bam |xargs -i samtools index {}  # build index for all .bam files 

ls *.sort.bam|cut -d"." -f 1 |sort -u |while read id
do
macs2 callpeak -c ${id}.bam -t ${id}.bam -q 0.05 -f BAM -g mm -n ${id} 2> ${id}.log &  # peak calling
done
wc -l *bed #check results of peak calling 

cat $wkd/$file | while read id
do
bamCoverage --bam ../${id}.sort.bam \    # transform .bam to .bigwig
--outFileName ${id}.sort.bigWig \
--outFileFormat bigwig \
--binSize 10 \
-p 12
done

# Results are for further visualization 

