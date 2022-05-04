CLANG = clang
CPPFLAGS=-O2

EXECABLE = ising

LIBRARY_PATH = -L/usr/lib64
LIBS = 

LOADINCLUDE += 
.PHONY: clean $(CLANG) ising build

clean:
	rm -f *.o *.so $(EXECABLE)

$(EXECABLE): build
	g++ -std=c++11 $(CPPFLAGS) $(MACRO) $(LOADINCLUDE) $(LIBRARY_PATH) $(LIBS) \
        ising.cpp -lm -o $(EXECABLE)

.DEFAULT_GOAL := $(EXECABLE)
