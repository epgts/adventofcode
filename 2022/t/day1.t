use v5.12;
use warnings;

use Test::More tests => 1;

require './elftool';

open(my $fh, '<', 'input/day1') || die;
is
    mostest_of_the_elves(elf_stuff(map { chomp; $_ } <$fh>)),
    75_622;
