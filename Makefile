R_VERSION := 3.6.2

# name of the image to build
IMAGE := prlprg/r

# user/group control in the image
USERID := $(shell id -u)
GROUPID := $(shell id -g)
USER := $(shell id -un)
GROUP := $(shell id -gn)

# CRAN mirror to use e.g. cloud.r-project.org
CRAN_MIRROR := mirrors.nic.cz
# CRAN repository to use e.g. https://cloud.r-project.org
CRAN_REPO := file:///CRAN
# packages to install as R string vector
CRAN_PACKAGES := available.packages()[,1]
# path where to install CRAN packages (i.e. lib.loc argument to install.packages)
CRAN_LIB := /CRAN-library
# path where to store CRAN packages source
# for it to work as a mirror it has to end on 'src'
CRAN_SRC := /CRAN/src
CRAN_SRC_EXTRACTED := /CRAN/src-extracted

# INSTALL_opts argument to install.packages
INSTALL_OPTS := c('--example', '--install-tests', '--with-keep.source', '--no-multiarch')
# Ncpus argument to install.packages
NCPUS := parallel::detectCores()

VOL_CRAN_LIB := 'r-packages-$(R_VERSION):$(CRAN_LIB)'
VOL_CRAN_MIRROR := 'r-cran-mirror:/CRAN'

# the directory where to put scripts
SCRIPTS_DIR := bin
# each of the scripts is basically the corresponding makefile task
SCRIPTS := $(SCRIPTS_DIR)/r.sh $(SCRIPTS_DIR)/rscript.sh $(SCRIPTS_DIR)/bash.sh $(SCRIPTS_DIR)/zsh.sh

DOCKER_RUN_ARGS :=

# while it looks like a variable it is not, please do not change
R_HOME := /R

.PHONY: bash bioc bioc-sources compile cran cran-mirror cran-sources exec image scripts r rscript backup restore zsh

image:
  # generate the entryfile.sh based on the parameters here
	docker build --rm -t $(IMAGE) .

# download all CRAN packages using rsync
# they will be placed into a volume $(VOL_CRAN_MIRROR)
cran-mirror:
	@$(MAKE) exec \
		COMMAND=" \
          rsync \
           -rtlzv \
           --delete \
           --include='*.tar.gz' \
           --include='PACKAGES*' \
           --exclude='*/*' \
           '$(CRAN_MIRROR)::CRAN/src/contrib' $(CRAN_SRC) \
        "

# install all downloaded CRAN packages
cran-install-packages:
	@$(MAKE) rscript \
		SCRIPT=" \
          options(repos='$(CRAN_REPO)'); \
          install.packages($(CRAN_PACKAGES), \
            lib='$(CRAN_LIB)', \
            dependencies=TRUE, \
            destdir='$(CRAN_SRC)', \
            INSTALL_opts=$(INSTALL_OPTS), \
            Ncpus=$(NCPUS) \
          )"

# extract all downloaded packages
cran-extract-packages:
	@$(MAKE) rscript \
		SCRIPT=" \
          x <- installed.packages('$(CRAN_LIB)'); \
          paths <- file.path('$(CRAN_SRC)/contrib', paste0(x[,1], '_', x[,3], '.tar.gz')); \
          dir.create('$(CRAN_SRC_EXTRACTED)'); \
          writeLines(paths[file.exists(paths)], '$(CRAN_SRC_EXTRACTED)/archives.txt') \
        "
	@$(MAKE) exec \
		COMMAND=" \
          parallel --workdir $(CRAN_SRC_EXTRACTED) --bar -a $(CRAN_SRC_EXTRACTED)/archives.txt tar xzf '{}'; \
          rm -f $(CRAN_SRC_EXTRACTED)/archives.txt \
        "

exec:
	docker run \
         --rm \
         -ti \
         -v $(VOL_CRAN_LIB) \
         -v $(VOL_CRAN_MIRROR) \
         -e R_LIBS=$(CRAN_LIB) \
         -e R_HOME=/R \
         -e USER=$(USER) \
         -e GROUP=$(GROUP) \
         -e USERID=$(USERID) \
         -e GROUPID=$(GROUPID) \
         -e ROOT="TRUE" \
         -e TERM="xterm-256color" \
         -e LANGUAGE=$(LANGUAGE) \
         -e LANG=$(LANG) \
         -e LC_ALL=$(LC_ALL) \
         $(DOCKER_RUN_ARGS) \
         $(IMAGE) \
         $(COMMAND)

zsh:
	[ -f .zhistory ] || touch .zhistory
	@$(MAKE) exec COMMAND="zsh $(ARGS)" DOCKER_RUN_ARGS=" \
         -v $$(pwd)/.zhistory:$(HOME)/.zhistory \
         -v $(HOME)/.zpreztorc:$(HOME)/.zpreztorc:ro \
         -v $(HOME)/.zprezto:$(HOME)/.zprezto:ro \
         -v $(HOME)/.zprofile:$(HOME)/.zprofile:ro \
         -v $(HOME)/.zshenv:$(HOME)/.zshenv:ro \
         -v $(HOME)/.zshrc:$(HOME)/.zshrc:ro \
    "

bash:
	@$(MAKE) exec COMMAND="bash $(ARGS)"

fish:
	@$(MAKE) exec COMMAND="fish $(ARGS)"

r:
	@$(MAKE) exec COMMAND="$(R_HOME)/bin/R $(ARGS)"

rscript:
    ifneq ("$(ARGS)", "")
		@$(MAKE) exec COMMAND="$(R_HOME)/bin/Rscript $(ARGS)"
    else
		@$(MAKE) exec COMMAND="$(R_HOME)/bin/Rscript -e \"$(SCRIPT)\""
    endif

# the directory where to put scripts
SCRIPTS_DIR := bin
# each of the scripts is basically the corresponding makefile task
SCRIPTS := $(SCRIPTS_DIR)/r.sh $(SCRIPTS_DIR)/rscript.sh $(SCRIPTS_DIR)/bash.sh $(SCRIPTS_DIR)/zsh.sh

$(SCRIPTS_DIR):
	mkdir $(SCRIPTS_DIR)

$(SCRIPTS_DIR)/%.sh: $(SCRIPTS_DIR)
	echo -e "#!/bin/sh\n" > $@
# this is stupid, but I did not find a way how to escape $@ passed into a make task
	make -sn $(shell basename $(@:.sh=)) ARGS='\"~@\"' | sed -n '/docker run/,$$p' >> $@
	sed -i 's/~@/$$@/' $@
	chmod +x $@

scripts: $(SCRIPTS)
