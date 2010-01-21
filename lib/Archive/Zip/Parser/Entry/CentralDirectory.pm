package Archive::Zip::Parser::Entry::CentralDirectory;

use warnings;
use strict;
use Data::ParseBinary;

use base qw( Archive::Zip::Parser::Entry::Header );

sub get_version_made_by {
    my ( $self, $argref ) = @_;

    my $version_made_by_struct
        = Struct(
            '_version_made_by',
            Byte('_specification_version'),
            Byte('_attribute_information'),
        );
    my $parsed_version_made_by_struct =
      $version_made_by_struct->parse( $self->{'_version_made_by'} );

    my %version_made_by;
    my $specification_version =
      $parsed_version_made_by_struct->{'_specification_version'};
    $version_made_by{'specification_version'} =
      int( $specification_version / 10 ) . '.'
      . $specification_version % 10;

    if ( $argref->{'describe'} ) {
        my %attribute_information_description_mapping = (
            '0' => 'MS-DOX and OS/2 (FAT / VFAT / FAT32 file systems)',
            '1' => 'Amiga',
            '2' => 'OpenVMS',
            '3' => 'UNIX',
            '4' => 'VM/CMS',
            '5' => 'Atari ST',
            '6' => 'OS/2 H.P.F.S.',
            '7' => 'Macintosh',
            '8' => 'Z-System',
            '9' => 'CP/M',
            '10' => 'Windows NTFS',
            '11' => 'MVS (OS/390 - Z/OS)',
            '12' => 'VSE',
            '13' => 'Acorn RISC',
            '14' => 'VFAT',
            '15' => 'alternate MVS',
            '16' => 'BeOS',
            '17' => 'Tandem',
            '18' => 'OS/400',
            '19' => 'OS/X (Darwin)',
        );
        $version_made_by{'attribute_information'} =
          $attribute_information_description_mapping{
            $parsed_version_made_by_struct->{'_attribute_information'} };

        return %version_made_by;
    }

    $version_made_by{'attribute_information'} =
      $parsed_version_made_by_struct->{'_attribute_information'},
    return %version_made_by;
}

sub get_file_comment_length {
    my $self = shift;
    return $self->{'_file_comment_length'};
}

sub get_start_disk_number {
    my $self = shift;
    return $self->{'_start_disk_number'};
}

sub get_internal_file_attr {
    my $self = shift;
    return unpack( 'H*', pack( 'N', $self->{'_internal_file_attr'} ) );
}

sub get_external_file_attr {
    my $self = shift;
    return unpack( 'H*', pack( 'N', $self->{'_external_file_attr'} ) );
}

sub get_rel_offset_local_header {
    my $self = shift;
    return unpack( 'H*', pack( 'N', $self->{'_rel_offset_local_header'} ) );
}

sub get_file_comment {
    my $self = shift;
    return $self->{'_file_comment'};
}

1;
