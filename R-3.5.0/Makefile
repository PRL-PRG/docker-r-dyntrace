include ../Makefile.in

# additional options passed to configure script
CONFIGURE_OPTS := ""

LOCAL_R_HOME := $(CURDIR)/R

R:
	curl https://cloud.r-project.org/src/base/R-3/R-3.5.0.tar.gz | tar -xzf -
	mv R-3.5.0 R

compile: R
	@$(MAKE) exec \
		COMMAND="sh -c 'cd /R && ./configure $(CONFIGURE_OPTS) && make -j8'"
