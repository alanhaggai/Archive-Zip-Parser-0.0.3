#!perl -T

use Test::More tests => 4;
eval "use Test::Pod::Coverage 1.04";
plan skip_all => "Test::Pod::Coverage 1.04 required for testing POD coverage" if $@;
pod_coverage_ok('Archive::Zip::Parser');
pod_coverage_ok('Archive::Zip::Parser::Entry');
pod_coverage_ok('Archive::Zip::Parser::Entry::LocalFileHeader');
pod_coverage_ok('Archive::Zip::Parser::Entry::CentralDirectory');
