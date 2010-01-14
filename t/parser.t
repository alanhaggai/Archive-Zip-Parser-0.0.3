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

done_testing();
