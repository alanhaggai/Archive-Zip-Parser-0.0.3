package Archive::Zip::Parser::Entry;

use warnings;
use strict;

use Archive::Zip::Parser::Entry::LocalFileHeader;

sub _get_entry {
    my ( $self, $entry_number ) = @_;

    if ( !defined $entry_number ) {
        my @entry_objects;
        for ( @{ $self->{'_entry'} } ) {
            push @entry_objects, bless $_, __PACKAGE__;
        }

        return @entry_objects;
    }

    return bless $self->{'_entry'}->[$entry_number], __PACKAGE__;
}

sub get_local_file_header {
    my $self = shift;
    return bless $self->{'_local_file_header'},
      'Archive::Zip::Parser::Entry::LocalFileHeader';
}

1;

