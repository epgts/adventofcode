use v5.12;
use warnings;

use Test::More tests => 5;

use Test::Differences;

require './supplies';

my @example = split("\n", <<'EOF');
    [D]    
[N] [C]    
[Z] [M] [P]
 1   2   3 

move 1 from 2 to 1
move 3 from 1 to 3
move 2 from 2 to 1
move 1 from 1 to 2
EOF

my ($arrangement, $rearrangement) = read_arrangement_and_re(\@example);
eq_or_diff
    [
     $arrangement,
     $rearrangement,
    ],
    [
     [
      ['N', 'Z'],
      ['D', 'C', 'M'],
      ['P'],
     ],
     [
      [1, 1, 0],
      [3, 0, 2],
      [2, 1, 0],
      [1, 0, 1],
      ]
    ];

CrateMover9000($arrangement, $rearrangement);
eq_or_diff
    $arrangement,
    [
     ['C'],
     ['M'],
     ['Z', 'N', 'D', 'P'],
    ];

eq_or_diff
    [take_tops($arrangement)],
    ['C', 'M', 'Z'];

open(my $fh, '<', 'input/day5') || die;
my @input = map { chomp; $_ } <$fh>;
($arrangement, $rearrangement) = read_arrangement_and_re([@input]);
CrateMover9000($arrangement, $rearrangement);
is
    join('', take_tops($arrangement)),
    'QNHWJVJZW';

($arrangement, $rearrangement) = read_arrangement_and_re([@input]);
CrateMover9001($arrangement, $rearrangement);
is
    join('', take_tops($arrangement)),
    'BPCZJLFJW';
