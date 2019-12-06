use v5.12;
use warnings;

use Test::More tests => 1;

require './orbits';

is orbits('COM)B',
          'B)C',
          'C)D',
          'D)E',
          'E)F',
          'B)G',
          'G)H',
          'D)I',
          'E)J',
          'J)K',
          'K)L')
    => 42;
