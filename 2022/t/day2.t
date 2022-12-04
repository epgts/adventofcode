use v5.12;
use warnings;

use Test::More tests => 3;

use List::Util 'sum';

require './rps';

use Env 'OBJDIR';

open(my $fh, '<', 'input/day2') || die;
my $guide = strategy_guide(<$fh>);
is
    sum(map { score_round(@$_) } @$guide),
    13268;

is
    sum(map { score_round($_->[0], choose_countr(@$_)) } @$guide),
    15508;

open($fh, '-|', "$OBJDIR//rps.com", 'input/day2') || die;
is
    scalar(<$fh>),
    "13268 15508\n";
