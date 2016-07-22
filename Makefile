ELM=elm

all: elm.js

elm.js: src/Main.elm $(wildcard src/*.elm)
	$(ELM) make --warn --output $@ $^
