use v5.12;
use warnings;

use Test::More tests => 7;

require './intcode';

# Example inputs and answers
ok interpret([1,9,10,3,2,3,11,0,99,30,40,50]),
    eq_array[3500,9,10,70,2,3,11,0,99,30,40,50];
ok interpret([1,0,0,0,99]),
    eq_array[2,0,0,0,99];
ok interpret([2,3,0,3,99]),
    eq_array[2,3,0,6,99];
ok interpret([2,4,4,5,99,0]),
    eq_array[2,4,4,5,99,9801];
ok interpret([1,1,1,4,99,5,6,0,99]),
    eq_array[30,1,1,4,2,5,6,0,99];

open(my $fh, '<', 'input/day2') or die;
my $input = <$fh>;
is fix1201_str($input), 3_765_464;

is fix1201_find($input), 7610;
