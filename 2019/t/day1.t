use v5.12;
use warnings;

use Test::More tests => 17;

require './rocketeq';

# Example inputs and answers; this is how we know they meant "truncate" when
# they said "round".
is         2, base_fuel_of_mass(12);
is         2, base_fuel_of_mass(14);
is       654, base_fuel_of_mass(1969);
is    33_583, base_fuel_of_mass(100_756);

# These should all be zero, but if that was required, I missed it, and it didn't
# affect the solution.
is         0, base_fuel_of_mass(0);
is         0, base_fuel_of_mass(1);
is         0, base_fuel_of_mass(2);
is         0, base_fuel_of_mass(3);
is         0, base_fuel_of_mass(4);
is         0, base_fuel_of_mass(5);
is         0, base_fuel_of_mass(6);
is         0, base_fuel_of_mass(7);
is         0, base_fuel_of_mass(8);
is         1, base_fuel_of_mass(9);

is       966, fuel_of_mass(1969);
is    50_346, fuel_of_mass(100_756);

open(my $fh, '<', 'input/day1') or die;
is 5_239_910, total_fuel_of_masses(<$fh>), 'total';
