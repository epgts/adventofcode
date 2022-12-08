use v5.12;
use warnings;

use Test::More tests => 7;

use List::Util 'sum';

require './tsreader';

my $example = <<'EOF';
$ cd /
$ ls
dir a
14848514 b.txt
8504156 c.dat
dir d
$ cd a
$ ls
dir e
29116 f
2557 g
62596 h.lst
$ cd e
$ ls
584 i
$ cd ..
$ cd ..
$ cd d
$ ls
4060174 j
8033020 d.log
5626152 d.ext
7214296 k
EOF

my $du = du(read_transcript($example));

is $du->{'a/e'}, 584;
is $du->{a}, 94853;
is $du->{d}, 24933642;
is $du->{''}, 48381165;

is
    sum(grep { $_ <= 100_000 } values(%$du)),
    95_437;

open(my $fh, '<', 'input/day7') || die;
# lol oops should have just taken list of lines to begin with
my $input = join('', <$fh>);
$du = du(read_transcript($input));
# part 1
is
    sum(grep { $_ <= 100_000 } values(%$du)),
    1_501_149;
# part 2
is
    smallest_dir_to_free(70_000_000, 30_000_000, $du),
    10_096_985;
