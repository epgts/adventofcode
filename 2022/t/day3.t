use v5.12;
use warnings;

use Test::More tests => 6;

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

my @rucksacks = map { rucksack($_) } (
    'vJrwpWtwJgWrhcsFMMfFFhFp',
    'jqHRNqRjqzjGDLGLrsFMfFZSrLrFZsSL',
    'PmmdzqPrVvPwwTWBwg',
    'wMqvLMZHhHMvwLHjbvcjnnSBnvTQFn',
    'ttgJtRGJQctTZtZT',
    'CrZsJsPPZsGzwwsLwLmpwMDw',
);
my $groups = elves_come_in_threes(@rucksacks);
is
    badge($groups->[0]),
    'r';
is
    badge($groups->[1]),
    'Z';

@rucksacks = map { chomp; rucksack($_) } <$fh>;

is
    sum(map { priority(first_misclassified_type($_)) } @rucksacks),
    8185;

$groups = elves_come_in_threes(@rucksacks);

is
    sum(map { priority(badge($_)) } @$groups),
    2817;
