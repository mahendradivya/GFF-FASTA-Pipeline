#!/bin/bash

#Code File 3/3 in Pipeline
#This script takes in the verified_short.txt, sequence.txt, and chr_list.txt files and creates the final output fasta formatted file sc_fasta.txt 
 

#if these are arguments are not given the script will exit and echo the usage statement in the console  
if [ $# -eq 0 ]; then 
	echo "Usage: bash $0 verified_short.txt sequence.txt chr_list.txt sc_fasta.txt"
	exit 1
fi

filename=$1
sequence=$2
chrlist=$3
output=$4

#Loop takes a while to run because it goes through the sequence.txt file for every line in chr_list.txt
count=2 #counter for first while loop, starts at line 2 of chr_list for next_chr variable
while read line #main loop to go through chr_list.txt file
do
	cur_chr=${line}
	next_chr=`cat ${chrlist} | head -n ${count} | tail -n 1`  #get the next chr name
	count1=1 #counter for inner while loop
	
	while read line2 #second loop to go through sequence.txt file 
	do
	
		v_cur_chr=`cat ${filename} | head -n ${count1} | tail -n 1 | awk -F"\t" '{print $1}'` #the name of the current chromosome
		
		if [ ${cur_chr} == ${v_cur_chr} ]; #if the chr name in chr_list.txt matches chr name of the current line in sequence.txt
			then
			
			num1=`cat ${filename} | head -n ${count1} | tail -n 1 | awk -F"\t" '{print $3}'` #starting position of sequence
			num2=`cat ${filename} | head -n ${count1} | tail -n 1 | awk -F"\t" '{print $4}'` #ending position of sequence
			gene=`cat ${filename} | head -n ${count1} | tail -n 1 | awk -F"\t" '{print $6}'` #name of gene from column 6 of verified_short.txt
			strand=`cat ${filename} | head -n ${count1} | tail -n 1 | awk -F"\t" '{print $5}'` #sign of the sequence strand
			difference=$((num2 - num1)) #how many characters is the sequence 
		
			echo ">${gene}/${v_cur_chr}:${num1}-${num2}/${strand}" >> ${output} #print out the header before each sequence in fasta 
			if [ ${strand} == '-' ]; then #if the strand is negative, print out the reverse complement of the sequence
					#echo "negative strand"
					sed -n -e '/'${cur_chr}'/,$p' ${sequence} | sed -e '/'${next_chr}'/,$d' | #get the sequence from after the current chromosome until the next chromosome
					sed -n -e '/[ATCG]/,$p' | 
					tr "\n" " "| sed  "s/ //g" | 
					awk -v l=$num1 -v r=$((difference+1)) '{print substr($0, l, r)}' | #get the sequence at the location given
					rev | # pipe to rev so the string is reversed
					tr "A" "a" | tr "C" "c" |  #create reverse complement by replacing A with T, T with A, C with G and G with C
					tr "T" "A" | tr "G" "C" | 
					tr "a" "T" | tr "c" "G" >> ${output} #output the sequence to fasta file
				else # if the strand is positive print the sequence
					#echo "positive strand"
					sed -n -e '/'${cur_chr}'/,$p' ${sequence} | sed -e '/'${next_chr}'/,$d' |  #get the sequence from after the current chromosome until the next chromosome
					sed -n -e '/[ATCG]/,$p' | 
					tr "\n" " "| sed  "s/ //g" | 
					awk -v l=$num1 -v r=$((difference+1)) '{print substr($0, l, r)}' >> ${output} #get the locations needed
			fi
			
		fi
		
		count1=$((count1+1))	#increment counter
	done < ${filename}
	count=$((count+1)) #increment counter
done < ${chrlist}


##### Sources ######
#pass bash variable to awk
#http://stackoverflow.com/questions/14585483/pass-bash-variable-to-awk-in-order-to-extract-characters-at-certain-positions

#substr: http://www.linuxnix.com/awk-substr-function-explained-with-examples/
#substr($col_no, start, how_many)

#subtracting two variables in bash
#http://stackoverflow.com/questions/21260698/subtract-two-variables

#if else in bash
#http://tldp.org/HOWTO/Bash-Prog-Intro-HOWTO-6.html