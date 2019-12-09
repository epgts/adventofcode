use v5.12;
use warnings;

use Test::More tests => 1;

require './sif';

open(my $fh, '<', 'input/day8') or die;
is checksum(<$fh>), 1548;
