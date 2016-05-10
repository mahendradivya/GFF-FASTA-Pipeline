Midterm Part II - GFF to FASTA Pipeline Version 1.0 3/17/16
Divya Mahendra - Genomic Analysis - Spring 2016

Documentation
-------------
This pipeline takes in a GFF file as input and identifies all genes with verified ORFs and prints their DNA sequence to a FASTA formatted text file.

Running the Pipeline:
	Open the command line environment and navigate to directory in which pipeline files are located.
	Simply type ‘make’ in the command line environment to run the pipeline
	The final output sc_fasta.txt is the result of this pipeline.
	To run the pipeline manually, follow the Pipeline Flow below.

Dependencies:
	saccharomyces_cerevisiae.gff must be downloaded
		LINUX environment use wget
		MAC environment use curl
		Makefile includes command to download gff file, uncomment the command that is suitable to your environment

RunTime of Pipeline: 
	Note the pipeline takes 1hr or longer to run

Files Included:
	Makefile
	Readme.txt
	verified_genes.sh
	create_verified_short.sh
	create_fasta.sh

Files Created:
	verified.txt
	sequence.txt
	chr_list.txt
	verified_short.txt
	sc_fasta.txt #Final output#


Pipeline-Flow
-------------

1)Download saccharomyces_cerevisiae.gff
	#wget -O saccharomyces_cerevisiae.gff http://downloads.yeastgenome.org/curation/chromosomal_feature/saccharomyces_cerevisiae.gff
	#curl -o saccharomyces_cerevisiae.gff http://downloads.yeastgenome.org/curation/chromosomal_feature/saccharomyces_cerevisiae.gff
2)Run bash script verified_genes.sh
	#bash verified_genes.sh saccharomyces_cerevisiae.gff verified.txt sequence.txt
	This splits the gff file into three separate files.
	Verified.txt - gff table of genes w/ verified open reading frames
	Sequence.txt - file with complete DNA sequence by chromosome number
	chr_list.txt - third file with the list of chromosome names
3)Run bash script create_verified_short.sh
	#bash create_verified_short.sh verified.txt verified_short.txt
	This takes in the verified.txt file and shortens it by eliminating unnecessary
 	columns and parsing out the gene ‘Name’ from column 9
	The script outputs verified_short.txt
4)Run bash script create_fasta.sh
	#bash create_fasta.sh verified_short.txt sequence.txt chr_list.txt sc_fasta.txt
	Final script in the pipeline that outputs a text file in fasta format
	of all the genes with verified ORF's with their corresponding DNA sequence

