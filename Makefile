IMAGE := prlprg/r-dyntrace
USERID := $(shell id -u)
GROUPID := $(shell id -g)
USER := $(shell id -un)

.PHONY: image compile exec shell

image:
	docker build --rm -t $(IMAGE) .

compile:
	[ -d R-dyntrace ] || git clone https://github.com/PRL-PRG/R-dyntrace.git
	$(MAKE) exec COMMAND="sh -c 'cd /R-dyntrace && ./build && make install'"

exec:
	[ -f .zhistory ] || touch .zhistory
	docker run \
         --rm \
         -ti \
         -v r-cran-mirror:/CRAN/src \
         -v r-packages:/R/installed \
         -v r-src-packages:/R/sources \
         -v $$(pwd)/promisedyntracer:/promisedyntracer \
         -v $$(pwd)/promise-dyntracing-experiment:/promise-dyntracing-experiment \
         -v $$(pwd)/promise-interference:/promise-interference \
         -v $$(pwd)/R-dyntrace:/R-dyntrace \
         -v $$(pwd)/.zhistory:$(HOME)/.zhistory \
         -v $(HOME)/.zpreztorc:$(HOME)/.zpreztorc:ro \
         -v $(HOME)/.zprezto:$(HOME)/.zprezto:ro \
         -v $(HOME)/.zprofile:$(HOME)/.zprofile:ro \
         -v $(HOME)/.zshenv:$(HOME)/.zshenv:ro \
         -v $(HOME)/.zshrc:$(HOME)/.zshrc:ro \
         -e R_LIBS=/R/installed \
         -e R_DYNTRACE_HOME=/R-dyntrace \
         -e USER=$(USER) \
         -e GROUP=$(shell id -gn) \
         -e USERID=$(USERID) \
         -e GROUPID=$(GROUPID) \
         -e ROOT="TRUE" \
		 -e TERM=$(TERM) \
		 -e LANGUAGE=$(LANGUAGE) \
		 -e LANG=$(LANG) \
		 -e LC_ALL=$(LC_ALL) \
         prlprg/r-dyntrace \
		 $(COMMAND)

shell:
	$(MAKE) exec COMMAND=zsh
