#import system/sysio
import strutils



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
  return a1

proc main_test_get() =
  var sz: cint = 10
  let buff = alloc(sz)
  var a = datum(dptr: cast[cstring](buff), dsize: sz)
  a.dptr= "abcd"

  echo cast[cstring](a.dptr)

  let db = mdbm_open("./t.mdbm", 0x42, 0o666,0,0)
  let fk = mdbm_firstkey(db)
  echo fk
  for i in 1..10000000-2:
    discard get_next db
  echo get_next db

proc fgets(c: cstring, n: cint, f: TFile): cstring {.
  importc: "fgets", header: "<stdio.h>", tags: [FReadIO].}

proc strchr(c: cstring, s: cchar): cstring {.
  importc: "strchr", header: "<string.h>".}

proc `-`(a: cstring, b:cstring): cint =
  cast[cint](a) - cast[cint](b)

proc `+!!`(a: cstring, b:int): cstring =
  cast[cstring](cast[int](a) + b)

proc main() =
  # buffered
  let db = mdbm_open("./tnim.mdbm", 0x42, 0o666,0,0)
  let buff_size = cint 2048
  var buff = cast[cstring](alloc(buff_size))
  var n = 0
  mdbm_lock(db)
  while fgets(buff, buffsize, stdin) != nil :
    let
      length = len(buff) - 1
      s = strchr(buff, ':')
      k = datum(dptr: buff, dsize: s-buff )
      v = datum(dptr: s +!! 1, dsize: cast[cint](length - 1 - k.dsize))
    discard mdbm_store(db, k, v, 0)
    n += 1
  echo n
  mdbm_unlock(db)

main()
