use v5.12;
use warnings;

use Test::More tests => 11;

require './elfcom';

my @examples = (
    bvwbjplbgvbhsrlpgdmjqwftvncz => 5,
    nppdvjthqldpwncqszvftbrmjlhg => 6,
    nznrnfrfntjfmvfwmzdfjlvtqnbhcprsg => 10,
    zcfzfwzzqfrljwzlrfnpqdbhtmscgvjw => 11,
    );

while (@examples) {
    my ($stream, $expected_start) = (shift(@examples), shift@examples);
    is start_of_packet($stream, 4), $expected_start;
}

my @examples2 = (
    mjqjpqmgbljsphdztnvjfqwrcgsmlb => 19,
    bvwbjplbgvbhsrlpgdmjqwftvncz => 23,
    nppdvjthqldpwncqszvftbrmjlhg => 23,
    nznrnfrfntjfmvfwmzdfjlvtqnbhcprsg => 29,
    zcfzfwzzqfrljwzlrfnpqdbhtmscgvjw => 26,
    );

while (@examples2) {
    my ($stream, $expected_start) = (shift(@examples2), shift@examples2);
    is start_of_packet($stream, 14), $expected_start;
}

open(my $fh, '<', 'input/day6') || die;
my $stream = <$fh>;
chomp($fh);
is
    start_of_packet($stream, 4),
    1287;

is
    start_of_packet($stream, 14),
    3716;
