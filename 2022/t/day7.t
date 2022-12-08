use v5.12;
use warnings;

use Test::More tests => 5;

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
    sum(grep { $_ <= 100000 } values(%$du)),
    95437;

open(my $fh, '<', 'input/day7') || die;
# lol oops should have just taken list of lines to begin with
my $input = join('', <$fh>);
is
    sum(grep { $_ <= 100000 } values(%{du(read_transcript($input))})),
    95437;
