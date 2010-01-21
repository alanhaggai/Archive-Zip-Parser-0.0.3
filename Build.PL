use strict;
use warnings;
use Module::Build;

my $builder = Module::Build->new(
    module_name       => 'Archive::Zip::Parser',
    license           => 'perl',
    dist_author       => 'Alan Haggai Alavi <haggai@cpan.org>',
    dist_version_from => 'lib/Archive/Zip/Parser.pm',
    requires          => {
        'Test::More'        => 0,
        'Test::Exception'   => 0,
        'version'           => 0,
        'Carp'              => 0,
        'autodie'           => 0,
        'Data::ParseBinary' => 0,
    },
    add_to_cleanup => ['Archive-Zip-Parser-*'],
    repository     => 'git://github.com/alanhaggai/Archive-Zip-Parser.git',
);

$builder->create_build_script();
