INCLUDES:=-I $$CLEAN_HOME/lib/Platform -I $$CLEAN_HOME/lib/Generics -I $$CLEAN_HOME/lib/StdLib
EXE:=Clone

all: *.icl *.dcl
	clm $(INCLUDES) $(EXE) -o $(EXE)

clean:
	$(RM) -r "Clean System Files" $(EXE)
