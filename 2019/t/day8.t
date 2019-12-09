use v5.12;
use warnings;

use Test::More tests => 2;

require './sif';

open(my $fh, '<', 'input/day8') or die;
my $line = <$fh>;

is checksum(25, 6, $line), 1548;

is decode(25, 6, $line),
      " OO  OOOO O  O O  O  OO  \n"
    . "O  O O    O O  O  O O  O \n"
    . "O    OOO  OO   O  O O  O \n"
    . "O    O    O O  O  O OOOO \n"
    . "O  O O    O O  O  O O  O \n"
    . " OO  OOOO O  O  OO  O  O \n";
