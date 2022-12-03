
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

static int VERBOSE = 0;

static void
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

static void
output_or_die(FILE *const fp, char const *const fmt, ...)
{
	va_list ap;
	va_start(ap, fmt);
	vfprintf_or_die(fp, fmt, ap);
	va_end(ap);
}

static void
usage(FILE *const fp)
{
	output_or_die(fp, "elftool INPUTFILE\n");
}

int
main(int argc, char **argv)
{
	argc--; argv++;

	if (argc < 1) {
		usage(stderr);
		return 2;
	}

	if (strcmp(argv[0], "-v") == 0) {
		argc--; argv++;
		VERBOSE++;
	}

	if (argc != 1) {
		usage(stderr);
		return 2;
	}

	int const fd = open(argv[0], O_RDONLY);
	if (fd < 0) {
		fprintf(stderr, "open(%s): ", argv[0]);
		perror(NULL);
		return 3;
	}
	struct stat st;
	if (fstat(fd, &st) < 0) {
		fprintf(stderr, "stat(%s): ", argv[0]);
		perror(NULL);
		return 4;
	}

	unsigned long long const buflen = st.st_size;
	// Leave room for a terminating null byte.
	char *buf = malloc(buflen + 1);
	int const status = read(fd, buf, st.st_size);
	if (status < 0) {
		fprintf(stderr, "read(%s, %llu): ", argv[0], buflen);
		perror(NULL);
		return 4;
	}
	if (status < st.st_size) {
		fprintf(stderr,
			"read(%s, %llu): but only read %llu\n",
			argv[0],
			buflen,
			(unsigned long long)status);
		return 4;
	}

	if (buf[buflen - 1] != '\n') {
		fprintf(stderr, "malformed input:  final byte is %d not LF\n", buf[buflen - 1]);
		return 5;
	}

	if (*buf == '\n') {
		fprintf(stderr, "malformed input:  first byte is LF\n");
		return 5;
	}

	buf[buflen] = 0;

	LOG("read %llu bytes from %s:\n%s\n", buflen, argv[0], buf);

	unsigned long long top_three[3] = { 0 };
	int n_elves = 0;
	int n_stuff = 0;
	for (char *p = buf; *p != 0;) {
		char *const lf = strchr(p, '\n');
		*lf = 0;
		errno = 0;
		long long const ll = strtoll(p, NULL, 10);
		if (errno != 0) {
			fprintf(stderr, "'%s' not integer: ");
			perror(NULL);
			return 5;
		}
		LOG("%llu\n", ll);
		n_stuff += ll;
		if (lf[1] == '\n' || lf[1] == 0) {
			LOG("ELF %d CARRIES %llu\n", n_elves, n_stuff);
			n_elves++;
			if (n_stuff > top_three[0]) {
				top_three[2] = top_three[1];
				top_three[1] = top_three[0];
				top_three[0] = n_stuff;
			}
			n_stuff = 0;
			p = lf + 2;
		} else {
			p = lf + 1;
		}
	}
	output_or_die(stdout, "found %d elves\n", n_elves);
	output_or_die(stdout, "top three:\n %d\n %d\n %d\n", top_three[0], top_three[1], top_three[2]);
	output_or_die(stdout, "top three total: %d\n", top_three[0] + top_three[1] + top_three[2]);

	return 0;
}

// Local variables:
// eval: (c-set-style "linux")
// End:
