#ifndef ENCRYPTER_H_INCLUDED
#define ENCRYPTER_H_INCLUDED

#include <mlvalues.h>
#include <alloc.h>
#include <memory.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <errno.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <dirent.h>

/* ---- HASH FUNCTIONS ---- */
struct sha256_state {
    unsigned long state[8], length, curlen;
    unsigned char buf[64];
};


union hash_state {
    struct sha256_state sha256;
};



#endif

