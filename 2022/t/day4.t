use v5.12;
use warnings;

use Test::More tests => 2;

require './camptool';

open(my $fh, '<', 'input/day4') || die;
my @range_pairs = map { chomp; range_pair($_) } <$fh>;
is
    scalar(
        grep {
            all_ranges_contained(@$_)
        }
        @range_pairs
    ),
    524;

is
    scalar(
        grep {
            pairs_overlap(@$_)
        }
        @range_pairs
    ),
    798;
