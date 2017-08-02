bindir := bin
updatestr = "Your branch is up-to-date"

GITSTATUS=$(shell cd $(gitdir) && git fetch && git status -uno | grep $(updatestr))

# HISAT2 variables
hisat2dir := hisat2
hisat2bins := $(hisat2dir)/hisat2 $(wildcard $(hisat2dir)/hisat2-*)

# StringTie variables
stringtiedir := stringtie
stringtiebins := $(stringtiedir)/stringtie

gitstatus: $(gitdir)
	if [ -z "$(GITSTATUS)" ]; then\
		touch $(gitdir)/.DEWIT;\
	fi

checkstatus:
	$(MAKE) gitstatus gitdir=$(gitdir)

hisat2b: checkstatus $(hisat2dir)/.DEWIT
	cd $(hisat2dir); git reset --hard; git pull
	$(MAKE) -C hisat2 clean; $(MAKE) -C hisat2
	cd $(bindir); ln -f $(addprefix ../,$(hisat2bins)) ./

stringtieb: checkstatus $(stringtiedir)/.DEWIT
	echo "Automatic build for StringTie"
	cd $(stringtiedir); git reset --hard; git pull;
	$(MAKE) -C stringtie clean; $(MAKE) -C stringtie release
	cd $(bindir); ln -f $
	$(MAKE) link bins=$(stringtiebins)

link:
	cd $(bindir); ln -f $(addprefix ../,$(bins))

push:
	git add bin/
	git commit -m "Updated $(tool) tool"
	git push

.PHONY: hisat2b gitstatus link push stringtieb

