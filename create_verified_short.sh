#!/bin/bash
#Code File 2/3 in Pipeline
#bash script to create verified_short.txt from verified.txt file


#check that the gff file is supplied as an argument
if [ $# -eq 0 ]; then 
	echo "Usage: bash $0 verified.txt verified_short.txt"
	exit 1
fi


filename=$1
output=$2


cat "$filename" | #filename is verified.txt
  awk -v OFS='\t' '{ 
    split($9, array, ";");
    for(key in array) {
      if(match(array[key], /^Name=/)) {
    	name = substr(array[key], 6)
      }
    };
    print($1, $3, $4, $5, $7, name);
  }' > "$output"
  
#print out the contents of the input file name which is then piped to the awk command
#awk -v passes bash variables into awk
#OFS(Output Field Separator) when awk is completed, the output is separated by "\t"
#OFS='\t' '{  
#split($9, array, ";");   												 ## splits column 9 into an array delimited by ';'
#for(key in array) {													 ## for loop, for every key in the array 
#      if(match(array[key], /^Name=/)) {						 ## if the current position in the array matches the string "Name="
#    	go = substr(array[key], 6)										 ## set the 'go' variable to substring that starts at position 6 (where "Name=" ends)
#      }																 ## until the end of the current column in array
#    };																	 ##
#    print($1, $3, $4, $5, $7, name);								     ## print out columns 1, 3, 4, 5, 7, and name of the array
#  }' > "$output"														 ## put the awk output (new table) into the output  file 	
