{.pragma: pfi, pure, final, importc, header: "../include/mdbm.h".}
{.pragma: dynf, cdecl, importc, dynlib: "./libmdbm.so"}

type
  datum* {.pfi.} = object
    dptr*: cstring
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
  let s = d.dptr
  d.dptr[0..sz-1]

proc `$`(kv: kvpair):string =
  "K: " & $kv.key & " V: " & $kv.val

proc `+!!`(p: pointer, size: int): pointer {.inline.} =
  result = cast[pointer](cast[int](p) + size)


proc mdbm_open(fname: cstring, flags: cint,
               mode: cint, psize: cint, presize: cint): dbptr {.dynf.}

proc mdbm_firstkey(db: dbptr): datum {.dynf.}
proc mdbm_next(db: dbptr): kvpair {.dynf.}
proc mdbm_lock(db: dbptr): void {.dynf.}
proc mdbm_unlock(db: dbptr): void {.dynf.}
# use 1
proc mdbm_store(db: dbptr, key: datum, val: datum, flag: cint): cint {.dynf.}
proc mdbm_store_str(db: dbptr, key: cstring, val: cstring, flag: cint): cint {.dynf.}


proc get_next(db: dbptr): kvpair =
  let a1 = mdbm_next(db)
  #echo "K: ", a1.key, " V: ", a1.val,
  #     " S: ", a1.key.dsize
  return a1

proc main() =
  var sz: cint = 10
  let buff = alloc(sz)
  var a = datum(dptr: cast[cstring](buff), dsize: sz)
  a.dptr= "abcd"

  echo cast[cstring](a.dptr)

  let db = mdbm_open("./t.mdbm", 0x42, 0o666,0,0)
  let fk = mdbm_firstkey(db)
  #echo "FK: ", fk.dptr, " S: ", fk.dsize, " L: ", len(fk.dptr)
  for i in 1..10000000-2:
    discard get_next db
  echo get_next db


main()
