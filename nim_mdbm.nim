{.pragma: pfi, pure, final, importc, header: "../include/mdbm.h".}
{.pragma: dynf, cdecl, importc, dynlib: "./libmdbm.so"}

type
  datum* {.pfi.} = object
    dptr*: ptr cchar
    dsize*: cint

  kvpair* {.pfi.} = object
    key: datum
    val: datum

  MDBM* {.pfi, nodecl.} = object

  dbptr = ptr MDBM

proc `[]`(s: cstring, i: TSlice[int]): string =
  result = ""
  for n in i.a..i.b:
    result &= $s[n]
  return result

proc `$`(d: datum):string =
  let sz: int = d.dsize
  let s = cast[cstring](d.dptr)
  d.dptr[0..sz-1]

proc `+!!`(p: pointer, size: int): pointer {.inline.} =
  result = cast[pointer](cast[int](p) + size)


proc mdbm_open(fname: cstring, flags: cint,
               mode: cint, psize: cint, presize: cint): dbptr {.dynf.}

proc mdbm_firstkey(db: dbptr): datum {.dynf.}
proc mdbm_next(db: dbptr): kvpair {.dynf.}

proc get_next(db: dbptr): void =
  let a1 = mdbm_next(db)
  echo "K: ", a1.key, " V: ", a1.val,
       " S: ", a1.key.dsize

proc main() =
  var sz: cint = 10
  let buff = alloc(sz)
  var a = datum(dptr: cast[ptr cchar](buff), dsize: sz)
  a.dptr[] = 'b'
  cast[ptr cchar](a.dptr +!! 1)[] = 'a'

  echo cast[cstring](a.dptr)

  let db = mdbm_open("./t.mdbm", 0x42, 0o666,0,0)
  let fk = mdbm_firstkey(db)
  #echo "FK: ", fk.dptr, " S: ", fk.dsize, " L: ", len(fk.dptr)
  for i in 1..3:
    echo i
    get_next db



main()
