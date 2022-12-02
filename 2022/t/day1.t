use v5.12;
use warnings;

use Test::More tests => 2;

require './elftool';

open(my $fh, '<', 'input/day1') || die;
my $stuff = elf_stuff(map { chomp; $_ } <$fh>);

is
    mostest_of_the_elves($stuff),
    75_622;

is
    top_three_sum_of_the_elves($stuff),
    213_159;
