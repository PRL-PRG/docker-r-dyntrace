include ../Makefile.in

DOCKER_RUN_ARGS := -e R_DYNTRACE_HOME=/R

LOCAL_R_HOME := $(CURDIR)/R

R:
	git clone https://github.com/PRL-PRG/R-dyntrace.git R

compile: R
	$(MAKE) exec \
		COMMAND="sh -c 'cd /R && ./build'"
