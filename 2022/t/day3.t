use v5.12;
use warnings;

use Test::More tests => 3;

use List::Util 'sum';
use Test::Differences;

require './rucksack';

open(my $fh, '<', 'input/day3') || die;

eq_or_diff
    [ map { join('', @$_) } @{rucksack('vJrwpWtwJgWrhcsFMMfFFhFp')} ],
    ['vJrwpWtwJgWr', 'hcsFMMfFFhFp'];

eq_or_diff
    [ map { priority($_) } 'A', 'Z', 'a', 'z' ],
    [ 27, 52, 1, 26 ];

is
    sum(map { chomp; priority(first_misclassified_type(rucksack($_))) } <$fh>),
    8185;
