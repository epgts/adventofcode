use v5.12;
use warnings;

use Test::More tests => 2;

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

# COM.B.C.D.E.J.K.YOU
# COM.B.C.D.I.SAN
# =>
# E.J.K.YOU
# I.SAN
# => 4
is orbital_transfer(
    'COM)B',
    'B)C',
    'C)D',
    'D)E',
    'E)F',
    'B)G',
    'G)H',
    'D)I',
    'E)J',
    'J)K',
    'K)L',
    'K)YOU',
    'I)SAN')
    => 4;
