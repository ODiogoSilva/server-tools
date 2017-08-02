bindir := bin
updatestr = "Your branch is up-to-date"

# HISAT2 variables
hisat2dir := hisat2
hisat2bins := $(hisat2dir)/hisat2 $(wildcard $(hisat2dir)/hisat2-*)

# StringTie variables
stringtiedir := stringtie
stringtiebins := $(stringtiedir)/stringtie

hisat2b:
	# Run shell that checks the status of remote repo
	@update="$(shell cd $(hisat2dir) && git fetch && git status -uno | grep $(updatestr))"
	# If the status contains the updatestr string, do nothing
	@if [ -z $(update) ]; then\
		echo $@ is already up-to-date;\
	# There are modifications upstream, so build it
	else\
		cd $(hisat2dir); git reset --hard; git pull;\
		$(MAKE) -C hisat2 clean; $(MAKE) -C hisat2;\
		cd $(bindir); ln -f $(addprefix ../,$(hisat2bins)) ./;\
	fi

stringtieb:
	echo "Automatic build for StringTie"
	cd $(stringtiedir); git reset --hard; git pull;
	$(MAKE) -C stringtie clean; $(MAKE) -C stringtie release
	mv $(stringtiebins) $(bindir)

push:
	git add bin/
	git commit -m "Updated $(tool) tool"
	git push

	
	

