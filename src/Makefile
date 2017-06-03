INCLUDES = -I $$CLEAN_HOME/lib/Platform -I $$CLEAN_HOME/lib/Generics -I $$CLEAN_HOME/lib/StdLib

all: *.icl *.dcl waitMinute.c
	gcc -c waitMinute.c -o waitMinute.o
	clm $(INCLUDES) -l waitMinute.o Clone -o Clone

clean:
	rm -rf "Clean System Files"
	rm waitMinute.o Clone
