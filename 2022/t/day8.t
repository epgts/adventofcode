use v5.12;
use warnings;

use Test::More tests => 24;

require './trees';

my @example = (
    map { [ split('', $_) ] }
    30373,
    25512,
    65332,
    33549,
    35390,
    );

my @map = @{map_visibility(\@example)};

is count_visible(\@map), 21;

# The top-left 5 is visible from the left and top. (It isn't visible from the
# right or bottom since other trees of height 5 are in the way.)
is $example[1]->[1], 5;
ok $map[1]->[1];

# The top-middle 5 is visible from the top and right.
is $example[1]->[2], 5;
ok $map[1]->[2];

# The top-right 1 is not visible from any direction; for it to be visible,
# there would need to only be trees of height 0 between it and an edge.
is $example[1]->[3], 1;
ok !$map[1]->[3];

# The left-middle 5 is visible, but only from the right.
is $example[2]->[1], 5;
ok $map[2]->[1];

# The center 3 is not visible from any direction; for it to be visible, there
# would need to be only trees of at most height 2 between it and an edge.
is $example[2]->[2], 3;
ok !$map[2]->[2];

# The right-middle 3 is visible from the right.
is $example[2]->[3], 3;
ok $map[2]->[3];

# In the bottom row,
# - the middle 5 is visible
is $example[3]->[2], 5;
ok $map[3]->[2];
# - the 3 is not
is $example[3]->[1], 3;
ok !$map[3]->[1];
# - but the 4 is not.
is $example[3]->[3], 4;
ok !$map[3]->[3];

open(my $fh, '<', 'input/day8') || die;
my @input = map { chomp; [ split('', $_) ] } <$fh>;
@map = @{map_visibility(\@input)};
is count_visible(\@map), 1688;

# Problem 2

is
    scenic_score(\@example, 1, 2),
    4;

is
    scenic_score(\@example, 3, 2),
    8;

is
    highest_scenic_score(\@example),
    8;

is
    highest_scenic_score(\@input),
    410400;
