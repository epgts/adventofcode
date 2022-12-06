use v5.12;
use warnings;

use Test::More tests => 3;

use List::Util 'sum';

require './rps';

use Env 'OBJDIR';

my $problem1 = 13_268;
my $problem2 = 15_508;

open(my $fh, '<', 'input/day2') || die;
my $guide = strategy_guide(<$fh>);
is
    sum(map { score_round(@$_) } @$guide),
    $problem1;

is
    sum(map { score_round($_->[0], choose_countr(@$_)) } @$guide),
    15508;

open($fh, '-|', "$OBJDIR/rps.com", 'input/day2') || die;
is
    scalar(<$fh>),
    "$problem1 $problem2\n";
