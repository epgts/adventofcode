use v5.12;
use warnings;

use Test::More tests => 3;

use Test::Differences;

require './elftool';

use Env 'OBJDIR';

open(my $fh, '<', 'input/day1') || die;
my $stuff = elf_stuff(map { chomp; $_ } <$fh>);

my $mostest = 75_622;
is
    mostest_of_the_elves($stuff),
    $mostest;

my $top_three = 213_159;
is
    top_three_sum_of_the_elves($stuff),
    $top_three;

open($fh, '-|', "$OBJDIR/elftool.com", 'input/day1') || die;
my @actual = <$fh>;
close($fh) || die;
eq_or_diff
    \@actual,
    [
     "found 254 elves\n",
     "top three:\n",
     " $mostest\n",
     " 69383\n",
     " 68154\n",
     "top three total: $top_three\n",
    ];
