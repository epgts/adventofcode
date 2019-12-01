use v5.12;
use warnings;

use Test::More tests => 5;

require './rocketeq';

# Example inputs and answers; this is how we know they meant "truncate" when
# they said "round".
is         2, fuel_of_mass(12);
is         2, fuel_of_mass(14);
is       654, fuel_of_mass(1969);
is    33_583, fuel_of_mass(100756);

open(my $fh, '<', 'input/day1') or die;
is 3_495_189, total_fuel_of_masses(<$fh>), 'total';
