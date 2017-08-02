bindir := bin
updatestr = "Your branch is up-to-date"

GITSTATUS=$(shell cd $(gitdir) && git fetch && git status -uno | grep $(updatestr))

# HISAT2 variables
hisat2dir := hisat2
hisat2bins := $(hisat2dir)/hisat2 $(wildcard $(hisat2dir)/hisat2-*)

# StringTie variables
stringtiedir := stringtie
stringtiebins := $(stringtiedir)/stringtie

# General rule recipies

gitstatus: $(gitdir)
	if [ -z "$(GITSTATUS)" ]; then\
		touch $(gitdir)/.DEWIT;\
	fi

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

stringtieb: 
	echo "Automatic build for StringTie"
	$(MAKE) gitstatus gitdir=$(stringtiedir)
	$(MAKE) stringtiebuild

stringtiebuild: $(stringtiedir)/.DEWIT
	cd $(stringtiedir); git reset --hard; git pull;
	$(MAKE) -C stringtie clean; $(MAKE) -C stringtie release
	$(MAKE) link bins=$(stringtiebins)

.PHONY: hisat2b gitstatus link push stringtieb

