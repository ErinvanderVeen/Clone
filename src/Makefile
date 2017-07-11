INCLUDES:=-I $$CLEAN_HOME/lib/Platform -I $$CLEAN_HOME/lib/Generics -I $$CLEAN_HOME/lib/StdLib
CLIBS:=-l IPC.o
EXE:=Clone

all: ipc *.icl *.dcl
	clm $(INCLUDES) $(CLIBS) $(EXE) -o $(EXE)

ipc: IPC.c
	gcc -c IPC.c -o IPC.o

clean:
	$(RM) -r "Clean System Files" $(EXE)
