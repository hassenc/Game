#include "encrypter.h"


#ifndef uint8
#define uint8  unsigned char
#endif

#ifndef uint32
#define uint32 unsigned long int
#endif

typedef struct
{
    uint32 total[2];
    uint32 state[8];
    uint8 buffer[64];
}
sha256_context;

void sha256_starts( sha256_context *ctx );
void sha256_update( sha256_context *ctx, uint8 *input, uint32 length );
void sha256_finish( sha256_context *ctx, uint8 digest[32] );

#define GET_UINT32(n,b,i)                       \
{                                               \
    (n) = ( (uint32) (b)[(i)    ] << 24 )       \
        | ( (uint32) (b)[(i) + 1] << 16 )       \
        | ( (uint32) (b)[(i) + 2] <<  8 )       \
        | ( (uint32) (b)[(i) + 3]       );      \
}

#define PUT_UINT32(n,b,i)                       \
{                                               \
    (b)[(i)    ] = (uint8) ( (n) >> 24 );       \
    (b)[(i) + 1] = (uint8) ( (n) >> 16 );       \
    (b)[(i) + 2] = (uint8) ( (n) >>  8 );       \
    (b)[(i) + 3] = (uint8) ( (n)       );       \
}

void sha256_starts( sha256_context *ctx )
{
    ctx->total[0] = 0;
    ctx->total[1] = 0;

    ctx->state[0] = 0x6A09E667;
    ctx->state[1] = 0xBB67AE85;
    ctx->state[2] = 0x3C6EF372;
    ctx->state[3] = 0xA54FF53A;
    ctx->state[4] = 0x510E527F;
    ctx->state[5] = 0x9B05688C;
    ctx->state[6] = 0x1F83D9AB;
    ctx->state[7] = 0x5BE0CD19;
}

void sha256_process( sha256_context *ctx, uint8 data[64] )
{
    uint32 temp1, temp2, W[64];
    uint32 A, B, C, D, E, F, G, H;

    GET_UINT32( W[0],  data,  0 );
    GET_UINT32( W[1],  data,  4 );
    GET_UINT32( W[2],  data,  8 );
    GET_UINT32( W[3],  data, 12 );
    GET_UINT32( W[4],  data, 16 );
    GET_UINT32( W[5],  data, 20 );
    GET_UINT32( W[6],  data, 24 );
    GET_UINT32( W[7],  data, 28 );
    GET_UINT32( W[8],  data, 32 );
    GET_UINT32( W[9],  data, 36 );
    GET_UINT32( W[10], data, 40 );
    GET_UINT32( W[11], data, 44 );
    GET_UINT32( W[12], data, 48 );
    GET_UINT32( W[13], data, 52 );
    GET_UINT32( W[14], data, 56 );
    GET_UINT32( W[15], data, 60 );

#define  SHR(x,n) ((x & 0xFFFFFFFF) >> n)
#define ROTR(x,n) (SHR(x,n) | (x << (32 - n)))

#define S0(x) (ROTR(x, 7) ^ ROTR(x,18) ^  SHR(x, 3))
#define S1(x) (ROTR(x,17) ^ ROTR(x,19) ^  SHR(x,10))

#define S2(x) (ROTR(x, 2) ^ ROTR(x,13) ^ ROTR(x,22))
#define S3(x) (ROTR(x, 6) ^ ROTR(x,11) ^ ROTR(x,25))

#define F0(x,y,z) ((x & y) | (z & (x | y)))
#define F1(x,y,z) (z ^ (x & (y ^ z)))

#define R(t)                                    \
(                                               \
    W[t] = S1(W[t -  2]) + W[t -  7] +          \
           S0(W[t - 15]) + W[t - 16]            \
)

#define P2(a,b,c,d,e,f,g,h,x,K)                  \
{                                               \
    temp1 = h + S3(e) + F1(e,f,g) + K + x;      \
    temp2 = S2(a) + F0(a,b,c);                  \
    d += temp1; h = temp1 + temp2;              \
}

    A = ctx->state[0];
    B = ctx->state[1];
    C = ctx->state[2];
    D = ctx->state[3];
    E = ctx->state[4];
    F = ctx->state[5];
    G = ctx->state[6];
    H = ctx->state[7];

    P2( A, B, C, D, E, F, G, H, W[ 0], 0x428A2F98 );
    P2( H, A, B, C, D, E, F, G, W[ 1], 0x71374491 );
    P2( G, H, A, B, C, D, E, F, W[ 2], 0xB5C0FBCF );
    P2( F, G, H, A, B, C, D, E, W[ 3], 0xE9B5DBA5 );
    P2( E, F, G, H, A, B, C, D, W[ 4], 0x3956C25B );
    P2( D, E, F, G, H, A, B, C, W[ 5], 0x59F111F1 );
    P2( C, D, E, F, G, H, A, B, W[ 6], 0x923F82A4 );
    P2( B, C, D, E, F, G, H, A, W[ 7], 0xAB1C5ED5 );
    P2( A, B, C, D, E, F, G, H, W[ 8], 0xD807AA98 );
    P2( H, A, B, C, D, E, F, G, W[ 9], 0x12835B01 );
    P2( G, H, A, B, C, D, E, F, W[10], 0x243185BE );
    P2( F, G, H, A, B, C, D, E, W[11], 0x550C7DC3 );
    P2( E, F, G, H, A, B, C, D, W[12], 0x72BE5D74 );
    P2( D, E, F, G, H, A, B, C, W[13], 0x80DEB1FE );
    P2( C, D, E, F, G, H, A, B, W[14], 0x9BDC06A7 );
    P2( B, C, D, E, F, G, H, A, W[15], 0xC19BF174 );
    P2( A, B, C, D, E, F, G, H, R(16), 0xE49B69C1 );
    P2( H, A, B, C, D, E, F, G, R(17), 0xEFBE4786 );
    P2( G, H, A, B, C, D, E, F, R(18), 0x0FC19DC6 );
    P2( F, G, H, A, B, C, D, E, R(19), 0x240CA1CC );
    P2( E, F, G, H, A, B, C, D, R(20), 0x2DE92C6F );
    P2( D, E, F, G, H, A, B, C, R(21), 0x4A7484AA );
    P2( C, D, E, F, G, H, A, B, R(22), 0x5CB0A9DC );
    P2( B, C, D, E, F, G, H, A, R(23), 0x76F988DA );
    P2( A, B, C, D, E, F, G, H, R(24), 0x983E5152 );
    P2( H, A, B, C, D, E, F, G, R(25), 0xA831C66D );
    P2( G, H, A, B, C, D, E, F, R(26), 0xB00327C8 );
    P2( F, G, H, A, B, C, D, E, R(27), 0xBF597FC7 );
    P2( E, F, G, H, A, B, C, D, R(28), 0xC6E00BF3 );
    P2( D, E, F, G, H, A, B, C, R(29), 0xD5A79147 );
    P2( C, D, E, F, G, H, A, B, R(30), 0x06CA6351 );
    P2( B, C, D, E, F, G, H, A, R(31), 0x14292967 );
    P2( A, B, C, D, E, F, G, H, R(32), 0x27B70A85 );
    P2( H, A, B, C, D, E, F, G, R(33), 0x2E1B2138 );
    P2( G, H, A, B, C, D, E, F, R(34), 0x4D2C6DFC );
    P2( F, G, H, A, B, C, D, E, R(35), 0x53380D13 );
    P2( E, F, G, H, A, B, C, D, R(36), 0x650A7354 );
    P2( D, E, F, G, H, A, B, C, R(37), 0x766A0ABB );
    P2( C, D, E, F, G, H, A, B, R(38), 0x81C2C92E );
    P2( B, C, D, E, F, G, H, A, R(39), 0x92722C85 );
    P2( A, B, C, D, E, F, G, H, R(40), 0xA2BFE8A1 );
    P2( H, A, B, C, D, E, F, G, R(41), 0xA81A664B );
    P2( G, H, A, B, C, D, E, F, R(42), 0xC24B8B70 );
    P2( F, G, H, A, B, C, D, E, R(43), 0xC76C51A3 );
    P2( E, F, G, H, A, B, C, D, R(44), 0xD192E819 );
    P2( D, E, F, G, H, A, B, C, R(45), 0xD6990624 );
    P2( C, D, E, F, G, H, A, B, R(46), 0xF40E3585 );
    P2( B, C, D, E, F, G, H, A, R(47), 0x106AA070 );
    P2( A, B, C, D, E, F, G, H, R(48), 0x19A4C116 );
    P2( H, A, B, C, D, E, F, G, R(49), 0x1E376C08 );
    P2( G, H, A, B, C, D, E, F, R(50), 0x2748774C );
    P2( F, G, H, A, B, C, D, E, R(51), 0x34B0BCB5 );
    P2( E, F, G, H, A, B, C, D, R(52), 0x391C0CB3 );
    P2( D, E, F, G, H, A, B, C, R(53), 0x4ED8AA4A );
    P2( C, D, E, F, G, H, A, B, R(54), 0x5B9CCA4F );
    P2( B, C, D, E, F, G, H, A, R(55), 0x682E6FF3 );
    P2( A, B, C, D, E, F, G, H, R(56), 0x748F82EE );
    P2( H, A, B, C, D, E, F, G, R(57), 0x78A5636F );
    P2( G, H, A, B, C, D, E, F, R(58), 0x84C87814 );
    P2( F, G, H, A, B, C, D, E, R(59), 0x8CC70208 );
    P2( E, F, G, H, A, B, C, D, R(60), 0x90BEFFFA );
    P2( D, E, F, G, H, A, B, C, R(61), 0xA4506CEB );
    P2( C, D, E, F, G, H, A, B, R(62), 0xBEF9A3F7 );
    P2( B, C, D, E, F, G, H, A, R(63), 0xC67178F2 );

    ctx->state[0] += A;
    ctx->state[1] += B;
    ctx->state[2] += C;
    ctx->state[3] += D;
    ctx->state[4] += E;
    ctx->state[5] += F;
    ctx->state[6] += G;
    ctx->state[7] += H;
}

void sha256_update( sha256_context *ctx, uint8 *input, uint32 length )
{
    uint32 left, fill;

    if( ! length ) return;

    left = ctx->total[0] & 0x3F;
    fill = 64 - left;

    ctx->total[0] += length;
    ctx->total[0] &= 0xFFFFFFFF;

    if( ctx->total[0] < length )
        ctx->total[1]++;

    if( left && length >= fill )
    {
        memcpy( (void *) (ctx->buffer + left),
                (void *) input, fill );
        sha256_process( ctx, ctx->buffer );
        length -= fill;
        input  += fill;
        left = 0;
    }

    while( length >= 64 )
    {
        sha256_process( ctx, input );
        length -= 64;
        input  += 64;
    }

    if( length )
    {
        memcpy( (void *) (ctx->buffer + left),
                (void *) input, length );
    }
}

static uint8 sha256_padding[64] =
{
 0x80, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
};

void sha256_finish( sha256_context *ctx, uint8 digest[32] )
{
    uint32 last, padn;
    uint32 high, low;
    uint8 msglen[8];

    high = ( ctx->total[0] >> 29 )
         | ( ctx->total[1] <<  3 );
    low  = ( ctx->total[0] <<  3 );

    PUT_UINT32( high, msglen, 0 );
    PUT_UINT32( low,  msglen, 4 );

    last = ctx->total[0] & 0x3F;
    padn = ( last < 56 ) ? ( 56 - last ) : ( 120 - last );

    sha256_update( ctx, sha256_padding, padn );
    sha256_update( ctx, msglen, 8 );

    PUT_UINT32( ctx->state[0], digest,  0 );
    PUT_UINT32( ctx->state[1], digest,  4 );
    PUT_UINT32( ctx->state[2], digest,  8 );
    PUT_UINT32( ctx->state[3], digest, 12 );
    PUT_UINT32( ctx->state[4], digest, 16 );
    PUT_UINT32( ctx->state[5], digest, 20 );
    PUT_UINT32( ctx->state[6], digest, 24 );
    PUT_UINT32( ctx->state[7], digest, 28 );
}


int get_file_size (char * filename)
{
   	FILE* f = NULL;
	f = fopen(filename,"r");
	if (!f) return -1;
	long long i = 0;
	while(getc(f) != EOF) {
		i++;
	}
	return i;
}

/* This routine reads the entire file into memory. */

static char *
read_whole_file (char * file_name, int appendKey)
{
    char * contents;
    FILE * f;
    int status;

    int s = get_file_size(file_name);
	if (s > 1024) s=1024; // take the 1024 first characters only (we don't want the program to close because of a memory issue)
    contents = (char*)(malloc (sizeof(char)*(s + 32)));
    if (! contents) {
        fprintf (stderr, "Not enough memory.\n");
        exit (EXIT_FAILURE);
    }

    f = fopen (file_name, "r");
    if (! f) {
        fprintf (stderr, "Could not open '%s': %s.\n", file_name,
                 strerror (errno));
        exit (EXIT_FAILURE);
    }
    int bytes_read = fread(contents, sizeof (char), s, f);
    if (bytes_read != s) {
        fprintf (stderr, "Short read of '%s': expected %d bytes "
                 "but got %d: %s.\n", file_name, s, bytes_read,
                 strerror (errno));
        exit (EXIT_FAILURE);
    }
    status = fclose (f);
    if (status != 0) {
        fprintf (stderr, "Error closing '%s': %s.\n", file_name,
                 strerror (errno));
        exit (EXIT_FAILURE);
    }
	if (appendKey != 0) { // append the crypt key
		contents[s+0] = '%';
		contents[s+1] = '0';
		contents[s+2] = 'E';
		contents[s+3] = 'd';
		contents[s+4] = 'A';
		contents[s+5] = '+';
		contents[s+6] = '@';
		contents[s+7] = 'z';
		contents[s+8] = '$';
		contents[s+9] = '8';
		contents[s+10] = '#';
		contents[s+11] = '[';
		contents[s+12] = '/';
		contents[s+13] = '1';
		contents[s+14] = ':';
		contents[s+15] = ' ';
		contents[s+16] = '*';
		contents[s+17] = 'a';
		contents[s+18] = 'b';
		contents[s+19] = 'O';
		contents[s+20] = '}';
		contents[s+21] = '^';
		contents[s+22] = ';';
		contents[s+23] = 'n';
		contents[s+24] = '~';
		contents[s+25] = '-';
		contents[s+26] = '|';
		contents[s+27] = '?';
		contents[s+28] = ' ';
		contents[s+29] = ')';
		contents[s+30] = '4';
		contents[s+31] = '*';
		contents[s+32] = '\0';
	}
	else
		contents[s] = '\0';

    return contents;
}

// function to avoid "\0" characters in a non-still-terminated string.
void reformatKey(char* key)
{
	int i;
	for(i=0; i < 32; i++)
		if (*(key+i) == '\0')
			*(key+i) = ' ';
	key[32] = '\0';
}

char* getFileChecksum(char* filename)
{	
	char* key = malloc(sizeof(char)*33);
	char* content = read_whole_file(filename, 1);
	sha256_context* hs = malloc(sizeof(sha256_context));
	sha256_starts(hs);
	sha256_update(hs, content, strlen(content) );
	sha256_finish(hs, key);
	key[32] = '\0';
	free(hs);
	free(content); // free the memory we took;
	reformatKey(key);
	return key;
}
char* readFileChecksum(char* filename)
{
	return read_whole_file(filename, 0);
}
void writeFileChecksum(char* filename, char* key)
{
	FILE * myfile;
	myfile = fopen(filename,"w");
	if (myfile == NULL) return;
	fputs(key, myfile);
	fclose(myfile);
}
char* getFileCheckFile(char* folder, char* filename)
{
	char* ret = malloc(sizeof(char)*(strlen(folder)+strlen(filename)+13));
	char after[] = "/.integrity.";
	strcpy(ret, folder);
	strcat(ret, (char*)(after));
	strcat(ret, filename);	
	return ret;
}
char* getFilenameWithFolder(char* folder, char* filename)
{
	char* newFile = malloc(sizeof(char)*(strlen(filename) + strlen(folder)+2));
	strcpy(newFile, folder);
	char separator[] = "/";
	strcat(newFile, (char*)(separator));
	strcat(newFile, filename);
	*(newFile + strlen(filename) + strlen(folder)+1) = '\0';
	return newFile;
}

int writeFileIntegrity(char* folder, char* filename)
{
	DIR* rep = NULL;
	char* file = getFilenameWithFolder(folder, filename);
	//printf("Writing %s integrity key...", file);
	rep = opendir(file);

	if (rep==NULL) { // it's a file, not a folder
		char* checkFile = getFileCheckFile(folder, filename);
		char* key = getFileChecksum(file);
		writeFileChecksum(checkFile, key);
		//printf("Calling free(checkFile) in writeFileIntegrity.\n");
		free(checkFile);
		//printf("Calling free(key) in writeFileIntegrity.\n");
		free(key);
		//printf("Written.\n", file);
	}
	//else
		//printf("An error has occured.\n", file);

	//printf("Calling free(file) in writeFileIntegrity.\n");
	free(file);
	return 1;
}

int writeFolderIntegrity(char* folder)
{
	DIR* rep = NULL;
	rep = opendir(folder);
	if (rep==NULL) return 0; // it's a file, not a folder, return 0

	struct dirent *lecture;
	while ((lecture = readdir(rep)))
   	{
		char* newFolder = getFilenameWithFolder(folder, lecture->d_name);
		DIR* testDir = NULL;
		testDir = opendir(newFolder);

		if (lecture->d_name[0] != '.' && testDir == NULL) { // it's not a folder or a check file
			char* checkFile = getFileCheckFile(folder, lecture->d_name);
			char* key = getFileChecksum(newFolder);
			writeFileChecksum(checkFile, key);
			//printf("Writing %s integrity key.\n", newFolder);
			free(key);
			free(checkFile);
      	}
		free(newFolder);
   	}
   	closedir(rep);
	return 1;
}

int checkFileIntegrity(char* folder, char* filename)
{
    DIR* rep = NULL;
	char* file = getFilenameWithFolder(folder, filename);
	rep = opendir(file);

	if (rep==NULL) { // it's a file, not a folder
		char* checkFile = getFileCheckFile(folder, filename);
		char* key = getFileChecksum(file);
		char* readKey = readFileChecksum(checkFile);

	
		if (strcmp(key, readKey) != 0) {
			//printf("The file \"%s\" is corrupted. \n", file);
			//printf("Keys are : \nCalculated: \"%s\"\nRead:       \"%s\"\n", key, readKey);
			return -1;
		}
		//else
			//printf("The file \"%s\" is correct.\n", file);
	
		free(checkFile);
		free(key);
		free(readKey);
	}
	free(file);
	return 1;
}

int checkFolderIntegrity(char* folder)
{
    DIR* rep = NULL;
	rep = opendir(folder);
	if (rep==NULL) return 0; // it's a file, not a folder, return 0

	struct dirent *lecture;
	while ((lecture = readdir(rep)))
   	{
		char* newFolder = getFilenameWithFolder(folder, lecture->d_name);
		DIR* testDir = NULL;
		testDir = opendir(newFolder);

		if (lecture->d_name[0] != '.' && testDir == NULL) { // it's not a folder or a check file
			char* checkFile = getFileCheckFile(folder, lecture->d_name);
			char* key = getFileChecksum(newFolder);
			char* readKey = readFileChecksum(checkFile);
			if (strcmp(key, readKey) != 0) {
				//printf("The file \"%s\" is corrupted. \n", newFolder);
				return -1;
			}
			//else
				//printf("The file \"%s\" is correct.\n", newFolder);
			free(checkFile);
			free(key);
			free(readKey);
      	}
		free(newFolder);
   	}
   	closedir(rep);
	return 1;
}

value writeMediaIntegrity()
{
	//printf("Writing integrity check files.\n");

   	writeFolderIntegrity("media/maps");
   	writeFolderIntegrity("media/creatures/references");
   	writeFolderIntegrity("media/story");
   	writeFolderIntegrity("media/objects");

	//printf("Integrity check files have been written.\n\n");
	return 0;
}
value writeSaveIntegrity()
{
	//printf("Writing save files integrity check files.\n");

   	writeFolderIntegrity("saves/main");

	//printf("Integrity save files check files have been written.\n\n");
	return 0;
}
value checkSaveIntegrity()
{

	printf("Cheking save files integrity.\n");

   	int a = checkFolderIntegrity("saves/main");

	if (a==1) {
		printf("The saves has no corrupted file.\n\n");
		return Val_int(1);
	}
	printf("Installation seems to be corrupted.\n\n");
	return Val_int(0);
}

value checkMediaIntegrity()
{

	printf("Cheking media folder integrity.\n");

   	int a = checkFolderIntegrity("media/maps");
   	int b = checkFolderIntegrity("media/creatures/references");
   	int c = checkFolderIntegrity("media/story");
   	int d = checkFolderIntegrity("media/objects");

	if (a==1 && b==1 && c==1 && d==1) {
		printf("The installation has no corrupted file.\n\n");
		return Val_int(1);
	}
	printf("Installation seems to be corrupted.\n\n");
	return Val_int(0);
}

char* strmid(char* text, int beginning, int end)
{
	char* res = malloc(sizeof(char)*(end-beginning+1));
	int i;	
	for (i=beginning; i<end; i++) {
		res[i-beginning] = text[i];	
	}
	res[end-beginning] = '\0';
	return res;
}

value checkFileIntegrityCAML(filenameCAML)
{
	char* folder = malloc(sizeof(char)*256);
	char* filename = malloc(sizeof(char)*256);

	strcpy(folder, String_val(filenameCAML));
	int slash = '/';
	int pos = (int)(strrchr(folder, slash)) - (int)(folder);
	char prefix[] = ".integrity.";
	char* file = strmid(folder, (int)(pos)+1, strlen(folder));
	strcpy(filename, folder);
	*(filename+(int)(pos)) = '\0'; // terminates the string after the folder name
	strcpy(folder, filename);
	*(filename) = '\0';
	//strcpy(filename, (char*)(prefix));
	strcat(filename, file);
	
	//printf("Checking \"%s/%s\" file.\n", folder, filename);
	int result = checkFileIntegrity(folder, filename);
	free(folder);
	free(filename);
	free(file);
	return Val_int(result);
}

value writeFileIntegrityCAML(filenameCAML)
{
	char* folder = malloc(sizeof(char)*256);
	char* filename = malloc(sizeof(char)*256);

	strcpy(folder, String_val(filenameCAML));
	int slash = '/';
	int pos = (int)(strrchr(folder, slash)) - (int)(folder);
	char prefix[] = ".integrity.";
	char* file = strmid(folder, (int)(pos)+1, strlen(folder));
	strcpy(filename, folder);
	*(filename+(int)(pos)) = '\0'; // terminates the string after the folder name
	strcpy(folder, filename);
	*(filename) = '\0';
	//strcpy(filename, (char*)(prefix));
	strcat(filename, file);
	
	//printf("Calling writeFileIntegrity with parameters folder=\"%s\" and filename=\"%s\".\n", folder, filename);
	int result = writeFileIntegrity(folder, filename);
	//printf("Calling free(folder) in writeFileIntegrityCAML.\n");
	free(folder);
	//printf("Calling free(filename) in writeFileIntegrityCAML.\n");
	free(filename);
	//printf("Calling free(file) in writeFileIntegrityCAML.\n");
	free(file);
	//printf("Failure of free(file) in writeFileIntegrityCAML.\n");
	return Val_unit;
}









