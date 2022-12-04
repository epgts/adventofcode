use v5.12;
use warnings;

use Test::More tests => 1;

require './camptool';

open(my $fh, '<', 'input/day4') || die;

is
    scalar(
        grep {
            all_ranges_contained(@$_)
        }
        map { chomp; range_pair($_) } <$fh>
    ),
    2;
