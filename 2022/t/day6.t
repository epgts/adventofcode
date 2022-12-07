use v5.12;
use warnings;

use Test::More tests => 5;

require './elfcom';

my @examples = (
    bvwbjplbgvbhsrlpgdmjqwftvncz => 5,
    nppdvjthqldpwncqszvftbrmjlhg => 6,
    nznrnfrfntjfmvfwmzdfjlvtqnbhcprsg => 10,
    zcfzfwzzqfrljwzlrfnpqdbhtmscgvjw => 11,
    );

while (@examples) {
    my ($stream, $expected_start) = (shift(@examples), shift@examples);
    is start_of_packet($stream), $expected_start;
}

open(my $fh, '<', 'input/day6') || die;
is
    start_of_packet(map { chomp; $_ } <$fh>),
    1287;
