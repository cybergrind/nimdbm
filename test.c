#include <string.h>
#include <stdlib.h>
#include <sys/fcntl.h>
#include "mdbm.h"

int main(int argc, char **argv)
{
  MDBM* db;

  char buf[2048];
  int ndups;

  db = mdbm_open("./t.mdbm",MDBM_O_RDWR|MDBM_O_CREAT,0666,0,0);
  if (!db) {
    perror("Unable to create database");
    exit(2);
  }
  ndups = 0;
  mdbm_lock(db);
  while (fgets(buf,sizeof(buf),stdin)) {
    int len = strlen(buf);
    char* s;
    if (buf[len-1] == '\n') {
      buf[--len] = 0;
    }
    s = strchr(buf,':');
    if (s) {
      datum key, val;
      int ret;
      key.dptr = buf;
      key.dsize = s-buf;
      val.dptr = s+1;
      val.dsize = len-key.dsize-1;

      ret = mdbm_store(db,key,val,MDBM_INSERT);

      if (ret == 1) {
        ndups++;
      } else if (ret == -1) {
        perror("Database store failed");
      }
    }
  }
  mdbm_unlock(db);
  mdbm_sync(db);      /* optional flush to disk */
  mdbm_close(db);
  return 0;
}
