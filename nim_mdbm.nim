{.pragma: pfi, pure, final, importc, header: "../include/mdbm.h".}

type
  datum* {.pfi.} = object
    dptr*: cstring
    dsize*: cint

  kvpair* {.pure, final, importc,
           header: "../include/mdbm.h".} = object
    key: datum
    val: datum

  MDBM* {.pfi, nodecl.} = object
  
  dbptr = ptr MDBM

proc mdbm_open(fname: cstring, flags: cint,
               mode: cint, psize: cint, presize: cint): dbptr
  {.cdecl, importc, dynlib: "./libmdbm.so".}

  
proc main() =
  var sz: cint = 10
  var a = datum(dptr: cast[cstring](alloc(sz)), dsize: sz)
  a.dptr = "asdf"
  echo a.dptr
  discard mdbm_open("./tnim.mdbm",0x42, 0o666,0,0);

main()
