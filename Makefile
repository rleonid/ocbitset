.PHONY: all clean build

PACKAGES="ctypes,ctypes.foreign,ctypes.stubs"
default: build

libcbitset_stubs:
	ocamlbuild -use-ocamlfind -package ${PACKAGES} -I src/lib src/lib/libcbitset_stubs.a

dllcbitset_stubs:
	ocamlbuild -use-ocamlfind -package ${PACKAGES} -I src/lib src/lib/dllcbitset_stubs.so

build: libcbitset_stubs dllcbitset_stubs
	ocamlbuild -use-ocamlfind -package ${PACKAGES} -I src/lib ocbitset.cma ocbitset.cmxa ocbitset.cmxs

install:
	ocamlfind install ocbitset META \
		_build/src/lib/cbitset_bindings.cmx \
		_build/src/lib/cbitset_generated.cmx \
		_build/src/lib/ocbitset.a \
		_build/src/lib/ocbitset.o \
		_build/src/lib/ocbitset.cmi \
		_build/src/lib/ocbitset.cma \
		_build/src/lib/ocbitset.cmx \
		_build/src/lib/ocbitset.cmxa \
		_build/src/lib/ocbitset.cmxs \
		_build/src/lib/ocbitset.mli \
		_build/src/lib/ocbitset.annot \
		_build/src/lib/libcbitset_stubs.a \
		_build/src/lib/dllcbitset_stubs.so \
		-optional _build/src/lib/ocbitset.cmti \
		_build/src/lib/ocbitset.cmt

test.byte: libcbitset_stubs
	ocamlbuild -use-ocamlfind -package ${PACKAGES} -I src/lib -I src/app test.byte

test.native: libcbitset_stubs
	ocamlbuild -use-ocamlfind -package ${PACKAGES} -I src/lib -I src/app test.native

all: build test.byte test.native

clean:
	ocamlbuild -clean
