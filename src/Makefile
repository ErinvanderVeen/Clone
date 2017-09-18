INCLUDES:=-I $$CLEAN_HOME/lib/Platform -I $$CLEAN_HOME/lib/Generics -I $$CLEAN_HOME/lib/StdLib
FLAGS:=-no-opt-link -l -no-pie -l -static
CLIBS:=-l IPC.o
EXE:=Clone

all: ipc *.icl *.dcl
	clm $(FLAGS) $(INCLUDES) $(CLIBS) $(EXE) -o $(EXE)

ipc: IPC.c
	gcc -c IPC.c -o IPC.o

clean:
	$(RM) -r "Clean System Files" $(EXE) IPC.o
