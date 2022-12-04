#include "io.h"

int VERBOSE = 0;

static void
vfprintf_or_die(FILE *const fp, char const *const fmt, va_list ap)
{
	if (vfprintf(fp, fmt, ap) < 0) {
		if (fp != stderr) {
			fprintf(stderr, "fprintf(%d): ", fileno(fp));
		}
		perror(NULL);
		exit(4);
	}
}

void
LOG(char const *const fmt, ...)
{
	if (VERBOSE == 0) {
		return;
	}
	va_list ap;
	va_start(ap, fmt);
	vfprintf_or_die(stderr, fmt, ap);
	va_end(ap);
}

void
output_or_die(FILE *const fp, char const *const fmt, ...)
{
	va_list ap;
	va_start(ap, fmt);
	vfprintf_or_die(fp, fmt, ap);
	va_end(ap);
}

int
read_file(unsigned long long *const buflen_out, char * *const buf, char const *const fn)
{
	int const fd = open(fn, O_RDONLY);
	if (fd < 0) {
		fprintf(stderr, "open(%s): ", fn);
		perror(NULL);
		return 3;
	}
	struct stat st;
	if (fstat(fd, &st) < 0) {
		fprintf(stderr, "stat(%s): ", fn);
		perror(NULL);
		return 4;
	}

	unsigned long long const buflen = st.st_size;
	// Leave room for a terminating null byte.
	*buf = malloc(buflen + 1);
	int const status = read(fd, *buf, st.st_size);
	if (status < 0) {
		fprintf(stderr, "read(%s, %llu): ", fn, buflen);
		perror(NULL);
		return 4;
	}
	if (status < st.st_size) {
		fprintf(stderr,
			"read(%s, %llu): but only read %llu\n",
			fn,
			buflen,
			(unsigned long long)status);
		return 4;
	}

	(*buf)[buflen] = 0;

	LOG("read %llu bytes from %s:\n%s\n", buflen, fn, *buf);

	*buflen_out = buflen;
	return 0;
}

// Local variables:
// eval: (c-set-style "linux")
// End:
