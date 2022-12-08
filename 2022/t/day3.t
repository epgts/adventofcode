use v5.12;
use warnings;

use Test::More tests => 8;

use List::Util 'sum';
use Test::Differences;

require './rucksack';

use Env 'OBJDIR';

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

open(my $fh, '<', 'input/day3') || die;
@rucksacks = map { chomp; rucksack($_) } <$fh>;

my $problem1 = 8185;
is
    sum(map { priority(first_misclassified_type($_)) } @rucksacks),
    $problem1;

$groups = elves_come_in_threes(@rucksacks);

my $problem2 = 2817;
is
    sum(map { priority(badge($_)) } @$groups),
    $problem2;

open($fh, '-|', "$OBJDIR/rucksack.com", 'input/day3') || die;
is
    scalar(<$fh>),
    "$problem1 $problem2\n";

open($fh, '-|', "$OBJDIR/rucksack", 'input/day3') || die;
is
    scalar(<$fh>),
    "$problem1 $problem2\n";
