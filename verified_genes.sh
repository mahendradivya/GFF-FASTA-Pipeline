#!/bin/bash

#Bash script that uses the gff file to creates three files, 
#File 1 is all the genes with Verified ORF
#File 2 is all the sequence
#File 3 uses file 2 to create a list of all the chromosomes
#Code File 1/3 in Pipeline
#bash verified_genes.sh saccharomyces_cerevisiae.gff verified.txt sequence.txt chr_list.txt

#check that the gff file is supplied as an argument
if [ $# -eq 0 ]; then 
	echo "Usage: bash $0 filename.gff verified.txt sequence.txt chr_list.txt"
	exit 1
fi

filename=$1
output1=$2
output2=$3
chr_list=$4

#Find all Open Reading Frames and Put them in one File
cat "${filename}" | #cat prints out contents of the file
	sed -e '/###/,$d' | # remove all the sequence code
	grep -v '^#' | # remove the comments at the top of the gff file
	awk '($3 == "gene")' | #only grab lines that are genes
	awk '($9 ~/orf_classification=Verified/)' >> "$output1" # only put lines in the file that have orf_classification = Verified

cat "${filename}" | #cat prints out contents of the file
	sed -n -e '/>chrI/,$p' >> "${output2}" # print only contents after ###

#create a list with the chr names and do a while read line of that file so go through each chromosome
grep ">" "${output2}" | sed "s/>//g" >> "${chr_list}"
