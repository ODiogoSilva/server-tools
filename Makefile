bindir := bin

# HISAT2 variables
hisat2dir := hisat2
hisat2binar = hisat2 hisat2-align-l hisat2-align-s hisat2-build hisat2-build-l hisat2-build-s hisat2-inspect-l hisat2-inspect hisat2-inspect-s
hisat2bins = $(addprefix $(bindir)/,$(hisat2binar))
hisat2: gitdir := $(hisat2dir)
hisat2: srcbins = $(addprefix $(hisat2dir)/,$(hisat2binar))

# StringTie variables
stringtiedir := stringtie
stringtiebinar = stringtie
stringtiebins = $(addprefix $(bindir)/,$(stringtiebinar))
stringtie: gitdir := $(stringtiedir)
stringtie: srcbins = $(addprefix $(stringtiedir)/,$(stringtiebinar))

# HTSlib variables
htslibdir = htslib
htslibbinar = htsfile tabix
htslibbins = $(addprefix $(bindir)/,$(htslibbinar))
htslib: gitdir:=$(htslibdir)
htslib: srcbins = $(addprefix $(htslibdir)/,$(htslibbinar))

# samtools variables
samtoolsdir = samtools
samtoolsbinar = samtools
samtoolsbins := $(bindir)/samtools
samtools: gitdir:=$(samtoolsdir)
samtools: srcbins = $(samtoolsdir)/$(samtoolsbinar)

# bcftools variables
bcftoolsdir = bcftools
bcftoolsbinar = bcftools
bcftoolsbins := $(bindir)/bcftools
bcftools: gitdir:=$(bcftoolsdir)
bcftools: srcbins = $(bcftoolsdir)/$(bcftoolsbinar)

# vcftools variables
vcftoolsdir = vcftools
vcftoolsbinar = vcftools 
vcftoolsbins = $(bindir)/$(vcftoolsbinar) 
vcftools: gitdir:=$(vcftoolsdir)
vcftools: srcbins = $(vcftoolsdir)/src/cpp/$(vcftoolsbinar)

# bowtie2 variables
bowtie2dir = bowtie2
bowtie2binar = bowtie2 bowtie2-align-l bowtie2-align-s bowtie2-build bowtie2-build-l bowtie2-build-s bowtie2-inspect bowtie2-inspect-l bowtie2-inspect-s
bowtie2bins = $(addprefix $(bindir)/,$(bowtie2binar))
bowtie2: gitdir = $(bowtie2dir)
bowtie2: srcbins = $(addprefix $(bowtie2dir)/,$(bowtie2binar))

.PHONY: hisat2 link push stringtie gitcheck htslib samtools bcftools vcftools bowtie2


# General rule recipies

all: hisat2 stringtie 

link:
	cd $(bindir); ln -f $(addprefix ../,$(bins)) ./

push:
	git add bin/
	git commit -m "Updated $(tool) tool"
	git push

gitcheck:
	# Git submodule updating 
	cd $(gitdir); git clean -fx
	git submodule update $(gitdir)


# Building recipies

# hisat2 build
hisat2: gitcheck $(hisat2bins) 

$(hisat2bins): .git/modules/$(hisat2dir)/HEAD
	cd $(hisat2dir); git reset --hard; git pull
	$(MAKE) -C hisat2 clean; $(MAKE) -C hisat2
	$(MAKE) link bins="$(srcbins)"


# Stringtie build
stringtie: gitcheck $(stringtiebins)

$(stringtiebins): .git/modules/$(stringtiedir)/HEAD
	cd $(stringtiedir); git reset --hard; git pull;
	$(MAKE) -C stringtie clean; $(MAKE) -C stringtie release
	$(MAKE) link bins="$(srcbins)"


# HTSlib build
htslib: gitcheck $(htslibbins)

$(htslibbins): .git/modules/$(htslibdir)/HEAD
	cd $(htslibdir); git reset --hard; git pull;
	$(MAKE) -C htslib clean; $(MAKE) -C htslib
	$(MAKE) link bins="$(srcbins)"


# samtools build
samtools: gitcheck $(samtoolsbins)

$(samtoolsbins): .git/modules/$(samtoolsdir)/HEAD
	$(MAKE) htslib
	cd $(samtoolsdir); git reset --hard; git pull;
	$(MAKE) -C samtools clean; $(MAKE) -C samtools
	$(MAKE) link bins="$(srcbins)"


# BCFtools build
bcftools: gitcheck $(bcftoolsbins)

$(bcftoolsbins): .git/modules/$(bcftoolsdir)/HEAD
	$(MAKE) htslib
	cd $(bcftoolsdir); git reset --hard; git pull;
	$(MAKE) -C bcftools clean; $(MAKE) -C bcftools
	$(MAKE) link bins="$(srcbins)"


# VCFtools build
vcftools: gitcheck $(vcftoolsbins)

$(vcftoolsbins): .git/modules/$(vcftoolsdir)/HEAD
	@cd $(vcftoolsdir); git reset --hard; git pull;
	cd $(vcftoolsdir); ./autogen.sh && ./configure
	$(MAKE) -C vcftools clean; $(MAKE) -C vcftools
	$(MAKE) link bins="$(srcbins)"


# Bowtie2 build
bowtie2: gitcheck $(bowtie2bins)

$(bowtie2bins): .git/modules/$(bowtie2dir)/HEAD
	cd $(bowtie2dir); git reset --hard; git pull;
	$(MAKE) -C bowtie2 clean; $(MAKE) -C bowtie2
	$(MAKE) link bins="$(srcbins)"
