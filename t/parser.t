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
is( $parser->get_entry(), 5, 'number of entries' );
my $entry = $parser->get_entry(2);

subtest 'local file header' => sub {
    isa_ok(
        my $local_file_header = $entry->get_local_file_header(),
        'Archive::Zip::Parser::Entry::LocalFileHeader'
    );
    is( $local_file_header->get_signature(), '04034b50', 'signature' );
    is( $local_file_header->get_version_needed(), 10, 'version needed' );
    is( $local_file_header->get_version_needed( { describe => 1 } ),
        'Default value',
        'version needed description'
    );

    subtest 'gp bit' => sub {
        isa_ok( $local_file_header->get_gp_bit(), 'ARRAY' );

        my $bit_count = 0;
        my @bits      = $local_file_header->get_gp_bit();
        is( scalar @bits, 16, '16 bit flags' );
        for (@bits) {
            is( $_, 0, 'bit ' . $bit_count++ );
        }

        done_testing();
    };

    is( $local_file_header->get_compression_method(), 0, 'compression method' );
    is( $local_file_header->get_compression_method( { describe => 1 } ),
        'The file is stored (no compression)',
        'compression method description'
    );

    subtest 'last mod time' => sub {
        my $last_mod_time = $local_file_header->get_last_mod_time();
        is( $last_mod_time->{'hour'},   13, 'hour' );
        is( $last_mod_time->{'minute'}, 32, 'minute' );
        is( $last_mod_time->{'second'}, 7,  'second' );

        done_testing();
    };

    subtest 'last mod date' => sub {
        my $last_mod_date = $local_file_header->get_last_mod_date();
        is( $last_mod_date->{'year'},  2010, 'year' );
        is( $last_mod_date->{'month'}, 1,    'month' );
        is( $last_mod_date->{'day'},   14,   'day' );

        done_testing();
    };

    is( $local_file_header->get_crc_32(), 'a7794e05', 'CRC-32' );
    is( $local_file_header->get_compressed_size(), '12', 'compressed size' );
    is( $local_file_header->get_uncompressed_size(), 12, 'uncompressed size' );
    is( $local_file_header->get_file_name_length(),  9,  'file name length' );
    is( $local_file_header->get_extra_field_length(),
        '28', 'extra field length' );
    is( $local_file_header->get_file_name(), 'a/b/b.txt', 'file name' );

    subtest 'extra field' => sub {
        is( scalar $local_file_header->get_extra_field(),
            2, 'number of extra fields' );
        my %extra_fields = $local_file_header->get_extra_field();
        is( $extra_fields{'7875'}, '0104e803000004e8030000', 'extra field' );
        is( $extra_fields{'5455'}, '0386cf4e4b83cf4e4b',     'extra field' );
        is( scalar $local_file_header->get_extra_field( { describe => 1 } ),
            'extended timestamp',
            'serialised extra field descriptions'
        );
        %extra_fields
          = $local_file_header->get_extra_field( { describe => 1 } );
        is( $extra_fields{'7875'}, '0104e803000004e8030000', 'extra field' );
        is( $extra_fields{'extended timestamp'},
            '0386cf4e4b83cf4e4b', 'extra field' );

        done_testing();
    };

    done_testing();
};

done_testing();
