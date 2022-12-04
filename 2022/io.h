int VERBOSE;

void
LOG(char const *const fmt, ...);

void
output_or_die(FILE *const fp, char const *const fmt, ...);

// Doesn't bother to free, spews to stderr on error or if VERBOSE.
// Returns 0 on success.
int
read_file(unsigned long long *const buflen, char * *const buf, char const *const fn);
