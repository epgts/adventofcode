#include "io.h"

enum Attack {
	AttackRock = 'A',
	AttackPapr = 'B',
	AttackScis = 'C',
};
enum Countr {
	CountrRock = 'X',
	CountrPapr = 'Y',
	CountrScis = 'Z',
};

enum Outcome {
	Lose = 'X',
	Draw = 'Y',
	Win  = 'Z',
};

struct Score {
	enum Attack attack;
	enum Countr countr;
	int score;
};
static struct Score const SCORES[] = {
	{ AttackRock, CountrRock, 1 + 3 },
	{ AttackRock, CountrPapr, 2 + 6 },
	{ AttackRock, CountrScis, 3 + 0 },
        { AttackPapr, CountrRock, 1 + 0 },
	{ AttackPapr, CountrPapr, 2 + 3 },
	{ AttackPapr, CountrScis, 3 + 6 },
        { AttackScis, CountrRock, 1 + 6 },
        { AttackScis, CountrPapr, 2 + 0 },
        { AttackScis, CountrScis, 3 + 3 },
};

struct Strategy {
	enum Attack attack;
	enum Outcome goal;
	enum Countr countr;
};
static struct Strategy const HOWTO[] = {
	{ AttackRock, Lose, CountrScis },
	{ AttackRock, Draw, CountrRock },
	{ AttackRock, Win,  CountrPapr },
	{ AttackPapr, Lose, CountrRock },
        { AttackPapr, Draw, CountrPapr },
        { AttackPapr, Win,  CountrScis },
	{ AttackScis, Lose, CountrPapr },
	{ AttackScis, Draw, CountrScis },
	{ AttackScis, Win,  CountrRock },
};

static int
score_round(enum Attack const attack, enum Countr const countr)
{
	for (int i = 0; i < sizeof SCORES; i++) {
		if (SCORES[i].attack == attack && SCORES[i].countr == countr) {
			return SCORES[i].score;
		}
	}
	CHECK(0, "SCORES table incomplete");
}

static enum Countr
choose_countr(enum Attack const attack, enum Outcome const goal)
{
	for (int i = 0; i < sizeof HOWTO; i++) {
		if (HOWTO[i].attack == attack && HOWTO[i].goal == goal) {
			return HOWTO[i].countr;
		}
	}
	CHECK(0, "HOWTO table incomplete");
}

static void
usage(FILE *const fp)
{
	output_or_die(fp, "rps INPUTFILE\n");
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

	int p1 = 0, p2 = 0;
	for (int i = 0; i < buflen; i += 4) {
		CHECK_LE(i + 4, buflen, "malformed input:  fewer than 4 bytes remain");
		p1 += score_round(buf[i], buf[i + 2]);
		p2 += score_round(buf[i], choose_countr(buf[i], buf[i + 2]));
	}
	output_or_die(stdout, "%d %d\n", p1, p2);

	return 0;
}

// Local variables:
// eval: (c-set-style "linux")
// End:
