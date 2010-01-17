package Archive::Zip::Parser::Entry;

use warnings;
use strict;

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

1;
