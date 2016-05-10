URL=http://downloads.yeastgenome.org/curation/chromosomal_feature/saccharomyces_cerevisiae.gff

.PHONY: clean cleanall

all: sc_fasta.txt

saccharomyces_cerevisiae.gff:
##	Choose whether to download via wget or curl.
##	Uncomment the one that works for your system.
#	wget -O saccharomyces_cerevisiae.gff $(URL)
	curl -o saccharomyces_cerevisiae.gff $(URL)

sequence.txt: saccharomyces_cerevisiae.gff
	bash verified_genes.sh saccharomyces_cerevisiae.gff verified.txt sequence.txt chr_list.txt

verified.txt: saccharomyces_cerevisiae.gff
	bash verified_genes.sh saccharomyces_cerevisiae.gff verified.txt sequence.txt chr_list.txt

chr_list.txt: saccharomyces_cerevisiae.gff verified.txt 
	bash verified_genes.sh saccharomyces_cerevisiae.gff verified.txt sequence.txt chr_list.txt

verified_short.txt: verified.txt
	bash create_verified_short.sh verified.txt verified_short.txt

sc_fasta.txt: verified_short.txt chr_list.txt sequence.txt
	bash create_fasta.sh verified_short.txt sequence.txt chr_list.txt sc_fasta.txt

clean:
	rm saccharomyces_cerevisiae.gff
	rm sequence.txt verified_short.txt verified.txt chr_list.txt

cleanall: clean
	rm sc_fasta.txt