package Archive::Zip::Parser::Entry::LocalFileHeader;

use warnings;
use strict;

use base qw( Archive::Zip::Parser::Entry::Header );

1;
__END__

=head1 NAME

Archive::Zip::Parser::Entry::LocalFileHeader - Provides methods to access local
file header fields.

=head1 VERSION

This document describes Archive::Zip::Parser::Entry::LocalFileHeader version 0.0.3


=head1 SYNOPSIS

    use Archive::Zip::Parser;

    my $parser
      = Archive::Zip::Parser->new( { file_name => 'secret_files.zip' } );
    $parser->parse();
    my $entry = $parser->get_entry(3);
    my $local_file_header = $entry->get_local_file_header();
    my $file_name = $local_file_header->get_file_name();


=head1 DESCRIPTION

Provides methods to access local file header fields.

=head1 INTERFACE

=over 4

=item C<< get_signature() >>

Returns local file header signature in hexadecimal (04034b50).

=item C<< get_version_needed() >>

Returns the version needed to extract.

=item C<< get_version_needed( { describe => 1 } ) >>

Returns description of the minimum feature version.

=item C<< get_gp_bit() >>

Returns a list of general purpose bit flags.

=item C<< get_gp_bit( { describe => 1 } ) >>

Returns a list of general purpose bit flag descriptions.

=item C<< get_compression_method() >>

Returns an integer representing the compression method.

=item C<< get_compression_method( { describe => 1 } ) >>

Returns the compression method.

=item C<< get_last_mod_time() >>

Returns a hash consisting of keys:

=over 4

=item * C<hour>

=item * C<minute>

=item * C<second>

=back

=item C<< get_last_mod_date() >>

Returns a hash consisting of keys:

=over 4

=item * C<year>

=item * C<month>

=item * C<day>

=back

=item C<< get_crc_32() >>

Returns CRC-32 in hexadecimal.

=item C<< get_compressed_size() >>

Returns compressed size in bytes.

=item C<< get_uncompressed_size() >>

Returns uncompressed size in bytes.

=item C<< get_file_name_length() >>

Returns file name length in bytes.

=item C<< get_extra_field_length() >>

Returns extra field length in bytes.

=item C<< get_file_name() >>

Returns file name.

=item C<< get_extra_field() >>

Returns a hash of extra fields:

=over 4

=item * C<< 'id' => 'data' >>

=back

=item C<< get_extra_field( { describe => 1 } ) >>

Returns a hash of extra fields with C<id>s substituted with corresponding
descriptions wherever possible:

=over 4

=item * C<< 'id description' => 'data' >>

=back

=back


=head1 CONFIGURATION AND ENVIRONMENT

Archive::Zip::Parser::Entry::LocalFileHeader requires no configuration files or
environment variables.


=head1 DEPENDENCIES

=over 4

=item L<autodie>

First released with perl 5.010001

=item L<Carp>

First released with perl 5

=item L<Data::ParseBinary>

Not in CORE

=item L<version>

First released with perl 5.009

=back


=head1 INCOMPATIBILITIES

None reported.


=head1 BUGS AND LIMITATIONS

No bugs have been reported.

Please report any bugs or feature requests to
C<bug-archive-zip-parser@rt.cpan.org>, or through the web interface at
L<http://rt.cpan.org>.


=head1 AUTHOR

Alan Haggai Alavi  C<< <haggai@cpan.org> >>


=head1 ACKNOWLEDGEMENTS

Thanks to Shain Padmajan (L<http://shain.co.in/>) for helping me shorten method
names.


=head1 SEE ALSO

=over 4

=item * L<Archive::Zip::Parser>

=item * L<Archive::Zip::Parser::CentralDirectoryEnd>

=item * L<Archive::Zip::Parser::Entry>

=item * L<Archive::Zip::Parser::Entry::CentralDirectory>

=item * L<Archive::Zip::Parser::Entry::DataDescriptor>

=back


=head1 LICENCE AND COPYRIGHT

Copyright (c) 2010, Alan Haggai Alavi C<< <haggai@cpan.org> >>. All rights reserved.

This module is free software; you can redistribute it and/or
modify it under the same terms as Perl itself. See L<perlartistic>.


=head1 DISCLAIMER OF WARRANTY

BECAUSE THIS SOFTWARE IS LICENSED FREE OF CHARGE, THERE IS NO WARRANTY
FOR THE SOFTWARE, TO THE EXTENT PERMITTED BY APPLICABLE LAW. EXCEPT WHEN
OTHERWISE STATED IN WRITING THE COPYRIGHT HOLDERS AND/OR OTHER PARTIES
PROVIDE THE SOFTWARE "AS IS" WITHOUT WARRANTY OF ANY KIND, EITHER
EXPRESSED OR IMPLIED, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE. THE
ENTIRE RISK AS TO THE QUALITY AND PERFORMANCE OF THE SOFTWARE IS WITH
YOU. SHOULD THE SOFTWARE PROVE DEFECTIVE, YOU ASSUME THE COST OF ALL
NECESSARY SERVICING, REPAIR, OR CORRECTION.

IN NO EVENT UNLESS REQUIRED BY APPLICABLE LAW OR AGREED TO IN WRITING
WILL ANY COPYRIGHT HOLDER, OR ANY OTHER PARTY WHO MAY MODIFY AND/OR
REDISTRIBUTE THE SOFTWARE AS PERMITTED BY THE ABOVE LICENCE, BE
LIABLE TO YOU FOR DAMAGES, INCLUDING ANY GENERAL, SPECIAL, INCIDENTAL,
OR CONSEQUENTIAL DAMAGES ARISING OUT OF THE USE OR INABILITY TO USE
THE SOFTWARE (INCLUDING BUT NOT LIMITED TO LOSS OF DATA OR DATA BEING
RENDERED INACCURATE OR LOSSES SUSTAINED BY YOU OR THIRD PARTIES OR A
FAILURE OF THE SOFTWARE TO OPERATE WITH ANY OTHER SOFTWARE), EVEN IF
SUCH HOLDER OR OTHER PARTY HAS BEEN ADVISED OF THE POSSIBILITY OF
SUCH DAMAGES.
