#include "io.h"

static void
usage(FILE *const fp)
{
	output_or_die(fp, "elftool INPUTFILE\n");
}

int
main(int argc, char **argv)
{
	argc--; argv++;

	if (argc > 0 && strcmp(argv[0], "-v") == 0) {
		argc--; argv++;
		VERBOSE++;
	}

	if (argc != 1) {
		usage(stderr);
		return 2;
	}

	unsigned long long buflen;
	char *buf;
	int const status = read_file(&buflen, &buf, argv[0]);
	if (status != 0) {
		return status;
	}

	if (buf[buflen - 1] != '\n') {
		fprintf(stderr, "malformed input:  final byte is %d not LF\n", buf[buflen - 1]);
		return 5;
	}

	if (*buf == '\n') {
		fprintf(stderr, "malformed input:  first byte is LF\n");
		return 5;
	}

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
