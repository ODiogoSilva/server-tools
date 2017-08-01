bindir := bin

# HISAT2 variables
hisat2dir := hisat2
hisat2bins := $(hisat2dir)/hisat2 $(wildcard $(hisat2dir)/hisat2-*)

# StringTie variables
stringtiedir := stringtie
stringtiebins := $(stringtiedir)/stringtie

hisat2b:
	echo "Automatic build for HISAT2"
	cd $(hisat2dir); git reset --hard; git pull;
	$(MAKE) -C hisat2 clean; $(MAKE) -C hisat2;
	#$(MAKE) -C hisat2;
	#ln -sf $(addprefix $(shell pwd)/, $(hisat2bins)) $(bindir)
	mv $(hisat2bins) $(bindir)

stringtieb:
	echo "Automatic build for StringTie"
	cd $(stringtiedir); git reset --hard; git pull;
	$(MAKE) -C stringtie clean; $(MAKE) -C stringtie release
	mv $(stringtiebins) $(bindir)

push:
	git add bin/
	git commit -m "Updated $(tool) tool"
	git push

	
	

