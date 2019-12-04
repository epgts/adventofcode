use v5.12;
use warnings;

use Test::More tests => 3;

require './intersection';

is closest_intersection(
    ['R75','D30','R83','U83','L12','D49','R71','U7','L72'],
    ['U62','R66','U55','R34','D71','R55','D58','R83'])
    => 159;
is closest_intersection(
    ['R98','U47','R26','D63','R33','U87','L62','D20','R33','U53','R51'],
    ['U98','R91','D20','R16','D67','R40','U7','R15','U6','R7'])
    => 135;

open(my $fh, '<', 'input/day3') or die;
is closest_intersection(
    map { my @directions = split(/\s*,\s*/); \@directions } <$fh>)
    => 860;
