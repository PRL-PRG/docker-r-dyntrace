include ../Makefile.in

R:
	git clone https://github.com/PRL-PRG/R-dyntrace.git R

compile: R
	$(MAKE) exec \
		COMMAND="sh -c 'cd /R && ./build'"
