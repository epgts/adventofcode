#include "io.h"

static void
usage(FILE *const fp)
{
	output_or_die(fp, "rucksack INPUTFILE\n");
}

struct rucksack {
	char *parts[2];		/* Every rucksack has two compartments. */
	size_t count;		/* Each compartment contains this many items. */
};
static void
rucksacks(struct rucksack * *const sacks, size_t *const nsacks, char const *const buf)
{
	size_t size = 256; /* smaller than input of 300 so we can test realloc path */
	*sacks = malloc(size * sizeof **sacks);
	*nsacks = 0;
	char const *lf;
	for (char *p = buf; *p; p = lf + 1) {
		lf = strchr(p, '\n');
		CHECK_NOTNULL(lf);
		size_t const len = lf - p;
		CHECK_GT(len, 0);

		if (*nsacks + 1 > size) {
			size *= 2;
			*sacks = realloc(*sacks, size * sizeof **sacks);
		}
		struct rucksack *const sack = *sacks + *nsacks;
		sack->count = len / 2;
		sack->parts[0] = p;
		sack->parts[1] = p + sack->count;
		(*nsacks)++;
	}
}

static char
priority(int const type)
{
	if ('a' <= type && type <= 'z') {
		return type - 96;
	}
	if ('A' <= type && type <= 'Z') {
		return type - 38;
	}
	CHECK(0, "type out of range: %d\n", type);
}

static char
badge(struct rucksack const *const sacks, uint8_t const group_size)
{
	uint8_t types[128] = { 0 };
	for (struct rucksack const *sack = sacks; sack < sacks + group_size; sack++) {
		uint8_t sack_set[128] = { 0 };
		for (int part_i = 0; part_i <= 1; part_i++) {
			for (int i = 0; i < sack->count; i++) {
				char const item = sack->parts[part_i][i];
				if (sack_set[item]++ == 0) {
					if (++types[item] == group_size) {
						return item;
					}
				}
			}
		}
	}
}

static char
first_misclassified_type(struct rucksack const *const sack)
{
	// TODO What!  I got lucky?!  I didn't implement the rule about types being case-insensitive...
	uint8_t types[128] = { 0 };
	for (int i = 0; i < sack->count; i++) {
		types[sack->parts[0][i]]++;
	}
	for (int i = 0; i < sack->count; i++) {
		char const item = sack->parts[1][i];
		if (types[item]) {
			return item;
		}
	}
	CHECK(0, "no misclassified");
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

	struct rucksack *sacks;
	size_t nsacks;
	rucksacks(&sacks, &nsacks, buf);
	int problem1 = 0;
	int problem2 = 0;
	for (char i = 'a'; i <= 'z'; i++) {
		LOG("%c %d\n", i, priority(i) - 1);
	}
	for (char i = 'A'; i <= 'Z'; i++) {
		LOG("%c %d\n", i, priority(i) - 1);
	}
	for (int i = 0; i < nsacks; i++) {
		problem1 += priority(first_misclassified_type(sacks + i));
		if ((i + 1) % 3 == 0) { /* elves come in threes */
			LOG("group %d-%d\n", i - 2, i);
			problem2 += priority(badge(sacks + i - 2, 3));
		}
	}

	output_or_die(stdout, "%d %d\n", problem1, problem2);
	return 0;
}

// Local variables:
// eval: (c-set-style "linux")
// End:
