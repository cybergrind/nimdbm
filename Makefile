

clt:
	clang -std=c99 test.c -I include -L `pwd` -lmdbm -v -lstdc++

run:
	LD_LIBRARY_PATH=$LD_LIBRARY_PATH:`pwd` ./a.out

nimbuild:
	nimrod --parallelBuild:1 -l:-lmdbm -l:-L`pwd` -l:-lstdc++ c nim_mdbm.nim

nimrun:
	LD_LIBRARY_PATH=$LD_LIBRARY_PATH:`pwd` ./nim_mdbm
