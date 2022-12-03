use v5.12;
use warnings;

use Test::More tests => 2;

use List::Util 'sum';

require './rps';

open(my $fh, '<', 'input/day2') || die;
my $guide = strategy_guide(<$fh>);
is
    sum(map { score_round(@$_) } @$guide),
    13268;

is
    sum(map { score_round($_->[0], choose_countr(@$_)) } @$guide),
    15508;
