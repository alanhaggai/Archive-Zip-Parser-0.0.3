#!perl -T

use Test::More;
use Test::Exception;
use strict;
use warnings;

use_ok('Archive::Zip::Parser');

dies_ok( sub { my $parser = Archive::Zip::Parser->new() },
    'Requires "file_name"' );
my $parser = Archive::Zip::Parser->new( { file_name => 't/files/a.zip' } );
isa_ok( $parser, 'Archive::Zip::Parser' );

is( $parser->verify_signature(), 1, 'Verified signature' );
ok( $parser->parse(), 'Parsed successfully' );

isa_ok( $parser->get_entry(1), 'Archive::Zip::Parser::Entry' );
for ( $parser->get_entry() ) {
    isa_ok( $_, 'Archive::Zip::Parser::Entry' );
}
is( $parser->get_entry(), 5, 'Got number of entries' );

done_testing();
