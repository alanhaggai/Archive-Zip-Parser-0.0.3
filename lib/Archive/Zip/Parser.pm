package Archive::Zip::Parser;

use warnings;
use strict;
use autodie;
use Data::ParseBinary;

use Archive::Zip::Parser::Exception;
use Archive::Zip::Parser::Entry;

use version; our $VERSION = qv( '0.0.0_01' );

sub new {
    my ( $class, $arg_ref ) = @_;

    my $new_object = bless {}, $class;
    my $exception_object = Archive::Zip::Parser::Exception->new();
    $new_object->{'_exception_object'} = $exception_object;

    if ( !exists $arg_ref->{'file_name'} ) {
        $exception_object->_croak('Missing "file_name"');
    }

    open my $file_handle, '<', $arg_ref->{'file_name'};
    $new_object->{'_file_handle'} = $file_handle;
    $new_object->{'_bit_stream'}
      = CreateStreamReader( File => $new_object->{'_file_handle'} );

    return $new_object;
}

sub verify_signature {
    my $self = shift;

    my $previous_position_in_file;
    eval {
        $previous_position_in_file = tell $self->{'_file_handle'};
        $self->_set_position_in_file( 0, 0 );

        Magic("PK\x03\x04")->parse( $self->{'_bit_stream'} );
    } or do {
        return 0;
    };

    $self->_set_position_in_file( $previous_position_in_file, 0 );
    return 1;
}

sub parse {
    my $self = shift;

    return 1 if $self->{'_is_parsed'};
    if ( !$self->verify_signature() ) {
        $self->{'_exception_object'}->_croak('Not a valid .ZIP archive');
    }

    my @parsed_entry_struct;
    while (1) {
        my $signature_struct = 
            Struct(
                '_signature_struct',
                Peek(
                    UBInt32('_signature')
                ),
            );
        my $parsed_signature_struct
          = $signature_struct->parse( $self->{'_bit_stream'} );
        my $signature = pack 'N', $parsed_signature_struct->{'_signature'};
        last if $signature ne "PK\x03\x04";

        my $local_file_header_struct
            = Struct(
                '_entry_struct',
                Struct(
                    '_local_file_header',
                    ULInt32('_signature'     ),
                    ULInt16('_version_needed'),
                    BitStruct( '_gp_bit',
                        Flag('_bit_7' ),
                        Flag('_bit_6' ),
                        Flag('_bit_5' ),
                        Flag('_bit_4' ),
                        Flag('_bit_3' ),
                        Flag('_bit_2' ),
                        Flag('_bit_1' ),
                        Flag('_bit_0' ),
                        Flag('_bit_15'),
                        Flag('_bit_14'),
                        Flag('_bit_13'),
                        Flag('_bit_12'),
                        Flag('_bit_11'),
                        Flag('_bit_10'),
                        Flag('_bit_9' ),
                        Flag('_bit_8' ),
                    ),
                    ULInt16('_compression_method'),
                    ULInt16('_last_mod_time'     ),
                    ULInt16('_last_mod_date'     ),
                    ULInt32('_crc_32'            ),
                    ULInt32('_compressed_size'   ),
                    ULInt32('_uncompressed_size' ),
                    ULInt16('_file_name_length'  ),
                    ULInt16('_extra_field_length'),
                    String(
                        '_file_name',
                        sub {
                            $_->ctx->{'_file_name_length'};
                        },
                    ),
                    Field(
                        '_extra_field',
                        sub {
                            $_->ctx->{'_extra_field_length'};
                        },
                    ),
                ),
                Field(
                    '_file_data',
                    sub {
                        $_->ctx->{'_local_file_header'}->{'_compressed_size'};
                    }
                ),
                If(
                    sub {
                        $_->ctx->{'_local_file_header'}->{'_gp_bit'}->{'_bit_3'};
                    },
                    Struct(
                        '_data_descriptor',
                        ULInt32('_crc_32'           ),
                        ULInt32('_compressed_size'  ),
                        ULInt32('_uncompressed_size'),
                    ),
                ),
            );

        push @parsed_entry_struct,
          $local_file_header_struct->parse( $self->{'_bit_stream'} );
    }

    my $entry_count = 0;
    while (1) {
        my $signature_struct = 
            Struct(
                '_signature_struct',
                Peek(
                    UBInt32('_signature')
                ),
            );
        my $parsed_signature_struct
          = $signature_struct->parse( $self->{'_bit_stream'} );
        my $signature = pack 'N', $parsed_signature_struct->{'_signature'};
        last if $signature ne "PK\x01\x02";

        my $central_directory_struct
            = Struct(
                '_entry_struct',
                Struct(
                    '_central_directory',
                    ULInt32('_signature'      ),
                    ULInt16('_version_made_by'),
                    ULInt16('_version_needed' ),
                    BitStruct(
                        '_gp_bit',
                        Flag('_bit_7' ),
                        Flag('_bit_6' ),
                        Flag('_bit_5' ),
                        Flag('_bit_4' ),
                        Flag('_bit_3' ),
                        Flag('_bit_2' ),
                        Flag('_bit_1' ),
                        Flag('_bit_0' ),
                        Flag('_bit_15'),
                        Flag('_bit_14'),
                        Flag('_bit_13'),
                        Flag('_bit_12'),
                        Flag('_bit_11'),
                        Flag('_bit_10'),
                        Flag('_bit_9' ),
                        Flag('_bit_8' ),
                    ),
                    ULInt16('_compression_method'     ),
                    ULInt16('_last_mod_time'          ),
                    ULInt16('_last_mod_date'          ),
                    ULInt32('_crc_32'                 ),
                    ULInt32('_compressed_size'        ),
                    ULInt32('_uncompressed_size'      ),
                    ULInt16('_file_name_length'       ),
                    ULInt16('_extra_field_length'     ),
                    ULInt16('_file_comment_length'    ),
                    ULInt16('_start_disk_number'      ),
                    ULInt16('_internal_file_attr'     ),
                    ULInt32('_external_file_attr'     ),
                    ULInt32('_rel_offset_local_header'),
                    String(
                        '_file_name',
                        sub {
                            $_->ctx->{'_file_name_length'};
                        },
                    ),
                    Field(
                        '_extra_field',
                        sub {
                            $_->ctx->{'_extra_field_length'};
                        },
                    ),
                    Field(
                        '_file_comment',
                        sub {
                            $_->ctx->{'_file_comment_length'};
                        }
                    ),
                ),
            );

        %{ $parsed_entry_struct[$entry_count] } = (
            %{ $parsed_entry_struct[$entry_count] },
            %{  $central_directory_struct->parse(
                    $self->{'_bit_stream'}
                )
              }
        );
        $entry_count++;
    }

    my $signature_struct = 
        Struct(
            '_signature_struct',
            Peek(
                UBInt32('_signature')
            ),
        );
    my $parsed_signature_struct
      = $signature_struct->parse( $self->{'_bit_stream'} );
    my $signature = pack 'N', $parsed_signature_struct->{'_signature'};
    last if $signature ne "PK\x05\x06";

    my $end_of_central_directory_struct
        = Struct(
            '_end_of_central_directory_struct',
            ULInt32('_signature'                ),
            ULInt16('_disk_number'),
            ULInt16('_start_disk_number'),
            ULInt16('_total_disk_entries'),
            ULInt16('_total_entries'),
            ULInt32('_size'),
            ULInt32('_start_offset'),
            ULInt16('_zip_comment_length'),
            String(
                '_zip_comment',
                sub {
                    $_->ctx->{'_zip_comment_length'};
                },
            ),
        );

    my @parsed_end_of_central_directory_struct
      = $end_of_central_directory_struct->parse( $self->{'_bit_stream'} );
    push @{ $self->{'_end_of_central_directory'} },
      @parsed_end_of_central_directory_struct;
    push @{ $self->{'_entry'} }, @parsed_entry_struct;

    $self->{'_is_parsed'} = 1;
    return 1;
}

sub get_entry {
    my ( $self, $entry_number ) = @_;

    if (wantarray) {
        return Archive::Zip::Parser::Entry::_get_entry($self);
    }

    return Archive::Zip::Parser::Entry::_get_entry( $self, $entry_number );
}

sub _set_position_in_file {
    my ( $self, $position_in_file, $whence ) = @_;
    my $file_handle = $self->{'_file_handle'};

    seek $file_handle, $position_in_file, $whence;

    return;
}

1;
__END__

=head1 NAME

Archive::Zip::Parser - Parser for .ZIP archives

=head1 VERSION

This document describes Archive::Zip::Parser version 0.0.0_01


=head1 SYNOPSIS

    use Archive::Zip::Parser;

    my $parser =
      Archive::Zip::Parser->new( { file_name => 'secret_files.zip' } );
    $parser->parse();


=head1 DESCRIPTION

This parser is based on the specifications stated in APPNOTE.TXT
(L<http://www.pkware.com/documents/casestudies/APPNOTE.TXT>) version 6.3.2
published by PKWARE, Inc.


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

=item C<< new() >>

Arguments: 1

=over 4

=item * HASHREF

I<file_name> - File name with path to .ZIP archive

=back

Returns reference to a parser object.

=item C<< verify_signature() >>

Returns true if the file is a valid .ZIP archive. Else returns false.

=item C<< parse() >>

Parses file if it has not already been parsed. Dies if not a valid .ZIP archive.

=item C<< get_entry() >>

Arguments: 1

=over 4

=item * INT

=over 4

=item * LIST

Ignores argument and returns a list of L<entry|Archive::Zip::Parser::Entry>
objects.

=item * SCALAR

Returns particular L<entry|Archive::Zip::Parser::Entry> object.

=back

=item * UNDEF

=over 4

=item * LIST

Returns a list of L<entry|Archive::Zip::Parser::Entry> objects.

=item * SCALAR

Returns number of list L<entries|Archive::Zip::Parser::Entry>.

=back

=back

=back

=head1 DIAGNOSTICS

=over

=item C<< Missing "file_name" >>

Reported when argument C<file_name> is not provided to C<new()>.

=item C<< Not a valid .ZIP archive >>

This error is reported when dying due to parsing an invalid .ZIP archive.

=back


=head1 CONFIGURATION AND ENVIRONMENT

Archive::Zip::Parser requires no configuration files or environment variables.


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
