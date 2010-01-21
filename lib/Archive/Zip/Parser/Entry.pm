package Archive::Zip::Parser::Entry;

use warnings;
use strict;

use base qw(
    Archive::Zip::Parser::Entry::LocalFileHeader
    Archive::Zip::Parser::Entry::CentralDirectory
);

sub get_local_file_header {
    my $self = shift;
    return bless $self->{'_local_file_header'},
      'Archive::Zip::Parser::Entry::LocalFileHeader';
}

sub get_central_directory {
    my $self = shift;
    return bless $self->{'_central_directory'},
      'Archive::Zip::Parser::Entry::CentralDirectory';
}

1;
__END__

=head1 NAME

Archive::Zip::Parser::Entry - Provides methods for getting local file header,
central directory and file data of .ZIP archive files.

=head1 VERSION

This document describes Archive::Zip::Parser::Entry version 0.0.0_01


=head1 SYNOPSIS

    use Archive::Zip::Parser;

    my $parser =
      Archive::Zip::Parser->new( { file_name => 'secret_files.zip' } );
    $parser->parse();
    my $entry             = $parser->get_entry(2);
    my $local_file_header = $entry->get_local_file_header();


=head1 DESCRIPTION

Provides methods to Archive::Zip::Parser objects.

=head1 INTERFACE

=head2 Method documentation format:

=over 4

=item C<< method() >>

Arguments: x

=over 4

=item * Argument type

=over 4

=item * CONTEXT

=back

=back

=item C<< get_local_file_header() >>

Arguments: 0

=over 4

=item * UNDEF

=over 4

=item * SCALAR

Returns L<local file header|Archive::Zip::Parser::Entry::LocalFileHeader>
object.

=back

=back

=back


=head1 CONFIGURATION AND ENVIRONMENT

Archive::Zip::Parser::Entry requires no configuration files or environment variables.


=head1 DEPENDENCIES

=over 4

=item L<Archive::Zip::Parser::Entry::LocalFileHeader>

Not in CORE

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
