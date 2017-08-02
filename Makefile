bindir := bin

# HISAT2 variables
hisat2dir := hisat2
hisat2bins := $(hisat2dir)/hisat2 $(wildcard $(hisat2dir)/hisat2-*)

# StringTie variables
stringtiedir := stringtie
stringtiebins := $(stringtiedir)/stringtie


# PHONY definition

.PHONY: hisat2b link push stringtie


# General rule recipies

link:
	cd $(bindir); ln -f $(addprefix ../,$(bins))

push:
	git add bin/
	git commit -m "Updated $(tool) tool"
	git push


# Building recipies

hisat2b: 
	$(MAKE) gitstatus gitdir=$(hisat2dir)
	$(MAKE) hisat2build

hisat2build: $(hisat2dir)/.DEWIT
	cd $(hisat2dir); git reset --hard; git pull
	$(MAKE) -C hisat2 clean; $(MAKE) -C hisat2
	cd $(bindir); ln -f $(addprefix ../,$(hisat2bins)) ./

# Stringtie build
stringtie: $(bindir)/stringtie

$(bindir)/stringtie: .git/modules/$(stringtiedir)/HEAD
	# Automatic build for StringTie
	git submodule update $(stringtiedir)
	$(MAKE) stringtiebuild

stringtiebuild: .git/modules/$(stringtiedir)/HEAD
	cd $(stringtiedir); git reset --hard; git pull;
	$(MAKE) -C stringtie clean; $(MAKE) -C stringtie release
	$(MAKE) link bins=$(stringtiebins)
