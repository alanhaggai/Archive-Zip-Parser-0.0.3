#!perl -T

use Test::More;

eval 'use Test::Pod::Coverage 1.04';
if ($@) {
    plan(
        skip_all => 'Test::Pod::Coverage 1.04 required for testing POD coverage'
    );
}

plan( tests => 5 );

pod_coverage_ok('Archive::Zip::Parser');
pod_coverage_ok('Archive::Zip::Parser::CentralDirectoryEnd');
pod_coverage_ok('Archive::Zip::Parser::Entry');
pod_coverage_ok('Archive::Zip::Parser::Entry::LocalFileHeader');
pod_coverage_ok('Archive::Zip::Parser::Entry::CentralDirectory');
