bindir := bin

# HISAT2 variables
hisat2dir := hisat2
hisat2bins := $(hisat2dir)/hisat2 $(wildcard $(hisat2dir)/hisat2-*)
hisat2: gitdir:=$(hisat2dir)


# StringTie variables
stringtiedir := stringtie
stringtiebins := $(stringtiedir)/stringtie
stringtie: gitdir:=$(stringtiedir)

# HTSlib variables
htslibdir = htslib
htslibbins := $(htslibdir)/tabix $(htslibdir)/htsfile
htslib: gitdir:=$(htslibdir)

# PHONY definition
.PHONY: hisat2 link push stringtie gitcheck 


# General rule recipies

all: hisat2 stringtie 

link:
	cd $(bindir); ln -f $(addprefix ../,$(bins))

push:
	git add bin/
	git commit -m "Updated $(tool) tool"
	git push

gitcheck:
	# Git submodule updating 
	git submodule update $(gitdir)


# Building recipies

# hisat2 build
hisat2: gitcheck $(hisat2bins) 

$(hisat2bins): .git/modules/$(hisat2dir)/HEAD
	cd $(hisat2dir); git reset --hard; git pull
	$(MAKE) -C hisat2 clean; $(MAKE) -C hisat2
	$(MAKE) link bins=$@


# Stringtie build
stringtie: gitcheck $(stringtiebins)

$(stringtiebins): .git/modules/$(stringtiedir)/HEAD
	cd $(stringtiedir); git reset --hard; git pull;
	$(MAKE) -C stringtie clean; $(MAKE) -C stringtie release
	$(MAKE) link bins=$@


# HTSlib build
htslib: gitcheck $(htslibbins)

$(htslibbins): .git/modules/$(htslibdir)/HEAD
	cd $(htslibdir); git reset --hard; git pull;
	$(MAKE) -C htslib clean; $(MAKE) -C htslib
	$(MAKE) link bins=$@

