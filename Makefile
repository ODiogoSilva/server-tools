bindir = bin

# HISAT2 variables
hisat2dir = hisat2
hisat2bins := $(hisat2dir)/hisat2 $(wildcard $(hisat2dir)/hisat2-*)

# StringTie variables
stringtiedir = stringtie
stringtiebins = $(stringtiedir)/stringtie

$(hisat2dir)/Makefile:
	echo "Automatic build for HISAT2"
	cd $(hisat2dir); git reset --hard; git pull

$(hisat2dir)/hisat2: $(hisat2dir)/Makefile
	$(MAKE) -C hisat2 clean
	$(MAKE) -C hisat2

hisat2b: $(hisat2bins)
	cd $(bindir); ln ../$< ./


stringtieb:
	echo "Automatic build for StringTie"
	cd $(stringtiedir); git reset --hard; git pull;
	$(MAKE) -C stringtie clean; $(MAKE) -C stringtie release
	mv $(stringtiebins) $(bindir)

push:
	git add bin/
	git commit -m "Updated $(tool) tool"
	git push

	
.PHONY: hisat2b	

